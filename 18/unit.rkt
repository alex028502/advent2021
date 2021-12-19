#lang racket

(define snailfish-ns (make-base-namespace))

(provide explode-first)
(provide tokenize)
(provide untokenize)
(provide split-first)
(provide explode-all)
(provide reduce-once)
(provide reduce-all)
(provide reduce)

;; these are the only ones used by the main program - the others are just
;; provided for testing
(provide snailfish-add)
(provide snailfish-magnitude)
(provide />)

;; finally only used the snailfish language's similarity to lisp to evaluate
;; the "magnitude"
(eval '(define (operation a b)
         (+ (* 3 a) (* 2 b)))
      snailfish-ns)

(define (snailfish-magnitude str)
  (/> str
      (curryr string-replace "[" "(operation ")
      (curryr string-replace "]" ")")
      (curryr string-replace "," " ")
      open-input-string ; thanks https://stackoverflow.com/a/51290591
      read
      (curryr eval snailfish-ns)))

(define (snailfish-add n0 . ns)
  (foldl (λ (next acc) (reduce (string-append "[" acc "," next "]"))) n0 ns))

(define (reduce str)
  (/> str tokenize reduce-all untokenize))

(define (reduce-all tokens)
  (let ([new-tokens (reduce-once tokens)])
    (if (equal? new-tokens tokens)
        tokens ; or could put new-tokens
        (reduce-all new-tokens))))

(define (reduce-once tokens)
  (let ([new-tokens (explode-all tokens)])
    (if (equal? new-tokens tokens)
        (split-first tokens)
        (reduce-once new-tokens))))

(define (explode-all tokens)
  (let ([new-tokens (explode-first tokens)])
    (if (equal? new-tokens tokens)
        new-tokens ; or just tokens
        (explode-all new-tokens))))

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))

(define (explode before during after)
  (let ([x (list-ref during 1)] [y (list-ref during 3)])
    (append (add-to-last-numeric-token before x)
            '(0)
            (add-to-first-numeric-token after y))))

(define (split-first tokens [checked '()])
  (if (= 0 (length tokens))
      (reverse checked)
      (let ([next (car tokens)])
        (if (and (number? next) (> next 9))
            (append (reverse checked)
                    (list "[" (floor (/ next 2)) "," (ceiling (/ next 2)) "]")
                    (cdr tokens))
            (split-first (cdr tokens) (cons next checked))))))

(define (untokenize tokens)
  (/> tokens
      (curry map (λ (x) (if (number? x) (number->string x) x)))
      (curry apply string-append)))

(define (explode-first token-list [n 0] [level 0])
  (if (= n (length token-list))
      token-list
      (let ([c (car (drop token-list n))])
        (cond
          [(= level 5) (explode (take token-list (- n 1))
                                (take (drop token-list (- n 1)) 5)
                                (drop token-list (+ n 4)))]
          [(equal? c "[") (explode-first token-list (add1 n) (add1 level))]
          [(equal? c "]") (explode-first token-list (add1 n) (sub1 level))]
          [else (explode-first token-list (add1 n) level)]))))

;; > (add-to-first-numeric-token '("A" "B" 1 "C" 3) 4)
;; '("A" "B" 5 "C" 3)
;; > (add-to-first-numeric-token '("A" "B" "D" "C") 4)
;; '("A" "B" "D" "C")
(define (add-to-first-numeric-token tokens amount [i 0])
  (if (= i (length tokens))
      tokens
      (let ([v (list-ref tokens i)])
        (if (number? v)
            (append (take tokens i) (list (+ v amount)) (drop tokens (add1 i)))
            (add-to-first-numeric-token tokens amount (add1 i))))))

;; > (add-to-last-numeric-token '("A" "B" 1 "C" 3) 4)
;; '("A" "B" 1 "C" 7)
(define (add-to-last-numeric-token tokens amount)
  (/> tokens reverse (curryr add-to-first-numeric-token amount) reverse))

(define (tokenize str)
  (/> str
      string->list
      (curry map list)
      (curry map list->string)
      (curry map (λ (c) (if (string->number c) (string->number c) c)))))
