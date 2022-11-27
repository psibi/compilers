%{
#include "token.h"
%}
DIGIT  [0-9]
LETTER [a-zA-Z]
%%
(" "|\t|\n) /* skip whitespace */
{DIGIT}+  { return TOKEN_INT; }
"boolean" { return TOKEN_TYPE_BOOLEAN; }
"string" { return TOKEN_TYPE_STRING; }
\+        { return TOKEN_PLUS; }
\-        { return TOKEN_MINUS; }
\*        { return TOKEN_MUL; }
\/        { return TOKEN_DIV; }
\(        { return TOKEN_LPAREN; }
\)        { return TOKEN_RPAREN; }
\;        { return TOKEN_SEMI; }
:        { return TOKEN_COLON; }
{LETTER}+ { return TOKEN_IDENTIFIER; }
.         { return TOKEN_ERROR; }
%%
int yywrap() { return 1; }
