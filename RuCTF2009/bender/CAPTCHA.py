from marshal import dumps, loads, dump
from types import CodeType, FunctionType
from random import random, randint
from struct import pack

commands = {
	0x02: (0, 2),
	0x03: (0, 3),
	0x04: (1, 1),
	0x05: (0, 4),
	0x0A: (0, 1),
	0x0B: (0, 1),
	0x0F: (0, 1),
	0x14: (-1, 2),
	0x17: (-1, 2),
	0x18: (-1, 2),
	0x40: (-1, 2),
	0x41: (-1, 2),
	0x42: (-1, 2),
	0x64: (1, 0),
	0x7C: (1, 0),
	0x7D: (-1, 1)
}

def generate():
	stack = 0
	code = ""
	maxstack = 0
	for i in xrange(50):
		available = [x for x in commands if commands[x][1] <= stack and (i < 50 or x != 0x64)]
		cmd = available[randint(0, len(available)-1)]
		stack += commands[cmd][0]
		if maxstack < stack: maxstack = stack
		code += chr(cmd)
		if cmd >= 0x64:	code += pack("<H", randint(0, 2))
	while stack > 1:
		code += '\x01'
		stack -= 1
	if stack == 1: code += '\x53'
	else: code += '\x7C\x00\x00\x53'
	co = CodeType(3, 3, maxstack, 0x41, code, (9487, 3129, 7828), (), ('a', 'b', 'c'), 'gen.py', 'test', 1, "\x01" * 1000, (), ())
	return co, FunctionType(co, {}, co.co_name)(1981, 3223, 1298)
