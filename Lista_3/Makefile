all: zad1

zad1: 	zad1.l
	flex -ozad1.c zad1.l
	bison -d zad1.y 
	gcc -o zad1 zad1.tab.c zad1.c -lfl 

clean:
	rm *.c *.h *.out parsetab.py zad1
