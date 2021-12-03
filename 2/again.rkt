#lang racket

(require racket/cmdline)

;; cheated a bit here because string->number really doesn't belong here
(define (polar->rectangular polar)
  (let ([values (hash "forward" '(1 0) "down" '(0 1) "up" '(0 -1))]
        [dir (car polar)]
        [mag (string->number (car (cdr polar)))])
    (map * (hash-ref values dir) (list mag mag))))

(define (read-data-file path)
  (map polar->rectangular (map string-split (file->lines path))))

(define input (read-data-file (vector-ref (current-command-line-arguments) 0)))

(display (apply * (apply map + input)))

(display "\n")
