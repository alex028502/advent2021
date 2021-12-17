
(provide />)

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))
