#lang racket

(provide main)
(provide practice-roll)
(provide roll-once)
(provide position-+)
(provide />)

(define n 3)

;; 10k games takes 46 seconds so I would be surprised if this works
;; except that we don't actually have to play every game - so who knows
;; (define (main . start-squares)
;;   (foldl (λ _
;;            (apply main- start-squares))
;;          0
;;          (range 10000)))

(define (main . args)
  (let ([start-squares (filter identity (map string->number args))])
    (if (member "--practice" args)
        (practice start-squares (make-list (length start-squares) 0) 0)
        (play start-squares (make-list (length start-squares) 0) 0))))

(define (practice positions points rolls)
  (if (> (length (filter (curryr >= 1000) points)) 0)
      (* (apply min points) rolls)
      (let* ([player-idx (modulo (/ rolls n) 2)]
             [new-space (position-+ (list-ref positions player-idx)
                                    (practice-roll rolls))])
        (practice (list-set positions player-idx new-space)
                  (list-update points player-idx (curryr + new-space))
                  (+ rolls n)))))

;; this is a perfect case for unit testing
(define (position-+ pos spaces)
  (/> pos sub1 (curry + spaces) (curryr modulo 10) add1))

(define (practice-roll rolls)
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

;; --- part ii ---

;; I have left this unfinished.  It should get the max of the two numbers
;; '(106768284484217 63041043110262)
;; except it takes 11 minutes
;; so I don't want to run it over and over until I get it working
;; I could lower the winning score and fix it... but I actually got the
;; correct answer already, so I'm just gonna leave this one unfinished
(define (play positions points rolls)
  (let ([winners (map (curryr >= 21) points)])
    (if (> (length (filter identity winners)) 0)
        (map boolean->number winners)
        (let* ([player-idx (modulo (/ rolls n) 2)]
               [space (list-ref positions player-idx)])
          (/> (map
               (λ (total-frequency)
                 (vec-*
                  (last total-frequency)
                  (let ([new-space (position-+ space (car total-frequency))])
                    (play (list-set positions player-idx new-space)
                          (list-update points player-idx (curry + new-space))
                          (+ rolls n)))))
               possibilities)
              (curry apply vec-+))))))

(define (boolean->number b)
  (if b 1 0))

;; vector addition
;; borowed from yesterday
(define (vec-+ . pts)
  (apply map + pts))

;; vector multiplication (not the datatype vector - it's for lists)
(define (vec-* n pt)
  (map (curry * n) pt))

;; the roll count doesn't change the output
;; let's calculate this one instead of calculating it millions of times
;; every turn splits into seven possibilities with different weights
;; > possibilities
;; '((3 1) (4 3) (5 6) (6 7) (7 6) (8 3) (9 1))
(define possibilities
  (filter (λ (x) (> (last x) 0))
          (map list
               (range (add1 (* 3 n)))
               (foldl (λ (next acc) (list-update acc next add1))
                      (make-list (add1 (* 3 n)) 0)
                      (map (curry apply +)
                           (apply cartesian-product
                                  (make-list 3 (range 1 (add1 n)))))))))
