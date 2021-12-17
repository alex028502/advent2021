#lang racket

(provide />)
(provide packet-content)
(provide ceiling4)


(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))

;; I don't know if I need this all the time or just for literals
;; it would be strange if operator expressions were able to go out of phase
;; with the hex digits but literals weren't
(define (ceiling4 len)
  (/> len
      (curryr / 4)
      ceiling
      (curry * 4)))


(define (packet-content packet)
  (substring packet 6))
