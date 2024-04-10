---
title: 'Hands-on: Clock'
---
# Hands-on: Clock
The `CLOCK` class is modeling a clock counting seconds, minutes and hours
of a day. The class contains routines to create the clock, set the time, and
increase the time.

1. Add a *model* declaration to define the abstract model.
2. Add a class `invariant` to restrict the attribute values.
3. Add a precondition to the creation procedure `make`.
  You should be able to verify `make` and `test_make`.
4. Add the specification to the `set_*` procedures.
  You should be able to verify the `set_*` and `test_set` procedures.
5. Add the specification to the `increase_*` procedures.
  You should be able to verify both classes completely.
