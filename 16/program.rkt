#lang racket

(require racket/cmdline)

(require "module.rkt")

(define (main path)
  (/> path
      file->lines
      (curryr list-ref 0)
      decode-buoyancy-interchange-transmission))

(display (/> (current-command-line-arguments)
             (curryr vector-ref 0)
             (curry main)))

(display "\n")

