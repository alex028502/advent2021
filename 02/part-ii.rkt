#lang racket

(require racket/cmdline)

(define raw-input (file->lines (vector-ref (current-command-line-arguments) 0)))

(define input (map string-split raw-input))

(define (follow-instructions moves)
  (foldl
   (lambda (move result)
     (apply (lambda (aim depth distance) ; really to destructure list
              (let ([command (car move)] [mag (string->number (last move))])
                (if (string=? "forward" command)
                    (list aim (+ depth (* mag aim)) (+ distance mag))
                    (list (+ aim (* mag (if (string=? "up" command) -1 1)))
                          depth
                          distance))))
            result))
   '(0 0 0)
   moves))

(display (apply * (cdr (follow-instructions input))))

(display "\n")
