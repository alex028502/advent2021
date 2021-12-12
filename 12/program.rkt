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

;; filter out start edges that lead to start for two reasons
;; in part i we don't need them since we'll never go back
;; in part ii there is a rule that we should never go back to start
;; we could have also put the rule in the option-check
;; but doing it this way
(define (add-edge-to-hash hash start end)
  (if (equal? end "start")
      hash
      (if (hash-has-key? hash start)
          (hash-update hash start (curry cons end))
          (add-edge-to-hash (hash-set hash start '())
                            start
                            end))))

;; I'm just adding every possible route to the array twice
(define (double-edge edge)
  (list edge (reverse edge)))

(define (find-solutions part options-table)
  (find-solutions:> (if (equal? part "ii")
                        complicated-option-check
                        simple-option-check)
                    options-table
                    '("start")))

;; didn't know what to call this so just gave it the same name as the wrapper
;; with a smile at the end - I think I would usually at an underscore to the
;; start while I was thinking of a name in other languages
(define (find-solutions:> option-check options-table trail)
  (if (equal? (car trail) "end")
      (list trail)
      (let ([options (hash-ref options-table (car trail))])
        (/> options
            (curry filter (curry option-check trail))
            (curry map (lambda (option)
                         (find-solutions:> option-check
                                           options-table
                                           (cons option trail))))
            (curry apply append)))))

(define (simple-option-check trail option)
  (or (is-upper-case option)
      (not (member option trail))))

;; this does not check if the destination is start because those edges are
;; already filtered out
(define (complicated-option-check trail option)
  (or (simple-option-check trail option)
      (/> trail
          (curry filter (lambda (x)
                          (not (is-upper-case x))))
          check-duplicates
          not)))

;; has to be all upper case but really we could just check the first letter
;; or check if it is not all lower case - all of the ones in the problem are
;; all one case or the other
(define (is-upper-case label)
  (equal? label (string-upcase label)))

; I still can't think of a cooler way to do this so copied this one
(define (/> . args)
   ((apply compose (reverse (cdr args))) (car args)))

;; ---------------

;; this turned a bit messy!
(display (/> (current-command-line-arguments)
             (lambda (x) (list
                          (vector-ref x 0)
                          (parse-file (vector-ref x 1))))
             (curry apply find-solutions)
             length))

(display "\n")

