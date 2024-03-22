#lang racket

(define (tres-digitos? n)
  (= (string-length (number->string n)) 3))