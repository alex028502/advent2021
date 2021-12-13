#lang racket

(require racket/cmdline)

(define (main path)
  (/> path
      parse-file
      (curry apply do-every-fold)))

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


(define (do-every-fold dots folds [population-log '()])
  (if (> (length folds) 0)
      (do-every-fold (fold-list dots (car folds))
                     (cdr folds)
                     (cons (length dots) population-log))
      (list dots
            (reverse population-log)))) ; no final count in log

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


(define (picture dots)
  (/> (foldl (lambda (dot acc)
               (apply grid-set acc dot))
             (apply make-grid (/> dots
                                  (curry apply map max)
                                  (curry map add1)))
             dots)
      (curry map (curryr string-join ""))
      (curryr string-join "\n")))

;; I wonder if (make-list h (make-list w ".")) would have worked? Seems like
;; I might end up with a reference to the same list on every row - since I
;; or maybe it has a way of copying the list every time it is passed around
;; will try sometime
;; (define (make-grid w h)
;;   (foldl (lambda (_ acc)
;;            (cons (make-list w ".") acc))
;;          '()
;;          (range h)))
;; Wait a minute!! this works! of course!!!
;; It makes one of those lazy copies or something!
(define (make-grid w h)
  (make-list h (make-list w ".")))


;; can only set it to one thing
(define (grid-set grid x y)
  (list-set grid y (list-set (list-ref grid y) x "#")))

;; maybe I need to extract this into a require
;; since it has turned out really useful
(define (/> . args)
   ((apply compose (reverse (cdr args))) (car args)))

(define (add-arrow-to-second first . others)
  (cons first (cons (string-append (car others) "<-") others)))

(/> (current-command-line-arguments)
    (curryr vector-ref 0)
    main
    (curry apply (lambda (dots population-log)
                   (begin
                     (/> population-log
                         (curry map number->string)
                         (curry apply add-arrow-to-second)
                         (curryr string-join "\n")
                         (curryr display (current-error-port)))
                     (display "\n" (current-error-port))
                     (display (picture dots))
                     (display "\n")))))

