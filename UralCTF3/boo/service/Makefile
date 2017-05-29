boo: boo.c
	gcc -o boo boo.c

shell: shell.asm
	nasm -o shell -f bin shell.asm
	hexcat shell
elf: shell.asm
	nasm -o shell.o -f elf shell.asm
	ld -o shell shell.o
	ls *abcd*
