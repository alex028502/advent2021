#lang racket

(provide lookup)
(provide prepare-algorithm)

;(define (prepare-image lines [y 0])

(define (add-line-to-image image line y [x 0])
  (if (= x (length line-list))
      image
      (add-line-to-image (add-point-to-image image x y (substring x (add1 x)))
                         line
                         y
                         (add1 x))))

;; only high points are set (infinite image technology)
(define (add-point-to-image image x y [v #t])
  (if v (hash-set image (list x y) #t) image))

;; was gonna use a vector, but maybe a binary number is quicker?
;; could always benchmark by changing these two methods
(define (prepare-algorithm line)
  (/> line
      (curryr string-replace "#" "1")
      (curryr string-replace "." "0")
      (curryr string->number 2)))

(define (lookup algorithm n)
  (arithmetic-shift (bitwise-and algorithm (arithmetic-shift 1 n)) (- n)))

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))
