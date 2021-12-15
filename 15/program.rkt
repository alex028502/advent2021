#lang racket

(require racket/cmdline)

(define (/> . args)
   ((apply compose (reverse (cdr args))) (car args)))

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
       (curry map list->immutable-vector)
       list->immutable-vector))


;; cycling through coordinates x and y - this might be helpful for part ii
;; so will having the entire total risk matrix - but that's not why I am doing
;; it - I'm just finding it easier to visualize
(define (solve-puzzle risk-matrix)
  (/> (foldl (λ (y total-risk-matrix)
               (let ([risk-line (vector-ref risk-matrix y)])
                 (cons (get-total-risk-line risk-line
                                            (car:> total-risk-matrix
                                                   (curry get-fake-line
                                                          (vector-length risk-line))))
                       total-risk-matrix)))
             '()
             (range (vector-length risk-matrix)))
      reverse
      list->immutable-vector))

;; I could put these into map together and except that I also need the value
;; to the left - instead of worry about the rule that the first square doesn't
;; count, I am going to subtract it from my final answer - since I think that
;; the most elegant formula I can come up will count it
;; if we pull of items off the pile car by car - we could probably have to
;; reverse the pile first - so might be about the same as looking them up
;; by index
(define (get-total-risk-line risk-line previous-total-risk-line)
  (/> (foldl (λ (x total-risk-line)
               (/> (min (car:> total-risk-line get-infinity)
                        (vector-ref previous-total-risk-line x))
                   (curry + (vector-ref risk-line x))
                   (curryr cons total-risk-line)))
             '()
             (range (vector-length risk-line)))
      reverse
      list->immutable-vector))

; oops I think I've made this mistake before!
(define (make-immutable-vector . args)
  (vector->immutable-vector (apply make-vector args)))

(define (list->immutable-vector . args)
  (vector->immutable-vector (apply list->vector args)))

;; just gives infinity if the array is empty
;; this could be done just as well if not better with an 'if'
;; especially since this could fail for a different reason
(define (car:> p df)
  (with-handlers ([exn:fail:contract? df])
    (car p)))

;; actually the first fake cave has to be 0 and then infinity after that so
;; that the very first cave doesn't choose infinity as the min
(define (get-fake-line l . _)
  (vector-append (make-immutable-vector 1 0)
                 (get-infinity-vector (sub1 l) (get-infinity))))

(define (get-infinity-vector l . _)
  (make-immutable-vector l (get-infinity)))

; infinity can't just be 10 because it needs to be higher than the total risk
; of the entire first column
(define (get-infinity . _)
  (expt 2 30))


;; remember to subtract the first cave because it doesn't count
(define (compress-into-single-number-to-answer-question total-risk-cave-matrix)
  (- (vector-last (vector-last total-risk-cave-matrix))
     (vector-ref (vector-ref total-risk-cave-matrix 0) 0)))


(define (vector-last vec)
  (vector-ref (vector-take-right vec 1) 0))

(display (/> (current-command-line-arguments)
             (curryr vector-ref 0)
             (curry main)
             compress-into-single-number-to-answer-question))

(display "\n")

