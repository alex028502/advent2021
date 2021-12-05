#lang racket

(require racket/cmdline)

(define input (file->lines (vector-ref (current-command-line-arguments) 0)))

;; get the length from any item (the first one for example)
(define number-of-digits (string-length (list-ref input 0)))

;; should I turn them into numbers, and then extract the binary digit
;; or use the string position, and convert them to numbers after??
;; it would be easier to decide if the input came in decimal
;; but since the input is already binary, I think I should take advantage
;; and use the string that has been provided to count

; (define input (map string-split raw-input))

;; thanks https://stackoverflow.com/a/30126228
;; (define (zip a b) (map list a b))
;; actually check this out

;> (group-digits (list "01010" "11111" "10000"))
;'((#\0 #\1 #\1) (#\1 #\1 #\0) (#\0 #\1 #\0) (#\1 #\1 #\0) (#\0 #\1 #\0))
(define (group-digits items)
  (apply map list (map string->list items)))

; > (get-value #\1)
;1
(define (get-value binary-character)
  (string->number (list->string (list binary-character))))

;; > (prepare-group-for-voting '(#\1 #\0))
;; '(1 0)
(define (prepare-group-for-voting l)
  (map get-value l))

;; > (prepare-dataset-for-voting '("00110" "10101"))
;; '((0 1) (0 0) (1 1) (1 0) (0 1))
(define (prepare-dataset-for-voting all)
  (map prepare-group-for-voting (group-digits all)))

;; > (vote '(0 0 1 1 1))
;; #t
;; > (vote '(0 0 1 1 1 0 0))
;; #f
;; haven't thought too hard about a tie
;; actually in part ii they do mention a tie
;; more important now - but luckily I have the right answer
;; > (vote '(0 0 1 1))
;; #t
;; gamma will have the opposite answer of epsilon
;; since I am going to get one by inverting the other
(define (vote votes)
  (<= 1/2 (/ (apply + votes) (length votes))))

;; > (renumberate '(#f #f #t #t #t))
;; 7
(define (renumberate list-of-bools)
  (string->number (apply string-append (map (lambda (x) (if x "1" "0"))
                                            list-of-bools))
                  2))

(define (get-gamma all)
  (renumberate (map vote (prepare-dataset-for-voting all))))

;; > (invert 7)
;; 24
;; since we know it's five digits
;; (define (invert number)
;;   (bitwise-and (bitwise-not number) 31))
;; WAIT A MINUTE - I see a pattern here
;; and also, let's make it try to get the length from the input
(define (invert number)
  (- (expt 2 number-of-digits) number 1))

(display (* (get-gamma input)
            (invert (get-gamma input))))

(display "\n")

(define numbers (map (lambda (x) (string->number x 2)) input))

;; pos means 1 for the most significant
;; > (get-digit 1 5 16)
;; 1
;; > (get-digit 1 5 15)
;; 0
(define (get-digit pos len number)
  (bitwise-and 1 (arithmetic-shift number (- pos len))))

;; if I have these two mixed up, it shouldn't affect the result!
(define (co2-check a b)
  (xor a b))

;; these methods don't make much sense except that they compare two bools
;; and give the opposite result from each other
(define (o2-check a b)
  (not (co2-check a b)))

(define (calculate options len op [pos 1])
  (if (= 1 (length options))
      (first options)
      (let ([bit (vote (map (lambda (x) (get-digit pos len x)) options))])
        (calculate (filter (lambda (x) (op (= 1 (get-digit pos len x)) bit))
                           options)
                   len
                   op
                   (+ 1 pos)))))

(display (* (calculate numbers number-of-digits co2-check)
               (calculate numbers number-of-digits o2-check)))

(display "\n")
