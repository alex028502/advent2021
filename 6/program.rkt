#lang racket

(require racket/cmdline)

(define (parse-input str)
  (map string->number (string-split str ",")))

;; (define (read-data-file path)
;;   (map comma-split (file->lines path)))

(define (add-day-to-datum age)
  (if (= age 0)
      '(8 6)
      (list (- age 1)))) ;; always return a list even if it is still one item

(define (add-day-to-data ages)
  (apply append (map add-day-to-datum ages)))

(define (add-days-to-data ages days)
  (if (= days 0)
      ages
      (add-days-to-data (add-day-to-data ages) (- days 1))))

(define (do-calculation timespan-str ages-str)
  (length (add-days-to-data (parse-input ages-str)
                            (string->number timespan-str))))

(define input-timespan (vector-ref (current-command-line-arguments) 0))
(define input-file (vector-ref (current-command-line-arguments) 1))

(display (do-calculation input-timespan
                         (first (file->lines input-file))))

(display "\n")
