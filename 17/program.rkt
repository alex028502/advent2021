#lang racket

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))

#|

I have kind of cheated here.  The question says to find the initial velocity,
and then to answer the highest position it reaches but I have skipped the
initial velocity.  I also cheated a bit when parsing the file.  Part ii will
probably force me to do it all the long way, so I kept all the stuff I
calculated already.

I tried to go through all the points, but had to think more about how far y
could go to know when to stop.  I also realised that any trajectory will reach
a certain x and then stop and fall straight down.

After that, I realised that since y and x are independent, and we know that the
vertical trajectory will be the name no matter what the horizontal trajectory
is... I could just ignore the horizontal part.  Also, from my trials and errors
I realised that the real problem is skipping the target area.

So finally this is the idea:

WHAT GOES UP MUST COME DOWN

so when you shoot something up, it's vertical speed right before crossing the
x-axis on the way back down will be the same as the initial vertical speed
so the first leap into negative vertical space will be one longer than the
initial vertical velocity.  This can't be farther than the bottom of the target
area.  So the initial vertical velocity has to be one less than the distance to
the bottom of the target area to maximize the initial vertical velocity and
therefore maximize the highest point reached.

I might have never figured this out if I hadn't take the following steps:
- program for hours trying to calculate the answer
- get it wrong, but use the programs and the knowledge to make a graph
- go do something else, and think about it

|#

(display (/> (current-command-line-arguments)
             (curryr vector-ref 0)
             file->lines
             (curryr list-ref 0)
             (curryr string-split "y=")
             (curryr list-ref 1)
             (curryr string-split "..")
             (curryr list-ref 0)
             string->number
             -
             range
             (curry apply +)))

(display "\n")
