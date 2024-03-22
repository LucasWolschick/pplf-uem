#lang racket

(define (par? n)
  (= (remainder n 2) 0))