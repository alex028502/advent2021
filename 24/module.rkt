#lang racket

(provide main)

(define (main path)
  (/> path
      parse
      (λ (instructions) (solve initial-memory instructions))
      string->number)) ; problem with module is it prints answer in quotes

(define (parse path)
  (/> path file->lines (curry map (curryr string-split " "))))

;; that's much easier than make-immutable-hash!
(define initial-memory (hash "w" 0 "x" 0 "y" 0 "z" 0))

(define (solve memory instructions [progress ""])
  (if (= 0 (length instructions))
      (if (= 0 (hash-ref memory "z")) progress #f)
      (let ([cmd (car (car instructions))] [args (cdr (car instructions))])
        (if (equal? cmd "inp")
            (first-ok (λ (n)
                        (solve (hash-set memory (car args) n)
                               (cdr instructions)
                               (string-append progress (number->string n))))
                      (reverse (range 1 10)))
            (solve (apply interpret memory cmd args)
                   (cdr instructions)
                   progress)))))

;(define (solve instructions memory [num ""])

;; I bet they already have this
;; I could just (car (filter identity (map pred list)))
;; except I only want to process what is necessary
(define (first-ok pred lst)
  (if (= (length lst) 0)
      #f
      (let ([v (pred (car lst))]) (if v v (first-ok pred (cdr lst))))))

;; > (interpret (hash "a" 1 "b" 2) "add" "a" "b")
;; '#hash(("a" . 3) ("b" . 2))
;; > (interpret (hash "a" 1 "b" 2) "add" "b" "a")
;; '#hash(("a" . 1) ("b" . 3))
;; > (interpret (hash "a" 1 "b" 2) "mul" "b" "a")
;; '#hash(("a" . 1) ("b" . 2))
;; > (interpret (hash "a" 5 "b" 2) "mul" "a" "b")
;; '#hash(("a" . 10) ("b" . 2))
;; > (interpret (hash "a" 5 "b" 2) "div" "a" "b")
;; '#hash(("a" . 2) ("b" . 2))
;; > (interpret (hash "a" 5 "b" 2) "eql" "a" "b")
;; '#hash(("a" . 0) ("b" . 2))
(define (interpret memory cmd . args)
  (hash-set memory
            (car args)
            (apply (cond
                     [(equal? cmd "add") +]
                     [(equal? cmd "mul") *]
                     [(equal? cmd "div") (λ items (floor (apply / items)))]
                     [(equal? cmd "mod") modulo]
                     [(equal? cmd "eql") (λ items (if (apply = items) 1 0))])
                   (map (curry lookup memory) args))))

(define (lookup memory token)
  (if (string->number token) (string->number token) (hash-ref memory token)))

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))
