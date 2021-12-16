I got both right answers, but seem to have done it the hard way.

#### racket program

* I created an elegant program in racket that assumes by the example that you can
only go down and left
```
xooooooooooo
xooooooooooo
oxxooooooooo
ooxxxooooooo
ooooxxxxxooo
ooooooooxxxx
```
but then got wrong answer so either have a bug in the program or you can go
backwards and up

#### python program

made a non elegant program in python that doesn't assume anything and just
checks all caves overs and over again against its neighbours to see if it can
create a shorter route by adding its risk level to its neighbour's risk level
and updates until there are now updates left because the cave total risk level
map has not changed over an iteration

this worked great on the sample data, as well as some extra tests, but then
failed got the wrong answer. This time the wrong answer was that there was a
bug in my program caused by messy variable naming that somehow the tests didn't
find. Once I noticed that I got the right answer and moved on to part ii.

#### part ii

the non elegant program totally worked but took seventeen minutes on github
actions. I really made a mess of the program by adding in the board multiplier.
I would like to put that in its own program that can pipe into either
implementation.

#### what now

I have two strategies in mind to figure out if my racket program has a bug or
or if there is an elegant way to handle backwards and up.

- modify the python program so that it outputs a map of the route to stderr
and then see if this is due to backwards and up
- look at somebody else's answer and find out how to do it

I'll sleep on it again before deciding which one.
