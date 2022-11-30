#include <stdlib.h>
#include <stdio.h>
#include "decl.h"

extern void expr_print(struct expr *e);

struct decl * decl_create( char *name,
                           struct type *type,
                           struct expr *value,
                           struct stmt *code,
                           struct decl *next )
{
  struct decl *d = malloc(sizeof(*d));
  d->name = name;
  d->type = type;
  d->value = value;
  d->code = code;
  d->next = next;
  return d;
}

struct type *type_create(type_t kind, struct type *subtype, struct param_list *params) {
  struct type *t = malloc(sizeof(*t));
  t->kind = kind;
  t->subtype = subtype;
  t->params = params;
  return t;
}

struct param_list *param_list_create(char *name, struct type *type, struct param_list *next) {
  struct param_list *p = malloc(sizeof(*p));
  p->name = name;
  p->type = type;
  p->next = next;
  return p;
}

void type_print(type_t kind) {
  printf(" (");
  switch (kind) {
  case TYPE_CHARACTER:
    printf("char");
    break;
  case TYPE_BOOLEAN:
    printf("boolean");
    break;
  case TYPE_INTEGER:
    printf("integer");
    break;
  case TYPE_STRING:
    printf("string");
    break;
  }
  printf(")");
}

void decl_print(struct decl *d) {
  if (!d)
    return;
  printf("%s", d->name);
  type_print(d->type->kind);
  expr_print(d->value);
  printf("\n");
  decl_print(d->next);
}
