%{
  #include "parser.tab.h"

  int yylex();
  void yyerror(char *s);
%}

%option noyywrap

DIGIT    [0-9]+

%%

"exit"                 return CMD_EXIT;
"print"                return CMD_PRINT;

"-"                    {return OP_MINUS;}
"+"                    {return OP_PLUS;}
"*"                    {return OP_MULT;}
"/"                    {return OP_DIV;}
"="                    {return OP_EQUAL;}
"("                    {return OP_L_PAREN;}
")"                    {return OP_R_PAREN;}

[a-zA-Z]               {yylval.id = yytext[0]; return VALUE_ID;}
(\.{DIGIT}+)|({DIGIT}+(\.{DIGIT}*)?([eE][+-]?[0-9]+)?)   {yylval.dval = atof(yytext); return NUMBER;}

[ \t\n]                ;
.                      {ECHO; yyerror("Unexpected character");}

%%
