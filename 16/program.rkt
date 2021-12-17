#lang racket

(require racket/cmdline)

(require "module.rkt")
(require "lib.rkt")

(define (main method path)
  (/> path file->lines (curryr list-ref 0) method))

;; cheat a bit with this argument - doesn't actually look at the argument
(define (get-method)
  (if (> (vector-length (current-command-line-arguments)) 1)
      bits-packet-version-total
      decode-bits-message))

(display (/> (current-command-line-arguments)
             (curryr vector-ref 0)
             (curry main (get-method))))

(display "\n")
