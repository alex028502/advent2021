# Avent of Code 2021

No promises about finishing the whole thing.

Trying to improve my LISP skills a little bit.

The tests are written in python, but they only test the end result using the
example in the question.  All the intermedia stuff is tested with "repl style"
(well... probably not the best repl style, but I am trying to improve)

Github actions is really just here because it is easier than documenting
dependencies and stuff.

The tests in theory should allow me to extract a function that I find myself
using every day into a shared module, and quickly make sure I haven't broken
anything, but I haven't done that yet.

I tried to set up test coverage using
[this](https://docs.racket-lang.org/cover/basics.html) but it it is designed
to run all the tests in one go. If I do it with mine, I can't find an easy way
to aggregate the reports from all the tests. That's OK. There doesn't seem to
be any danger of unused branches so far. It just would have been cool to see a
coverage report.
