#lang racket

(provide check-position)
(provide check-trajectory)
(provide />)

#|

(define (optimise x0 x1 y0 y1)

|#

(define (check-trajectory x0 x1 y0 y1 v [pos '(0 0)] [apex 0])
  (let ([result (apply check-position x0 x1 y0 y1 pos)]
        [acme (max (last pos) apex)]) ;; instead of "new-apex"
    (if result
        (if (equal? result "T") acme result)
        (apply check-trajectory
               x0
               x1
               y0
               y1
               (append (next-v-pos v pos) (list acme))))))

(define (next-v-pos v pos)
  (list (apply map + v pos)
        (list (max 0 (sub1 (car v))) ; we never shoot backwards
              (sub1 0))))

;; see diagram in test to find out what this means
(define (check-position x0 x1 y0 y1 x y)
  (cond
    [(and (<= x x1) (>= x x0) (<= y y1) (>= y y0)) "T"]
    [(and (< x x0) (< y y0)) "S"]
    [(and (> x x1) (> y y1)) "L"]
    [(or (< x x0) (> y y1)) #f] ; false for asking "do we know the answer yet?"
    [else "U"]))

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))
