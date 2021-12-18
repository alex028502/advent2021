#lang racket

(require plot)
(require "unit.rkt")

;; was easier to figure out once I made a picture!

(define (action x0 x1 y0 y1 v0)
  (let ([answer (check-trajectory x0 x1 y0 y1 v0)])
    (plot (points
           (append (last answer)
                   (list (list x0 y0) (list x1 y0) (list x1 y1) (list x1 y1))))
          #:title (car answer))))

(action 20 30 -10 -5 '(6 10))
