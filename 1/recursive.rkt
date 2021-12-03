#lang racket

(require racket/cmdline)

(define raw-input (file->lines (vector-ref (current-command-line-arguments) 0)))

(define input (map string->number raw-input))

(define (process-item tally unprocessed-items)
  (list (if (< (list-ref unprocessed-items 0)
               (list-ref unprocessed-items 1))
            (+ 1 tally)
            tally)
        (cdr unprocessed-items)))

(define (add-up tally unprocessed-items)
  (if (< (length unprocessed-items) 2)
      tally
      (apply add-up (process-item tally unprocessed-items))))

(display (add-up 0 input))
(display "\n")
