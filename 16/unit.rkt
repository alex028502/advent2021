#lang racket

(require rackunit)

(require "module.rkt")

(check-equal? (construct-sample-message "X") "sample X")

;; real tests are:
;; 8A004A801A8002F478 16
;; 620080001611562C8802118E34 12
;; C0015000016115A2E0802F182340 23
;; A0016C880162017C3686B18A3D4780 31
(check-equal? (decode-buoyancy-interchange-transmission "X")
              "processing: sample X")
