#lang racket

(require racket/cmdline)

(define window-size (string->number (vector-ref (current-command-line-arguments) 0)))
(define input-file-path (vector-ref (current-command-line-arguments) 1))

(define raw-input (file->lines input-file-path))

(define input (map string->number raw-input))

;; could have added a command line param to make it work for both part i and part ii
;; but instead just making it only work for a window of 3, and then hardcode
(define (process-item tally unprocessed-items)
  (list (if (< (apply + (take unprocessed-items window-size))
               (apply + (take (cdr unprocessed-items) window-size)))
            (+ 1 tally)
            tally)
        (cdr unprocessed-items)))

(define (add-up tally unprocessed-items)
  (if (< (length unprocessed-items) (+ 1 window-size))
      tally
      (apply add-up (process-item tally unprocessed-items))))

(display (add-up 0 input))
(display "\n")
