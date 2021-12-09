#lang racket

(require racket/cmdline)

(define raw-input (file->lines (vector-ref (current-command-line-arguments) 0)))

(define input (map string-split raw-input))

(define (follow-instructions moves [aim 0] [depth 0] [distance 0])
  (if (= 0 (length moves))
      (list aim depth distance)
      (let ([command (car (car moves))]
            [mag (string->number (last (car moves)))])
        (if (string=? "forward" command)
            ;; I don't know what tail call optimisation means by the "last"
            ;; thing - are two possibilities in an if both last? or just the
            ;; one listed last?
            (follow-instructions (cdr moves)
                                 aim
                                 (+ depth (* mag aim))
                                 (+ distance mag))
            (follow-instructions (cdr moves)
                                 (+ aim
                                    (* mag (if (string=? "up" command) -1 1)))
                                 depth
                                 distance)))))

(display (apply * (cdr (follow-instructions input))))

(display "\n")
