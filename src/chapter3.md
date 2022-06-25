# Scanning

## Kind of Tokens

-   Scanning is the process of identifying **tokens** from the raw text
    source code of a program.

Most languages will have tokens in these categories:

-   Keywords
-   Identifiers
-   Numbers
-   Strings
-   Comments and Whitespace

## A Hand-Made Scanner

-   The basic approach is to read one character at a time from the input
    stream (`fgetc(fp)`) and then classify it.
-   Hand Made scanner is usually verbose.
-   For a complex language with a large number of tokens, we need a more
    formalized approach to defining and scanning tokens. A formal
    approach will allow us to have a greater confidence that token
    definitions do not conflict and the scanner is implemented
    correctly.
-   The formal tools of **regular expressions** and **finite automata**
    allow us to state very precisely what may appear in a given token
    type. Then, automated tools can process these definitions, find
    errors or ambiguities, and produce compact, high performance code.

## Regular Expressions

-   Regular expressions (REs) are a language for expressing patterns.
-   They were first described in the 1950s by Stephen Kleene.

![](./images/c3_regular_expression.png)

Note that *ϵ* represents empty string.

![](./images/c3_re_examples.png)

The syntax described so far is entirely sufficient to write any regular
expression. But, it is also handy to have a few helper operations built
on top of the basic syntax:

![](./images/c3_re_helpers.png)

Regular expressions also obey several algebraic properties, which make
it possible to re-arrange them as needed for efficiency or clarity:

![](./images/c3_re_algebric_properties.png)

Some examples of regular expressions:

![](./images/c3_re_more_examples.png)

## Finite Automata

-   A **finite automaton (FA)** is an abstract machine that can be used
    to represent certain forms of computation.
-   Graphically, an FA consists of a number of states (represented by
    numbered circles) and a number of edges (represented by labeled
    arrows) between those states. Each edge is labeled with one or more
    symbols drawn from an alphabet Σ.
-   The machine begins in a start state S0. For each input symbol
    presented to the FA, it moves to the state indicated by the edge
    with the same label as the input symbol.
-   Some states of the FA are known as **accepting states** and are
    indicated by a double circle. If the FA is in an accepting state
    after all input is consumed, then we say that the FA **accepts** the
    input.
-   We say that the FA **rejects** the input string if it ends in a
    non-accepting state, or if there is no edge corresponding to the
    current input symbol.
-   **Every RE can be written as an FA, and vice versa.**
-   For a simple regular expression, one can construct an FA by hand.

FA for regular expression `for`:

![](./images/c3_fa_for.png)

FA for regular expression `[a-z][a-z0-9]+`:

![](./images/c3_fa_ex2.png)

FA for regular expression `([1-9][0-9]*)|0`

[![](./images/c3_fa_ex3.png)](./images/c3_fa_ex3.png)

## Deterministic Finite Automata

-   Each of the above three examples is a **deterministic finite
    automaton (DFA)**.
-   A DFA is a special case of an FA where every state has no more than
    one outgoing edge for a given symbol.
-   Put another way, DFA has no ambiguity: For every combination of
    state and symbol there is exactly one choice of what to do next.
-   DFA is easy to implement in software or hardware.

## Nondeterministic Finite Automata

-   The alternative to a DFA is a **nondeterministic finite automaton
    (NFA)**. A NFA is a perfectly valid FA, but it has an ambiguity that
    makes it somewhat more difficult to work with.
-   Example: Regular expression `[a-z]*ing` which represents all
    lowercase ending in the suffix `ing`. It can be represented by the
    following automaton:

[![](./images/c3_nfa_ex1.png)](./images/c3_nfa_ex1.png)

There is a ambiguity in the above automamata because the word `sing`
could proceed in two different ways:

-   State 0 (s) -\> State 1 (i) -\> State 2 (n) -\> Stage 3 (g)
-   State 0 (s) -\> State 0 (i) -\> State 0 (i) -\> State 0 (g)

Both ways obey the transition rules, but one results in acceptance,
while the other results in rejection.

-   And the above NFA becomes complicated for a word like `singing`
-   An NFA can also have an *ϵ* (epsilon) transition, which represents
    an empty string. This transition can be taken without consuming any
    input symbols at all. For example, we could represent the regular
    expression `a*(ab|ac)` with this NFA:

[![](./images/c3_nfa_ex2.png)](./images/c3_nfa_ex2.png)