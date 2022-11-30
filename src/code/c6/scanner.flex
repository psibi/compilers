%{
#include "token.h"
%}

DIGIT  [0-9]
LETTER [a-zA-Z]

%%

(" "|\t|\n) /* skip whitespace */
{DIGIT}+                   { return TOKEN_INT;           }
"boolean"                  { return TOKEN_TYPE_BOOLEAN;  }
"string"                   { return TOKEN_TYPE_STRING;   }
"integer"                  { return TOKEN_TYPE_INTEGER;  }
true                       { return TOKEN_BOOL_TRUE;     }
false                      { return TOKEN_BOOL_FALSE;    }
\+                         { return TOKEN_PLUS;          }
\-                         { return TOKEN_MINUS;         }
\*                         { return TOKEN_MUL;           }
\/                         { return TOKEN_DIV;           }
\(                         { return TOKEN_LPAREN;        }
\)                         { return TOKEN_RPAREN;        }
\;                         { return TOKEN_SEMI;          }
:                          { return TOKEN_COLON;         }
\=                         { return TOKEN_EQUAL;         }
\".*\"                     {
  if ((strlen(yytext)) > 160) {
    fprintf(stderr, "string longer than 160 characters\n");
    return TOKEN_ERROR;
                                                         }
  else return TOKEN_STRING_LITERAL;
}
{LETTER}+{DIGIT}*{LETTER}* { return TOKEN_IDENTIFIER;    }
.                          { return TOKEN_ERROR;         }

%%
int yywrap() { return 1; }
