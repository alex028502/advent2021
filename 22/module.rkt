#lang racket

;; this takes under a minute
;; > (findout 9)
;; 100000000
;; (define (findout n [x 0])
;;   (if (>= (string-length (number->string x)) n)
;;       x
;;       (findout n (add1 x))))
;; it looks like part ii is gonna be more like (findout 16) if I do it the way
;; I plan on doing part i - so hopefully I learn something else along the way

;; (define (main path)
;;   (let [rules

(provide main)
(provide init-rules)

(provide in)
(provide in3d)
(provide parse-rule)
(provide highest-number-in-rules)

;; cheat - the arg will either be --init-rules or nothing but I just look if
;; there is an arg or not
(define (main . args)
  (if (> (length args) 0) (init-rules) (main-main)))

(define (main-main)
  (let* ([rules (parse-rules "/dev/stdin")] [n (highest-number-in-rules rules)])
    (foldl
     (λ (next acc) (if (find-last-sighting-of-cube rules next) (add1 acc) acc))
     0
     (apply cartesian-product (make-list 3 (range (- n) (add1 n)))))))

;; don't worry about the highest number in each direction unless there is a
;; problem - just cover that distance up and down each axis
(define (highest-number-in-rules rules)
  (/> rules
      (curry map cdr)
      (curry apply append)
      (curry apply append)
      (curry map abs)
      (curry apply max)))

(define (find-last-sighting-of-cube rules coordinates)
  (if (= (length rules) 0)
      #f
      (if (in3d coordinates (cdr (car rules)))
          (car (car rules))
          (find-last-sighting-of-cube (cdr rules) coordinates))))

(define (in3d coordinates inclusive-ranges)
  (apply non-lazy-and (map in coordinates inclusive-ranges)))

;; looks like and can't be used with apply because of how the macro works
;; but we don't need lazy
(define (non-lazy-and . args)
  (foldl (λ (next acc) (and acc next)) #t args))

(define (in number inclusive-range)
  (and (>= number (car inclusive-range)) (<= number (last inclusive-range))))

(define (parse-rules path)
  (/> path file->lines (curry map parse-rule) reverse))
;; this is run a a separate main program
(define (init-rules)
  (/> (filter (λ (line)
                (/> line
                    (curry string->list)
                    (curry map list)
                    (curry map list->string)
                    (curry map (λ (c) (if (string->number c) c " ")))
                    (curry apply string-append)
                    (curryr string-split " ")
                    (curry map string->number)
                    (curry filter identity)
                    (curry apply max)
                    (curryr <= 50)))
              (file->lines "/dev/stdin"))
      (curryr string-join "\n")
      (curryr string-append "\n")
      display))

(define (parse-rule str)
  (let ([parts (string-split str " ")])
    (/>
     parts
     last
     (curry string->list)
     (curry map list)
     (curry map list->string)
     (curry filter (λ (x) (or (string->number x) (string-contains? "-,." x))))
     (curry apply string-append)
     (curryr string-split ",")
     (curry map (curryr string-split ".."))
     (curry map (curry map string->number))
     (curry cons (equal? (car parts) "on")))))

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))
