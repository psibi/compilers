%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "decl.c"
#include "expr.c"

int yylex();
struct decl* parser_result;
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
%token TOKEN_EQUAL
%token TOKEN_TYPE_BOOLEAN
%token TOKEN_TYPE_STRING
%token TOKEN_TYPE_INTEGER
%token TOKEN_IDENTIFIER

%union {
    struct decl *decl;
    struct expr *expr;
    struct type *type;
    char *name;
};

%type   <decl> program decl decl_list
%type   <expr> expr int_term factor int_expr str_expr
%type   <type> atomic_type
%type   <name> identifier

%%
program : decl_list { parser_result = $1; }
;
decl_list:      decl { $$ = $1;}
|       decl decl_list { $$ = $1, $1->next = $2;}
        ;
decl:           identifier TOKEN_COLON atomic_type TOKEN_SEMI { $$ = decl_create($1, $3, NULL, NULL, NULL);}
 |               identifier TOKEN_COLON atomic_type TOKEN_EQUAL expr TOKEN_SEMI { $$ = decl_create($1, $3, $5, NULL, NULL);}
        ;
expr : int_expr { $$ = $1; }
| str_expr {$$ = $1;};
int_expr: int_expr TOKEN_PLUS int_term { $$ = expr_create(EXPR_ADD, $1, $3); }
     | int_expr TOKEN_MINUS int_term { $$ = expr_create(EXPR_SUB, $1, $3); }
     | int_term { $$ = $1; }
;
int_term : int_term TOKEN_MUL factor { $$ = expr_create(EXPR_MUL, $1, $3); }
     | int_term TOKEN_DIV factor { $$ = expr_create(EXPR_DIV, $1, $3); }
     | factor { $$ = $1; }
;
factor: TOKEN_MINUS factor { $$ = expr_create(EXPR_SUB, expr_create_integer_literal(0), $2); }
      | TOKEN_LPAREN expr TOKEN_RPAREN { $$ = $2; }
      | TOKEN_INT { $$ = expr_create_integer_literal(atoi(yytext)); }
str_expr:        TOKEN_IDENTIFIER { $$ = expr_create_string_literal(strdup(yytext));}
        ;
identifier:     TOKEN_IDENTIFIER { $$ = strdup(yytext); }
        ;

atomic_type:    TOKEN_TYPE_BOOLEAN { $$ = type_create(TYPE_BOOLEAN, NULL, NULL); }
        |       TOKEN_TYPE_STRING { $$ = type_create(TYPE_STRING, NULL, NULL);}
|       TOKEN_TYPE_INTEGER { $$ = type_create(TYPE_INTEGER, NULL, NULL);}
        ;
;
%%
