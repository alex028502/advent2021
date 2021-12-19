#lang racket

(provide check-position)
(provide check-trajectory)
(provide />)
(provide get-on-target-probe-v0)

(define (get-on-target-probe-v0 x0 x1 y0 y1)
  (/> (cartesian-product (range (find-min-vx0-to-reach-x x0) (add1 x1))
                         (range y0 (- 1 y0)))
      (curry map (curry check-trajectory x0 x1 y0 y1))
      (curry filter number?)))


;; If we just returned 0, it would just take longer
;; > (find-min-vx0-to-reach-x 10)
;; 0
;; > (find-min-vx0-to-reach-x 10)
;; 4
;; > (find-min-vx0-to-reach-x 11)
;; 5
;; > (find-min-vx0-to-reach-x 9)
;; 4
(define (find-min-vx0-to-reach-x x [s 0])
  (if (>= (apply + (range 0 (add1 s))) x)
      s
      (find-min-vx0-to-reach-x x (add1 s))))

;; this returns the max height for every successful shot but I don't use i
;; this was written this way for my original attempt at part i and is now only
;; used in part ii
(define (check-trajectory x0 x1 y0 y1 v0 [pos '(0 0)] [apex 0])
  (let ([result (apply check-position x0 x1 y0 y1 pos)]
        [acme (max (last pos) apex)]) ;; instead of "new-apex"
    (if result
        (if (equal? result "T") acme result)
        (apply check-trajectory
               x0
               x1
               y0
               y1
               (append (next-v-pos v0 pos) (list acme))))))

(define (next-v-pos v pos)
  (list (list (max 0 (sub1 (car v))) ; we never shoot backwards
              (sub1 (last v)))
        (apply map + (list v pos))))

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
