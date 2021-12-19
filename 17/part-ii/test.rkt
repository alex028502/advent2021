#lang racket

(require rackunit)

(require "./unit.rkt")

#|

UNUSED
it turns out I didn't need to know this for part i. I could have done it this
way once I had narrowed down the range.. but I eventually narrowed down the
range to one vertical velocity, and figured out that I don't need to know the
horizontal component to answer the question

there are nine zones - but some can be grouped
take a look at sample.txt

S - short
L - long
T - on target
. - don't know yet
U - unlucky

if it hits an unlucky zone I can't use that value, but I can't stop sweeping
either - just skip to the next one

y to list-ref conversion
 1   0
 0   1
-1   2
-2   3
list-ref is (- 1 y)
|#

;; modify function to give X at orgin to make sure origin of test data is
;; lined up correctly
(let* ([sample '("........LLLLL" ;;  1 row
                 "X.......LLLLL" ;;  0 row
                 "........LLLLL" ;; -1 row
                 "........LLLLL" ;; -2
                 "....TTTTUUUUU" ;; -3
                 "....TTTTUUUUU" ;; -4
                 "....TTTTUUUUU" ;; -5
                 "SSSSUUUUUUUUU" ;; -6
                 "SSSSUUUUUUUUU" ;; -7 ;; (- 1 h)
                 "SSSSUUUUUUUUU")] ;; -8 ;; (- 2 h)
       [dot->false (λ (c) (if (equal? c ".") #f c))]
       [get-expected-answer (λ (x y)
                              (/> sample
                                  (curryr list-ref (- 1 y))
                                  (curryr substring x (add1 x))
                                  dot->false))]
       [sut (curry check-position 4 7 -5 -3)]
       [sutx (λ (x y) (if (and (= x 0) (= y 0)) "X" (sut x y)))]
       [w (string-length (car sample))]
       [h (length sample)]
       [pts (cartesian-product (range 0 w) (range (- 2 h) 2))])
  (begin
    (check-equal? 1 1)
    (check-equal? (length pts) (* 13 10))
    (for-each (λ (coordinates)
                (check-equal? (apply sutx coordinates)
                              (apply get-expected-answer coordinates)
                              coordinates))
              pts)))

;; example from question
(let ([sut (curry check-trajectory 20 30 -10 -5)])
  (begin
    (check-equal? (sut '(7 2)) 3)
    (check-equal? (sut '(6 3)) 6)
    (check-equal? (sut '(9 0)) 0)
    (check-equal? (sut '(17 -4)) "U")
    (check-equal? (sut '(6 9)) 45)
    (check-equal? (sut '(0 0)) "S") ;; they didn't give an example for this
    (check-equal? (sut '(10 10)) "L"))) ;; or this

(check-equal? (length (get-on-target-probe-v0 20 30 -10 -5))
              112
              "answer to part ii")
(check-equal? (apply max (get-on-target-probe-v0 20 30 -10 -5))
              45
              "show that we _could_ use this to answer part i")
