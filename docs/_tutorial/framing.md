---
layout: page
title: Framing
---
# Framing
The framing model that AutoProof uses is based on *modifies clauses*. The
`ACCOUNT` class deliberately used three different ways of specifying the modifies
clause to demonstrate the differences between them.

## `modify_model (fields, objects)`
Using `modify_model` you can specify that model fields may change during
the execution of a routine. You can specify one or more model fields by
providing as first parameter a manifest string with the name of the model
attribute or a manifest tuple with multiple manifest strings. The second
parameter is either a single object, a single set of objects of type `MML_SET`,
or a manifest tuple with mixed objects or sets of objects.

```eiffel
deposit (amount: INTEGER)
	...
	ensure
		modify_model ("balance", Current)
	end
```

This routine is allowed to modify the model field `balance` of the
`Current` object.

The effect of `modify_model` is as follows: each model attribute specified
in the `modify_model` clause *as well as each non-model attribute* can be
modified in the routine. All model fields that are not listed remain unchanged.
This means in turn that for clients all non-model attributes are potentially
modified even though they are not listed in the modifies clause.


## `modify_field (fields, objects)`
With `modify_field` you specify directly which attributes may be changed
by a routine. As before, you can specify one or more attribute names by
providing as first parameter a manifest string with the name of the model
attribute or a manifest tuple with multiple manifest strings. The second
parameter is again either a single object, a single set of objects of type `MML_SET`,
or a manifest tuple with mixed objects or sets of objects.

This way of specifying the modifies clause is lower-level than specifying
which model fields may change. This is also the reason we are required to
add the ghost field `closed` in the example shown here. The `closed` field is
a boolean flag that is `True` whenever an object is in a consistent state. (see
[class invariants]({% link input-language.md %}#class-invariant) for details).

```eiffel
withdraw (amount: INTEGER)
	...
	ensure
		modify_field (["balance", "closed"], Current)
	end
```
This routine is allowed to modify the attributes `balance` and `closed` of
the `Current` object.

## `modify (objects)`
The third option to specify modifies clauses is to give a list of objects which
can be modified without limiting the modifications to certain attributes or
model fields. For this modifies clause you can specify mixed objects or sets
of objects.

```eiffel
transfer (amount: INTEGER; other: ACCOUNT)
	...
	ensure
		modify (Current, other)
	end
```

This routine is allowed to modify all attributes of `Current` and `other`.

Since the objects may be modified freely, you have to specify the full effect
on the modified objects. For example the `transfer` procedure of the
account example, the postcondition not only describes the effect on the
`balance` attribute of the two objects but also has clauses to specify that
the `credit_limit` attribute does not change. This is for demonstration pur-
poses only, it would be a better design to use `modify_model` instead (*try to
change it!*).

Giving an empty tuple as argument --- `modify ([])` --- denotes that nothing
may be modified, i.e., that the routine is *pure*.

## Default modifies clauses
When no modifies clause is given a default modifies clause is used based on
the type of routine:
* For **procedures** (routines without a return value), the default modifies
  clause is `modify (Current)`. So all attributes can be modified in a
  procedure if no specific modifies clause is given.
* For **functions** (routines with a return value), the default modifies
  clause is `modify ([])`. Therefore, by default, all functions are *pure*.

When you overwrite the default modifies clause for procedures, for example
to modify an object passed as parameter, and you want to be able to
modify the `Current` object as well, you will need to add `modify (Current)`
to the modifies clause (or a more specific version when only a subset of the
attributes needs to be modifiable).

## Combining modifies annotations
You can add several modifies annotations to a modifies clause. The set of
modifiable objects and attributes is the union of all modifies annotations.
