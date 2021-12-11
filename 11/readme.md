What a great problem!

This time I hashed the grid and used the coordinates as a key, so once that is
done the board can be any shape. So totally by accident, this can solve an
input like this:

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
