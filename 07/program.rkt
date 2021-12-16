#lang racket

(require racket/cmdline)

;; threading function from day 5
;; (define (/> . args)
;;   (let ([value (car args)]
;;         [functions (cdr args)])
;;     (if (= 0 (length functions))
;;         value
;;         (apply /> (cons ((car functions) value) (cdr functions))))))

;; this time I want to do the same thing except start my iteration from the
;; other end - so defining my own compose function that returns a value instead
;; of a function - this must be what they mean by _not_ a tail call because
;; after each recursion, there is still work to do in the current frame
;; so you wouldn't want to do something like this for millions of items
(define (compose-and-call . args)
  (if (= 1 (length args))
      (car args)
      ((car args) (apply compose-and-call (cdr args)))))

(define (/> . args)
  (apply compose-and-call (append (reverse (cdr args)) (list (car args)))))

(define (parse-input str)
  (map string->number (string-split str ",")))

;; copied from day 5
(define (add-to-hash hash key)
  (if (hash-has-key? hash key)
      (hash-update hash key add1)
      (hash-set hash key 1)))

;; pretty much copied from day 5 as well
(define (sort-items input [result (make-immutable-hash '())])
  (if (= 0 (length input))
      result
      (sort-items (cdr input) (add-to-hash result (car input)))))

;; not really the size but this could have been a list
;; actually now we are just using "size" to turn it into a list
(define (get-size sorted-items)
  (apply max (hash-keys sorted-items)))

(define (organise-hash hash)
  (map (lambda (x) (hash-ref hash x 0)) (range (+ (get-size hash) 1))))

;; I hope we don't have any final answer higher than a trillion!
;; don't want to make my min compare handle the first case where there
;; isn't a minium yet
;; I tried passing down a list that starts as '() and then becomes
;; (list current-winner) but that was a lot of extra list and apply
(define infinity (expt 2 40))
;; I could also just define a min function that filters out false
;; and use false as the initial value

(define (get-price-list-up-to n [price-list '(0)])
  (if (> (length price-list) n) ;; is it expensive to get the length twice?
      price-list
      (get-price-list-up-to
       n
       (append price-list (list (+ (last price-list) (length price-list)))))))

;; just gonna visualize for a sec..
;; '(16 1 2 0 4 2 7 1 2 14) - input
;; '(0  1 2 3 4 5 6 7 8 9)
;; '(0  1 3 6 10 - price list

;; the first item should not repeat
;; this is gonna be costly... to reverse the long list but we only have to
;; do it once - so we don't mind
(define (reflect-list l)
  (append (reverse (cdr l)) l))

;; we might be able to speed this up by doing it recursively instead of
;; truncating the list to only cycle through the list one time, but maybe not
(define (calculate-fuel price-list frequencies)
  (apply + (map * frequencies (take price-list (length frequencies)))))

(define (find-best-answer price-list frequencies [best-answer infinity])
  (if (< (length price-list) (length frequencies))
      best-answer
      (find-best-answer
       (cdr price-list)
       frequencies
       (min best-answer (calculate-fuel price-list frequencies)))))

(define (get-best-answer frequencies price-list-function)
  (find-best-answer (/> frequencies length price-list-function reflect-list)
                    frequencies))

(define input-file (vector-ref (current-command-line-arguments) 0))

;; not sure if I should "thread" into the function with "side-effects" display
(define (run-with message price-list-function)
  (begin
    (display message)
    (display ": ")
    (/> input-file
        file->lines
        first
        parse-input
        sort-items
        organise-hash
        (lambda (x) (get-best-answer x price-list-function))
        display)
    (display "\n")))

;; make the linear price list one longer than I think it has to be because
;; of off by one errors, and since the answer is not at the end, I can't use
;; trial and error to see if I have included enough so add 2 to the range
;; instead of 1
(run-with "part i" (lambda (n) (range (+ n 2))))
(run-with "part ii" get-price-list-up-to)

;; just imagining some more stuff...
;; 28 21 15 10 6 3 1 0 1 3 6 10 15 21 28 36 45 55 66 78 91 105 120 136 153 171
;; 1  2  3  0  1 0 0 1 0 0 0 0  0  0  1  0
;; 28 42 45 0  6 0 0 0 0 0 0 0  0  0  28

;; 3 1 0 1 3 6 10 15 21 28 36 45 55 66 78 91 105 120 136 153 171
;; 1 2 3 0 1 0 0  1  0  0  0  0  0  0  1  0
;; 3 2 0 1 3 6 0  15 0  0  0  0  0  0  78 0
