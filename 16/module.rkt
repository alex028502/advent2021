#lang racket

(require "./lib.rkt")
(require "./literal.rkt")

(provide parse-bits-transmission)

;; these are kind of dual purpose
;; it works as an enum to be able to follow what the code means
;; but then also is the actual number
(define subpacket-bit-count-len 15)
(define subpacket-count-len 11)

;; only work with binary strings
;; even to find the end of the literal package later, I'll just count in fours
(define (parse-bits str)
  (/> str
      (curryr string->number 16)
      (curryr number->string 2)
      next))

;; I am using a binary string - If this had to run all day every day and scale
;; to millions of users, I guess I would change it to shift bits the end
;; (or I mind find out that I have to do it now for a reason that I don't know
;; about yet) then I could just implement a drop in replacement for substring

;; wait a minute! - what's the difference between "the rest of the
;; transmission" and "subpackets"? - maybe I can take a shortcut
;; or maybe by trying to take the shortcut, I'll understand better
;; because no matter what happens, after the length string, there is another
;; packet - or is there extra stuff at the end? I'll just look if there are
;; at least six digits left maybe?

;; gives a value and the remainder of the transmission

;; returns the "version total" of the next packet, and any leftovers

(define (next transmission)
  (let ([version (substring transmission 0 3)]
        [operation (substring transmission 3 6)]
        [content (substring transmission 6)])
    (cond [(equal? operation "100")
           (let ([value (literal-packet-value transmission)])
             (list (list version operation value)
                   (substring transmission
                              (ceiling4 (literal-packet-length value)))))]
          [(= (operator-len-str-len transmission) subpacket-bit-count-len)
           (let ([subpacket-bit-count (/> content
                                          skip1
                                          (curryr substring
                                                  0
                                                  subpacket-bit-count-len)
                                          (curryr string->number 2))]
                 [body+ (/> transmission
                            content
                            skip1
                            (curryr substring subpacket-bit-count-len))])
             (list (list version
                         operation
                         (/> body+
                             (curryr substring 0 subpacket-bit-count)
                             get-all-subpackets-in))
                   (substring body+ subpacket-bit-count)))]
          [else (let* ([subpacket-count (/> transmission
                                           content
                                           skip1
                                    (curryr substring 0 subpacket-count-len)
                                    (curryr string->number 2))]
                 [body+ (/> transmission
                            content
                            skip1
                            (curryr substring subpacket-count-len))]
                 [tmp (take-subpackets body+ subpacket-count)]
                 [subpackets (car tmp)]
                 [leftovers (last tmp)])
                  (list (list version
                              operation
                              subpackets) ; couldn't think of a name for var
                        leftovers))])))
                         

(define (get-all-subpackets-in body)
  '())


(define (take-subpackets body+)
  '())


(define (skip1 str)
  (substring str 1))                 
               
|#
(define (next transmission)
  (let ([v (version transmission)]
        [content (subtring transmission 6)])
    (cond [(is-literal transmission)]
          (/> transmission
              decode-literal-packet
              (curryr number->string 16)
              string-length
              (curry * 5) ;; undo everything I just did
              (curry + 6) ;; instead of just calculting it in the first place
              (curryr / 4) ;; because I already made the function and have a
              ceiling ;; test for it from the question
              (curry * 4)
              (curry substring transmission)
              (curry list v))
          [(= (substring (content transmission) 0 1) "0")]
          (let ([l (/> transmission
                       content
                       (curryr subtring 1)
                       (curryr subtring 0 15)
                       (curryr string->number 2))])
            (list 10
                 (substring (content transmission)
                            (+ l 1)))
#|

      

        ;;   (/> transmission
        ;;       (curryr substring 6) ; have already dealt with header
        ;;       (curryr substring 1)
        ;;       (curryr substring )))))

(define (operator-len-str-len transmission)
  (if (equal? (substring transmission 6 7) "0")
      subpacket-bit-count-len
      subpacket-count-len))
