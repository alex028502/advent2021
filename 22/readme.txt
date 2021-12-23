part ii tests might take too long to run every time

I had a pretty cool solution to part i - take a look in source
control if you are interested.

I tried all kinds of clever stuff to make that one scale
before giving up and trying this instead.

I started by smashing each cuboid into up to 26 other cuboids when a new rule
came along and overlapped it, but that meant the part ii example took 23
seconds on my big computer and the real input part ii timed out after six hours
on github actions.  Now as soon as I break up the cuboid into after a new rule
replaces part of it, I try to put back together as many cuboids as possible
trying each dimension. This finishes the practice input on my big computer in
like two seconds, so I am hopeful about CI giving me the answer.
