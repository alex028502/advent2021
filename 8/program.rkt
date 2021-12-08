#lang racket

(require racket/cmdline)

;; this time I am going to try the built in threading module
;; when it gets a non list as input, it works just like the one I wrote
;; (require threading)
;; actually that didn't work with lambda so back to my home made one:
;; since it is not always the final argument
(define (/> . args)
   ((apply compose (reverse (cdr args))) (car args)))
;; since threading is a module you have to import I could use use their symbol
;; but I have already gotten used to my symbol

;; don't know if this is better or worse than searching a short list
(define (special-value? n)
  (or (= n 2) ;; 1
      (= n 4) ;; 4
      (= n 3) ;; 7
      (= n 7))) ;; 8

;; this program is divided into the part I plan on trying with repl and the
;; part I don't (but I might change my mind)
(define (add-up-line line)
  (/> line
      (lambda (x) (string-split x "|"))
      (lambda (x) (list-ref x 1)) ;; this will change in part ii for sure
      string-trim
      string-split
      (curry map string-length)
      (curry filter special-value?)
      length))

(display (/> (current-command-line-arguments)
             (lambda (x) (vector-ref x 0))
             file->lines
             (curry map add-up-line)
             (lambda (x) (apply + x))))

(display "\n")

;; just start all over for part ii

;; looking at the first example, I am hoping that we always have a example of
;; 1 4 7 and 8 on each line - if not we'll get an error - which will be useful
;; can make this more efficient in a couple ways
;; not append, just go through one list and then the next, and then stop when
;; we find something - but let's try the long way first
(define (get-example n . examples)
  (/> (apply append examples)
      (curry filter (lambda (x) (= (string-length x) n)))
      car
      string->list
      list->set))

;; just jot something down...
;; 6 0
;; 2 1 *
;; 5 3
;; 4 4 *
;; 5 5
;; 6 6
;; 3 7 *
;; 7 8 *
;; 6 9



(define get1 (curry get-example 2))
(define get4 (curry get-example 4))
(define get7 (curry get-example 3))
;; eight might not be much use
;; (define get8 (curry get-example 7))

(define (get-a x7 x1)
  (set-subtract x7 x1))

(define (get-b) x4 x3
  
  

;; (define (anylize examples output)
;;   (let ([e1 (get1 examples output)]
;;         [e2 (get2 examples output)]
;;         [e7 (get7 examples output)])
;;     (make-immutable-hash (list (cons 

(define (calculate examples output)
  (get-example 2 examples output))

;; some examples to repl manual test with
;; be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
;; 8394
;; edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
;; 9781
(define (calculate-line line)
  (/> line
      (lambda (x) (string-split x "|"))
      (curry map string-trim)
      (curry map string-split)
      (curry apply calculate)))

(display (/> (current-command-line-arguments)
             (lambda (x) (vector-ref x 0))
             file->lines
             (curry map calculate-line)
             (curry apply +)))

(display "\n")
