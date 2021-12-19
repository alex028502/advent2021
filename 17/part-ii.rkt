#lang racket

(require "./unit.rkt")

;; check this out
(display
 (/> (current-command-line-arguments)
     (curryr vector-ref 0)
     file->lines
     (curryr list-ref 0)
     string->list
     (curry map list)
     (curry map list->string)
     (curry map (λ (c) (if (or (equal? c "-") (string->number c)) c " ")))
     (curry apply string-append)
     (curryr string-split " ")
     (curry map string->number)
     (curry filter identity)
     (curry apply count-on-target-probe-v0)))

(display "\n")
