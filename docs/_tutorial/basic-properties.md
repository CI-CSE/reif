---
layout: page
title: Basic properties
---
# Basic properties
## Booleans
The Eiffel boolean operations `not`, `and`, `or`, `xor`, and `implies` are supported
by AutoProof. The semi-strict operators `and then` and `or else` are also
supported with the correct semantics that the right-hand side only needs to
be valid if the left-hand side does not already define the overall value of the
expression.

## Integers
The Eiffel integer operations `+`, `-`, `*`, `//` (quotient of integer division), and
`\\` (remainder of integer division) are supported by AutoProof. Integers in
AutoProof can be modeled in two modes, either as mathematical integers or
as machine integers. By default integers will be modeled as mathematical
integers, though AutoProof can also check overflows of bounded integers (see
Section 2.8 (TODO: add link)).

The Eiffel comparison operations on integers `=`, `/=`, `<`, `>`, `<=`, and `>=` are
all supported.

## References
Comparison of objects always uses reference equality. The standard equality
operator `a = b` and inequality operator `a /= b` work as expected; object
equality `a ~ b` and inequality `a /~ b` are not supported and will fall back to
reference equality when used.
