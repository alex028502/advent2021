#lang racket

(require "./lib.rkt")
(require "./literal.rkt")

(provide bites-packet-version-total)

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))

;; only work with binary strings
;; even to find the end of the literal package later, I'll just count in fours
(define (bites-packet-version-total str)
  (/> str
      (curryr string->number 16)
      (curryr number->string 2)
      binary-bites-packet-version-total))

;; I am using a binary string - If this had to run all day every day and scale
;; to millions of users, I guess I would change it to shift bits the end
;; (or I mind find out that I have to do it now for a reason that I don't know
;; about yet) then I could just implement a drop in replacement for substring

(define (binary-bites-packet-version-total transmission [acc 0])
  (if (< (string-length transmission) 6)
      acc
      (binary-bites-packet-version-total (next transmission)
                                         (+ acc (version transmission)))))

;; wait a minute! - what's the difference between "the rest of the
;; transmission" and "subpackets"? - maybe I can take a shortcut
;; or maybe by trying to take the shortcut, I'll understand better
;; because no matter what happens, after the length string, there is another
;; packet - or is there extra stuff at the end? I'll just look if there are
;; at least six digits left maybe?

;; gives a value and the remainder of the transmission

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

;; I don't know if I need this all the time or just for literals
;; it would be strange if operator expressions were able to go out of phase
;; with the hex digits but literals weren't
(define (fit-length-into-hex len)
  (/> len
      (curryr / 4)
      ceiling
      (curry * 4)))
      

        ;;   (/> transmission
        ;;       (curryr substring 6) ; have already dealt with header
        ;;       (curryr substring 1)
        ;;       (curryr substring )))))

(define (operator-len-str-len transmission)
  (if (equal? (substring transmission 6 7) "0") 15 11))

(define (version packet)
  (/> packet (curryr substring 0 3) (curryr string->number 2)))

(define (content packet)
  (substring packet 6))


(define (is-literal packet)
  (equal? "100" (substring packet 3 6)))
