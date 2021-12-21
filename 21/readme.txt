used a "module" this with a main function instead of a main program. also didn't
parse input file - was only two numbers so just used them as arguments.

The end to end test was not really necessary because the unit tests test the
main function, except that the first time I ran the program, I realised main was
set up to accept integers. so always work making sure the whole thing works.
Actually, then I realised I had put the wrong arguments into the calculation
section of ci (production) so I made a wrapper bash script to always get the
arguments right.

Even though I got my answer, part ii takes 11 minutes, and the program is
not tested, as part of automated tests because that would take 11 minutes.
I wish that the question had included some intermediate answers... like
tell us what the tally is for a game to 10 points, and then ask for the
answer for a game to 21.  Then I would be able to test this. But I have
no reliable answers for any lower numbers. I would have to get the test
answers from the program itself.
