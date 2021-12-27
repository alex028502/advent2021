# Avent of Code 2021

I mainly attempted this to improve my LISP skills, or at least to get enough
practice and familiarity that I can now effortlessly digest LISP/Clojure demos,
and start to improve my LISP skills.

I also think all this practice will help me understand Erlang, OCaml, Elixir..
tutorials... since I have always found the recursion bits that hardest to get
through, and now I have had lots of recursion practice, so should be able to
take in all their examples a lot quicker.

If you are looking at this, there is a good chance that you are a potential
employer.  I am particularily proud of my solution to
[day 22](./22), my [pragmatic testing strategy](./tests)
and my use of [continuous integration](.github/workflows/ci.yml)

I didn't do too bad. I got all but three days (19 23 24). I thought I would
look at other people's answers, and do the ones I couldn't get, but for now, I
think I will just leave this here to show what I am capable of.

One thing I have learned from all of this is that I am not a "10x programmer".
Some of these took me all day.

In a couple cases, where a brute force solution was needed, and it was past my
bed time, I fell back on python.

I tried to solve [day 24](./24) by translating their pseudo assembler program
into a C program, and then looking to see if `gcc` optimised out any of the
arguments.. but I didn't crack it.

### source control

Also, if you are a potential employer, and want to asses my organizational
skills, you might not be too impressed by the code itself, but if you look at
the git history with `gitk`, that is where I think I really shine
organization-wise. Every commit on the left hand track passes the tests, and
the commits on the right hand track are ones that went into master for one
reason or another, but have failed the tests, so have been grouped or replaced
by an alternative history. There are no proper merges with a 3-way diff, mainly
because I can't figure out three way diffs. I only use merges to group commits
together, or to rewrite history without force pushing, so that every commit
in CI is visible in the repository.

### testing

The tests are written in python, but they only test the end result using the
example in the question.  All the intermediate stuff is tested with "repl style"
(well... probably not the best repl style, but I am trying to improve)

Github actions shows how to run the tests, checks python formatting, makes sure
that all solutions finish in a reasonable amount of time, and allows anybody
interesting to see my answers so that they can try their solution against my
input and check if we got the same answer.

For later questions, I ended up using unit tests written in racket. There are
trade-offs between writing unit tests that last forever, and testing
intermediate functions manually, and then hoping that the end to end tests
catch it if they are broken and then investigating by re manual testing. In
this project, the program is relatively simple, and the end to end test covers
almost every line of the implementation, so unit tests are not needed to cover
corner cases as much as to help get the functions right in the first place.

### test coverage

I tried to set up test coverage using
[this](https://docs.racket-lang.org/cover/basics.html) but it it is designed
to run all the tests in one go. If I do it with mine, I can't find an easy way
to aggregate the reports from all the tests. That's OK. There doesn't seem to
be any danger of unused branches so far. It just would have been cool to see a
coverage report.

### threading

Racket has a "threading macro", but I didn't use it. Instead I used a threading
function that I wrote myself.  I sometimes implemented it like this

```
(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))
```

The difference between this and the built in one is that this takes unary
functions as arguments... so everything in the list with other arguments
has to be curried explicity. I didn't mind though.  I this a really handy way
to reason about stuff... take the X, then do this, then do that.

I think the difference between the threading function that I created and the
threading macro that comes with racket and clojure is analogous to these two
proposals for the javascript pipe operator: "hack pipes" and "F# pipes".
https://github.com/tc39/proposal-pipeline-operator
The one I created is analogous to F# pipes.

### CI

Github actions came in really handy. I set it up at the start to run the tests,
but then I started to calculate my answers when my little raspberry pi 4
couldn't do it. I usually tried to find an efficient solutions, but there were
times where I just settled for somethign that took github actions a long time
to calculate.
