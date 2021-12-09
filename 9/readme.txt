experimented with different ways to organise the program
- functions arranged in opposite order
- distinction between the function that solves the hard part of the problem and
the stuff you do at the end to multiply or add your answers together to prove
you got it right
- no calculated definitions so that I never have to reload more than the
function I have just edited
- nested threading functions that then has to use curryr

I tried not to cache anything by guessing what would take a long time, hoping
I would have to profile it after and find out for real, but then the whole
program ran in under two seconds... so no need I guess - but I might still
check one day.


--- about the problem ---

I found the watershed by exploring all higher neighbours until I hit 9 or the
edge of the board... which I just call 10 or 'infinity'. This works but I
don't understand how it works because two low points should be able to be
divided by a local maximum of 8.  Even if the only number that is allowed to
be adjacent to itself is 9, you could still have this

08769
87659
12349
99999

I think my formula will find the 0 and the 1 as the lowpoints and then it will
calculate the same basin for both of them I think.

The puzzle input must come with other guarantees that were not mentioned in the
instructions, or that I missed.  If I didn't have something that told me that I
got the right answer (me in real life) or I were not in this emergency situation
(me in the story), I don't think I would want to rely on this program without
understanding a bit more.
