#lang racket

(require rackunit)

(require "./module.rkt")
(require "./literal.rkt")

(check-equal? (parse-bits-transmission "38006F45291200")
              '(#b1 "110" (#b110 "100" 10) (#b101 "100" 20)))

(check-equal? (parse-bits-transmission "EE00D40C823060")
              '(#b111 "011" (#b010 "100" 1) (#b100 "100" 2) (#b001 "100" 3)))


; from example
(define packet2021-bin "110100101111111000101000")
(define packet2021-hex "D2FE28")

(check-equal? (string->number packet2021-hex 16)
              (string->number packet2021-bin 2))

(check-equal? (parse-bits-transmission packet2021-hex)
              '(#b110 "100" 2021))

#|
;; detailed example except I had to get the version bits out of the example
;; string
(check-equal? (bites-packet-version-total "EE00D40C823060")
              (+ 7 0 #b010 #b100 #b001))

(check-equal? (bites-packet-version-total "8A004A801A8002F478") 16)

(check-equal? (bites-packet-version-total "620080001611562C8802118E34") 12)

(check-equal? (bites-packet-version-total "C0015000016115A2E0802F182340") 23)

(check-equal? (bites-packet-version-total "A0016C880162017C3686B18A3D4780") 31)
|#




(check-equal? (literal-packet-value packet2021-bin) 2021)

;; (check-equal?
;;  (decode-literal-packet (string-append packet2021 "01010101000011111"))
;;  2021)

;; ; and this is the function that uses the above function in a roundabout way
;; (let ([rest-of-transmission "101011100010101"])
;;   (check-equal? (next (string-append packet2021 rest-of-transmission))
;;                 (list 6 rest-of-transmission)))

;; (let ([rest-of-transmission "101011100010101"]
;;       [sample "00111000000000000110111101000101001010010001001000000000"])
;;   (check-equal? (get-subpackets-and-rest-of-transmission1
;;                  (string-append sample
;;                                 rest-of-transmission))
;;                 (list '() rest-of-transmission)))
