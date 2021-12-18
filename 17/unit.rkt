#lang racket

(provide check-position)
(provide check-trajectory)
(provide />)

#|

I was working on this library "called unit" because it gets unit tested, so
it's like the unit that the unit test tests.. I was working on it and then
didn't need it.  I'll either use it for part ii, or delete it.

(define (optimise x0 x1 y0 y1)

|#

;;(define (find-trajectory-with-style x0 x1 y0 y1)

;; do we need to worry about y less than zero?
;; if we need it, than the best we can do is apex 0
;; which means we don't need to worry about short vs unlucky results
;; at least not for this stage - even though check-position tells us

(define (find-best-apex-for-vx x0 x1 y0 y1 vx [vy 0] [record 0])
  (let ([apex (check-trajectory x0 x1 y0 y1 (list vx vy))])
    (if (or (equal? apex "L") (> vy (* 10 x1)))
        record
        (find-best-apex-for-vx x0
                               x1
                               y0
                               y1
                               vx
                               (add1 vy)
                               (max record (if (number? apex) apex 0))))))

;; (define (find-best-apex-for-vy x0 x1 y0 y1 vy [vx 1] [record 0])
;;   (let ([apex (check-trajectory x0 x1 y0 y1 (list vx vy))])
;;     (if (equal? apex "L")
;;         record
;;         (find-best-apex-for-vx x0 x1 y0 y1 vy (add1 vx) (max record
;;                                                              (if (number? apex)
;;                                                                  apex
;;                                                                  0))))))

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
