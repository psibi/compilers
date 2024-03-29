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

The above NFA also presents a variety of ambiguos choices:

-   From state zero, it could consume `a` and stay in state zero.
-   From state zero, it could consume *ϵ* to state one.
-   From state zero, it could consume *ϵ* to state four.

There are two common ways to interpret this ambiguity:

-   The **crystal ball interpretation** says that NFA somehow knows what
    the best choice is, by some means external to the NFA. Needless to
    say, this isn't possible in a real implementation.
-   The **many-worlds interpretation** suggests that NFA exists in all
    allowable states `simultaneously`. When the input is complete, if
    any of those states are accepting states, then the NFA has accepted
    the input. This interpretation is more useful for constructing a
    working NFA, or converting it to a DFA.

Let us use the many-worlds interpretation on the example above. Suppose
that the input string is `aaac`.

-   Initial State: Initially the NFA is in state zero. Without consuming
    any input, it could take an epsilon transition to states one or
    four. So, we can consider it's initial state to be all of those
    simultaneously.
-   Second State (after consuming `a`): From state zero, it can consume
    `a` and remain in State 0, or go to state 1 or 4 with epsilon
    transition. And from state one (from initial state on step 1), it
    can go to state 2. Similarly from state 4 (from initial step on step
    1), it can go to state 5. So in the second state, it can be in state
    0, 1, 4, 2 or 5 simultaneously.

NFA would traverse these states untill accepting the complete string
`aaac`:

[![](./images/c3_nfa_states.png)](./images/c3_nfa_states.png)

-   In principal once can implement an NFA in software or hardware by
    simply keeping track of all of the possible states. But it is
    inefficient.
-   A better approach is to convert NFA into an equivalent DFA.

# Conversion Algorithms

-   For every RE, there is an FA, and vice versa.
-   DFA is by far the most straightfoward of the three to implement in
    software.

[![](./images/c3_relations.png)](./images/c3_relations.png)

## Converting REs to NFAs

-   We follow the same inductive definition of regular expression as
    given earlier. We define automata corresponding to base cases of
    REs:

[![](./images/c3_re_to_fa_1.png)](./images/c3_re_to_fa_1.png)

-   If we write the concatenation of `A` and `B` as `AB`, then the
    corresponding NFA is simply `A` and `B` connected by an *ϵ*
    transition.

[![](./images/c3_re_to_fa_2.png)](./images/c3_re_to_fa_2.png)

-   In a similar fashion, the alternation of `A` and `B` written as
    `A|B` can be expressed as two automata joined by common starting and
    accepting nodes, all connected by *ϵ* transitions

[![](./images/c3_re_to_fa_3.png)](./images/c3_re_to_fa_3.png)

-   Finall, the Kleene closure `A*` is constructed by taking the
    automaton for `A`, adding starting and accepting nodes, then adding
    *ϵ* transitions to allow zero or more repetitions:

[![](./images/c3_re_to_fa_4.png)](./images/c3_re_to_fa_4.png)

### Example: Convert RE `a(cat|cow)*` to NFA

-   Step 1: Construct NFA for `cat` and `cow` (the innermost expression)

[![](./images/c3_re_to_fa_eg1_s1.png)](./images/c3_re_to_fa_eg1_s1.png)

-   Step 2: Construct NFA for `cat|cow`

[![](./images/c3_re_to_fa_eg1_s2.png)](./images/c3_re_to_fa_eg1_s2.png)

-   Step 3: Construct NFA for Kleene closure `(cat|cow)*`

[![](./images/c3_re_to_fa_eg1_s3.png)](./images/c3_re_to_fa_eg1_s3.png)

-   Step 4: Construct NFA for RE `a(cat|cow)*`

[![](./images/c3_re_to_fa_eg1_s4.png)](./images/c3_re_to_fa_eg1_s4.png)

Observations from the above example:

-   It's complex and contains large number of epsilon transitions.
-   Could be impractical to implement for a complete language that could
    end up having thousands of states.
-   Instead, we can convert NFA into an equivalent DFA.

## Converting NFAs to DFAs

-   The technique to convert any NFA into an equivalent DFA is called
    **subset construction**.
-   Basic idea is to create a DFA such that each state in the DFA
    corresponds to multiple states in the NFA, according to the
    `many-worlds` interpretation.

[![](./images/c3_epsilon_closure.png)](./images/c3_epsilon_closure.png)

[![](./images/c3_subet_algorithm.png)](./images/c3_subet_algorithm.png)

Example of converting NFA to DFA for the regualr expression which we saw
previously: `a(cat|cow)*`

[![](./images/c3_nfa_to_dfa.png)](./images/c3_nfa_to_dfa.png)

Before diving into each steps, let's see a concrete example of epsilon
closure using the above example.

*ϵ*-closure(*N*<sub>*o*</sub>) = {*N*<sub>*o*</sub>} because
*N*<sub>*o*</sub> is the only state that is reachable from NFA state
*N*<sub>*o*</sub> by zero or more *ϵ* transitions.

Each steps of the algorithm:

[![](./images/c3_nfa_to_dfa_step1.png)](./images/c3_nfa_to_dfa_step1.png)

[![](./images/c3_nfa_to_dfa_step2.png)](./images/c3_nfa_to_dfa_step2.png)

## Minimizing DFAs

-   Large DFAs will consume a lot of memory.
-   We can apply Hopcroft's algorithm to shrink a DFA into a smaller
    DFA.

[![](./images/c3_minimization_algo.png)](./images/c3_minimization_algo.png)

[![](./images/c3_minimize_eg1_1.png)](./images/c3_minimize_eg1_1.png)

Observations:

-   If we are in super-state (1,2,3,4) then an input of `a` always goes
    to state 2, which keeps us within the super-state. So, this DFA is
    consistent with respect to `a`.
-   From super-state (1,2,3,4) an input of `b` can either stay within
    the super-state or go to super-state (5). So, the DFA is
    inconsistent with respect to `b`.

[![](./images/c3_minimize_eg1_2.png)](./images/c3_minimize_eg1_2.png)

Observations:

-   We observe that super-state 1,2,3 is consistent with respect to `a`.
-   But not consistent with respect to `b` because it can either lead to
    state 3 or state 4.
-   We attempt to fix this by splitting out state 2 into its own
    super-state, yielding this DFA:

[![](./images/c3_minimize_eg1_3.png)](./images/c3_minimize_eg1_3.png)

# Limits of Finite Automata

-   Not sufficient to analyze all of the structures in a problem.
-   Designing a finite automaton to match an **arbitrary** number of
    nested parenthesis is impractical.
-   So, we limit ourselves to using regular expressions and finite
    automata for the narrow purpose of identifying the words and symbols
    within a problem.

# Using a Scanner Generator

-   The program **Lex** developed at AT&T was one of the earliest
    examples of a scanner generator.
-   Vern Paxson translated Lex into the C language to create **Flex**.

[![](./images/c3_flex_struct.png)](./images/c3_flex_struct.png)

To use Flex, we write a specification of the scanner that is a mixture
of regular expressions, fragments of C code, and some specialized
directives. The Flex program itself consumes the specification and
produces regular C code that can then be compiled in the normal way.

A peculiar requirement of Flex is that we must define a function
`yywrap()` which returns 1 to indicate that the input is complete at the
end of the file. If we wanted to continue scanning in another file, then
`yywrap()` would open the next file and return 0.

## Syntax

-   The regular expression language accepted by Flex is very similar to
    that of formal regular expressions discussed above.
-   The main difference is that characters that have special meaning
    with a regular expression (like parentheses, square brackets, and
    asterisks) must be escaped with a backslash or surrounded with
    double quotes.
-   Also, a period (.) can be used to match any character at all, which
    is helpful for catching error conditions.

## Other details

-   Flex generates the scanner code, but not a complete program, so you
    must write a main function to go with it.
-   The main program must declar as
    [**extern**](https://stackoverflow.com/questions/856636/effects-of-the-extern-keyword-on-c-functions)
    the symbols it expects to use in the generated scanner code:
    -   `yyin` is the file from which text will be read
    -   `yylex` is the function that implements the scanner
    -   array `yytext` contains the actual text of each token discovered

``` bash
flex -o scanner.c scanner.flex
```

## Source code

Filename: token.h

``` c
{{#include code/c3/token.h}}
```

Filename: scanner.flex

``` c
{{#include code/c3/scanner.flex}}
```

Filename: main.c

``` c
{{#include code/c3/main.c}}
```

Sample session:

``` bash
❯ ./one
hello world 32234
token: 3 text: hello
token: 3 text: world
token: 4 text: 32234
fooboar
token: 3 text: fooboar
   3
token: 4 text: 3
```
