# Parsing in Practice

-   While LL(1) parsers are commonly written by hand, LR(1) parsers are
    simply too cumbersome to do the same.
-   Instead, we rely upon a **parser generator** to take a specification
    of a grammar and automatically produce the working code.
-   In this chapter, we will look into **Bison**.

Using Bison, we will define an LALR grammar for algebraic expressions,
and then employ it to create three different varieties of programs:

-   A **validator** reads the input program and then simply informs the
    user whether it is a valid sentence in the language specified by the
    grammar.
-   An **interpreter** reads the input program and then actually
    executes the program to produce a result.
-   A **translator** reads the input program, parses it into an abstract
    syntax tree, and then traverses the abstract syntax tree to produce
    an equivalent program in a different format.

# The Bison Parser Generator

-   It is not practical to implement an LALR parser by hand, and so we
    rely on tools to automatically generate tables and code from a
    grammar specification.
-   YACC (Yet Another Compiler Compiler) was a widely used parser
    generator in the Unix environment, recently supplanted by the GNU
    Bison parser which is generally compatible.
-   Bison is designed to automatically invoke Flex as needed, so it is
    easy to combine the two into a complete program.

The overall structure of a Bison file is similar to that of Flex:

``` bison
%{
   (C PREAMBLE CODE)
%}
   (declarations)
%%
   (grammar rules)
%%
   (C postamble code)
```

-   The second section can contain a variety of declarations specific to
    the Bison language. We will use the `%token` keyword to declare all
    of the terminals in our language.

The main body of the file contains a series of rules of the form:

``` bison
expr : expr TOKEN_ADD expr
     | TOKEN_INT
     ;
```

-   The above code indicats that the non terminal `expr` can produce the
    sentence `expr TOKEN_ADD expr` or single terminal `TOKEN_INT`.
-   White space is not significant, so it’s ok to arrange the rules for
    clarity.
-   Note that the usual naming convention is reversed: since upper case
    is customarily used for C constants, we use lower case to indicate
    non-terminals.
-   The resulting code creates a single function `yyparse()` than
    returns an integer:
    -   zero indicates a successful parse
    -   one indicates a parse error
    -   two indicates an internal problem such as memory exhaustion
-   `yyparse` assumes that there exists a function `yylex` that returns
    integer token types. This can be written by hand or generated
    automatically by Flex.