#lang racket

(define ns (make-base-namespace))

(require "./lib.rkt")
(require "./literal.rkt")

(provide parse-bits-transmission)
(provide bits-packet-version-total)

(define (bits-packet-version-total transmission)
  (eval (parse-bits-transmission evaluator transmission) ns))

(define (evaluator version operation . body)
  (if (equal? operation "100") version (apply + version body)))

;; these are kind of dual purpose
;; it works as an enum to be able to follow what the code means
;; but then also is the actual number
(define subpacket-bit-count-len 15)
(define subpacket-count-len 11)

;; only work with binary strings
(define (parse-bits-transmission fn str)
  (/> str
      (curry string-append "1") ; add a 1 to keep the leading 0s
      (curryr string->number 16)
      (curryr number->string 2)
      (curryr substring 1) ; remove the 1 I added before
      (curry next fn)
      car))

;; I am using a binary string - If this had to run all day every day and scale
;; to millions of users, I guess I would change it to shift bits the end
;; (or I mind find out that I have to do it now for a reason that I don't know
;; about yet) then I could just implement a drop in replacement for substring

(define (next fn transmission)
  (let ([version (string->number (substring transmission 0 3) 2)]
        [operation (substring transmission 3 6)]
        [content (substring transmission 6)])
    (cond
      [(equal? operation "100")
       (let* ([tmp (take-literal-packet content)]
              [value (car tmp)]
              [leftover (last tmp)])
         (list (list fn version operation value) leftover))]
      [(= (operator-len-str-len transmission) subpacket-bit-count-len)
       (let ([subpacket-bit-count
              (/> content
                  skip1
                  (curryr substring 0 subpacket-bit-count-len)
                  (curryr string->number 2))]
             [body+
              (/> content skip1 (curryr substring subpacket-bit-count-len))])
         (list (apply list
                      fn
                      version
                      operation
                      (/> body+
                          (curryr substring 0 subpacket-bit-count)
                          (curry get-all-subpackets-in fn)))
               (substring body+ subpacket-bit-count)))]
      [else
       (let* ([subpacket-count (/> content
                                   skip1
                                   (curryr substring 0 subpacket-count-len)
                                   (curryr string->number 2))]
              [body+ (/> content skip1 (curryr substring subpacket-count-len))]
              [tmp (take-subpackets fn body+ subpacket-count)]
              [subpackets (car tmp)]
              [leftovers (last tmp)])
         (list (apply list fn version operation subpackets) leftovers))])))

(define (get-all-subpackets-in fn body [result '()])
  (if (= (string-length body) 0)
      (reverse result)
      (let* ([tmp (next fn body)] [subpacket (car tmp)] [leftovers (last tmp)])
        (get-all-subpackets-in fn leftovers (cons subpacket result)))))

(define (take-subpackets fn body+ n [result '()])
  (if (= n 0)
      (list (reverse result) body+)
      (let* ([tmp (next fn body+)] ; tried to use let-values
             [subpacket (car tmp)] ; but then I realised it's not for lists
             [leftovers (last tmp)]) ; so using 'tmp'
        (take-subpackets fn leftovers (- n 1) (cons subpacket result)))))

(define (skip1 str)
  (substring str 1))

(define (operator-len-str-len transmission)
  (if (equal? (substring transmission 6 7) "0")
      subpacket-bit-count-len
      subpacket-count-len))
