all: calc

run: clean calc exec

clean:
	cd source && rm -rf *.tab.* *.yy.*

calc:
	rm -rf /bin/*.out
	cd source && flex lexer.l
	cd source && bison -d parser.y
	cd source && gcc parser.tab.c lex.yy.c -lm -o ../bin/calc.out

exec:
	bin/*.out