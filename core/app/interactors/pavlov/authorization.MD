Given:

Rails only calls interactors, queries and commands are only called by Interactors.



How to do Authorization in Pavlov:

There are multiple facets to whether a user is authorized:

1. Can this user execute this operation
2. On which set of objects can this user execute this operation

We decided that the best way to handle this is:

The interactors check whether an operation is authorized before running the execution code, but not in the initialization. This is not implemented yet, but will mean an interactor has something like run which does authorize; execute.

When a operation is executed on one object and this is not authorized, this is clearly an exceptional situation (in the sense that it shouldn't happen), and an exception is thrown.

When a operation is executed on a set of objects, the operation will only execute on the subset the user is authorized for.
