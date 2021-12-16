#lang racket

(require racket/cmdline)

;; let's not convert the strings to numbers
;; until we are ready to add up the value of the winning card

;; since I already know the array size, I don't need all the info in the file
;; either the blank lines or the number lines
;; either the newlines or the number of columns
;; so let's see what is easier
(define array-size 5)
(define file-name (vector-ref (current-command-line-arguments) 0))

(define (comma-split str)
  (string-split str ","))

(define (group size lines [progress '()])
  (if (= (length lines) 0) ;; so we might get an error if there is a mismatch
      progress
      (group size
             (drop lines size)
             (append (list (take lines size)) progress))))

(define (read-matrix lines)
  (map string-split lines))

(define (non-empty line)
  (> (string-length line) 0))

;; don't know how to use struct so just using a cons of the moves and card
(define (read-data-file path dim)
  (let ([relevant-lines (filter non-empty (file->lines path))])
    (cons (comma-split (car relevant-lines))
          (map read-matrix (group dim (cdr relevant-lines))))))

(define (row-check row moves)
  (= 0 (length (filter (lambda (x) (not (member x moves))) row))))

;; filter and check the length instead of recursion and exit when found
;; how do the pros do it?
(define (partial-card-check card moves)
  (> (length (filter (lambda (x) (row-check x moves)) card)) 0))

;; this trick is really coming in handy!
(define (flip card)
  (apply map list card))

;; this is the first example of something that will not be verified by turning
;; the example into an automated test because in the example it is a row that
;; is found and so the column will never be found. even if we measured test
;; coverage this issue would no be found because the flipping still happens
;; on every non winning card but we never find a matching column
;; to solve this I might get the tests to invert the input but that would
;; mean rewriting the whole parsing procedure in python
;; or I could just depend on my manual repl tests but I might want to rewrite
;; this in future as I get better at LISP so a working test would be handy
(define (card-check card moves)
  (or (partial-card-check card moves) (partial-card-check (flip card) moves)))

;; be careful - the value changes depending when the game ends
(define (card-value card moves)
  (* (string->number (last moves))
     (apply +
            (map string->number
                 (filter (lambda (x) (not (member x moves)))
                         (apply append card))))))

;; if it is a winner, all we need is the score now
;; but if is a future winner, we need the whole card still
;; so let's just send what we have and let the next function figure out the
;; difference
(define (check-and-score card moves)
  (if (card-check card moves) (card-value card moves) card))

(define (check-all-cards cards moves)
  (map (lambda (x) (check-and-score x moves)) cards))

;; let's try passing the index instead of splitting up the list this time
;; I tried doing it with a past moves and a future moves argument but since
;; I couldn't decide which list the current move should be in
;; so good opportunity to try this, which is less efficient because it has to
;; traverse the list an extra time every time
(define (calculate cards all-moves [cursor 1] [winners '()])
  (if (> cursor (length all-moves))
      (list (first winners) (last winners))
      (let* ([moves (take all-moves cursor)]
             [result (check-all-cards cards moves)])
        (calculate (filter (lambda (x) (not (number? x))) result)
                   all-moves
                   (+ 1 cursor)
                   (append winners (filter number? result))))))

(let ([input (read-data-file file-name array-size)])
  (display (calculate (cdr input) (car input))))

(display "\n")
