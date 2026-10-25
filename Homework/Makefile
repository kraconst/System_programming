homework_asm: homework.asm
	fasm homework.asm

main_c: main.c
	gcc -c main.c -o main.o

build: homework_asm main_c
	gcc main.o homework.o -o homework

run: build homework
	./homework $(var)

clean:
	rm -f *.o
