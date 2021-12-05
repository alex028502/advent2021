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
;; update - I just uniquely sorted them because I misunderstood the question
;; so maybe it'll be quicker

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
      (queen-recursive direction
            destination
            (cons (map (lambda (x) (apply + x))
                       (zip2 (car path) direction))
                  path))))

(define (queen corner1 corner2)
    (queen-recursive (travel-direction corner1 corner2)
                      corner2
                      (list corner1)))

(define (expand move)
  (apply queen move))

(define (add-to-hash hash key)
  (if (hash-has-key? hash key)
      (hash-update hash key add1)
      (hash-set hash key 1)))

(define (find-repeats input [result (make-immutable-hash '())])
  (if (= 0 (length input))
      result
      (find-repeats (cdr input)
                    (add-to-hash result (car input)))))

(define (count-repeats input)
  (length (filter (lambda (x) (> (cdr x) 1))
                  (hash->list (find-repeats input)))))

(define (evaluate-file path)
  (count-repeats (apply append (map expand (read-data-file path)))))

(display (evaluate-file (vector-ref (current-command-line-arguments) 0)))
(display "\n")
