#lang racket

(require racket/cmdline)

(define (/> . args)
   ((apply compose (reverse (cdr args))) (car args)))

;; this is a lot like day 12
;; but having learned my lesson on day 14 I'm going to store only the current
;; score and not the history since I only seem to be able to go right and down


(define (main path)
  (/> path
      file->lines
      create-board
      solve-puzzle))

;; I am going to use vectors this time, and exception handling to deal
;; with off board points
(define (create-board lines)
  (/>  lines
       (curry map string->list)
       (curry map (curry map list))
       (curry map (curry map list->string))
       (curry map (curry map string->number))
       (curry map list->vector)
       list->vector))

(define (solve-puzzle board [pos '(0 0)] [risk-total 0])
  (if (equal? pos (get-goal board))
      (list risk-total)
      (/> pos
          (curry apply get-neighbours)
          (curry map (λ (xy)
                       (list xy
                             (apply get-risk board xy))))                      
          (curry filter last)
          (curry map (λ (possibility)
                       (list (car possibility)
                             (+ (last possibility) risk-total))))
          (curry map (curry apply solve-puzzle board))
          (curry apply append))))

;; seems like you can only move down and right from the example
;; > (neighbours 1 2)
;; '((1 3) (2 2))
(define (get-neighbours x y)
  (list (list x (add1 y))
        (list (add1 x) y)))


;; assume it's a square
(define (get-goal board)
  (list (sub1 (vector-length (vector-ref board 0)))
        (sub1 (vector-length board))))

(define (get-risk board x y)
  (with-handlers ([exn:fail:contract? (λ (e) #f)])
    (/> board
        (curryr vector-ref y)
        (curryr vector-ref x))))

;; ---------------

(display (/> (current-command-line-arguments)
             vector->list
             (curry main)))

(display "\n")

