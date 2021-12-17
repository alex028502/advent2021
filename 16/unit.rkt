#lang racket

(require rackunit)

(require "module.rkt")
(require "literal.rkt")

;; detailed example except I had to get the version bits out of the example
;; string
(check-equal? (bites-packet-version-total "EE00D40C823060")
              (+ 7 0 #b010 #b100 #b001))

(check-equal? (bites-packet-version-total "8A004A801A8002F478") 16)

(check-equal? (bites-packet-version-total "620080001611562C8802118E34") 12)

(check-equal? (bites-packet-version-total "C0015000016115A2E0802F182340") 23)

(check-equal? (bites-packet-version-total "A0016C880162017C3686B18A3D4780") 31)

; from example
(define packet2021 "110100101111111000101000")

;; I don't know if we actually need this for this stage
(check-equal? (decode-literal-packet packet2021) 2021)

;; oh except we do need it for this stage, except with a bunch of stuff at the
;; end - and we are gonna use the value to cut it off
(check-equal?
 (decode-literal-packet (string-append packet2021 "01010101000011111"))
 2021)

; and this is the function that uses the above function in a roundabout way
(let ([rest-of-transmission "101011100010101"])
  (check-equal? (next (string-append packet2021 rest-of-transmission))
                (list 6 rest-of-transmission)))

;; (let ([rest-of-transmission "101011100010101"]
;;       [sample "00111000000000000110111101000101001010010001001000000000"])
;;   (check-equal? (get-subpackets-and-rest-of-transmission1
;;                  (string-append sample
;;                                 rest-of-transmission))
;;                 (list '() rest-of-transmission)))
