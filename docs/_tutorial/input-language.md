---
layout: page
title: Input language
---
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
