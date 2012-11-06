Given:

Rails only calls interactors, queries and commands are only called by Interactors.



How to do Authorization in Pavlov:

There are multiple facets to whether someone is authorized:

1. Can this person execute this operation
2. Can this person see the result

We decided that the best way to handle this is:

The interactors check whether an operation is authorized before running the execution code, but not in the initialization. This is not implemented yet, but will mean an interactor has something like run which does authorize; execute.

When objects are retrieved by the interactor, and the user is not authorized to see all of them, he only gets the set which he is authorized to see. If one object is retrieved, and this is not authorized, this is clearly an exceptional situation (in the sense that it shouldn't happen), and an exception is thrown.
