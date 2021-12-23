#lang racket

(require rackunit)

(require "./module.rkt")

(check-equal? (parse-rule "on x=10..12,y=10..12,z=10..12")
              '(#t (10 12) (10 12) (10 12)))
(check-equal? (parse-rule "off x=1..2,y=-10..-2,z=3..-60")
              '(#f (1 2) (-10 -2) (3 -60)))

(check-equal? (in 2 '(1 3)) #t)
(check-equal? (in 2 '(-1 1)) #f)
(check-equal? (in 2 '(-1 2)) #t)
(check-equal? (in 2 '(1 3)) #t)
(check-equal? (in -2 '(1 3)) #f)
(check-equal? (in -2 '(-5 -2)) #t)
(check-equal? (in -2 '(-5 -1)) #t)
(check-equal? (in -2 '(-5 -3)) #f)

(check-equal? (in3d '(1 2 3) '((1 2) (-20 -12) (-40 3))) #f)
(check-equal? (in3d '(1 2 3) '((1 2) (-2 4) (-40 3))) #t)

#|
 123456789
1XXXXXXXXX
2XXOOOXXXX
3XXOOOXXXX
4XXOOOXXXX
5XXOOOXXXX
6XXOOOXXXX
7XXXXXXXXX
8XXXXXXXXX
9XXXXXXXXX
|#

(check-equal? (list->set (smash '((3 5) (2 6)) '((1 9) (1 9))))
              (list->set '(((1 2) (1 1)) ((1 2) (2 6))
                                         ((1 2) (7 9))
                                         ((3 5) (1 1))
                                         ((3 5) (7 9))
                                         ((6 9) (1 1))
                                         ((6 9) (2 6))
                                         ((6 9) (7 9)))))

#|
 123456789
1XXXXOOOOO
2XXXXOOOOO
3XXXXOOOOO
4XXXXOOOOO
5XXXXOOOOO
6XXXXOOOOO
7XXXXXXXXX
9XXXXXXXXX
|#

(check-equal? (list->set (smash '((5 15) (-2 6)) '((1 9) (1 9))))
              (list->set '(((1 4) (1 6)) ((1 4) (7 9)) ((5 9) (7 9)))))

(check-equal? (list->set (smash '((-3 -5) (-2 -6)) '((1 9) (1 9))))
              (list->set '(((1 9) (1 9)))))

(check-equal? (calculate-volume '((-3 5) (3 6) (1 9))) 324)
