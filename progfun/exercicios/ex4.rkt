#lang racket

(define (exclamacao frase n)
  (string-append frase (make-string n #\!)))