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
      (sort-items (cdr input)
                  (add-to-hash result (car input)))))

;; not really the size but this could have been a list
(define (get-size sorted-items)
  (apply max (hash-keys sorted-items)))

(define (dist a b)
  (abs (- a b)))

;; I don't know if this is better than just counting up to the size
;; and evaluating the get-size on every iternation to find out if we are at
;; the end yet
(define (calculate-fuel-for prices destination sorted-items [idx #f] [total 0])
  (let ([pos (if (not idx) (get-size sorted-items) idx)])
    (if (< pos 0) ;; inclusive remember
        total
        (calculate-fuel-for prices
                            destination
                            sorted-items
                            (- pos 1)
                            (+ total
                               (* (hash-ref sorted-items pos 0)
                                  (list-ref prices
                                            (dist pos destination))))))))

;; I hope we don't have anything higher than a trillion!
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
      (get-price-list-up-to n (append price-list
                                      (list (+ (last price-list)
                                               (length price-list)))))))

;; a little bit of copy/paste from above - should extract something maybe
;; we don't care what the position is (or maybe that is part ii?)
(define (calculate-fuel sorted-items [idx #f] [best infinity])
  (let* ([size (get-size sorted-items)]
         [pos (if (not idx) size idx)]
         [prices (get-price-list-up-to size)])
    (if (< pos 0) ;; inclusive remember
        best
        (calculate-fuel sorted-items
                        (- pos 1)
                        (min best (calculate-fuel-for prices
                                                      pos
                                                      sorted-items))))))

(define input-file (vector-ref (current-command-line-arguments) 0))

;; not sure if I should "thread" into the function with "side-effects" display
(/> input-file file->lines first parse-input sort-items calculate-fuel display)

(display "\n")
