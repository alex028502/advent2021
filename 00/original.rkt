#lang racket

(require racket/cmdline)

(define raw-input (file->lines (vector-ref (current-command-line-arguments) 0)))

(define input (map string->number raw-input))

(define keys (range (length input)))

(define key-pairs
  (filter (lambda (x) (> (car x) (cdr x)))
          (apply append
                 (for/list ([i keys])
                   (for/list ([j keys])
                     (cons i j))))))

(define number-pairs
  (map (lambda (x) (cons (list-ref input (car x)) (list-ref input (cdr x))))
       key-pairs))

(define number-pair
  (car (filter (lambda (x) (= (+ (cdr x) (car x)) 2020)) number-pairs)))

(display (* (cdr number-pair) (car number-pair)))
