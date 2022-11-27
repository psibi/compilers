#include "token.h"
#include <stdio.h>

extern FILE *yyin;
extern int yylex();
extern char *yytext;

int main() {
  /* yyin = fopen("program.c","r"); */
  FILE *yyin = stdin;
  if(!yyin) {
    printf("could not open program.c!\n");
    return 1;
  }
  while(1) {
    yytoken_kind_t t = yylex();
    if(t==YYEOF) break;
    printf("token: %d text: %s\n",t,yytext);
  }
}
