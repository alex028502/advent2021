#lang racket

(require racket/cmdline)

(define (/> . args)
   ((apply compose (reverse (cdr args))) (car args)))

;; this function starts and ends where I can test the four examples in the
;; explanation - add the stuff that adds up the answer is separate
;; > (main "4" "../tests/data/14.txt")
;; "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB"
(define (main n path)
  (/> path
      file->lines
      parse-lines
      (curry apply (λ (template rules)
                     (foldl (λ (_ acc)
                              (/> acc
                                  (curry map (curry cooperate rules))
                                  (curry apply append)
                                  consolidate))
                            (list (cons template 1))
                            (range (string->number n)))))))

;; > (consolidate '((1 . 2) (2 . 2) (1 . 5)))
;; '((1 . 7) (2 . 2))
(define (consolidate items)
  (/> (foldl (λ (item acc)
               (if (hash-has-key? acc (car item))
                   (hash-update acc (car item) (curry + (cdr item)))
                   (hash-set acc (car item) (cdr item))))
             (make-immutable-hash)
             items)
      hash->list))

;; name just sounds cool
;; using cons instead of list because that is what we get when we explode the
;; hash after each dedupe
(define (cooperate rules multi-template)
  (let ([template (car multi-template)]
        [frequency (cdr multi-template)])
    (/> (operate rules template)
        (curry map (curryr cons frequency)))))

;; once two letters are in next to each other and will never have anything
;; inserted between, they will stay that way forever. I am going to break the
;; string into two strings right at that point, and then group identical
;; strings
(define (operate rules template)
  (/> (foldl (λ (rule t)
               (apply string-full-replace t rule))
             (fill-with-0 template)
             rules)
      (curryr string-split "0")))

;; there are probably much quicker ways to do this
;; but now that I have realised that holding a terrabyte
;; string is the biggest problem - I will worry about this if the
;; the profiler tells me to worry
;; > (fill-with-0 "TEST")
;; "T0E0S0T"
(define (fill-with-0 str)
  (/> str
      string->list
      (curry map list)
      (curry map list->string)
      (curryr string-join "0")))

; even if we use "all" we still get this
;; > (string-replace "AAAA" "AA" "A1A" #:all? #t)
;; "A1AA1A"
;; (doesn't replace the ones that have already been involved in a replace
(define (string-full-replace str from to)
  (if (string-contains? str from)
      (string-full-replace (string-replace str from to) from to)
      str))

(define (parse-lines lines)
  (list (car lines)
        (/> lines
            (curry filter (curryr string-contains? "->"))
            (curry map parse-rule)
            (curry map format-rule))))
            ;; (curry map (λ (rule)
            ;;              (list rule (reverse-rule rule))))
            ;; (curry apply append))


(define (parse-rule line)
  (/> line
      (curryr string-split "->") ;; could just split on " -> "
      (curry map string-trim))) ;; but will trim instead

;; replace the second item with something that can find/replace
;; > (format-rule '("AB" "C"))
;; '("A0B" "ACB")
(define (format-rule raw-rule)
  (let ([a (string-ref (car raw-rule) 0)]
        [b (string-ref (car raw-rule) 1)]
        [c (string-ref (last raw-rule) 0)])
    (map list->string (list (list a #\0 b)
                            (list a c b)))))

;; OK it turns out adjacent means in the same order
;; I thought te NC rule would apply to CN
;; (define (reverse-rule rule)
;;   (map (λ (str)
;;          (/> str ; no string reverse function?!?!
;;              string->list
;;              reverse
;;              list->string))
;;        rule))


(define (most-and-least lst [result #f])
  (if result
      (if (= 0 (length lst))
          (let ([freqs (sort (hash-values result) <)])
            (list (last freqs)
                  (car freqs)))
          (if (hash-has-key? result (car lst))
              (most-and-least (cdr lst)
                              (hash-update result (car lst) add1))
              (most-and-least lst ; I could save a step by setting to 1
                              (hash-set result (car lst) 0))))
      ;; don't want to call a function in the default - no good reason
      (most-and-least lst (make-immutable-hash))))



;; ---------------

;; this turned a bit messy!
(display (/> (current-command-line-arguments)
             vector->list
             (curry apply main)
             string->list
             most-and-least
             (curry apply -)))

(display "\n")

