# Parsing

# Overview

-   To parse a computer program, we must first describe the form of
    valid sentences in a language. This formal statement is known as a
    context free grammar (CFG). Because they allow for recursion, CFGs
    are more powerful than regular expressions and can express a richer
    set of structures.
-   LL(1) grammars are CFGs that can be evaluated by considering only
    the current rule and next token in the input stream. This property
    makes it easy to write a hand-coded parser known as a recursive
    descent parser.
-   LR(1) grammars are more general and more powerful than LL(1). Nearly
    all useful programming languages can be written in LR(1) form.
    However, the parsing algorithm for LR(1) grammars is more complex
    and usually cannot be written by hand. Instead, it is common to use
    a parser generator that will accept an LR(1) grammar and
    automatically generate the parsing code.

# Context Free Grammars

## Terminal

-   A **terminal** is a discrete symbol that can appear in the language,
    otherwise known as a **token** from the previous chapter.
-   Examples: keywords, operators and identifiers.
-   Convention: lower-case letters to represent terminals.

## Non terminal

-   A **non-terminal** represents a structure that can occur in a
    language, but is not a literal symbol.
-   Examples: declarations, statements and expressions.
-   Convention: Upper-case letters to represent non terminals: `P` for
    programs, `S` for statement, `E` for expression etc.

## Sentence

-   A **sentence** is a valid sequence of terminals in a language.

## Sentential form

-   A **sentential form** is a valid sequence of terminals and non
    terminals.
-   Convention: Greek symbols to represent sentential forms. Example:
    *α*, *β* and *γ* to represent possibly mixed sequence of terminals
    and non-terminals. We will use a seqence like
    *Y*<sub>1</sub>*Y*<sub>2</sub>...*Y*<sub>*n*</sub> to indicate the
    individual symbols in a sentential form: *Y*<sub>*i*</sub> may
    either be a terminal or non terminal.

## Context Free Grammar (CFG)

-   A **CFG** is a list of **rules** that formally describe the
    allowable sentences in a language.
-   The left hand side of each rule is always a single non-terminal.
-   The right hand side of a rule is a **sentential form** that
    describes an allowable form of that non-terminal.
-   Example rule: `A -> xXy` indicates that the non-terminal `A`
    represents a terminal `x` followed by a non-terminal `X` and a
    terminal `y`.
-   The right hand side of a rule can be *ϵ* to indicate that the rule
    produces nothing.
-   The first rule is special: it is the top level definition of
    aprogram and it's non terminal is known as the **start symbol**

Sample CFG describing expressions involving addition, integers and
identifiers:

[![](./images/c4_g2.png)](./images/c4_g2.png)

## Deriving Sentences

-   Each grammar describes a (possibly infinite) set of sentences, which
    is known as the **language** of the grammar.
-   To prove that a given sentence is a member of that language, we must
    show that there exists a sequence of rule applications that connects
    the start symbol with the desired sentence.
-   A sequence of rule applications is known as a **derivation** and a
    double arrow (⇒) is used to show that one sentential form is equal
    to another by applying a given rule. Example: E ⇒ int by applying
    rule 4 of grammer G2.