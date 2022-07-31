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
-   The first rule is special: it is the top level definition of a
    program and it's non terminal is known as the **start symbol**

Sample CFG describing expressions involving addition, integers and
identifiers:

[![](./images/c4_g2.png)](./images/c4_g2.png)

For brevity, the above grammar can also be written as:

E -\> E + E | ident | int

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

There are two approaches to derivation:

-   top-down: Begin with the start symbol, and then apply rules in the
    CFG to expand non terminals until reaching the desired sentence.
-   bottom-up: Begin with the desired setence, and then apply the rules
    backwards until reaching the start symbol.

For example, `ident + int + int` is a sentence in this language and here
is one top-down derivation to prove it:

[![](./images/c4_g2_top_down.png)](./images/c4_g2_top_down.png)

And similar proof using bottom-up derivation:

![](./images/c4_g2_bottom_up.png)

It is quite possible for two different grammars to generate the same
language, in which case we describe them as having **weak equivalence**.

## Ambiguous Grammars

-   An **ambiguous grammar** allows for more than one possible
    derivation of the same sentence.
-   Example: The sentence `ident + int + int` can have two derivations:

![](./images/c4_ambigous_grammar.png)

-   Does it matter in the above case ? It certainly does!
-   In a language like Java such a sentence `hello + 5 + 5` could be
    interpreted as either `hello55` or `hello10` and that's not good.
-   It is possible to re-write a grammer so that it is not ambiguous. In
    the common case of binary operators, we can require that one side of
    the expression be an atomic term (T), like this:

[![](./images/c4_g3.png)](./images/c4_g3.png)

-   With this change, the grammer is no longer ambigous. But it still
    accepts the same language as Grammer *G*<sub>2</sub>
-   If you want to construct a grammar with more operators (division,
    muliplication) - then the usual approach is to construct a grammar
    with multiple levels that reflect the intended precedence of
    operators:

[![](./images/c4_g4.png)](./images/c4_g4.png)

Grammar which supports two if statements (if-then and if-then-else
variant):

[![](./images/c4_g5.png)](./images/c4_g5.png)

The above grammer is ambiguous because it allows for two derivations of
this sentence:

-   If E then if E then other else other

There are two derivations of this sentence:

-   If E then (if E then other else other)
-   If E then (if E then other) else other

# LL Grammars

-   LL(1) grammars are a subset of CFGs that are easy to parse with
    simple algorithms.
-   A grammar is LL(1) if it can be parsed by considering only one
    non-terminal and the next token in the input stream.

To ensure a grammar is LL(1) we must do the following:

-   Remove any ambiguity as shown above.
-   Eliminate any left recursion.
-   Eliminate any common left prefixes.

## Eliminating Left recursion

LL(1) grammars cannot contain **left recursion** which is a rule of the
form A → A*α* or, more generally, any rule A → B*β* such that B ⇒ A*γ*
by some sequence of derivations.

[![](./images/c4_elim_left_recur.png)](./images/c4_elim_left_recur.png)

## Eliminating Common Left Prefixes

[![](./images/c4_elim_comm_prefix_1.png)](./images/c4_elim_comm_prefix_1.png)

Fixing the grammar will result in:

[![](./images/c4_g8.png)](./images/c4_g8.png)

## First and Follow Sets

-   In order to construct a complete parser for an LL(1) grammar, we
    must compute two sets, known as `FIRST` and `FOLLOW`.
-   Informally, FIRST(*α*) indicates the set of terminals (including
    *ϵ*) that could potentially appear at the beginning of any
    **derivation** of *α*.
-   FOLLOW(A) indicates the set of terminals (including $) that could
    potentially occur after any derivation of non-terminal A.
-   Given the contents of these two set, the LL(1) parser will always
    know `which rule to pick next`.

[![](./images/c4_first_set.png)](./images/c4_first_set.png)

For non terminals, it says this:

For each rule X → *Y*<sub>1</sub>*Y*<sub>2</sub>...*Y*<sub>*k*</sub> in
a grammar G:

-   FIRST(X) = a if FIRST(Y<sub>1</sub>) = a or (a =
    FIRST(Y<sub>n</sub>) and Y<sub>1</sub>…Y<sub>n</sub>  ⇒ *ϵ* )

In the above *a* = FIRST(*Y*<sub>*n*</sub>) refers to *n* where n can be
1,2 or *n*

*Y*<sub>1</sub>...*Y*<sub>*n* − 1</sub> ⇒ *ϵ* means
*ϵ* ∈ FIRST(*Y*<sub>1</sub>)...*ϵ* ∈ FIRST(*Y*<sub>*n* − 1</sub>)

[![](./images/c4_follow_sets.png)](./images/c4_follow_sets.png)

I also found the following source very helpful:

-   [jambe.con.nz
    source](https://www.jambe.co.nz/UNI/FirstAndFollowSets.html) (For
    first sets)
-   [cs.ecu.edu
    source](http://www.cs.ecu.edu/karl/5220/spr16/Notes/Top-down/follow.html)
    [Archive
    link](https://web.archive.org/web/20190203020902/http://www.cs.ecu.edu/karl/5220/spr16/Notes/Top-down/follow.html)
    (For follow set, example specifically)

I personally found that working out the examples, let me to understand
the above algorithm better. Always going back to the informal definition
above will help you. Now let's see an example:

[![](./images/c4_g9.png)](./images/c4_g9.png)

You can also use this [Haskell
module](https://hackage.haskell.org/package/context-free-grammar-0.1.1/docs/Data-Cfg-Analysis.html)
to find them. (Future todo: Write a blog post about it)

Now for Grammer *G*<sub>9</sub>, let's find out the follow sets:

FOLLOW(P) = {$} since P is the start state.

FOLLOW(E)

FOLLOW(E) contains $ since the sentinel form E shows that. (P =\> E)

E =\> TE' =\> FT'E' =\> (E)T'E'

yields a sentinel form where E is followed by `)`

FOLLOW(E')

P =\> E =\> TE' =\> E'

So, FOLLOW(E') contains $.

T =\> FT' =\> (E)T' =\> (TE')T'

yields a sentinel form where E' is followed by `)`

FOLLOW(T)

P =\> E =\> TE' =\> T

So, FOLLOW(T) contains $.

TE' =\> T+TE'

yields a sentinel form where T is followed by `+`

T =\> FT' =\> (E)T' =\> (TE')T' =\> (T)T'

yields a sentinel form where T is followed by `)`

FOLLOW(T')

P =\> E =\> TE' =\> FT'E' =\> FT' =\> T

We know that FOLLOW(T) contains $

T' =\> \*FT' =\> \*(E)T' =\> \*(+TE')T' =\> \*(+FT')T'

yields a sentinel form where T' is followed by `)`

FT' =\> (E)T' =\> (TE')T' =\> (FT'E')T' =\> (FT'+TE)T'

yields a sentinel form wherer T' is followed by `+`

FOLLOW(F)

P =\> E =\> TE' =\> T =\> FT' =\> F

So, Follow(F) contains $

FT' =\> F\*FT'

yields a sentinel form where F is followd by `*`

TE' =\> T+TE' =\> FT'+TE' =\> F+TE'

yields a sentinel form where F is followed by `+`

FT' =\> F\*FT' =\> F\*(E)T' =\> F\*(TE')T' =\> F\*(T)T' =\> F\*(FT')T'
=\> F\*(F)T'

yiels a sentinel form where F is followed by `)`

## Recursive Descent Parsing

-   LL(1) grammars are very amenable to write simple hand-coded parsers.
-   A common approach is a **recursive descent parser** in which there
    is one simple function for each non-terminal in the grammar. The
    body of the function follow the right hand sides of the
    corresponding rules: non-terminal results in a call to another parse
    function, while terminals result in considering the next token.

## Table Driven Parsing

-   An LL(1) grammar can also be parsed using generalized table driven
    code.
-   A table driven parser requires a grammar, a parse table and a stack
    to represent the current set of non-terminals.
-   The **LL(1) parse table** is used to determine which rule should be
    applied for any combination of non-terminal on the stack and next
    token on the input stream.

[![](./images/c4_l1_parse_table.png)](./images/c4_l1_parse_table.png)

[![](./images/c4_parse_table_g9.png)](./images/c4_parse_table_g9.png)

[![](./images/c4_ll_parsing_algo.png)](./images/c4_ll_parsing_algo.png)

# LR Grammars

-   While LL(1) grammars and top-down parsing techniques are easy to
    work with, they are not able to represent all of the structures
    found in many programming languages. For more general-purpose
    programming languages, we must use an LR(1) grammar and associated
    bottom-up parsing techniques.
-   LR(1) is the set of grammars that can be parsed via shift-reduce
    techniques with a single character of lookahead.
-   LR(1) is a super-set of LL(1) and can accommodate left recursion and
    common left prefixes which are not permitted in LL(1).

Example of LR(1) grammar:

[![](./images/c4_g10.png)](./images/c4_g10.png)

And it's first and follow sets are these:

[![](./images/c4_g10_sets2.png)](./images/c4_g10_sets2.png)

## Shift Reduce Parsing

-   LR(1) grammars must be parsed using the **shift-reduce** parsing
    technique. This is a bottom-up parsing strategy that begins with the
    tokens and looks for rules that can be applied to reduce sentential
    forms into non-terminals. If there is a sequence of reductions that
    leads to the start symbol, then the parse is successful.
-   A **shift** action consumes one token from the input stream and
    pushes it onto the stack.
-   A **reduce** action applies one rule of the form *A* → *α* from the
    grammar, replacing sentential form *α* on the stack with the non
    terminal *A*.

Example of shift-reduce parse of the sentence `id(id+id)` using Grammar
*G*<sub>10</sub>:

[![](./images/c4_shift_reduce.png)](./images/c4_shift_reduce.png)

In the above example, you can see that there is some action chosen at
each step. To understand how these decisions are made, we must analyze
LR(1) grammars in more detail.

## The LR(0) Automaton

-   An **LR(0) automaton** represents all the possible rules that are
    currently under consideration by a shift-reduce parser.
-   Each state in the automaton consists of multiple **items**, which
    are rules augmented by a **dot(.)** that indicates the parser's
    current position in that rule. For example, the configuration
    *E* → *E*. + *T* indicates that *E* is currently on the stack, and
     + *T* is a possible next sequence of tokens.
-   The automaton is constructed as follows. State 0 is created by
    taking the production for the start symbol (*P*→*E*) and adding a
    dot at the beginning of the right hand. This indicates that we
    expect to see a complete program, but have not yet consumed any
    symbols. This is known as the **kernel** of the state.

![](./images/c4_kernel.png)

-   Then, we compute the **closure** of the state as follows. For each
    item in the state with a non-terminal *X* immediately to the right
    of the dot, we add all the grammar that have X as the left hand
    side. The newly added items have a dot at the beginning of the right
    hand side.

![](./images/c4_closure.png)

-   From this state, all of the symbols (terminals and non-terminals
    both) to the right of the dot are possible outgoing transitions. If
    the automaton takes that transition, it moves to a new state
    containing the matching items, with the dot moved one position to
    the right. The closure of the new state is computed, possibly adding
    new rules as described above.

![](./images/c4_transition.png)

[![](./images/c4_lr_automaton.png)](./images/c4_lr_automaton.png)

-   The LR(0) automaton tells us the choices available at any step of
    bottom up parsing. When we reach a state containing an item with a
    dot at the end of the rule, that indicates a possible reduction. A
    transition on a terminal that moves the dot one position to the
    right indicates a possible shift. While the LR(0) automaton tells us
    the available actions at each step, it does not always tell us
    `which` action to take.

Two types of conflict can appear in an LR grammar:

-   A **shift-reduce conflict** indicates a choice between a shift
    action and a reduce action. Example: State 4 in the above automaton

[![](./images/c4_shift_reduce_conflict.png)](./images/c4_shift_reduce_conflict.png)

-   A **reduce-reduce conflict** indicates that two distinct rules have
    been completely matched, and either one could apply.

[![](./images/c4_reduce_reduce.png)](./images/c4_reduce_reduce.png)

The LR(0) automaton forms the basis of LR parsing, by telling us which
actions are available in each state. But, it does not tell us which
action to take or how to resolve shift-reduce and reduce-reduce
conflicts. To do that, we must take into account some additional
information.

## SLR Parsing

-   **Simple LR(SLR)** parsing is basic form of LR parsing in which we
    use `FOLLOW` sets to resolve conflicts in the `LR(0)` automaton.
-   In short, we take the reduction *A* → *α* only when the next token
    on the input is in `FOLLOW(A)`. If a grammar can be parsed by this
    technique, we say it is an **SLR grammar**, which is a subset of
    LR(1) grammars.
