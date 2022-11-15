%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>

    double yylex();
    void yyerror(char *s);

    double symbols[52];

    double symbolVal(char symbol);
    void updateSymbolVal(char symbol, double val);
    int computeSymbolIndex(char token);
%}

/* ========================================================================== */
%union {
    double dval;
    int ival;
    char id;
}

%start line

%token OP_MULT OP_DIV OP_PLUS OP_MINUS OP_EQUAL OP_L_PAREN OP_R_PAREN 
%token CMD_PRINT CMD_EXIT
%token <dval> NUMBER
%token <id> VALUE_ID

%left OP_PLUS OP_MINUS OP_MULT OP_DIV
%nonassoc UOP_MINUS

%type <dval> line exp term
%type <id> assignment

/* ========================================================================== */
%%

line    : assignment ';'         {;}
        | CMD_EXIT ';'       {exit(EXIT_SUCCESS);}
        | CMD_PRINT exp ';'          {printf("= %3f\n", $2);}
        | line assignment ';'    {;}
        | line CMD_PRINT exp ';'     {printf("= %3f\n", $3);}
        | line CMD_EXIT ';'  {exit(EXIT_SUCCESS);}
        ;

assignment : VALUE_ID OP_EQUAL exp  { updateSymbolVal($1,$3); }
           ;

exp     : term                   {$$ = $1;}
        | exp OP_PLUS term           {$$ = $1 + $3;}
        | exp OP_MINUS term           {$$ = $1 - $3;}
        | exp OP_MULT term           {$$ = $1 * $3;}
        | exp OP_DIV term           {$$ = $1 / $3;}
        ;

term    : NUMBER                 {$$ = $1;}
        | VALUE_ID             {$$ = symbolVal($1);} 
        ;

%%

/* ========================================================================== */

double symbolVal(char symbol) {
    int bucket = computeSymbolIndex(symbol);
    return symbols[bucket];
}

void updateSymbolVal(char symbol, double val) {
    int bucket = computeSymbolIndex(symbol);
    symbols[bucket] = val;
}

int computeSymbolIndex(char token) {
    int idx = -1;
    if(islower(token)) {
        idx = token - 'a' + 26;
    }
    else if(isupper(token)) {
        idx = token - 'A';
    }
    return idx;
} 

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    #ifdef YYDEBUG
        yydebug = 1;
    #endif

    int i;
    for(i=0; i<52; i++) {
        symbols[i] = 0;
    }
    return yyparse();
}