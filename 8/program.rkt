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
      (lambda (x) (map string-length x))
      (lambda (x) (filter special-value? x))
      length))

(display (/> (current-command-line-arguments)
             (lambda (x) (vector-ref x 0))
             file->lines
             (lambda (x) (map add-up-line x))
             (lambda (x) (apply + x))))

(display "\n")
