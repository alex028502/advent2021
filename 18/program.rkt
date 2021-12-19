#lang racket

(require "./unit.rkt")

(display (/> (current-command-line-arguments)
             (curryr vector-ref 0)
             file->lines
             (curry apply snailfish-add)
             snailfish-magnitude))

(display "\n")
