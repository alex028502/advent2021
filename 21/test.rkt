#lang racket

(require rackunit)

(require "./module.rkt")

(check-equal? (main "4" "8") 739785)

(check-equal? (roll-once 0) 1)
(check-equal? (roll-once 1) 2)
(check-equal? (roll-once 99) 100)
(check-equal? (roll-once 100) 1)
(check-equal? (roll-once 101) 2)

;; unfortunately no examples for the die turning over but hopefully I can rely
;; on the test above
(check-equal? (roll 0) (+ 1 2 3))
(check-equal? (roll 3) (+ 4 5 6))
(check-equal? (roll 6) (+ 7 8 9))
(check-equal? (roll 9) (+ 10 11 12))

(check-equal? (position-+ 3 3) 6)
(check-equal? (position-+ 7 (+ 2 2 1)) 2)
(check-equal? (position-+ 10 1) 1)
(check-equal? (position-+ 9 1) 10)
