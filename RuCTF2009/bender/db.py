#!/usr/bin/python

import sqlite3

conn = sqlite3.connect('x.db')
c = conn.cursor()

def createTable(c):	
	c.execute('create table bender (id text, flag text)')

def insertRow(c, id, flag):
	c.execute('insert into bender values (?, ?)', (id, flag))

def showTable(c):
	c.execute('select * from bender')
	for row in c:
		print row

def getFlag(c, id):
	c.execute('select flag from bender where id=?', (id,))
	r = c.fetchone()
	if r: return r[0]
	return None

createTable(c)
#insertRow(c, "id", "flag")
#showTable(c)
#print getFlag(c, "id")

c.close()
conn.commit()
