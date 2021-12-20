#lang racket

(require rackunit)

(require "./unit.rkt")

;; inside, this algrithm is stored as a binary # - but this test doesn't know
;; that in case I want to change it to a vector
(let ([algorithm (prepare-algorithm "...#..")])
  (check-equal? (lookup algorithm 0) 0)
  (check-equal? (lookup algorithm 1) 0)
  (check-equal? (lookup algorithm 2) 1)
  (check-equal? (lookup algorithm 3) 0)
  (check-equal? (lookup algorithm 4) 0))
