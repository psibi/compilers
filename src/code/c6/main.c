#include <stdio.h>
#include <stdlib.h>
#include "expr.h"
#include "decl.h"

extern FILE *yyin;
extern int yyparse();
extern struct decl* parser_result;

int expr_evaluate(struct expr *e) {
  if (!e) return 0;

  int l = expr_evaluate(e->left);
  int r = expr_evaluate(e->right);

  switch(e->kind) {
  case EXPR_VALUE: return e->value;
  case EXPR_ADD: return l+r;
  case EXPR_SUBTRACT: return l-r;
  case EXPR_MULTIPLY: return l*r;
  case EXPR_DIVIDE:
    if(r==0) {
      printf("error: divide by zero\n");
      exit(1);
    }
    return l/r;
  }
  return 0;
}

void expr_print( struct expr *e )
{
  if(!e) return;
  printf("(");
  expr_print(e->left);
  switch(e->kind) {
  case EXPR_VALUE: printf("%d",e->value);
    break;
  case EXPR_ADD: printf("+"); break;
  case EXPR_SUBTRACT: printf("-"); break;
  case EXPR_MULTIPLY: printf("*"); break;
  case EXPR_DIVIDE: printf("/"); break;
  }
  expr_print(e->right);
  printf(")");
}

void type_print(type_t kind) {
  printf(" (");
  switch (kind) {
    case TYPE_BOOLEAN: printf("boolean"); break;
    case TYPE_STRING: printf("string"); break;
  }
  printf(")\n");
}

void decl_print(struct decl *d) {
  if (!d) return;
  printf("%s", d->name);
  type_print(d->type->kind);
  decl_print(d->next);
}

int main(int argc, char *argv[])
{
  if (argc == 2) {
    yyin = fopen(argv[1], "r");
  }
  if(yyparse() == 0) {
    fprintf(stderr, "Parse successful!\n");
    decl_print(parser_result);
    /* int result = expr_evaluate(parser_result); */
    /* printf("Result of expression: %d \n", result); */
    /* expr_print(parser_result); */
  } else {
    printf("Parse failed.\n");
  }
}
