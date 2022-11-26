%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
int parser_result;
extern char *yytext;
void yyerror (char const *s) {
    fprintf (stderr, "%s\n", s);
}
%}
%token TOKEN_INT
%token TOKEN_PLUS
%token TOKEN_MINUS
%token TOKEN_MUL
%token TOKEN_DIV
%token TOKEN_LPAREN
%token TOKEN_RPAREN
%token TOKEN_SEMI
%token TOKEN_ERROR
%%
program : expr TOKEN_SEMI { parser_result = $1; };
expr : expr TOKEN_PLUS term { $$ = $1 + $3; }
     | expr TOKEN_MINUS term { $$ = $1 - $3; }
     | term { $$ = $1; }
;
term : term TOKEN_MUL factor { $$ = $1 * $3; }
     | term TOKEN_DIV factor { $$ = $1 / $3; }
     | factor { $$ = $1; }
;
factor: TOKEN_MINUS factor { $$ = -$2; }
      | TOKEN_LPAREN expr TOKEN_RPAREN { $$ = $2; }
      | TOKEN_INT { $$ = atoi(yytext); }
;
%%
