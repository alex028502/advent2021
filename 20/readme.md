### part i

This was one of the rare ones where the tests passed, but the answer was wrong.
It turned out the trick was that in the example, the first character of the
algorithm string was `.` but in the real input it's `#`.

I only noticed because I was making sure I was adding enough cells each
iteration, and that changed the answer.  I solved the problem by putting a
point way out in space and calling it "the infinity point", and keeping track
of its value, and then using it as a default for any neighbours with no value.

To do this I had to change the hash from keeping track of only `#` to keeping
track of `#` and `.`, so that I could default uncharted points to the value
of the `infinity-point` and not to `.`.

### part ii

I'm unhappy with the tests I have written, so I didn't add tests for 50x.

The tests are already not covering the most important part - the rule
in the real data that if an unlit point has no lit neighbours, it lights
up, so testing more times with my unrepresentative test data didn't seem
worthwhile.  Instead I just ran it with the 50 argument and checked the answer.

I guess I could have put in the work to try it with a 2x2 image, but I just
went ahead and tried the program I had.
