#lang racket

(require "./unit.rkt")

;; because all the interesting stuff is in a different module, let's do most
;; of the work right in the body of this script today for a change

(define times (string->number (vector-ref (current-command-line-arguments) 0)))
(define file-lines
  (file->lines (vector-ref (current-command-line-arguments) 1)))

(define algorithm (prepare-algorithm (list-ref file-lines 0)))
(define image (prepare-image (drop file-lines 2)))

(define enhanced-image (apply-image-enhancement image algorithm times))

(display (length (hash-keys enhanced-image)))

(display "\n")
