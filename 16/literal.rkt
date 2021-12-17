#lang racket

(require "./lib.rkt")

(provide decode-literal-packet)

;; this is not used as intended in part i
;; but since I followed the instructions and have a test for, and will probably
;; need it in part ii, I'll just keep it, and then work backwards to calculate
;; the length - it already ignores the stuff at the end
;; this function doesn't figure out the difference between trailing bits in
;; this packet and stuff that belongs to the next packet - that is reverse
;; engineered later because I am not sure if all packets follow the rule that
;; they have to fit into hex or only the literal ones so I have to try both

(define (decode-literal-packet str)
  (/> str (curryr substring 6) parse-literal-value))

;; grabs characters in groups of five
;; and watches the prefix
(define (parse-literal-value str [acc '()])
  (let ([prefix (substring str 0 1)] [digits (cons (substring str 1 5) acc)])
    (if (equal? prefix "0")
        (/> digits
            reverse
            (curry apply string-append)
            (curryr string->number 2))
        (parse-literal-value (substring str 5) digits))))

;; anything that starts with decode - the packet header is included even though
;; we already know what it is and that's why we are using the function
;; (define (decode-length-type-0 str)
