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
                              (apply operate rules acc))
                            (list (initial-gen template)
                                  (hash-add-all (make-immutable-hash)
                                                (string->list template))
                            (range (string->number n))))))))

;; game plan
;; NNCB
;; add Nx2 Cx1 Bx1
;; NN NC CB
;; C  B  H
;; add Cx1 Bx1 Hx1
;; total Cx2 Bx2 Hx1 Nx2 -- I'm gonna call this _the score_
;; NC CN NB BC -- I'm gonna call this _the gen_

(define (operate rules gen score)
  (foldr (λ (item acc)
           (cons (process rules p))
         (list score gen)
         (hash->list gen))))
      

;; returns two new pairs for the next generation
;; and a list of items to be added to the total
(define (process rules p)
  (let ([new-item (hash-ref rules p)])
    (list (multify p new-item)
          new-item)))

       
      ;; (curry map (curry process rules))
      ;; (curry apply zip)
      ;; (curry apply (λ (gen-items score-items)
                     


(define (zip . args)
  (apply map list args))

;; I'm gonna see if I can get away with using a list for each generation
;; if we had kept doing replace, we could have used this on every iteration
;; > (initial-gen "NNCB")
;; '#hash(("CB" . 1) ("NC" . 1) ("NN" . 1))
(define (initial-gen template)
  (hash-add-all (make-immutable-hash)
                (map (curry substring template)
                     (range 0 (- (string-length template) 1))
                     (range 2 (+ (string-length template) 1)))))


           
(define (hash-add-all hash lst)
  (foldl (λ (next acc)
           (hash-add acc next))
         hash
         lst))

;; for counting items in a hash
;; > (hash-add (make-immutable-hash '((1 . 1))) 1)
;; '#hash((1 . 2))
;; > (hash-add (make-immutable-hash '((1 . 1))) 2)
;; '#hash((1 . 1) (2 . 1))
(define (hash-add hash item)
  (if (hash-has-key? hash item)
      (hash-update hash item add1)
      (hash-add (hash-set hash item 0) item)))

;; > (multify "AB" "C")
;; '("AC" "CB")
(define (multify p new-item)
  (/> p
      string->list
      (curry map list)
      (curry map list->string)
      (curry apply (λ (a b)
                     (list (string-append a new-item)
                           (string-append new-item b))))))
      

 
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
            (curry apply cons)
            make-immutable-hash)))

(define (parse-rule line)
  (/> line
      (curryr string-split "->") ;; could just split on " -> "
      (curry map string-trim))) ;; but will trim instead

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

