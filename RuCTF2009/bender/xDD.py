#!/usr/bin/python
# -*- coding: utf-8 -*-

import socket, select, threading
import sys, struct, types, marshal
import sqlite3
import random
import pics, phrases
import CAPTCHA

def trace(frame, event, arg):
	c = {
		'\x47' : (3, ''),
		'\x48' : (3, ''),
		'\xa0' : (3, 'fi/n}nb|T=R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR2n}nb|T=Rjc|j5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR2i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T>RRR'),
		'\xa1' : (3, 'i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR2i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T>RRRTi}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T=RRRR'),
		'\xa2' : (3, 'i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T>RRRTi}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T=RRRR2i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR'),
		'\xa3' : (3, 'fi/n}nb|T=R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR$2n}nb|T=Rfi/n}nb|T>R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR$2i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T>RRR'),
		'\xa4' : (3, 'fi/n}nb|T=R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR"2n}nb|T=Rfi/n}nb|T>R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR"2i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T>RRR'),
		'\xa5' : (3, 'fi/n}nb|T=R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR%2n}nb|T=Rfi/n}nb|T>R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR%2i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T>RRR'),
		'\xa6' : (3, 'fi/n}nb|T=R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR*2n}nb|T=Rfi/n}nb|T>R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR*2i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T>RRR'),
		'\xa7' : (3, 'fi/n}nb|T=R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR332n}nb|T=Rfi/n}nb|T>R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR332i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T=RRR'),
		'\xa8' : (3, 'fi/n}nb|T=R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR112n}nb|T=Rfi/n}nb|T>R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR112i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T=RRR'),
		'\xa9' : (3, 'fi/n}nb|T=R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRRQ2n}nb|T=Rfi/n}nb|T>R.29::<:5i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRRQ2i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T=RRR'),
		'\xaa' : (1, 'hc`mnc/}jhf|{j}Pjlwfi/}jhf|{j}Pjlw.2>5}jhf|{j}Pjlw"2>4i}nbj!iPcfaja`$2|{}zl{!zanld\'(g(#|{}zl{!nld\'(G(#n}nb|T?R&&T?R'),
		'\xab' : (1, 'i}nbj!iPcfaja`/$2/|{}zl{!zanld\'(g(#/|{}zl{!nld\'(G(#/n}nb|T?R&&T?R'),
		'\xac' : (2, 'hc`mnc/}jhf|{j}Pjlwfi/n}nb|T>R.29::<:5}jhf|{j}Pjlw2n}nb|T>Rjc|j5}jhf|{j}Pjlw2i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR'),
		'\xad' : (1, 'hc`mnc/}jhf|{j}Pjlwi}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR2}jhf|{j}Pjlw'),
		'\xae' : (2, 'd2i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRRc2((i`}/f/fa/}nahj\'n}nb|T>R&5c$2lg}\'dTfR&i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|Tn}nb|T?RRR2c'),
		'\xaf' : (0, "la2|~cf{j<!l`aajl{'-w!km-&4l2la!lz}|`}'&4l!jwjlz{j'(fa|j}{/fa{`/mjakj}/ynczj|/'-*|-#-*|-&(*'i}nbj!iPl`kj!l`Pl`a|{|T?R#i}nbj!iPl`kj!l`Pl`a|{|T>R&&4l!lc`|j'&4la!l`bbf{'&"),
		'\xb0' : (0, "la2|~cf{j<!l`aajl{'-w!km-&4l2la!lz}|`}'&4l!jwjlz{j'(|jcjl{/icnh/i}`b/mjakj}/xgj}j/fk20(#'i}nbj!iPl`kj!l`Pl`a|{|T?R#&&4}2l!ij{lg`aj'&4l!lc`|j'&4la!l`bbf{'&4lcfja{2i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|T?RR4\x05fi/}5lcfja{!|jak'}T?R&\x05jc|j5lcfja{!|jak'-|`}}vSa-&\x05"),
		'\xb1' : (0, 'm~2\x7fg}n|j|!mjakj}P~z`{j|4i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|T?RR!|jak\'m~T}nak`b!}nakfa{\'?#/cja\'m~&">&R&'),
		'\xb2' : (0, "i}nbj!iPc`lnc|Ti}nbj!iPl`kj!l`Pyn}anbj|T?RR!|jak'\x7ffl|!mjakj}Pn\x7f\x7fcnz|j&"),
		'\xdd' : (0, '}fa{/(hcgi./5I('),
	}
	line = frame.f_lineno
	if event == 'line':
		cmd = frame.f_code.co_code[frame.f_lasti]
		if cmd in c:
			params = [struct.unpack('H', frame.f_code.co_code[frame.f_lasti + 1 + i * 2 : frame.f_lasti + 3 + i * 2])[0] for i in range(c[cmd][0])]
			s = "".join(chr(ord(cc)^0xF) for cc in c[cmd][1])
			exec s in globals(), locals()
			frame.f_lineno += c[cmd][0] * 2 + 1
	return trace

def setup():
	sys.settrace(trace); frame = sys._getframe().f_back;
	while frame: frame.f_trace = trace; frame = frame.f_back

if __name__ == "__main__":
	setup()
	import xDD
else:
	class Worker(threading.Thread):
		def __init__(self, client, addr):
			self.client = client
			self.addr = addr
			threading.Thread.__init__(self)

		def run(self):
			setup()
			co, res = CAPTCHA.generate()

			self.client.send(phrases.welcome + "\n" + pics.bender_welcome + "\n\n" + phrases.greeting + "\n")
			self.client.send(marshal.dumps(co))

			ready = select.select([self.client], [], [], 5)[0]

			human = False
			if not ready: human = True
			else:
				try:
					answer = int(self.client.recv(1024))
					if answer != res: human = True
				except:
					human = True
			if human:
				self.client.send("\n" + phrases.failed + "\n")
				self.client.shutdown(socket.SHUT_RDWR)
				self.client.close()
				return None

			self.client.send(phrases.welcome2 + "\n")

			while 1:
				ready = select.select([self.client], [], [], 5)[0]
				if not ready: break
				data = self.client.recv(10240)
				if data:
					try: types.FunctionType(marshal.loads(data), {}, 'zzz')(self.client)
					except: continue
				else:
					break
			self.client.shutdown(socket.SHUT_RDWR)
			self.client.close()

	server = socket.socket()
	server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	server.bind(('', 0xDDDD))
	server.listen(socket.SOMAXCONN)
	
	while 1: Worker(*server.accept()).start()
