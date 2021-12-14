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
          (λ (template-and-rules)
            (foldl (λ (_ acc)
                     (apply operate acc))
                   template-and-rules
                   (range (string->number n))))
          car))

;; template is reversed each iteration so rules need to be reversed too since
;; I discovered earlier they don't want to apply them in both directions
;; but the rules only have to flip once, or even if I flip them every time
;; it always takes the same amount of time but the polymer will keep growing
(define (operate rules-hash flip todo [done '()])
  (if (= 1 (length todo))
      (cons (car template) done)
      (let ([key (list->string ((if flip reverse identity) (take todo 2)))])
        (if (hash-has-key? rules-hash key)
            (operate rules-hash flip (cdr todo) (cons (car todo) 
          

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
;; > (format-rule '("AB" "c"))
;; '("AB" "AcB")
(define (format-rule raw-rule)
  (list (car raw-rule)
        (list->string (list (string-ref (car raw-rule) 0)
                            (/> raw-rule
                                last
                                string-downcase
                                (curryr string-ref 0))
                            (string-ref (car raw-rule) 1)))))

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

