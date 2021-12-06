#lang racket

(require racket/cmdline)

;; pads on the right
(define (pad-list l len)
  (append l (make-list (- len (length l)) 0)))

;; sorry about the terrible argument names
(define (convert-number-to-list n [x 1])
  (append (make-list n 0) (list x)))

;; thanks https://stackoverflow.com/a/64041141
;; I keep copying this zip - I need to find out soon what apply 3 args does
(define (list-add . l)
  (let ([len (apply max (map length l))])
    (apply map + (map (lambda (x) (pad-list x len)) l))))

;; > (classify '(0 0 0 1 1 4 4))
;; '(3 2 0 0 2)
;; wow - I could have done this by mapping all the numbers in the list to
;; (append (make-list (car new-items) 0)) and then adding up the list using
;; list add above... it can already handle multiple items, and the input list
;; is never too long... but I have started to do recursion without thinking
(define (classify new-items [output '()])
  (if (= 0 (length new-items))
      output
      (classify (cdr new-items)
                (list-add output
                          (convert-number-to-list (car new-items))))))

(define (parse-input str)
  (classify (map string->number (string-split str ","))))

;; (define (read-data-file path)
;;   (map comma-split (file->lines path)))

;; am I re-inventing fibonacci or something??
(define (add-day-to-data ages)
  (list-add (cdr ages)
            (convert-number-to-list 6 (car ages))
            (convert-number-to-list 8 (car ages))))

(define (add-days-to-data ages days)
  (if (= days 0)
      ages
      (add-days-to-data (add-day-to-data ages) (- days 1))))

(define (do-calculation timespan-str ages-str)
  (apply + (add-days-to-data (parse-input ages-str)
                             (string->number timespan-str))))

(define input-timespan (vector-ref (current-command-line-arguments) 0))
(define input-file (vector-ref (current-command-line-arguments) 1))

(display (do-calculation input-timespan
                         (first (file->lines input-file))))

(display "\n")
