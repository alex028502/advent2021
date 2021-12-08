I thought about seing if I could solve this with minikanren or datalog or prolog
but I am not sure if that is possible so I went back to brute force.

I generated a list of all possible wire mixup combinations and then just looked
up the info about existing combinations in my list.  I hashed the list, but I
am not sure if that was necessary.  There were only 200 exampes so I am sure
I could have searched the list 200 times.

I made other uneducated guesses about what to optimize.

I can't wait to look at how the pros figure this out!

I started using the curry function in combination with my threading function.
Works great. If you use the standard one, I think they basically curry
everything, so if the arguments are in the wrong order, I don't know how to
deal with it. and there are different threading macros for different args but
they won't all be the same in the same list. so I am gonna keep using mine.

