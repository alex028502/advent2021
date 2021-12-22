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

(check-equal? (highest-number-in-rules '((#f (1 2) (-10 -2) (3 -40))
                                         (#f (1 2) (-10 -2) (3 -60))
                                         (#t (1 2) (-10 -2) (-3000 60))))
              3000)

(check-equal? (in3d '(1 2 3) '((1 2) (-20 -12) (-40 3))) #f)
(check-equal? (in3d '(1 2 3) '((1 2) (-2 4) (-40 3))) #t)
