---
layout: page
title: AutoProof quick start guide
---
# AutoProof quick start guide

This page gives a short introduction to using AutoProof.

Many things here are simplified in this guide.
For a more systematic description
please go to the [AutoProof tutorial][tut].

## What is AutoProof
AutoProof is a static program verifier for Eiffel. It means that
AutoProof can take Eiffel programs with contracts and verify
that contracts hold in all executions without
running the code.

AutoProof generates a model of the program
and tries to mathematically prove that contracts hold.

### What AutoProof can do?
For example, AutoProof can "see" that the postcondition of
the following function holds.
```eiffel
double (a: INTEGER): INTEGER
  do
    Result := a + a
  ensure
    is_double: Result = 2 * a
  end
```
AutoProof's output for this feature is `Successfully verified` as expected.

AutoProof can also "find the bug" in the following implementation:
```eiffel
double (a: INTEGER): INTEGER
  do
    if a = 7 then
    Result := 0
  else
    Result := a + a
  end
  ensure
    is_double: Result = 2 * a
  end
```
AutoProof's output for this feature is `Postcondition is_double may be violated`
also as expected. Indeed, when the argument `a` is equal to `7`,
the postcondition does not hold.

Suppose there is a precondition saying that `a` cannot be `7`.
Then there is no bug and the postcondition "always" holds. More correctly,
the postcondition holds if the precondition held at the beginning
of the routine.

```eiffel
double (a: INTEGER): INTEGER
  require
    a_is_big: a > 100
  do
    if a = 7 then
    Result := 0
  else
    Result := a + a
  end
  ensure
    is_double: Result = 2 * a
  end
```
AutoProof's output is again `Successfully verified`. Indeed,
if `a` is greater than `100`, then it cannot be `7`, so the
execution cannot enter the `then` branch.

### What AutoProof cannot do?
AutoProof cannot invent contracts. If there are no contracts, AutoProof
has nothing to verify.

If the program has not enough contracts (underspecification),
then AutoProof can say that some check might be violated, while
in reality this case cannot happen. Additional preconditions
can limit the possible initial state set, which would exclude the impossible
states.

Some program mechanisms such as loops, recursion, invariants relying
on other objects can be handled by AutoProof
but they require extra contracts. Loops are discussed later
in this guide. The other mechanisms are out of scope of this guide.

TODO: explain more.

## Installing AutoProof
AutoProof is a part of Reif. See the [Reif installation][install] page for
details.

## Using AutoProof online
An online version of AutoProof is available at
<http://autoproof.sit.org/comcom/#AutoProof>.

There are several example programs available on that page.
You can replace the text of any example with your code.

Click the **Verify** button to start AutoProof on your code.
After AutoProof verification completes, verification results
of every feature in the class will be visible in the box under
the Verify button.

Notice that the *ACCOUNT* example does not verify. Indeed, there
are bugs in the program. Can you fix the bugs and make all features verify?

## Writing Eiffel for AutoProof
Writing code in Eiffel to be verified by AutoProof is not that
different from writing normal Eiffel with contracts.

### Assertions `check`
The `check` instruction can be used to add an assertion which
must be verified by AutoProof at the respective point in the program.
Consider the following example:
```eiffel
check_demo
  local
    a: INTEGER
  do
    a := 5
    check a_is_five: a = 5 end
    check a_is_not_seven: a /= 7 end
    a := a + a
    check a_is_ten: a = 10 end
    check a_is_five_again: a = 5 end -- This fails
  end
```
Verification output is `Check a_is_five_again be violated`. Removing
the `a_is_five_again` assertion gives the `Successfully verified` result.

Notice that assertion `a = 5` was checked in two different points
of program: the second and the last line of the routine.
The first assertion verified (indeed, `a` is `5` because it was
assigned this value just one line above), the second assertion did not
verify because at that point in the program `a` is in fact `10`.

### Precondition `require`
The precondition of a routine is written after the `require` keyword.
It can be assumed that the precondition holds before the first
instruction in the body.

The order of precondition clauses is important. The first clause is checked first,
then it can be used for checking the second clause and so on. In Eiffel terms,
it is similar to precondition clauses to be joined using `and then`.

```eiffel
precondition_demo (a: INTEGER)
  require
    a_is_five_or_ten: a = 5 or a = 10
  do
    check a_is_small: a < 100 end
  end
```

This feature is successfully verified. Indeed, because of the precondition
`a_is_five_or_ten` we can assume that `a` is `5` or `10` and
both cases are less than `100`, so the assertion `a_is_small` verifies.

### Conditional instruction `if then else`
Conditional instruction has a `then` branch and an optional `else` branch.
It can be assumed that the condition holds at the beginning of the `then`
branch and the condition does not hold at the beginning of the `else` branch.

```eiffel
conditional_demo (a: INTEGER)
  require
    a_is_five_or_ten_or_fifteen: a = 5 or a = 10 or a = 15
  do
    if a = 5 then
      check a = 5 end
    else
      check a /= 5 end
      check a = 10 or a = 15 end
      if a = 10 then
        check a = 10 end
      else
        check a = 15 end
        check a = 10 end -- This fails
      end
    end
  end
```

Only the last `check a = 10 end` does not verify in this feature.
Indeed, `a` could be one of `5`, `10`, `15` at the beginning of the body.
To reach the failing check `a` must be not `5` (to reach the `else` branch)
and `a` must be not `10` (to reach the next `else` branch).

If a branch is unreachable, its body "is not verified". You will not get
verification errors from the unreachable branches.
Consider the following example:

```eiffel
unreachable_demo
  do
    if 1 = 2 then
      check 2 = 1 end
    end
  end
```
This feature successfully verifies. There is no such state in which `1 = 2` holds,
so there is no possible execution that goes into the `then` branch,
so there is no state in which the verifier needs to prove that `check 2 = 1 end`
holds. So, in all possible executions there are no failing checks.

The `check False end` trick can be often used to check if a branch is reachable.
```eiffel
check_false_demo
  do
    if 1 = 2 then
      check first: False end
    end
    if 1 = 2 or 1 = 1 then
      check second: False end
    end
  end
```
Only the `second` check fails. The `first` check does not give an error.
It hints that the `first` check is not reachable and the `second` check
is reachable. Indeed, `1 = 2` does not hold and `1 = 2 or 1 = 1` holds.

The `check False end` assertion should always fail. If it does not result
in a verification error, then the verifier "thinks" that this line
is not reachable. You can use this trick for debugging. After you have
seen that the branch is reachable, remove the `check False end` assertion.


### Postcondition `ensure`
The postcondition of a routine is written after the `ensure` keyword.
The routine's body must end in a state where the postcondition holds, if
the precondition held at the beginning of the routine. In a function,
postcondition can use the `Result` variable which is the returned value.

```eiffel
postcondition_demo (a: INTEGER): INTEGER
  require
    a_is_even: a \\ 2 = 0
  do
    Result := a + 1
  ensure
    result_bigger: Result > a
    result_is_odd: Result \\ 2 /= 0
  end
```

This feature verifies. If we remove the precondition, then the
feature does not verify.

The order of postcondition clauses is important. The first clause is checked
after the last line of the body, then it can be assumed for checking
the second clause and so on.

### Feature calls `f (x)` and `g.f (x)` are opaque
The precondition of the called procedure must hold before the call.
After the call, only the postcondition of the procedure can be assumed.

Feature calls are opaque (opposite of transparent). This means that
details of the feature body are not visible from outside.

Consider the following function:
```eiffel
more (a: INTEGER): INTEGER
  require
    a_not_too_big: a < 100
  do
    Result := a + 1
  ensure
    result_is_greater: Result > a
  end
```

Even though according to the body this feature returns a number which
is greater that the passed value by exactly `1`,
callers of this feature do not know this.
Callers only see that the result is greater than the passed value.

```eiffel
call_demo (a: INTEGER): INTEGER
  do
    if a = 999 then
      Result := more (a) -- This fails
    end
    if a = 10 then
      Result := more (a)
      check Result > 10 end
      check Result = 11 end -- This fails too
    end
  end
```

Verification of this feature results in two errors. The first error is
`Precondition a_not_too_big may be violated on call to {ACCOUNT}.more`
in the first branch in which `a` is `999`. Indeed, calling `more (999)`
violates the precondition `a_not_too_big` which says that the argument must
be less than `100`.

The second error is `Check Result = 11 may be violated` in the second branch
in which `a` is `10`. Notice that the previous check `Result > 10` verifies.
Indeed, caller (`call_demo`) sees only the postcondition of `more`
which says that the result is simply greater than the passed value, so
`Result > 10` verifies. However, caller does not know the details of the body,
so AutoProof cannot prove the check `Result = 11`.

### Do not have inconsistent preconditions `require False`!
Be careful not to have an inconstistent precondition. If the routine's
precondition is not satisfiable, this routine will be **Successfully verified**
irrespective of its body or postcondition.
Most probably you do not want this!

```eiffel
inconsistent_precondition: INTEGER
  require
    contradiction: 1 = 2
  do
    Result := 10
  ensure
    result_is_25: Result = 25
  end
```

This verifier's output is `Successfully verified`, which can be surprising.
However, it makes sense. In all cases when the precondition is met (`1 = 2`),
the postcondition holds. It is just that there are no such states at all,
so there is no state where postcondition does not hold.

AutoProof verifies that for all initial states satisfying the precondition,
postconditions and intermediate checks are satisfied. If there are
no such initial states, the feature is successfully verified.

The most simple inconsistent precondition is just `False`:
```eiffel
simply_false: False
```

Contradicting precondition clauses also result in an inconsistent precondition:
```eiffel
a_positive: a > 0
a_negative: a < 0
```

These are just several examples of inconsistent preconditions. Many more
are possible depending on the surrounding program.

There are several ways to catch inconsistent preconditions.

Calling a feature with an inconsistent precondition will not verify.
Indeed, there will be no state that satisfies the inconsistent precondition.
So, you can write a test feature that calls your feature. If your test
feature verifies, it will be a proof of having at least several states
that satisfy the precondition.

Adding a `check False end` at the beginning of the feature body.
Verifying `check False end` should fail. If it does not fail, it means
that execution cannot reach this line. If the execution cannot reach the first
line, it might mean that the precondition is inconsistent.
After you have checked the precondition and `check False end` gives an error,
you can remove it to verify the rest of the routine.

These checks are not completely safe. However, they are quick ways to find
some inconsistencies using the verifier.

### Loops `from invariant until loop variant`
Verifying loops has some important differences when compared with
how they are executed.

Loops in Eiffel have the following parts in this order. While
some parts are optional, most probably you need to include them
to fully specify the loop behavior.

The `from` part containing the optional initialization instructions,
the optional `invariant` part containing the loop invariant assertions,
the required `until` part containing one boolean expression which
is the exit condition,
and the optional `variant` part containing one integer expression
which is the *loop variant*.

As a reminder, *loop variant* is an integer expression that must
decrease every iteration but cannot become less than zero.
The presence of such an invariant proves that the loop terminates, because
an integer value cannot decrease infinitely and must eventually stop
at zero or earlier.

When loops are executed, each next iteration
starts from the state that achieved at the end of the previous iteration.
The first iteration executes from the state that happened before the loop.

Verification uses a simplified model of loop execution to simplify the
verifier's job. This is a technical limitation. Consider the following loop:
```eiffel
from
invariant
  loop_invariant
until
  exit_condition
loop
  loop_body
variant
  loop_variant
end
```

Each iteration is verified starting in the same
abstract state which is represented by the loop invariant.
This way, loop iteration can assume the loop invariant and must ensure
loop invariant at the end. Additionally, iteration can assume that
the exit condition does not hold. In other words, we can
say that the loop body is verified similarly to the following procedure:

```eiffel
one_loop_iteration
  require
    invariant_assumed: loop_invariant
  loop_not_terminated: not exit_condition
  do
    loop_body
  ensure
    invariant_preserved: loop_invariant
    variant_decreased: loop_variant < old loop_variant
    variant_non_neg: loop_variant >= 0
  end
```

This imaginary feature highlights the important aspects of loop verification.
The loop body can rely on the invariant and can assume that exit condition
does not hold. Loop body must ensure loop invariant (even in the last iteration!).
The loop body can do anything with the exit condition:
keep it `False` or make it `True`.
The loop body must decrease the variant but must not make it negative.

Loops are opaque similarly to the feature calls. 
```eiffel
whole_loop_application
  require
    loop_invariant
  ensure
    loop_invariant
    exit_condition
  end
```

This imaginary feature shows the pre- and post-condition of a loop
as a whole. Loop application
requires the invariant and ensures the invariant and the exit condition.
Loop invariant must hold even if the exit condition holds before the first
iteration.

### Class creators `create`
The procedures which can be used to create a new object of the class
are called *creation procedures*. Creation procedures are specified in
the optional `create` part of the class text.

As a reminder, creator procedures are still available as features
of objects. AutoProof verifies such procedures two times in two
different contexts: as a normal procedure on an existing object
and as a creation procedure for a previously non-existing object.

```eiffel
class
  MY_COUNTER

create
  make_empty

feature
  count: INTEGER

  make_empty
    do
      -- count := 0 -- Uncomment to fix verification
    ensure
      count_is_zero: count = 0
    end
end
```

The class `MY_CONTAINER` lists `make_empty` as a creation procedure.
The verifier's output contains two messages for the two contexts of `make_empty`:

---|---
`MY_COUNTER.make_empty` *(creator)* | `Successfully verified.`
`MY_COUNTER.make_empty` | `Postcondition count_is_zero may be violated.`

Note the *(creator)* mark in the first message. It signifies
that this is the verification result of the feature in the creation context.

Indeed, when `make_empty` is used in creation,
`count` is initialized by Eiffel to zero by default.

However, it is still possible to call `make_empty` on an existing object.
In this case, `count` can have any value (other features could have changed it).
To satisfy the postcondition and fix the error, we can uncomment
the `count := 0` instruction. This way `make_empty` is correct
both as a creator and as a normal procedure.

### Class invariants `invariant`
Class invariant clauses are written at the end of the class after the `invariant`
keyword. In general, class invariant specifies the assertions which
must hold for objects of the class when they are visible.

There are much more nuances to class invariants.
Please read the [AutoProof tutorial][tut] to read more about invariants.

In this quick start guide we oversimplify and say that invariants
must hold at the beginning and at the end of procedures. This means
that procedures can assume the invariant (as if it was part of the precondition)
and must not break it (as if it was part of the postcondition).

```eiffel
class
  OVERFLOWING_COUNTER

feature
  count: INTEGER

  increment
    do
      check inv_before: -10 <= count and count <= 10 end
      count := count + 1
      -- Uncomment the following to fix verification
      -- if count > 10 then
      --   count := -10
      -- end
    end

invariant
  lower_bound: -10 <= count
  upper_bound: count <= 10
end
```
Verifier's output is
`Invariant upper_bound might not hold on call to {ANY}.wrap` and the line
number is the line of the feature's `end` keyword. This message
means that the class invariant does not hold when it must hold
(end of the procedure, in this case). Indeed, if `increment` is called
when `count` is exactly `10`, the procedure would increase `count`
and break the invariant clause `upper_bound`. To fix the problem,
we can uncomment the code which resets `count` to the lowest
valid value if it overflows.

Note that the `check` instruction successfully verifies. It means
that it is known that the invariant holds at the beginning of the procedure.

## Further reading
To continue learning about AutoProof, please go to the [AutoProof tutorial][tut].
The tutorial provides much more detail on the topics already covered here
and talks about advanced features of AutoProof.

[tut]: {% link _tutorial/index.md %}
[install]: {% link installation.md %}
