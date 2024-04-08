---
layout: default
title: Tutorial
---

# AutoProof tutorial

## Introduction
AutoProof is an auto-active (AutoProof tries to achieve an intermediate degree of automation in the continuum
that goes from *automatic* to *interactive*) verifier for the Eiffel programming language;
it proves functional correctness of Eiffel programs annotated with contracts.
The goal of this tutorial is to show how to verify Eiffel programs with Auto-Proof
through hands-on exercises.

### Preparations
TODO: Add installation instructions.

Old online version is [available](http://comcom.csail.mit.edu/comcom/#AutoProof).

### Structure
Each of the following sections describes in detail the use of AutoProof based
on increasingly complex examples. Each example is used throughout one
section to explain some of the concepts behind AutoProof and how they
are used to verify programs. Each section also has hands-on exercises with
verification tasks for one or more programs.

## Verification of Basic Properties
To prove functional correctness automatically, a program needs a machine-
readable specification. We are using Eiffel --- an object-oriented programming
language --- which allows one to write contracts as part of the program. Each
Eiffel routine is equipped with pre- and postconditions and each class has a
class invariant.

We will use the *Account* example to show the basic concepts of Auto-
Proof. The example consists of the two classes `ACCOUNT` and `ACCOUNT_TEST`.
The first class models a bank account and the second class consists of two
test cases that show proper and improper usage of the class. The full code
of class `ACCOUNT` is shown below.

```eiffel
note
  description: "Account class."
  model: balance, credit_limit

class ACCOUNT
create make

feature {NONE} -- Initialization

  make
	  -- Initialize empty account.
  note
	status: creator
  do
	balance := 0
	credit_limit := 0
  ensure
	balance_set: balance = 0
	credit_limit_set: credit_limit = 0
  end

feature -- Access

  balance: INTEGER
	  -- Balance of this account.

  credit_limit: INTEGER
	  -- Credit limit of this account.

  available_amount: INTEGER
	  -- Amount available on this account.
	note
	  status: functional
	do
	  Result := balance + credit_limit
	end

feature -- Element change

  set_credit_limit (limit: INTEGER)
	  -- Set ‘credit_limit’ to ‘limit’.
	require
	  limit_valid: limit ≥ (0).max(−balance)
	  modify_model ("credit_limit", Current)
	do
	  credit_limit := limit
	ensure
	  credit_limit_set: credit_limit = limit
	end

  deposit (amount: INTEGER)
	  -- Deposit ‘amount’ in this account.
	require
	  amount_non_negative: amount ≥ 0
	  modify_model ("balance", Current)
	do
	  balance := balance + amount
	ensure
	  balance_set: balance = old balance + amount
	end

  withdraw (amount: INTEGER)
	  -- Withdraw ‘amount’ from this account.
	require
	  amount_not_negative: amount ≥ 0
	  amount_available: amount ≤ available_amount
	  modify_field (["balance", "closed"], Current)
	do
	  balance := balance − amount
	ensure
	  balance_set: balance = old balance − amount
	end

feature -- Basic operations

  transfer (amount: INTEGER; other: ACCOUNT)
	  -- Transfer ‘amount’ from this to ‘other’.
	require
	  amount_not_negative: amount ≥ 0
	  amount_available: amount ≤ available_amount
	  no_aliasing: other 6 = Current
	  modify (Current, other)
	do
	  balance := balance − amount
	  other.deposit (amount)
	ensure
	  balance = old balance − amount
	  other.balance = old other.balance + amount
	  credit_limit = old credit_limit
	  other.credit_limit = old other.credit_limit
	end

invariant
  limit_not_negative: credit_limit ≥ 0
  balance_not_credit: balance ≥ −credit_limit

end
```

First you can look through the example and verify the two classes; all
routines, except for the deliberately failing test case, will be successfully
verified.

### Input Language
#### Eiffel Programs and Contracts
Here we give a short overview of the Eiffel programming language based on
the *Account* example.

##### Class definition
Eiffel is an object-oriented programming language. Classes
are defined with the `class` keyword. If no inheritance clause is given (as in
this example), then the class implicitly inherits from the class `ANY`, which
serves as a common ancestor for all classes.
```eiffel
class
  ACCOUNT
```

##### Constructors
To define constructors for the class, you can use the `create`
keyword, followed by a comma-separated list of constructors called *creation routines*.
If no constructor is defined, the routine `default_create` will implicitly
become the only creation routine. In our example the routine `make`
will be the creation procedure.
```eiffel
create
  make
```

##### Features and visibility
Routines and attributes (together called *features*)
are defined in feature blocks using the `feature` keyword. Feature blocks can
declare a visibility restriction by indicating a list of class names in curly
braces. For example the first feature block restricts the access of the make
routine to `NONE`, essentially hiding the routine from all other classes (no class
can inherit from `NONE`). The other feature blocks do not have any access
restriction and thus the features inside these feature blocks are public. It is
common to name feature clauses by adding a comment using the double-dash
`--` comment style (there are no multi-line comments in Eiffel).
```eiffel
feature {NONE} -- Initialization
feature -- Access
feature -- Basic operations
```

##### Attributes
Attributes are defined with an attribute name followed by the
type of the attribute. For all features it is common to add a comment on the
line following the feature declaration.
```eiffel
balance: INTEGER
	-- Balance of this account.
```

##### Routines
A routine declaration consists of the routine name, optional parameters,
optional return type, optional precondition, routine body and optional
postcondition. The precondition denoted by the `require` keyword
and postcondition denoted by the `ensure` keyword are the specification of
the routine. The precondition holds prior to the execution of the routine,
and the postcondition holds afterwards. Therefore the precondition is the
responsibility of the client of the routine, whereas the postcondition has to
be established by the routine itself. If a pre- or postcondition is omitted, the
routine will have an implicit pre- or postcondition of `True`.
```eiffel
set_credit_limit (limit: INTEGER)
	-- Set ‘credit_limit’ to ‘limit’.
  require
	limit_valid: limit ≥ (0).max(−balance)
	modify_model ("credit_limit", Current)
  do
	credit_limit := limit
  ensure
	credit_limit_set: credit_limit = limit
  end
```

##### Assertion tags
Each assertion, be it a precondition, a postcondition, a
class or loop invariant, or an intermediate check instruction, can have an
*assertion tag*. These tags are useful for debugging, as the feedback from
AutoProof will specify the tag of violated assertions.

##### Class invariants
Class invariants are written at the end of a class using
the *invariant* keyword. Class invariants define the state of a consistent
object and hold by default whenever an object is visible to other classes, for
example at the beginning and end of each public routine.
```eiffel
invariant
  credit_limit_not_negative: credit_limit ≥ 0
  balance_not_below_credit: balance ≥ −credit_limit
```
There are more details on how to write an Eiffel program and what spec-
ification can be written for the verification with AutoProof; this will be ex-
plained throughout the rest of the tutorial.

#### AutoProof Annotations
AutoProof supports tow forms of custom annotations: note clauses for fea-
tures and classes, and dummy routines made available through *ANY*.

Note clauses are used to denote special types of routines and attributes
that influence the verification like creation routines (see (TODO: add link) Section 1.5) or ghost
features (see (TODO: add link) Section 2.6). Additionally, note clauses are used to disable
defaults for implicit pre-/postconditions of the ownership methodology (see
(TODO: add link) Section 3.4).

The second form of AutoProof annotations are dummy features (routines
and functions with empty implementation) that can be used in assertions
or regular code. These features are defined in class `ANY` and are available
everywhere. AutoProof gives special semantics to these features, for example
to specify modifies clauses (see (TODO: add link) Section 1.4).

You can look at the AutoProof [manual](https://se.inf.ethz.ch/research/autoproof/manual/#annotations) (TODO: copy manual)
for a complete listing of custom
annotations of both note clauses and dummy features.

### Basic Properties
TODO: continue from here
