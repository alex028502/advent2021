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
