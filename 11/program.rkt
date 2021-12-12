#lang racket

(require racket/cmdline)

;; copy a few things from day 9
;; but not many because this time I am hashing the board
;; this is how I should have done day 9 - glad I am getting another chance

(define (/> . args)
   ((apply compose (reverse (cdr args))) (car args)))

(define (all-neighbouring-coordinates coordinates)
  (map (curry rectangular-+ coordinates)
       (all-directions)))

(define (rectangular-+ a b)
  (map + a b))

;; ---------------

;; diagonals too this time
;; changing this to a constant makes all the tests for this day take a little
;; less time on my little computer
;; before ============== 12 passed in 19.28s ===========
;; after =============== 12 passed in 18.91s ===========
;; but when I tried replacing it with a macro, I got this
;; ===================== 12 passed in 21.91s ===========
;; I repeated the experiment a few times
;; I guess the macro adds a lot of compile time? maybe if I precompiled the
;; program and then used the same compiled program for all 12 test cases it
;; would speed it up, but as you can see by the experiment with a constant,
;; I'll just leave it like this, and calculate once for everything flash
;; the most expensive part of this program seems to be listing the hash keys
(define (all-directions)
  (filter (lambda (point)
         (> (apply + (map abs point)) 0))
          (cartesian-product (range -1 2) (range -1 2))))

(define (main turns path)
  (/> path
      file->lines
      (curry map string->list)
      (curry map (curry map char->number))
      hash-board
      (curry operation turns)))

(define (operation arg board)
  (if (equal? "--predict-synchroflash" arg)
      (predict-synchroflash board)
      (last (take-turns (string->number arg) board))))

;; different from standard function char->integer which gets the ascii value
(define (char->number char)
  (/> char
      list
      list->string
      string->number))

(define (hash-board rows)
  (/> rows
      (curry map
             hash-row
             (range (length rows)))
      (curry apply append)
      make-immutable-hash))

;; wow program should work even if rows are not all the same length!!!
;; just gives cons list for the row - can turn them into a hash later
(define (hash-row y row)
  (map cons
       (map (curryr list y) (range (length row)))
       row))

;; is there a better way to iterate this many times if we are never using the
;; value than passing in an list of a certain length?
;; and I guess there is a better way to create that list than range if I only
;; want to use the length
(define (take-turns turns board)
  (foldl (lambda (n situation)
           (apply take-turn situation))
         (list board 0)
         (range turns)))

(define (take-turn board score)
  (/> board
      increment-all-points
      resolve-flashes
      (curry tally-and-reset score)))

(define (increment-all-points board)
  (increment-points board (hash-keys board)))

(define (tally-and-reset score board [points #f])
  (if points
      (if (> (length points) 0)
          (if (hash-ref board (car points))
              (tally-and-reset score board (cdr points))
              (tally-and-reset (+ score 1)
                               (hash-set board (car points) 0)
                               (cdr points)))
          (list board score))
      (tally-and-reset score board (hash-keys board))))

(define (resolve-flashes board)
  (let ([new-board (do-one-flash board)])
    (if new-board
        (resolve-flashes new-board)
        board)))

(define (do-one-flash board)
  (let ([location (find-next-epicenter board)])
    (if location
        (/> board
            (curry mark-flash location)
            (curry increment-neighbours location))
        #f)))

(define (mark-flash location board)
  (hash-set board location #f)) ; #f also stands for FLASH

(define (increment-neighbours location board)
  (increment-points board
                    (all-neighbouring-coordinates location)))

;; this has some stuff that is not used when incrementing the whole board
;; - handling off board points
;; - handling #f values
;; but we still use it to increment the whole board
(define (increment-points board points)
  (foldl (lambda (point board)
           (if (hash-ref board point #f)
               (hash-update board point add1)
               board))
         board
         points))

(define (find-next-epicenter board [keys #f])
  (if keys
      (if (> (length keys) 0)
          (let ([val (hash-ref board (car keys))])
            (if (and val (> val 9))
                (car keys) ; ha ha sounds like "car keys"
                (find-next-epicenter board (cdr keys))))
          #f)
      (find-next-epicenter board (hash-keys board))))

;; part ii..

;; some functions have names that makes more sense in the context of part i
;; and I am just passing in zero as the flash count into take-turn instead
;; of changing the existing function

;; I actually made this, tried it out, and then added one to the starting point
;; instead of actually trying to understand the source of the off by 1 issue
;; but automated tests and off by one errors kind of work well together
(define (predict-synchroflash board [turns 1])
  (let ([situation (take-turn board 0)])
    (if (= turns infinity) ;; don't search forever
        "infinity"
        (if (= (last situation) (hash-count board))
           turns
           (predict-synchroflash (car situation) (+ turns 1))))))

;; the example was less than a thousand so that's what I used, and then
;; luckily the answer to my real puzzle input was also less than a thousand
;; to I didn't have to redefine infinity - this could have been another param
(define infinity
  (expt 2 10))

;; ---------------

(display (/> (current-command-line-arguments)
             (lambda (x) (list (vector-ref x 0) (vector-ref x 1)))
             (curry apply main)))

(display "\n")

