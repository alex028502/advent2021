#lang racket

(define (main path)
  (/> path
      parse
      (λ (instructions)
        (solve instructions initial-memory))))

(define (parse path)
  (/> path
      file->lines
      (curry map (curryr string-split " "))))

;; that's much easier than make-immutable-hash!
(define initial-memory (hash "w" 0 "x" 0 "y" 0 "z" 0))

(define (find-best-solution instructions memory key [n 9])
  (if (= n 0)
      #f
      (let ([solution (solve instructions (hash-set memory key n))])
        (if solution
            (string-append (number->string n) solution)
            (find-best-solution instructions memory key (sub1 n)))))) 

(define (solve instructions memory [num ""])
  (if (= 0 (length instructions))
      (= 0 (hash-ref memory "z"))
      (let* ([next (car instructions)]
             [cmd (car next)]
             [rest (cdr instructions)])
        (if (equal? cmd "inp")
            (find-best-solution rest memory (second next))
            (solve rest (apply interpret memory next))))))

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
  (if (string->number token)
      (string->number token)
      (hash-ref memory token)))

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))
