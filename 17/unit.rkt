#lang racket

(provide find-best-apex-for-vx)
(provide check-position)
(provide check-trajectory)
(provide />)

#|

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

(define (check-trajectory x0 x1 y0 y1 v [path '((0 0))] [apex 0])
  (let* ([pos (car path)]
         [result (apply check-position x0 x1 y0 y1 pos)]
         [acme (max (last pos) apex)]) ;; instead of "new-apex"
    (if result
        (list (if (equal? result "T") acme result) path)
        (let* ([next-v-pos-tmp (next-v-pos v pos)]
               [next-v (car next-v-pos-tmp)]
               [next-pos (last next-v-pos-tmp)])
          (check-trajectory x0 x1 y0 y1 next-v (cons next-pos path) acme)))))

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
