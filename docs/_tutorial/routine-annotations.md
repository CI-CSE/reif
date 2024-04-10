---
title: Routine annotations
---
# Routine annotations
## Creation procedures
Creation procedures can be used as regular routines as well. Therefore,
AutoProof will verify all creation routines twice, once as creation routines
and once as regular routines. The context of the verification is different for
the two verifications, as for example for creation routines all attributes are
initialized to their default values before the routine is executed.

You can instruct AutoProof to verify a creation routine only once by
adding a `creator` annotation. This denotes the routine as being creation-
only and AutoProof will not verify it as a regular routine.

```eiffel
make
	note
		status: creator
	do ... end
```

Marks `make` to be only a creation routine.

## Functional functions
AutoProof supports a special type of function, consisting of only a single
assignment to `Result`. To declare such a function you have to add a
`functional` annotation to the function. These functions are defined by their
implementation and have an implicit postcondition; given an implementation
`Result := x` the implicit postcondition will be `Result = x`.

```eiffel
available_amount: INTEGER
	note
		status: functional
	do
		Result := balance + credit_limit
	end
```

Marks `available_amount` to be *functional*, therefore only consisting
of a single assignment to `Result`.
