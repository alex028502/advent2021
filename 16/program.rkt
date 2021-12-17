#lang racket

(require racket/cmdline)

(require "module.rkt")
(require "lib.rkt")

(define (main path)
  (/> path file->lines (curryr list-ref 0) bits-packet-version-total))

(display
 (/> (current-command-line-arguments) (curryr vector-ref 0) (curry main)))

(display "\n")
