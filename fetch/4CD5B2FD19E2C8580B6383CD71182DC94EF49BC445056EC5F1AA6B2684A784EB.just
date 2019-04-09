build: daily_programmer

daily_programmer: dp_352_easy 

dp_352_easy:
	nasm -f elf64 dp_352_easy.asm
	ld -m elf_x86_64 dp_352_easy.o -o bin/dp_352_easy
	rm dp_352_easy.o

project_euler: euler_1 euler_2 euler_3 euler_4 euler_5

euler_1:
	nasm -f elf64 euler_1.asm
	ld -m elf_x86_64 euler_1.o -o bin/euler_1
	rm euler_1.o

euler_2:
	nasm -f elf64 euler_2.asm
	ld -m elf_x86_64 euler_2.o -o bin/euler_2
	rm euler_2.o

euler_3:
	nasm -f elf64 euler_3.asm
	ld -m elf_x86_64 euler_3.o -o bin/euler_3
	rm euler_3.o

euler_4:
	nasm -f elf64 euler_4.asm
	ld -m elf_x86_64 euler_4.o -o bin/euler_4
	rm euler_4.o

euler_5:
	nasm -f elf64 euler_5.asm
	ld -m elf_x86_64 euler_5.o -o bin/euler_5
	rm euler_5.o

test: euler_5
	bin/euler_5
