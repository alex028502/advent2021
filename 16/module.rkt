#lang racket

;; provided to main module
(provide />)
(provide decode-buoyancy-interchange-transmission)

;; provided only for unit testing
(provide construct-sample-message)

(define (/> . args)
  ((apply compose (reverse (cdr args))) (car args)))

(define (decode-buoyancy-interchange-transmission str)
  (string-append "processing: " (construct-sample-message str)))

(define (construct-sample-message str)
  (string-append "sample " str))
