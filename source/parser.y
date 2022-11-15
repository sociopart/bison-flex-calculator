%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>

    int yylex();
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

%token CMD_PRINT CMD_EXIT
%token <dval> NUMBER
%token <id> VALUE_ID

%left '+' '-'
%left '*' '/'
%nonassoc UOP_MINUS

%type <dval> exp

/* ========================================================================== */
%%

line    : assignment ';'                {;}
        | CMD_EXIT ';'                  {exit(EXIT_SUCCESS);}
        | CMD_PRINT exp ';'             {printf("= %3f\n", $2);}
        | line assignment ';'           {;}
        | line CMD_PRINT exp ';'        {printf("= %3f\n", $3);}
        | line CMD_EXIT ';'             {exit(EXIT_SUCCESS);}
        | exp                           {;}

exp     : assignment ';'        {;}
        | CMD_EXIT ';'          {exit(EXIT_SUCCESS);}
        | CMD_PRINT exp ';'     {printf("= %3f\n", $2);}
        | exp '+' exp           {$$ = $1 + $3;}
        | exp '-' exp           {$$ = $1 - $3;}
        | exp '*' exp           {$$ = $1 * $3;}
        | exp '/' exp           {$$ = $1 / $3;}
        | VALUE_ID              {$$ = symbolVal($1);}
        | NUMBER                {$$ = $1;}

assignment : VALUE_ID '=' exp   { updateSymbolVal($1, $3); }
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

    int i;
    for(i = 0; i < 52; i++) {
        symbols[i] = 0;
    }
    return yyparse();
}