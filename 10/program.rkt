#lang racket

(require racket/cmdline)
(require math/statistics)

;; (define raw-input (file->lines (vector-ref (current-command-line-arguments) 0)))

(define (process-file path)
  (/> path file->lines (curry map string->list) (curry map process-line)))

;; ): 3 points.
;; ]: 57 points.
;; }: 1197 points.
;; >: 25137 points.
;; this can be a constant because it doesn't rely on any functions I invented
;; but if it were calculated with functions I made up and defined in this file
;; I would call it (rules)
;; for each closer you need to know the thing it is allowed to close and the
;; points if it is misplaced
(define rules
  (make-immutable-hash
   '((#\) . (#\( 3)) (#\] . (#\[ 57)) (#\} . (#\{ 1197)) (#\> . (#\< 25137)))))

(define more-rules
  (make-immutable-hash '((#\( . 1) (#\[ . 2) (#\{ . 3) (#\< . 4))))

(define (autocomplete-score stack)
  (foldl (lambda (next score)
           (/> score (curry * 5) (curry + (hash-ref more-rules next))))
         0
         stack))

;; this does not handle the case when you hit a closer and the stack is empty
;; the sample and my input didn't have that, so didn't put that feature in
;; you will just get an error
(define (process-line line [stack '()])
  (if (= 0 (length line))
      (- (autocomplete-score stack)) ; negative, secret code for uncorrupt
      (let ([rule (hash-ref rules (car line) #f)])
        (if rule
            (if (equal? (car stack) (car rule)) ;; will fail if stack is empty
                (process-line (cdr line) (cdr stack))
                (last rule)) ; return the points
            (process-line (cdr line) (cons (car line) stack))))))

;; check this out
;; need to figure out how to replace lambda with eval
(define (/> arg . ops)
  (foldl (lambda (op v) (op v)) arg ops))

;; using negative as a secret code for the autocomplete scores
;; so now I need to separate them
;; > (classify -1 -2 1 5 -100)
;; '((5 1) -100 -2 -1)
;; looks weird because I made the two answers a cons instead of a two item list
;; and so it shows it as a big list with the former list as the first element
;; of the second list... but... just don't look at it
(define (classify . args)
  (foldl (lambda (next scores)
           (if (< next 0)
               (cons (car scores) (cons next (cdr scores)))
               (cons (cons next (car scores)) (cdr scores))))
         '(() . ())
         args))

;; ---

;; I guess it is always on odd number?
;; (define (median l)
;;   (/> l
;;       (curryr sort >)
;;       (curryr list-ref (floor (length l
;; wait a second! I think I just import something

(let ([results (/> (current-command-line-arguments)
                   (lambda (x) (vector-ref x 0))
                   process-file
                   (curry apply classify))])
  (begin
    (display "part i: ")
    (display (apply + (car results)))
    (display "\n")
    (display "part ii: ")
    (display (- (median < (cdr results))))
    (display "\n")))
