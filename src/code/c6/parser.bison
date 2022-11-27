%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "expr.c"
#include "decl.c"

int yylex();
struct decl* parser_result = 0;
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
%token TOKEN_COLON
%token TOKEN_TYPE_BOOLEAN
%token TOKEN_TYPE_STRING
%token TOKEN_IDENTIFIER

%union {
    struct decl *decl;
    struct expr *expr;
    struct type *type;
    char *name;
};

%type   <decl> program decl
%type   <expr> expr term factor
%type   <type>          atomic_type
%type   <name> identifier

%%
program : decl { parser_result = $1; }
;
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
decl:           identifier TOKEN_COLON atomic_type { $$ = decl_create($1, $3, NULL, NULL);}
        ;
identifier:     TOKEN_IDENTIFIER { $$ = strdup(yytext); }
        ;
atomic_type:    TOKEN_TYPE_BOOLEAN { $$ = type_create(TYPE_BOOLEAN, NULL, NULL); }
        |       TOKEN_TYPE_STRING { $$ = type_create(TYPE_STRING, NULL, NULL);}
        ;
;
%%
