#lang racket

;; provided to main module
(provide />)
(provide read-buoyancy-interchange-transmission-from-file)

;; provided only for unit testing

(define (/> . args)
   ((apply compose (reverse (cdr args))) (car args)))

(define (read-buoyancy-interchange-transmission-from-file path)
  (string-append "processing " path))

