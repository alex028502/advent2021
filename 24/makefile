
program.s: program.c makefile
	gcc -S program.c -O3
program.c: transpile.py input.txt makefile
	python3 $< input.txt > $@

