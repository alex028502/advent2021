#lang racket

;; some are used by main program and some are exported just for tests
;; but _could_ be used by the main program in future
(provide lookup)
(provide prepare-algorithm)
(provide prepare-image)
(provide prepare-line)
(provide point-+)
(provide get-regional-value)
(provide apply-image-enhancement)
(provide all-relevant-points)
(provide draw-points-on-canvas)
(provide blank-canvas)
(provide canvas->string)
(provide image->string)
(provide infinity-point)
(provide />)

;; only debug the total now - but I might actually need it for part ii
(define (image->string image)
  (let ([drawing-filter (curry filter (curry hash-ref image))])
    (/> image
        (curryr boundaries drawing-filter)
        (curry apply
               (λ (min-x max-x min-y max-y)
                 (draw-points-on-canvas
                  (blank-canvas (add1 (- max-x min-x)) (add1 (- max-y min-y)))
                  (/> image
                      hash-keys
                      drawing-filter
                      (curry map (curry point-+ (list (- min-x) (- min-y))))))))
        canvas->string)))

(define (canvas->string canvas)
  (/> canvas
      (curry map (curry apply string-append))
      string-join
      (curryr string-replace " " "\n")))

(define (blank-canvas x y)
  (make-list y (make-list x ".")))

(define (draw-points-on-canvas canvas points)
  (foldl (λ (next acc)
           (list-set acc
                     (last next)
                     (list-set (list-ref acc (last next)) (car next) "#")))
         canvas
         points))

;; don't mind that the values in the hash are #t when we create it and then
;; 1 after image enhancement - I am just using the hash to see if there is
;; any entry at all for the point
(define (apply-image-enhancement image algorithm [n 1])
  (if (< n 1)
      image
      (apply-image-enhancement (enhance-image image algorithm)
                               algorithm
                               (sub1 n))))

(define (enhance-image image algorithm)
  (/> image
      all-relevant-points
      (curry cons infinity-point)
      (curry map
             (λ (pt)
               (/> pt
                   (curry get-regional-value image)
                   (curry lookup algorithm)
                   (curry cons pt))))
      (curry map (λ (pt-v) (cons (car pt-v) (> (cdr pt-v) 0))))
      make-immutable-hash))

;; point that keeps track of what happens to a typical
;; point in the infinite space
(define infinity-point '(-100000000 -100000000))

;; this method was created in an emergency after I figured out the flaw in the
;; original strategy so it mashes up methods that aren't quite made for this
;; because of this the image contain one rank and file more than what is needed
(define (prepare-image lines)
  (/> lines
      (curry map prepare-line (range (length lines)))
      (curry apply append)
      (curry cons (cons infinity-point #f))
      make-immutable-hash))

(define (prepare-line y str)
  (/> str
      string->list
      (curry map (curry equal? #\#))
      (curry map cons (map (curryr list y) (range (string-length str))))))

; order is important - idx is power of two
; so not using cartesian-product because i don't know if there is an order
(define neighbours
  '((1 1) (0 1) (-1 1) (1 0) (0 0) (-1 0) (1 -1) (0 -1) (-1 -1)))

(define (get-regional-value image pt)
  (/> neighbours
      (curry map
             (λ (order direction)
               (if (hash-ref image
                             (point-+ direction pt)
                             (hash-ref image infinity-point))
                   (expt 2 order)
                   0))
             (range (length neighbours)))
      (curry apply +)))

; vector addition but vector means a type so call it point
(define (point-+ . pts)
  (apply map + pts))

;; find all the points and then add one more point around the side to account
;; for infinite image technology
(define (all-relevant-points image)
  (/> image
      boundaries
      (curry apply
             (λ (min-x max-x min-y max-y)
               (cartesian-product (range (sub1 min-x) (+ 2 max-x))
                                  (range (sub1 min-y) (+ 2 max-y)))))))

;; it used to be a good idea to share this but it not longer is so we have
;; and awkward argument
(define (boundaries image [drawing-filter identity])
  (/> image
      hash-keys
      drawing-filter
      (curry filter (λ (x) (not (equal? x infinity-point))))
      (curry apply map list)
      (curry apply
             (λ (every-x every-y)
               (list (apply min every-x)
                     (apply max every-x)
                     (apply min every-y)
                     (apply max every-y))))))

;; was gonna use a vector, but maybe a binary number is quicker?
;; could always benchmark by changing these two methods
(define (prepare-algorithm line)
  (/> line
      string->list
      reverse
      list->string
      (curryr string-replace "#" "1")
      (curryr string-replace "." "0")
      (curryr string->number 2)))

(define (lookup algorithm n)
  (arithmetic-shift (bitwise-and algorithm (arithmetic-shift 1 n)) (- n)))

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))
