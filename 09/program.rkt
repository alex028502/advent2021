#lang racket

(require racket/cmdline)

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))

;; ---------------

(define (solve-puzzle-for-file path)
  (/> path
      file->lines
      (curry map string->list)
      (curry map (curry map (curryr /> list list->string string->number)))
      (lambda (points)
        (/> (all-coordinates points) (curry map (curry get-value points))))
      (curry filter identity)))

;; inline is-low-point into here to save lookups
(define (get-value points coordinates)
  (if (is-low-point points coordinates)
      (+ 1 (lookup-value points coordinates))
      #f))

;; to save one lookup, this could return the value instead of the coordinates
;; but this time I hope to query everything and then see if I can profile it
;; to find the actual bottlenecks instead of using my imagination
(define (is-low-point points coordinates)
  (< (lookup-value points coordinates)
     (apply min (all-neighbouring-values points coordinates))))

(define (all-neighbouring-values points coordinates)
  (/> coordinates
      all-neighbouring-coordinates
      (curry map (curry lookup-value points))))

(define (all-neighbouring-coordinates coordinates)
  (map (curry rectangular-+ coordinates) (all-directions)))

(define (rectangular-+ a b)
  (map + a b))

;; I'm trying to get x and y right but since this is a really a square I won't
;; know if I mess up
(define (lookup-value points coordinates)
  (let ([x (car coordinates)] [y (last coordinates)])
    (if (or (< x 0)
            (< y 0)
            (>= y (last (dims points)))
            (>= x (car (dims points))))
        (infinity)
        (list-ref (list-ref points y) x))))

;; if we have to iterate into higher numbers later this will change
(define (infinity)
  10)

;; trying not to define constants unless necessary to make it easier to
;; redefine a single part of the program in repl mode - for example here I
;; could redefine all-points and would not have to evaluate all-directions
;; again, but if it were a constant I would
(define (all-directions)
  (/> (all-coordinates-in-rectangle 2 2 -1 -1)
      (curry filter (lambda (x) (member 0 x)))
      (curry filter (lambda (x) (not (equal? x '(0 0)))))))
;; actually I forgot about this.. so not much case for reuse for
;; all-coordinates-in-rectangle but I'll leave it like this in case they add in
;; diagonals later a list of the four ordered pairs would work OK too

(define (all-coordinates points)
  (/> points dims (curry apply all-coordinates-in-rectangle)))

;; hope all rows are all the same length!
(define (dims points)
  (list (length (car points)) (length points)))

;; h isn't really the height if y0 is no 0 - it's more like the elevation
;; and w isn't the width - it's... longitude? that's ok - x0 and y0 are zero
;; except when getting the list of directions
(define (all-coordinates-in-rectangle w h [x0 0] [y0 0])
  (/> (range x0 w)
      (curry map (curry all-coordinates-in-row y0 h))
      (curry apply append)))

(define (all-coordinates-in-row y0 h x)
  (map (curry list x) (range y0 h)))

;; ---------------

(display (/> (current-command-line-arguments)
             (lambda (x) (vector-ref x 0))
             solve-puzzle-for-file
             (curry apply +)))

(display "\n")

;; ---------------

(define (solve-other-puzzle-for-file path)
  (/> path
      file->lines
      (curry map string->list)
      (curry map (curry map (curryr /> list list->string string->number)))
      (lambda (points)
        (/> (all-coordinates points)
            (curry map (lambda (p) (if (is-low-point points p) p #f)))
            (curry filter identity)
            (curry map (curry explore-basin points))
            (curry map length)))))

(define (explore-basin points starting-point)
  (/> starting-point
      (curry get-higher-neighbours points)
      (curry map (curry explore-basin points))
      (curry apply append)
      (curry cons starting-point)
      list->set
      set->list))

;; we should already have looked up all the neighbours once for the first
;; the initial point but that's OK - let's see if it bothers the computer to
;; look twice
;; see notes about this function in readme for this day
(define (get-higher-neighbours points coordinates)
  (let ([value (lookup-value points coordinates)])
    (/> coordinates
        all-neighbouring-coordinates
        (curry map (lambda (p) (list p (lookup-value points p))))
        (curry map
               (lambda (x)
                 (if (and (> (last x) value) (< (last x) 9)) (car x) #f)))
        (curry filter identity))))

;; ---------------

(display (/> (current-command-line-arguments)
             (lambda (x) (vector-ref x 0))
             solve-other-puzzle-for-file
             (curryr sort >)
             (curryr take 3)
             (curry apply *)))

(display "\n")

;; ---------------
