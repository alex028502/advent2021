#lang racket

(require racket/cmdline)

(define raw-input (file->lines (vector-ref (current-command-line-arguments) 0)))

(define input (map string-split raw-input))

(define (collect direction items)
  (filter (lambda (x) (string=? direction (list-ref x 0)))
          items))

(define (total direction items)
  (apply + (map (lambda (x) (string->number (list-ref x 1)))
                (collect direction items))))

(display (* (- (total "down" input)
               (total "up" input))
            (total "forward" input)))

(display "\n")
