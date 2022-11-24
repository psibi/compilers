%{
#include "token.h"
%}
DIGIT  [0-9]
LETTER [a-zA-Z]
%%
(" "|\t|\n) /* skip whitespace */
\+        { return TOKEN_ADD; }
\-        { return TOKEN_MINUS; }
\*        { return TOKEN_MUL; }
\/        { return TOKEN_DIV; }
\/        { return TOKEN_DIV; }
{LETTER}+ { return TOKEN_IDENT; }
{DIGIT}+  { return TOKEN_INT; }
.         { return TOKEN_ERROR; }
%%
int yywrap() { return 1; }
