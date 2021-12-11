What a great problem!

This time I hashed the grid and used the coordinates as a key. This makes it
really easy to deal with neighbours that are off the board. A totally
accidental feature of this method is that not all the rows have to be the same
length, and can be length zero, so this can solve an input like this:

```
11111
19991
19191
19991
11111

5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
```

and the blank row will make it so that flashes on one board can't effect the
other. I made a test to show this by combining the two sample inputs that I had.

This came in really handy in part ii because I wanted to make it give up after
a certain number in case there are possibl boards with no solution. To create
a board with no solution to test this, I just made an input file with two
octopuses separated by a blank line, so that they will each flash every ten
turns and never at the same time. Then I used this input to test the no
solution case in part ii. Otherwise, I would have made the limit the parameter
and then just tested it with a limit lower than the test solution.

This is a bit slow.  It takes about 3 seconds on my raspberry pi 4 to get an
answer. If I understand what the profiler is trying to tell me, the problem
isn't generating the list of neibouring directions... because I guess that only
happens once per flash - it's 'hash-keys'. So I guess if I made the 'board' data
structure a list of points as well as the hash, then the program might run a
little faster.


Luckily I listened to these two podcast episodes yesterday. They really
helped me figure out this question.
https://clojuredesign.club/episode/002-tic-tac-toe-state-in-a-row/
https://clojuredesign.club/episode/003-tic-tac-repl/
