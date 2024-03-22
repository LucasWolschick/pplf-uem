#lang racket

(define (so-primeira-maiuscula palavra)
  (string-append (string-upcase (substring palavra 0 1))
                 (string-downcase (substring palavra 1))))