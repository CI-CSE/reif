---
title: Models
---
# Models
AutoProof supports *model-based* contracts. Models are used to express the
*abstract state space* of a class and describe its changes. To define the model
of a class you add a `model` annotation to the `note` clause of the class. The
model may only consist of attributes of the class.

```eiffel
note
  model: balance, credit_limit
class ACCOUNT
```

This makes the two attributes `balance` and `credit_limit` model fields of the
class.

The idea behind model-based contracts is to have an abstract and concise
yet expressive way to specify the interface of a class. When using models
you use the class invariant to describe object validity in terms of the model
attributes. The effect of each procedure is expressed by relating the pre-state
of the model fields to their post-state. In addition you can express the
framing specification in terms of the model fields.

The Mathematical Model Library (MML, see Section 2.1 (TODO: add link)) can be used
to model complex behavior. Also, ghost attributes might be introduced to
define abstract behavior in terms of other functions or attributes and can
then be used as model fields (see Section 2.6 (TODO: add link)).
