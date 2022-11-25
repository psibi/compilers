%{
#include <stdio.h>
#include <stdlib.h>
#include "expr.c"

#define YYSTYPE struct expr*

int yylex();
struct expr* parser_result = 0;
extern char* yytext;
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
expr : expr TOKEN_PLUS term { $$ = expr_create(EXPR_ADD, $1, $3); }
     | expr TOKEN_MINUS term { $$ = expr_create(EXPR_SUBTRACT, $1, $3); }
     | term { $$ = $1; }
;
term : term TOKEN_MUL factor { $$ = expr_create(EXPR_MULTIPLY, $1, $3); }
     | term TOKEN_DIV factor { $$ = expr_create(EXPR_DIVIDE, $1, $3); }
     | factor { $$ = $1; }
;
factor: TOKEN_MINUS factor { $$ = expr_create(EXPR_SUBTRACT, expr_create_value(0), $2); }
      | TOKEN_LPAREN expr TOKEN_RPAREN { $$ = $2; }
      | TOKEN_INT { $$ = expr_create_value(atoi(yytext)); }
;
%%
