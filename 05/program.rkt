#lang racket

(require racket/cmdline)

;; this program can take like five minutes on the real data set on my little
;; computer, but can be run on github actions to speed it up

;; messing around with "threading" here
;; except instead of a macro, just using a function that takes lambdas as
;; arguments, but then made a function to make the lambdas a little shorter
;; but that doesn't matter because it still doesn't fit on one line
;; so could have just left it as lambda
(define-syntax-rule (fn (x) y) (lambda (x) y))

(define (/> . args)
  ;;   (let ([value (car args)]
  ;;         [functions (cdr args)])
  ;;     (if (= 0 (length functions))
  ;;         value
  ;;         (apply /> (cons ((car functions) value) (cdr functions))))))
  ((apply compose (reverse (cdr args))) (car args)))

(define (parse-move str)
  (/> str
      arrow-split
      (fn (x) (map string-trim x))
      (fn (x) (map parse-vector x))))

(define (parse-vector str)
  (map string->number (comma-split str)))

(define (comma-split str)
  (string-split str ","))

(define (arrow-split str)
  (string-split str "->"))

(define (read-data-file path)
  (/> path file->lines (fn (x) (map parse-move x))))

;; I don't understand how this works. I understood for a second while
;; I was making it or copying it or whatever
(define (zip2 a b)
  (apply map list (list a b)))

;; it turns out there is a function in the docs that does the same thing as this
;; one and has the same name, but I can't figure out how to import it
;; even with require racket/list
(define (inclusive-range a b)
  (range a (+ 1 b)))

(define (travel-direction corner1 corner2)
  (let* ([diff (apply map - (list corner2 corner1))]
         [side (apply max (map abs diff))])
    (map (lambda (x) (/ x side)) diff)))

;; this used to be the bishop function but while writing it it became clear
;; that it good do the rook stuff too
;; the rook function was really cool and took advantage of cartesian products
;; and might have been a little quicker, but this is simpler
(define (queen-recursive direction destination path)
  (if (equal? (car path) destination)
      path
      (queen-recursive
       direction
       destination
       (cons (map (lambda (x) (apply + x)) (zip2 (car path) direction)) path))))

(define (queen corner1 corner2)
  (queen-recursive (travel-direction corner1 corner2) corner2 (list corner1)))

(define (expand move)
  (apply queen move))

(define (add-to-hash hash key)
  (if (hash-has-key? hash key)
      (hash-update hash key add1)
      (hash-set hash key 1)))

(define (find-repeats input [result (make-immutable-hash '())])
  (if (= 0 (length input))
      result
      (find-repeats (cdr input) (add-to-hash result (car input)))))

(define (count-repeats input)
  (/> input
      find-repeats
      hash->list
      (fn (y) (filter (fn (x) (> (cdr x) 1)) y))
      length))

(define (evaluate-file path)
  (/> path
      read-data-file
      (fn (x) (map expand x))
      (fn (x) (apply append x))
      count-repeats))

(/> (vector-ref (current-command-line-arguments) 0) evaluate-file display)
(display "\n")
