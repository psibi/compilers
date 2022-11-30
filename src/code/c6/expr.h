typedef enum {
  EXPR_ADD,
  EXPR_SUB,
  EXPR_DIV,
  EXPR_MUL,
  EXPR_NAME,
  EXPR_INTEGER_LITERAL
} expr_t;

struct expr {
  expr_t kind;
  struct expr *left;
  struct expr *right;

  const char *name;
  int integer_value;
  const char *string_literal;
};
