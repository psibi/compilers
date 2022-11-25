#include <stdio.h>

extern int yyparse();
extern int parser_result;

int main()
{
  if(yyparse()==0) {
    printf("Parse successful!\n");
    printf("Result of expression: %d", parser_result);
  } else {
    printf("Parse failed.\n");
  }
}
