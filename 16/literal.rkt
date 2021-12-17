#lang racket

(require "./lib.rkt")

(provide take-literal-packet)

(define (take-literal-packet packet-content)
  (/> packet-content parse-literal-value))

;; grabs characters in groups of five
;; and watches the prefix
(define (parse-literal-value str [acc '()])
  (let ([prefix (substring str 0 1)]
        [digits (cons (substring str 1 5) acc)]
        [leftover (substring str 5)])
    (if (equal? prefix "0")
        (list (/> digits
                  reverse
                  (curry apply string-append)
                  (curryr string->number 2))
              leftover)
        (parse-literal-value leftover digits))))

;; anything that starts with decode - the packet header is included even though
;; we already know what it is and that's why we are using the function
;; (define (decode-length-type-0 str)

