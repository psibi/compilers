#include "decl.h"
#include "expr.h"
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int yyparse();
extern void decl_print(struct decl *d);
extern struct decl *parser_result;

int expr_evaluate(struct expr *e) {
  if (!e)
    return 0;

  int l = expr_evaluate(e->left);
  int r = expr_evaluate(e->right);

  switch (e->kind) {
  case EXPR_NAME:
    return -2;
  case EXPR_STRING_LITERAL:
    return -1;
  case EXPR_INTEGER_LITERAL:
    return e->integer_value;
  case EXPR_ADD:
    return l + r;
  case EXPR_SUB:
    return l - r;
  case EXPR_MUL:
    return l * r;
  case EXPR_DIV:
    if (r == 0) {
      printf("error: divide by zero\n");
      exit(1);
    }
    return l / r;
  }
  return 0;
}

int main(int argc, char *argv[]) {
  if (argc == 2) {
    yyin = fopen(argv[1], "r");
  }
  if (yyparse() == 0) {
    fprintf(stderr, "Parse successful!\n");
    decl_print(parser_result);
    /* int result = expr_evaluate(parser_result); */
    /* printf("Result of expression: %d \n", result); */
    /* expr_print(parser_result); */
  } else {
    printf("Parse failed.\n");
  }
}
