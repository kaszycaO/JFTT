all: zad1 zad2 zad3 zad4

zad1: 	zad1.l
	flex -ozad1.c zad1.l
	gcc zad1.c -o zad1 

zad2: 	zad2.l
	flex -ozad2.c zad2.l
	gcc zad2.c -o zad2 

zad3: 	zad3.l
	flex -ozad3.c zad3.l
	gcc zad3.c -o zad3 

zad4: 	zad4.l
	flex -ozad4.c zad4.l
	gcc zad4.c -o zad4


clean:
	rm *.c zad1 zad2 zad3 zad4
