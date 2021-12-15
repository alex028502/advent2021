#lang racket

(require racket/cmdline)

(define (/> . args)
   ((apply compose (reverse (cdr args))) (car args)))

;; let's take a step back
;; I peaked and the real input is like 100x100
;; which means 200 steps
;; so would need every order of 100 right steps and 100 down steps
;; which is a lot  200! / 100! / 100! ?? maybe
;; if it's that I should not try what I was about to try

;; this is a lot like day 12
;; but having learned my lesson on day 14 I'm going to store only the current
;; score and not the history since I only seem to be able to go right and down

;; I know the answer now - I worked it out, but then vaguely remember my
;; highschool math teacher doing it on the blackboard - but maybe I am
;; imagining that
;; it was good to step back after trying for a few minutes
;; A B C
;; D E F
;; G H I
;; the total risk to get to any square is the risk of that square plus the
;; lower of the risk of the box to the left and the box above
;; the total risk to get to F is the risk of F plus the lower of the total risk
;; to get to E and the total risk to get to C
;; and if in step ii, they want to know the route we are gonna take then we
;; have to pass down the whole path instead of just the adding up the risk
;; which would make more sense in the story - but I'll figure out how to add
;; that after. the problem is that I am not planning on using coordinates
;; to figure this out (and I could) so if they want coordinates of the path in
;; part ii - it's gonna be a bit messy to put them in - but let's see

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

