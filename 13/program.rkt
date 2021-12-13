#lang racket

(require racket/cmdline)

(define (main path)
  (/> path
      parse-file
      (curry apply do-first-fold)))

(define (parse-file path)
  (/> path
      file->lines
      (curry filter (lambda (x) (> (string-length x) 0)))
      sort-and-parse-lines))

;; if anything doesn't match the exact format, we'll just get an error
;; at some point
(define (sort-and-parse-lines lines [dots '()] [folds '()])
  (if (= (length lines) 0)
      (list dots (reverse folds))
      (if (string-contains? (car lines) "=")
          (sort-and-parse-lines (cdr lines)
                                dots
                                (cons (parse-fold (car lines)) folds))
          (sort-and-parse-lines (cdr lines)
                                (cons (parse-dot (car lines)) dots)
                                folds))))

;; > (parse-fold "put anything here y=8")
;; '(1 8)
(define (parse-fold line)
  (/> line
      string-split
      last
      (curryr string-split "=")
      (curry apply
             (lambda (k v)
               (list (lookup k '("x" "y")) (string->number v))))))

;; is this the only way to find the index of an item in a list?
(define (lookup v lst)
  (- (length lst) (length (member v lst))))

(define (parse-dot line)
  (/> line
      (curryr string-split ",")
      (curry map string->number)))

(define (do-first-fold dots folds)
  (fold-list dots (car folds)))

(define (fold-list dots fold)
  (/> dots
      (curry map (apply curry (cons fold-point fold)))
      remove-duplicates))

;; I wonder if the trick is that the "first fold" in the example is y but it
;; doesn't have to be
(define (fold-point dimension fold-on point)
  (list-set point dimension (fold-number fold-on
                                         (list-ref point dimension))))

;; so 10 folded on 8 should be 6?
;; 9 -> 7
;; 10 -> 6
;; > (fold-number 8 10)
;; 6
;; > (fold-number 8 6)
;; 6
;; > (fold-number 8 7)
;; 7
(define (fold-number fold-on value)
  (- fold-on (abs (- value fold-on))))


;; I keep writing this function and then not needing it so leaving it here to
;; copy the next time
;; like filter except keeps the discarded ones in another list
;; I bet this exists or is really easy somehow
;; (define (classify pred list [wheat '()] [chaff'()])
;;   (if (= (length list) 0)
;;       (list wheat chaff)
;;       (if (pred (car list))
;;           (classify pred (cdr list) (cons (car list) wheat) chaff)
;;           (classify pred (cdr list) wheat (cons (car list) chaff)))))

;; maybe I need to extract this into a require
;; since it has turned out really useful
(define (/> . args)
   ((apply compose (reverse (cdr args))) (car args)))



(display (/> (current-command-line-arguments)
             (curryr vector-ref 0)
             main
             length))

(display "\n")

