#lang racket

(require rackunit)

(require "./unit.rkt")
(require "./sample.rkt")

;; inside, this algrithm is stored as a binary # - but this test doesn't know
;; that in case I want to change it to a vector
(let ([algorithm (prepare-algorithm "...#..")])
  (check-equal? (lookup algorithm 0) 0)
  (check-equal? (lookup algorithm 1) 0)
  (check-equal? (lookup algorithm 2) 0)
  (check-equal? (lookup algorithm 3) 1)
  (check-equal? (lookup algorithm 4) 0)
  (check-equal? (lookup algorithm 5) 0))

(check-equal? (prepare-line 2 ".#.#.") '((1 2) (3 2)))

(check-equal? (prepare-image '("#.." "..#" ".#."))
              (make-immutable-hash '(((0 0) . #t) ((2 1) . #t) ((1 2) . #t))))

(check-equal? (point-+ '(1 2) '(3 -3) '(1 1)) '(5 0))

; the last column only has dots so we get 4x5 instead of 4x6
(check-equal? (length (all-relevant-points (prepare-image '("#..." "..#."))))
              20)

(check-equal?
 (canvas->string (draw-points-on-canvas (blank-canvas 4 4) '((1 1) (2 3))))
 (string-join (list "...." ".#.." "...." "..#.") "\n"))

(check-equal? (string-length sample-image-enhancement-algorithm) 512)

;; main example
(let ([image (prepare-image sample-input-image-lines)]
      [algorithm (prepare-algorithm sample-image-enhancement-algorithm)])
  (for-each (λ (i)
              (check-equal?
               (if (= (lookup algorithm i) 1) "#" ".")
               (substring sample-image-enhancement-algorithm i (+ 1 i))
               i))
            (range 512))
  (check-equal? (get-regional-value image '(2 2)) #b000100010)
  (check-equal? (image->string image)
                (string-join sample-input-image-lines "\n"))
  (check-equal? (lookup algorithm (get-regional-value image '(2 2))) 1)
  (check-equal? (length (all-relevant-points image)) 49 "7x7 with padding")
  (check-equal? (image->string (apply-image-enhancement image algorithm))
                (string-join (list ".##.##." ; trimmed sample by hand
                                   "#..#.#."
                                   "##.#..#"
                                   "####..#"
                                   ".#..##."
                                   "..##..#"
                                   "...#.#.")
                             "\n"))
  (check-equal? (length (hash-keys (apply-image-enhancement image algorithm)))
                24
                "I counted this number from the picture")
  (check-equal? (length (hash-keys (apply-image-enhancement image algorithm 2)))
                35
                "final answer"))
