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

;; tried to see if I could put I had had learned in minikanren and prolog
;; tutorials to use.. but either I don't have to skills, or this isn't that
;; class of problem, but I definitely don't have the skills to tell if this
;; is that class of problem.  While thinking about that, I realised that 7!
;; is only like five thousand!

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

;; I bet this exists!
;; > (length (all-orders (apply set (string->list "abcdefg"))))
;; 5040
;; that's 7! but I can't calculate that in racket without loading another lib
;; I don't think this meets the tail call rules but it's not that big I guess
;; so it works
(define (all-orders items [tail '()])
  (if (= (set-count items) 0)
      (list tail) ;; but this into list to cancel some other mistake
      (apply append (set-map items (lambda (x) (all-orders (set-remove items x)
                                                           (cons x tail)))))))

;; let's take a brake to define the digits in terms of numbers LEDs
;; and keep the letters for the incorrect ones
;; so that we can just look them up in that list
;; except let's put the real letters first because it's less likely to make
;; a mistake if we can copy straight from the instructions and leave the math
;; to the computer
(define correct-digits (list (set #\a #\b #\c #\e #\f #\g)
                             (set #\c #\f)
                             (set #\a #\c #\d #\e #\g)
                             (set #\a #\c #\d #\f #\g)
                             (set #\b #\c #\d #\f)
                             (set #\a #\b #\d #\f #\g)
                             (set #\a #\b #\d #\e #\f #\g)
                             (set #\a #\c #\f)
                             (set #\a #\b #\c #\d #\e #\f #\g)
                             (set #\a #\b #\c #\d #\f #\g)))

(define (convert-letter-to-number x)
  (let ([letters "abcdefg"])
    (- (string-length letters)
       (length (member x (string->list letters))))))

;; convert the correct letters into numbers and leave letters for the wrong ones
(define (switch-letters-to-numbers s)
  (apply set (set-map s convert-letter-to-number)))

(define renumbered-correct-digits
  (map switch-letters-to-numbers correct-digits))

;; OK so now we have to look at every possible conversion chart and figure out
;; what the numbers are in terms of that order of letters
;; like what will numbers 0 through 9 be if the miswiring-pattern is
;; "deafgbc" actually maybe "cbgfaed" is the one in the example because I
;; starts backwards - let's see...
(define (mangle-digit miswiring-pattern numbered-led-set)
  (apply set (set-map
              numbered-led-set
              (lambda (x) (list-ref miswiring-pattern x)))))

;; to optimise we could just remove 8 from the array since it is always abcdefg
(define (mangle-digits miswiring-pattern)
  (map (curry mangle-digit miswiring-pattern)
       renumbered-correct-digits))

;; mangle-digits gets you the "rewiring table" that looks like this
;; for now just look up the answers
;; but I might have to hash this too - who knows
;; (list
;;  (set #\a #\b #\c #\d #\e)
;;  (set #\a #\b)
;;  (set #\a #\c #\d #\f #\g)
;;  (set #\a #\b #\c #\d #\f)
;;  (set #\a #\b #\e #\f)
;;  (set #\b #\c #\d #\e #\f)
;;  (set #\b #\c #\d #\e #\f #\g)
;;  (set #\a #\b #\d)
;;  (set #\a #\b #\c #\d #\e #\f #\g)
;;  (set #\a #\b #\c #\d #\e #\f))

;; part i seems to imply that we can uniquely identify a solution with 1,4,7
;; so let's base our first hash attempt on that and see if they are all unique
;; ok that didn't work! only 630 hashes
;; (define (hash-rewiring-table d)
;;   (list (list-ref d 1)
;;         (list-ref d 4)
;;         (list-ref d 7)))
;; the above didn't work, but the input is only 200 lines so maybe we don't
;; need to hash it - just find it somehow - 200 * 5040 * ... let's find out
;; or let's just use the whole set as the hash and do what we were gonna do!!
;; and just ignore the order because we don't know the order of what we compare
;; it to
(define (hash-rewiring-table rewiring-table)
   (apply set rewiring-table))

;; assume that our hash is unique so if we are wrong we'll overwrite entries
(define all-possible-answers
  (/> (all-orders (apply set (string->list "abcdefg")))
      (curry map mangle-digits)
      (curry map (lambda (x) (cons (hash-rewiring-table x) x)))
      make-immutable-hash))

;; > (hash-count all-possible-answers)
;; 5040
;; we are on the home stretch - whether this can finish in seconds or days is
;; another question

;; use this to find the same hash that we have in all possible answers
(define (hash-jumbled-rewiring-info jumbled-rewiring-info)
  (hash-rewiring-table (/> jumbled-rewiring-info
                           (curry map string->list)
                           (curry map (curry apply set)))))


;; unjumble by looking through the list of all possible solutions
(define (unjumble-rewiring-info jumbled-rewiring-info)
  (/> jumbled-rewiring-info
      hash-jumbled-rewiring-info
      (curry hash-ref all-possible-answers)))

;; we are asking the length every single time even though it is always 10
(define (rewiring-info-lookup rewiring-info jumbled-digit)
  (- (length rewiring-info) (length (member jumbled-digit rewiring-info))))

(define (interpret-info jumbled-rewiring-info jumbled-numbers)
  (let ([rewiring-info (unjumble-rewiring-info jumbled-rewiring-info)])
    (/> jumbled-numbers
        (curry map string->list)
        (curry map (curry apply set))
        (curry map (curry rewiring-info-lookup rewiring-info))
        (curry map number->string) ; should just do it with numbers
        (curry apply string-append) ; but they are already in the right order
        string->number))) ;; for appending

(define (interpret-line line)
  (/> line
      (lambda (x) (string-split x "|"))
      (curry map string-trim)
      (curry map string-split)
      (curry apply interpret-info)))

(display (/> (current-command-line-arguments)
             (lambda (x) (vector-ref x 0))
             file->lines
             (curry map interpret-line)
             (curry apply +)))

(display "\n")
