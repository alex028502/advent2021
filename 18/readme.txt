
I'm sure there is something more LISPy I could have done about this.
But I couldn't imagine how to find the number to the left and the number to the
right regardless of the hierarchy.  I used eval for the magnitude at the end.

I did part ii without creating any new module functions - I just added up the
the input file differently.  It takes 20 seconds.  It's hard to imagine an
optimisation.. Could there be a pattern in here? I didn't do anything clever to
solve this.. except maybe the magnitude thing at the end.

If this takes too long in ci/prod I can split up the two main programs, and
then use both in tests, but not calculate the final answer for part ii every
build.
