#lang racket

(require rackunit)

(require "./module.rkt")
(require "./literal.rkt")
(require "./lib.rkt")

(define (packet-content packet)
  (substring packet 6))

;; the program injects a function into the start of the list but here to test
;; I am just injecting a string
(check-equal? (parse-bits-transmission "TEST" "38006F45291200")
              '("TEST" #b1 "110" ("TEST" #b110 "100" 10) ("TEST" #b010 "100" 20)))

(check-equal? (parse-bits-transmission "TEST" "EE00D40C823060")
              '("TEST" #b111 "011" ("TEST" #b010 "100" 1) ("TEST" #b100 "100" 2) ("TEST" #b001 "100" 3)))

; from example
(define packet2021-bin "110100101111111000101000")
(define packet2021-hex "D2FE28")

(check-equal? (string->number packet2021-hex 16)
              (string->number packet2021-bin 2))

(check-equal? (parse-bits-transmission "TEST" packet2021-hex) '("TEST" #b110 "100" 2021))


;; detailed example except I had to get the version bits out of the example
;; string
(check-equal? (bits-packet-version-total "EE00D40C823060")
              (+ 7 0 #b010 #b100 #b001))

(check-equal? (bits-packet-version-total "8A004A801A8002F478") 16)

(check-equal? (bits-packet-version-total "620080001611562C8802118E34") 12)

(check-equal? (bits-packet-version-total "C0015000016115A2E0802F182340") 23)

(check-equal? (bits-packet-version-total "A0016C880162017C3686B18A3D4780") 31)




(check-equal? (take-literal-packet (packet-content packet2021-bin)) '(2021 "000"))

;; get rid of the last three digits to make sure it can handle nothing after
(check-equal? (/> packet2021-bin
                  (curryr string->number 2) ; only works because we know it
                  (curryr arithmetic-shift -3) ; starts with a 1 and not 0
                  (curryr number->string 2)
                  packet-content
                  take-literal-packet)
              '(2021 ""))

;; (let ([rest-of-transmission "101011100010101"])
;;   (check-equal? (take-literal-packet
;;                  (packet-content (string-append packet2021-bin rest-of-transmission)))
;;                 (list 2021 rest-of-transmission)))


;; from inside one of the examples
(check-equal? (take-literal-packet (packet-content "11010001010")) '(10 ""))
