LIB=-lfl
CC=gcc
turing: turing.c
	$(CC) -Wall -o turing turing.c $(LIB)
turing.c: turing.lex
	flex -oturing.c turing.lex
