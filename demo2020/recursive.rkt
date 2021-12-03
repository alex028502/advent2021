#lang racket

(require racket/cmdline)

(define raw-input (file->lines (vector-ref (current-command-line-arguments) 0)))

(define input (map string->number raw-input))

(define magic-number 2020)

(define (find-complement-in-list number candidates)
  (if (= 0 (length candidates))
      #f
      (if (= magic-number (+ number (car candidates)))
          (car candidates)
          (find-complement-in-list number (cdr candidates)))))

; if the list runs out of options then eventually we'll just get an
; error from trying to (cdr '()) but that is as good an an error we
; could create I guess
(define (find-complements-in-list candidates)
  (let ([compliment (find-complement-in-list (car candidates) (cdr candidates))])
    (if compliment
        (list (car candidates) compliment)
        (find-complements-in-list (cdr candidates)))))

(display (apply * (find-complements-in-list input)))
