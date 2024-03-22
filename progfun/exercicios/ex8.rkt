#lang racket

(define (ordem a b c)
  (cond [(< a b c) "crescente"]
        [(> a b c) "decrescente"]
        [else "sem ordem"]))