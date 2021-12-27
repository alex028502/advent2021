#lang racket

(provide main)
(provide sea-cucumber-step)
(provide parse-input)

(define (main path)
  (/> path
      file->lines
      (curry apply parse-input)
      count-steps-to-sea-cucumber-gridlock))

(define (count-steps-to-sea-cucumber-gridlock situation-map [n 0] [pre #f])
  (if (equal? pre situation-map)
      n
      (count-steps-to-sea-cucumber-gridlock (sea-cucumber-step situation-map)
                                            (add1 n)
                                            situation-map)))

(define (parse-input . lines)
  (/> lines
      (curry map string->list)
      (curry map list->vector)
      list->vector
      vector->immutable-vector))

(define (blank-map w h)
  (make-immutable-vector h (make-immutable-vector w #\.)))

(define (make-immutable-vector size v)
  (list->vector (make-list size v)))

(define (sea-cucumber-step situation-map)
  (/> situation-map
      (curryr sea-cucumber-half-step #\> '(1 0))
      (curryr sea-cucumber-half-step #\v '(0 1))))

(define (sea-cucumber-half-step situation-map herd-character herd-direction)
  (let ([h (vector-length situation-map)]
        [w (vector-length (vector-ref situation-map 0))])
    (sea-cucumber-half-step:> situation-map
                              herd-character
                              herd-direction
                              (blank-map w h)
                              (cartesian-product (range w) (range h))
                              (list w h))))

(define (sea-cucumber-half-step:> old-map herd-char herd-dir new-map pts dims)
  (if (= 0 (length pts))
      new-map
      (let ([char (lookup old-map (car pts))])
        (if (equal? char #\.)
            (sea-cucumber-half-step:> old-map
                                      herd-char
                                      herd-dir
                                      new-map
                                      (cdr pts)
                                      dims)
            (if (and
                 (equal? char herd-char)
                 (equal? #\. (lookup old-map (next (car pts) herd-dir dims))))
                (sea-cucumber-half-step:>
                 old-map
                 herd-char
                 herd-dir
                 (update new-map (next (car pts) herd-dir dims) herd-char)
                 (cdr pts)
                 dims)
                (sea-cucumber-half-step:> old-map
                                          herd-char
                                          herd-dir
                                          (update new-map (car pts) char)
                                          (cdr pts)
                                          dims))))))

(define (lookup situation-map coordinates)
  (/> situation-map
      (curryr vector-ref (last coordinates))
      (curryr vector-ref (car coordinates))))

(define (update situation-map coordinates v)
  (vector-set situation-map
              (last coordinates)
              (vector-set (vector-ref situation-map (last coordinates))
                          (car coordinates)
                          v)))

;; used vectors because I hope it leads to  fast lookup of current values and
;; what which spaces are occupied but now I think I might pay for it with slow
;; writes.  I'll see if this works at all, and then think about improving if
;; needed
(define (vector-set vec pos v)
  (/> vec vector->list (curryr list-set pos v) list->vector))

(define (next pt dir dims)
  (vec-mod (vec-+ pt dir) dims))

(define (vec-mod pt dims)
  (map modulo pt dims))

;; stuff copied from previous projects:
(define (vec-+ . pts)
  (apply map + pts))

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))
