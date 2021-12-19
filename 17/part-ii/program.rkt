#lang racket

(require "./unit.rkt")

;; check this out
(let ([apices
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
           (curry apply get-on-target-probe-v0))])
  (begin ; need to find out the equivalent of %s in python on day
    (display (apply max apices))
    (display " <- answer to part i the hard way\n")
    (display (length apices))
    (display " <- answer to part ii\n")))
