#include <stdlib.h>
#include "decl.h"

struct decl * decl_create( char *name,
                           struct type *type,
                           struct expr *value,
                           /* struct stmt *code, */
                           struct decl *next )
{
  struct decl *d = malloc(sizeof(*d));
  d->name = name;
  d->type = type;
  d->value = value;
  /* d->code = code; */
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
