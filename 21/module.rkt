#lang racket

(provide main)
(provide roll)
(provide roll-once)
(provide position-+)
(provide />)

(define (main . start-squares)
  (play (map string->number start-squares)
        (make-list (length start-squares) 0)
        0))

(define (play positions points rolls)
  (if (> (length (filter (curryr >= 1000) points)) 0)
      (* (apply min points) rolls)
      (let* ([n 3] ;; really a constant
             [player-idx (modulo (/ rolls n) 2)]
             [new-space (position-+ (list-ref positions player-idx)
                                    (roll n rolls))])
        (play (list-set positions player-idx new-space)
              (list-update points player-idx (curryr + new-space))
              (+ rolls n)))))

;; this is a perfect case for unit testing
(define (position-+ pos spaces)
  (/> pos sub1 (curry + spaces) (curryr modulo 10) add1))

(define (roll n rolls)
  (/> rolls
      (curry make-list n)
      (curry map + (range n))
      (curry map roll-once)
      (curry apply +)))

; needs to go from 1 to 100 instead of 0 to 99
(define (roll-once rolls)
  (/> rolls (curryr modulo 100) add1))

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))
