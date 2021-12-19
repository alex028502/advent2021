#lang racket

(require "./unit.rkt")

(display (/> (current-command-line-arguments)
             (curryr vector-ref 0)
             file->lines
             (curry apply snailfish-add)
             snailfish-magnitude))

(display "\n")

;; part ii
;; 100P2 is like 10k (because it is almost the same thing as 100x100)
;; and part i did 100 calculations in like a second
;; so this shouldn't take more than a couple minutes?
;; and if some of that second was startup time.. ever better

(/> (current-command-line-arguments)
    (curryr vector-ref 0)
    file->lines
    (λ (lines) (cartesian-product lines lines))
    (curry filter (λ (perm) (not (equal? (car perm) (last perm)))))
    (curry map (curry apply snailfish-add))
    (curry map snailfish-magnitude)
    (curry apply max))

(display "\n")
