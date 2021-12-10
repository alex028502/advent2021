#lang racket

(require racket/cmdline)

;; (define raw-input (file->lines (vector-ref (current-command-line-arguments) 0)))

(define (process-file path)
  (/> path
      file->lines
      (curry map string->list)
      (curry map process-line)))

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
  (make-immutable-hash '((#\) . (#\( 3))
                         (#\] . (#\[ 57))
                         (#\} . (#\{ 1197))
                         (#\> . (#\< 25137)))))

;; this does not handle the case when you hit a closer and the stack is empty
;; the sample and my input didn't have that, so didn't put that feature in
;; you will just get an error
(define (process-line line [stack '()])
  (if (= 0 (length line))
      0 ; no points
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

;; ---

(display (/> (current-command-line-arguments)
             (lambda (x) (vector-ref x 0))
             process-file
             (curry apply +)))
             
(display "\n")
