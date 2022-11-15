%{
  #include "parser.tab.h"

  int yylex();
  void yyerror(char *s);
%}

%option noyywrap

DIGIT    [0-9]+

%%

"exit"                 {return CMD_EXIT;}
"print"                {return CMD_PRINT;}

[a-zA-Z]               {yylval.id = yytext[0]; return VALUE_ID;}
[-+*/=();]             {return yytext[0];}
(\.{DIGIT}+)|({DIGIT}+(\.{DIGIT}*)?([eE][+-]?[0-9]+)?) {yylval.dval = atof(yytext); return NUMBER;}

[ \t\n]                ;
.                      {ECHO; yyerror("Unexpected character");}

%%
