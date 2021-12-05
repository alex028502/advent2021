#lang racket

(require racket/cmdline)

;; on the real data set, this program ran for 55 minutes on my raspberry pi 4
;; with no result before I stopped it
;; on github actions, it took 4 1/2 minutes
;; I tried running it in parts against the real data set, and even the stage
;; that expands each item into a list of points seemed to take a while
;; but that might have just been from printing them out
;; If I had to try to make it faster I would start by grouping all the points
;; into columns or rows, and then adding up each group, so each point only
;; needed to be compared to like 1000 other points instead of like 1000000
;; The sorting function could just be called 'classify' and then could be tuned
;; I would start by classifying into columns, but as long as the classification
;; formula is deterministic, I think that you could do anything, even make each
;; point its own list, and see what could get the answer in a reasonable amount
;; of time

(define (parse-move str)
  (map parse-vector (map string-trim (arrow-split str))))

(define (parse-vector str)
  (map string->number (comma-split str)))

(define (comma-split str)
  (string-split str ","))

(define (arrow-split str)
  (string-split str "->"))

(define (read-data-file path)
  (map parse-move (file->lines path)))

(define (rook? move)
  (or (apply = (map first move))
      (apply = (map last move))))

;; I don't understand how this works. I understood for a second while
;; I was making it or copying it or whatever
(define (zip2 a b)
  (apply map list (list a b)))

(define (inclusive-range a b)
  (range a (+ 1 b)))

;; just create a rectangle function to get all the points and then only use it
;; when we know all the points will appear in a single row or column
(define (rectangle corner0 corner1)
  (apply cartesian-product (map (lambda (x) (apply inclusive-range (sort x <)))
                                (zip2 corner0 corner1))))

;; crooked lines expand to zero points
(define (expand move)
  (if (not (rook? move))
      '()
      (apply rectangle move)))

(define (find-repeats input [result '()])
  (if (= 0 (length input))
      result
      (find-repeats (cdr input)
                    (if (member (car input) (cdr input))
                        (append (list (car input)) result)
                        result))))

;; I could have just added the repeats to a set in the first place
;; instead of adding them to a list and then converting it to a set
(define (count-repeats input)
  (set-count (list->set (find-repeats input))))

(define (evaluate-file path)
  (count-repeats (apply append (map expand (read-data-file path)))))

(display (evaluate-file (vector-ref (current-command-line-arguments) 0)))
(display "\n")