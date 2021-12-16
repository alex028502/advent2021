#lang racket

;; provided to main module
(provide />)
(provide bites-packet-version-total)

;; provided only for unit testing
(provide decode-literal-packet)
(provide next-header)
(provide version)

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
      (binary-bites-packet-version-total (next-header transmission)
                                         (+ acc (version transmission)))))

;; wait a minute! - what's the difference between "the rest of the
;; transmission" and "subpackets"? - maybe I can take a shortcut
;; or maybe by trying to take the shortcut, I'll understand better
;; because no matter what happens, after the length string, there is another
;; packet - or is there extra stuff at the end? I'll just look if there are
;; at least six digits left maybe?

;; gives a value and the remainder of the transmission
(define (next-header transmission)
  (if (is-literal transmission)
      (/> transmission
          decode-literal-packet
          (curryr number->string 16)
          string-length
          (curry * 5) ;; undo everything I just did
          (curry + 6) ;; instead of just calculting it in the first place
          (curryr / 4) ;; because I already made the function and have a good
          ceiling ;; test for it from the question
          (curry * 4)
          (curry substring transmission))
      (/> transmission
          (curryr substring 6) ; we deal with this somewhere else
          (curryr substring 1)
          (curryr substring (operator-len-str-len transmission)))))

(define (operator-len-str-len transmission)
  (if (equal? (substring transmission 6 7) "0") 15 11))

(define (version packet)
  (/> packet (curryr substring 0 3) (curryr string->number 2)))

;; in the question, 'subpacket' has a hyphen in it, but I need hyphens to
;; separate it from other words
;; (define (number-of-subpackets packet)
;;   (/> (substring packet 6 7)
;;       (

;; (define (get-subpackets packet [subpackets])
;;   (if (is-literal)

(define (is-literal packet)
  (equal? "100" (substring packet 3 6)))

(define (decode-literal-packet str)
  (/> str (curryr substring 6) parse-literal-value))

;; grabs characters in groups of five
;; and watches the prefix
;; the trailing digits will always be 0 but we don't take advantage of that
;; this is the first time I've ever wanted to comment out a comment:
;; ;; we could use the trailing 0s and not the prefix - except we wouldn't know
;; ;; when it's an actual zero.. or we could just look for whole groups of 5
;; ;; and ignore the prefixes and the trailing digits completely
;; it turns out we don't know the length, and for part i at least, we don't
;; need the value - but the way of finding out where the packet ends above
;; means we can get the length from the info - and can pass in the whole
;; rest of the transmission, and calculate the length - knowing that we have to
;; round up to the number of digits to fit hex digits - we aren't using the
;; value right now, but I'm just gonna use the function anyway, expecially
;; since it is well tested using their example
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
