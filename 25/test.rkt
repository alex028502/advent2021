#lang racket

(require rackunit)

(require "./module.rkt")

(check-equal? (sea-cucumber-step (parse-input "...>..."
                                              "......."
                                              "......>"
                                              "v.....>"
                                              "......>"
                                              "......."
                                              "..vvv.."))
              (parse-input "..vv>.."
                           "......."
                           ">......"
                           "v.....>"
                           ">......"
                           "......."
                           "....v.."))
