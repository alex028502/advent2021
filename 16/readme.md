I can't believe that worked!

(evaluated locally before sending to ci this time)

I tried to learn to about lex and yacc this morning.  I think this might be a
non context-free language?  Anyway, I need to do a few practice problems with
yacc before I can recognise if it will make something easier.


I listed to this podcast on my walk
https://www.se-radio.net/2008/11/episode-118-eelco-visser-on-parsers/
and it inspired me to figure this out.

I don't think this is how you are supposed to inject the function into the
s-expressions for evaluation.

I used unit tests this time, and then debugged with Dr Racket. Not much
REPL this time. The unit tests made me think I should split it into a few files
and that made it harder to use the REPL (since I don't know how).
But yeah Dr Racket's debugger was really cool.

I don't know where the best place to break up that big iterative function is.
