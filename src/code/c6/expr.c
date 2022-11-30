#include <stdlib.h>
#include <stdio.h>
#include "expr.h"

struct expr* expr_create(expr_t kind, struct expr* left, struct expr* right) {
  struct expr* e = malloc(sizeof(*e));
  e->kind = kind;
  e->left = left;
  e->right = right;
  e->string_literal = NULL;
  e->integer_value = 0;
  e->name = NULL;
  return e;
}

struct expr* expr_create_integer_literal( int i )
{
  struct expr* e = expr_create(EXPR_INTEGER_LITERAL, NULL, NULL);
  e->integer_value = i;
  return e;
}

struct expr* expr_create_name( const char *name )
{
  struct expr* e = expr_create(EXPR_NAME, NULL, NULL);
  e->name = name;
  return e;
}

struct expr* expr_create_boolean( int bool) {
  struct expr* e = expr_create(EXPR_BOOLEAN, NULL, NULL);
  e->integer_value = bool;
  return e;
}

struct expr* expr_create_string_literal( const char *string_literal )
{
  struct expr* e = expr_create(EXPR_STRING_LITERAL, NULL, NULL);
  e->string_literal = string_literal;
  return e;
}

void expr_print(struct expr *e) {
  if (!e)
    return;
  printf("(");
  expr_print(e->left);
  switch (e->kind) {
  case EXPR_NAME:
    printf("%s", e->name);
    break;
  case EXPR_BOOLEAN:
    if (e->integer_value == 0) {
      printf("true");
    } else {
      printf("false");
    }
    break;
  case EXPR_STRING_LITERAL:
    printf("%s", e->string_literal);
    break;
  case EXPR_INTEGER_LITERAL:
    printf("%d", e->integer_value);
    break;
  case EXPR_ADD:
    printf("+");
    break;
  case EXPR_SUB:
    printf("-");
    break;
  case EXPR_MUL:
    printf("*");
    break;
  case EXPR_DIV:
    printf("/");
    break;
  }
  expr_print(e->right);
  printf(")");
}
