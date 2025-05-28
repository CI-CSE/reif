---
layout: page
title: Verification of basic properties
---
# Verification of basic properties
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
