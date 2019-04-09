default: compile

compile:
	lex -l calc.l
	yacc -vd calc.y
	cc lex.yy.c y.tab.c -o calc 

