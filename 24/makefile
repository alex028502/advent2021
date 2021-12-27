
search: a.out
	python3 search.py $$PWD/$<
a.out: program.c
	gcc program.c -O3
program.s: program.c makefile
	gcc -S program.c -O3
program.c: transpile.py input.txt makefile
	python3 $< input.txt > $@
