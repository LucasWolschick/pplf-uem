#lang racket

; Faça uma função chamada produto-anterior-posterior que recebe um número inteiro n e calcula
; o produto de n, n + 1 e n - 1. Confira na janela de interações se a função funciona de acordo com
; os exemplos a seguir

(define (produto-anterior-posterior n)
  (* (- n 1) n (+ n 1)))