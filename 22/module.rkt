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
(provide calculate-volume)
(provide in)
(provide in3d)
(provide parse-rule)
(provide smash)
(provide pair-up)
(provide fuse-on-dimension)
(provide sort-on-dimension)
(provide consolidate-on-dimension)

;; cheat - the arg will either be --init-rules or nothing but I just look if
;; there is an arg or not
(define (main . args)
  (if (> (length args) 0) (init-rules) (main-main)))

(define (main-main [path "/dev/stdin"])
  (/> (foldl (λ (next acc)
               (/> acc
                   (curry map (curry smash (cdr next)))
                   (curry map consolidate)
                   (curry apply append)
                   (λ (l) (if (car next) (cons (cdr next) l) l))))
             '()
             (parse-rules path))
      (curry map calculate-volume)
      (curry apply +)))

;; this one is not unit tested so is hard coded for three dimensions
(define (consolidate shapes)
  (foldl consolidate-on-dimension shapes (range 3)))

(define (calculate-volume ranges)
  (/> ranges
      (curry map (curry apply -))
      (curry map abs)
      (curry map add1)
      (curry apply *)))

; see diagrams in tests
(define (smash new-shape old-shape)
  (/> (map smash-dimension new-shape old-shape)
      (curry apply cartesian-product)
      (curry filter (curry no-overlap new-shape))))

;; cheating a bit - only checking one point since I know there is a small shape
;; entirely inside the new shape
(define (no-overlap new-shape small-shape)
  (let ([sample-point (map car small-shape)])
    (not (in3d sample-point new-shape))))

(define (smash-dimension new-range old-range)
  (/> old-range
      (curryr split-range (- (car new-range) 1/2))
      (curry map (curryr split-range (+ (last new-range) 1/2)))
      (curry apply append)))

(define (consolidate-on-dimension n shapes)
  (/> shapes
      (curry group-by (curry remove-dimension n))
      (curry map (curry sort-on-dimension n))
      (curry map (curry fuse-on-dimension n))
      (curry apply append)))

(define (remove-dimension n shape)
  (/> shape
      length
      range
      (curry filter-not (curry = n))
      (curry map (curry list-ref shape))))

(define (sort-on-dimension n shapes)
  (sort shapes
        (λ two-shapes
          (/> two-shapes
              (curry map (curryr list-ref n))
              (curry map car)
              (curry apply <)))))

(define infinity (expt 2 40))

;; doesn't check if the other dimensions match up
;; that should be done by sorting before
;; so assuming they are in the same in the other directions, I am just using
;; the other dimension of the first one
(define (fuse-on-dimension n shapes)
  (/> shapes
      (curry map (curryr list-ref n))
      (curry apply append)
      (curryr append (list infinity))
      (curry cons (- infinity))
      pair-up
      (curry filter-not (λ (ab) (= (add1 (car ab)) (last ab))))
      (curry apply append)
      cdr
      (curryr drop-right 1)
      pair-up
      (curry map (curry list-set (car shapes) n))))

(define (pair-up lst [done '()])
  (if (= 0 (length lst))
      (reverse done)
      (pair-up (drop lst 2) (cons (take lst 2) done))))

(define (split-range inclusive-range splitter)
  (if (and (> splitter (car inclusive-range))
           (< splitter (last inclusive-range)))
      (list (list (car inclusive-range) (floor splitter))
            (list (ceiling splitter) (last inclusive-range)))
      (list inclusive-range)))

(define (in3d coordinates inclusive-ranges)
  (apply non-lazy-and (map in coordinates inclusive-ranges)))

;; looks like and can't be used with apply because of how the macro works
;; but we don't need lazy
(define (non-lazy-and . args)
  (foldl (λ (next acc) (and acc next)) #t args))

(define (in number inclusive-range)
  (and (>= number (car inclusive-range)) (<= number (last inclusive-range))))

(define (parse-rules path)
  (/> path file->lines (curry map parse-rule)))
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
