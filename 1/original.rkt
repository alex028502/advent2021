#lang racket

(require racket/cmdline)

(define raw-input (file->lines (vector-ref (current-command-line-arguments) 0)))

(define input (map string->number raw-input))

(display (length (filter (lambda (x) (> (cdr x) (car x)))
                  (map (lambda (x) (cons (list-ref input (cdr x))
                                         (list-ref input (car x))))
                       (map (lambda (x) (cons x (- x 1)))
                            (range 1 (length input)))))))

(display "\n")
