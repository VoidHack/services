#!/usr/bin/python

import socket
from os import fork
import os
from sys import exit
from bsddb import db 
import bsddb
import sys
import re
import random
import pickle
import signal

signal.signal(signal.SIGCHLD,signal.SIG_IGN)

global db_filename
db_filename='db'

global re_str
re_str=re.compile('^[A-Za-z0-9_]+$')

global re_usr
re_usr=re.compile('^USR_(.*)$')

global login
login=None

def h(s):
    y=0
    for x in s:
	y=(y+ord(x))%1337
    return y

def echo(l,s,f):
#    db=start_db()
#    print dir(db)
    y=''
    for x in l:
	y=y+x
    return y
    
def new_user(l,s,f):

    if len(l)==0:
	return '-BAD_USR'
	
    if len(l)==1:
	return '-BAD_PSSWD'

    user=l[0]
    pswd=l[1]
    
    if not re_str.search(user):
	return '-BAD_USR'

    if not re_str.search(pswd):
	return '-BAD_PSSWD'

    key='USR_' + user
    db=start_db()
    
    if db.has_key(key):
	db.delete(key)
	return '-USR_ALREADY_EXST'

    if db.put(key,str(h(pswd))) == None:
	return '+OK'
	
    return '-ISE: Unknown error'
    
def login(l,s,f):
    global login

    if len(l)<2:
	login=None
	return '-BAD_LOGIN'

    user=l[0]
    pswd=l[1]

    if (not re_str.search(user)) or (not re_str.search(pswd)):
	login=None
	return '-BAD_LOGIN'

    key='USR_' + user
    db=start_db()
    
    if db.get(key) == str(h(pswd)):
	login=user
	return '+OK'

    login=None
    return '-BAD_LOGIN'

def msg_list(l,s,f):
    global login

    if login==None:
	return '-BAD_LOGIN'

    db=start_db()

    ret=''
    
    dumps=db.get('MSG_USR_' + login)
    if dumps:
        msgs=pickle.loads(dumps)
    else:
	msgs={}
    
    for x in msgs.keys():
	msg_from=db.get('MSG_FROM_' + str(x))
	ret+=msg_from + ' ' + str(x) + "\n"

    ret+='+0'
    return ret

def usr_list(l,s,f):
    global login
    global re_usr

    if login==None:
	return '-BAD_LOGIN'

    ret="+OK\n"

    db=start_db()
    for x in db.keys():
	m=re_usr.match(x)
	if(m):
	    usr=m.group(1)
	    ret+=usr+"\n"

    ret+='+0'
    return ret

def msg_read(l,s,f):
    global login
    
    if len(l)<1:
	return '-ISE:Too few params!'
    
    mid=l[0]
    
    if login==None:
	return '-NO_PERM'

    key=('MSG_' + str(mid))

    db=start_db()
    ret="+OK\n"
    if db.has_key(key):
	ret+=db.get('MSG_' + str(mid))
    ret+="\n"
    ret+='+0'
    
    return ret
    
def msg_del(l,s,f):
    global login
    
    if len(l)<1:
	return '-ISE:Too few params!'
    
    if login==None:
	return '-NO_PERM'

    ret=''
    db=start_db()
    for x in db.keys():
	ret+=x
        
    return ret    

def msg_send(l,s,f):
    if len(l)<1:
	return '-ISE:Too few params!'
	
    to=l[0]
	
    s.send("+GO_AHEAD\n")
    msg=''
    a=f.readline().strip("\r\n")
    while(a!="+0"):
	msg+=a+"\n"
	a=f.readline().strip("\r\n")
    
    db=start_db()
    
    mid=random.randint(0,2345543466359044543)
    while (db.has_key('MSG_' + str(mid))):
	mid=random.randint(0,2345543466359044543)

    db.put('MSG_' + str(mid),msg)
    msgs_dumps=db.get('MSG_USR_' + to)
    
    if msgs_dumps:
	db.delete('MSG_USR_' + to)
	msgs=pickle.loads(msgs_dumps)
    else:
	msgs={}

    msgs[mid]=1
    
    msgs_dumps=pickle.dumps(msgs)

    db.put('MSG_USR_' + to, msgs_dumps)
    db.put('MSG_FROM_' + str(mid),login)

    return '+OK'
    


cmd =	{
	    'echo'	: echo,
	    'NEW_USR'	: new_user,
	    'LOGIN'	: login,
	    'MSG_LIST'  : msg_list,
	    'USR_LIST'	: usr_list,
	    'READ'	: msg_read,
	    'DEL'	: msg_del,
	    'MSG_SEND'	: msg_send
	    
	}

def start_db():
    global db_filename

    try:
	DB = db.DB()
	DB.open(db_filename, None, db.DB_HASH, db.DB_AUTO_COMMIT)
    except:
	DB = db.DB()
	DB.open(db_filename, None, db.DB_HASH, db.DB_CREATE)
    return DB

def serve(c,a):
	f=os.fdopen(c.fileno())
	s=f.readline()
	s=s.strip("\r\n")
	while(s):
		l=s.split(' ')
		fun=cmd.get(l.pop(0))
		if(fun!=None):
		    c.send(fun(l,c,f)+"\n")
		else:
		    c.send("No such command: :(\n")
		
		s=f.readline().strip("\r\n")

def accept_loop():
	#create an INET, STREAMing socket
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

	#bind the socket to a public host, 
	# and a well-known port
	s.bind(('0.0.0.0', 5000))
	#become a server socket
	s.listen(5)

	while 1:
		(c,a)=s.accept()
		f=fork()
		if(f>0):
			c.close()
		elif(f==0):
			s.close()
			serve(c,a)
			exit(0)
		else:
			print 'ERROR while fork :('
accept_loop()
