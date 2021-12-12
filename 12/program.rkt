#lang racket

(require racket/cmdline)

;; ---------------

(define (parse-file path)
  (/> path
      file->lines
      (curry map (curryr string-split "-"))
      (curry map double-edge)
      (curry apply append)
      make-edge-hash))

;; is edge the right word?
(define (make-edge-hash edges)
  (foldl add-edge-to-hash-reducer-style
         (make-immutable-hash)
         edges))

(define (add-edge-to-hash-reducer-style edge hash)
  (add-edge-to-hash hash
                    (car edge)
                    (last edge)))

(define (add-edge-to-hash hash start end)
  (if (hash-has-key? hash start)
      (hash-update hash start (curry cons end))
      (add-edge-to-hash (hash-set hash start '())
                        start
                        end)))

;; I'm just adding every possible route to the array twice
;; if I wanted to slightly speed up the program I could filter out all the ones
;; that end with start
(define (double-edge edge)
  (list edge (reverse edge)))

(define (find-solutions options-table [trail '("start")])
  (if (equal? (car trail) "end")
      (list trail)
      (let ([options (hash-ref options-table (car trail))])
        (/> options
            (curry filter (curry option-check trail))
            (curry map (lambda (option)
                         (find-solutions options-table
                                         (cons option trail))))
            (curry apply append)))))

(define (option-check trail option)
  (or (is-upper-case option)
      (not (member option trail))))

;; has to be all upper case but really we could just check the first letter
;; or check if it is not all lower case - all of the ones in the problem are
;; all one case or the other
(define (is-upper-case label)
  (equal? label (string-upcase label)))

; I still can't think of a cooler way to do this so copied this one
(define (/> . args)
   ((apply compose (reverse (cdr args))) (car args)))

;; ---------------

(display (/> (current-command-line-arguments)
             (curryr vector-ref 0)
             parse-file
             find-solutions
             length))

(display "\n")

