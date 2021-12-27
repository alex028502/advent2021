Tried two things:

- make a racket program that runs each instruction and splits into 9 paths
each time it hits an input
- convert the program to C, and see if any of the 14 arguments were optimised
out of the equation

Neither succeeded.  All 14 arguments seem to be used, but I had fun getting it
to work after I made a few mistakes.

The assembly language version of the program is in the artifacts in github
actions.

I am sure there is a pattern in there somewhere, but I have not found it.

Just in case, I have tried to figure out which arguments matter by trial and
error using the C program, and told a script to run it 10M times. So I still
might be lucky, but probably not, since the answer could be in a winning
combination of the digits that seem to not matter.
