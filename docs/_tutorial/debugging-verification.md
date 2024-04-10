---
title: Debugging verification
---
# Debugging verification
The only feedback given by AutoProof is whether a routine is successfully
verified or if some specific assertions could not be proven. When the
verification fails it can be necessary to find out which facts the verifier could
establish or even guide the verifier to the right conclusion. For this you can
use intermediate assertions (`check` instructions in Eiffel). During the debug-
ging process it can also be beneficial to *assume* specific facts and thus limit
the possible executions that the verifier considers during the proof.

## Assertions
Using Eiffel’s `check` instruction you can add an intermediate assertion that
will be verified by AutoProof. This can help to check if you have the same
understanding of the state at a program point as the verifier. You can add
multiple expressions to a single check instruction, and each expression can
be equipped with a tag. AutoProof will show the tags in error messages.

```eiffel
check tag: expr end
```

Check instruction to establish if `expr` holds.

Note that it is possible that when you have multiple consecutive assertions
successfully verified, removing an intermediate assertion will make the
verification of later assertions fail. In these cases you have to keep the assertion
in order to guide the verifier towards the successful verification.

## Assumptions
Eiffel does not support assumptions out of the box. To write an assumption
in AutoProof, you have to write a check instruction with the special tag
`assume`. AutoProof will assume the expression for the rest of the routine
without checking it.

You can use assumptions to limit the executions considered by the verifier.
For example by assuming `False` in a branch of a conditional instruction the
verification of that branch will always succeed.

```eiffel
if ... then
	...
else
	check assume: False end
end
```

Ignores all code path that go through the `else` branch.

Another way to use assumptions to limit executions it by restricting the
state space of otherwise unrestricted values. This can be used for example
to ignore executions where an array is empty.

```eiffel
check assume: not a.is_empty end
```

Ignores executions where `a` is empty.

## Inconsistencies
It can happen that verification succeeds due to inconsistent contracts or
assumptions. If you for example have a routine with the precondition `a > 0`
and an additional class invariant `a < 0` (or an assumption `a < 0` in the body of
the routine), your specification is inconsistent. This is essentially equivalent
to an assumption of `False` and the verifier will be able to derive any fact
from it, including false ones.

A quick (though not completely safe) check for inconsistencies is to add
an assertion or postcondition `False` to your routine. If the verifier manages
to prove the assertion, this is a sign for an inconsistency in the specification.
