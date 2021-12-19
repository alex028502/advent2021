

[this](./part-i) gets the answer to part i using a short-cut that I figured out
while trying to determine the range I had to scan. The question says

```
Find the initial velocity that causes the probe to reach the highest y
position and still eventually be within the target area after any step.
What is the highest y position it reaches on this trajectory?
```

but it never actually finds _the initial velocity_ - it just figured out the
_highest y position_.

---

[this](./part-ii) gets the answer to part ii. The question says this:

```
you need to find every initial velocity that causes the probe to
eventually be within the target area after any step.
```

except I didn't do that, because I already had a helper that returned to apex
of a trajectory, not the initial velocity itself.

I just skipped right to this:

```
How many distinct initial velocity values cause the probe to be within
the target area after any step?
```

This program could be modified to match the intent of part ii by making the
core function return the initial velocity if successful instead of returning
the maximum height.

If I did that I could unit test a part of the program against the list of
successful initial velocities in the example problem, and debug debug it, except
that it worked the first time, so I didn't have to do that.

Instead I might modify it to match the intent of part i, and find the over all
max height, which is much easier.
