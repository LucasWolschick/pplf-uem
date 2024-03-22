#lang racket

;; Universidade Estadual de Maringá
;; Paradigma de Programação Lógica e Funcional
;;
;; Trabalho 1 - Classificação no Brasileirão
;; Lucas Wolschick
;;
;; Este programa recebe uma lista de resultados de jogos de futebol do campeonato
;; brasileiro e constrói uma tabela de pontuação final, ordenada por pontuação
;; segundo os critérios de desempate do campeonato.
;;
;; Feito para o primeiro trabalho da disciplina de Paradigma de Programação Lógica e
;; Funcional.

(require examples)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Tipos de dados
;;

;; Resultado-String é uma string da forma "Time Gol Time Gol", onde Time não contém
;; espaços e Gol é um número natural.

(struct resultado (time-a gols-a time-b gols-b) #:transparent)
;; String Natural String Natural -> Resultado
;; Representa o resultado de uma partida.
;; - time-a: String - o nome do time da casa.
;; - gols-a: Natural - o número de gols do time da casa.
;; - time-b: String - o nome do time visitante.
;; - gols-b: Natural - o número de gols do time visitante.

(struct desempenho (time pontos vitorias saldo) #:transparent)
;; String Natural Natural Inteiro -> Resultado
;; Representa dados de desempenho de um time no campeonato.
;; - time: String - o nome do time.
;; - pontos: Natural - a pontuação do time.
;; - vitorias: Natural - o número de partidas vencidas do time.
;; - saldo: Inteiro - o saldo de gols do time.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Funções
;;


;; String String -> (list String)
;;
;; Recebe a string str e a corta na primeira ocorrência de padrao, retornando uma lista
;; contendo duas strings: as partes antes e depois de padrao (padrao não incluso em
;; nenhuma das strings).
;;
;; Caso o padrao não esteja contido na string, retorna uma lista com um elemento: str.
;; Caso o padrao seja igual à string, retorna uma lista com a string vazia.
(examples
 (check-equal? (corta-string-em "Olá mundo!" " ") (list "Olá" "mundo!"))
 (check-equal? (corta-string-em "Banana" "an") (list "B" "ana"))
 (check-equal? (corta-string-em "string" " ") (list "string"))
 (check-equal? (corta-string-em "teste" "") (list "" "teste"))
 (check-equal? (corta-string-em "" "") (list "")))
(define (corta-string-em str padrao)
  (define (itera pos)
    (define str-teste (substring str pos))
    (cond [(equal? str-teste padrao) (list str)]
          [(string-prefix? str-teste padrao)
           (list (substring str 0 pos)
                 (substring str (+ pos (string-length padrao))))]
          [(= pos (string-length str)) (list str)]
          [else (itera (add1 pos))]))
  (itera 0))


;; String String -> (list String)
;;
;; Recebe a string str e a corta em cada ocorrência de padrao, retornando uma lista de
;; strings. Caso o padrao não ocorra em str, retorna uma lista contendo apenas str.
;;
;; Esta função implementa  um subconjunto da funcionalidade da função da biblioteca
;; padrão string-split.
(examples
 (check-equal? (corta-string-por "Olá mundo!" " ") (list "Olá" "mundo!"))
 (check-equal? (corta-string-por "Banana" "an") (list "B" "" "a"))
 (check-equal? (corta-string-por "Letras" "") (list "" "L" "e" "t" "r" "a" "s" "")))
(define (corta-string-por str padrao)
  ; isso é para lidar com o caso do separador ser "" ...
  ; (deve haver algum jeito melhor de fazer isso)
  ; (na verdade o jeito melhor de fazer isso é usar a função string-split e não se
  ;; preocupar com isso)
  (define (interno str)
    (define corte (corta-string-em str padrao))
    (cond [(empty? (rest corte)) corte]
          ; caso degenerado: o separador é ""
          [(equal? (first (rest corte)) str) 
           (cons
            (substring str 0 1)
            (interno (substring str 1)))]
          [else (cons (first corte)
                      (interno (first (rest corte))))]))
  (if (equal? padrao "")
      (cons "" (interno str))
      (interno str)))


;; Resultado-String -> String
;;
;; Recebe uma string resultado-str representando o resultado de uma partida e retorna
;; uma instância do tipo Resultado com as mesmas informações.
(examples
 (check-equal? (string->resultado "Cuiaba 2 Juventude 2")
               (resultado "Cuiaba" 2 "Juventude" 2))
 (check-equal? (string->resultado "Bahia 3 Santos 0")
               (resultado "Bahia" 3 "Santos" 0))
 (check-equal? (string->resultado "Sao-Paulo 0 Fluminense 0")
               (resultado "Sao-Paulo" 0 "Fluminense" 0))
 (check-equal? (string->resultado "Gremio 0 Internacional 27")
               (resultado "Gremio" 0 "Internacional" 27))) ; pouco enviesado
(define (string->resultado resultado-str)
  (define partes (corta-string-por resultado-str " "))
  (define time-a (first partes))
  (define gols-a (string->number (first (rest partes)))) ; (second partes)
  (define time-b (first (rest (rest partes)))) ; (third partes)
  (define gols-b (string->number (first (rest (rest (rest partes)))))) ; (fourth partes)
  (resultado time-a gols-a time-b gols-b))


;; (list) -> Boolean
;;
;; Retorna se a lista palheiro contém o elemento agulha.
(examples
 (check-equal? (contem? "1" (list "1" 2 #t)) #t)
 (check-equal? (contem? 4 (list 1)) #f)
 (check-equal? (contem? #t (list)) #f))
(define (contem? agulha palheiro)
  (cond [(empty? palheiro) #f]
        [(equal? (first palheiro) agulha) #t]
        [else (contem? agulha (rest palheiro))]))


;; (list) -> (list)
;;
;; Recebe uma lista e retorna a lista com elementos repetidos removidos. Apenas a
;; primeira ocorrência de cada elemento repetido é preservada na lista.
(examples
 (check-equal? (deduplica empty) empty)
 (check-equal? (deduplica (list 1 2 3)) (list 1 2 3))
 (check-equal? (deduplica (list 1 1 2)) (list 1 2)))
;(define (deduplica lst)
;  (cond [(empty? lst) empty]
;        [(contem? (first lst) (rest lst)) (deduplica (rest lst))]
;        [else (cons (first lst) (deduplica (rest lst)))]))
; para usar o filter ao menos uma vez
(define (deduplica lst)
  (cond [(empty? lst) empty]
        [else (cons (first lst) (deduplica
                                 (filter
                                  (λ (elem) (not (equal? elem (first lst))))
                                  (rest lst))))]))


;; (list) Any -> (list)
;;
;; Recebe uma lista e um elemento e remove a primeira ocorrência do elemento na lista.
;; Caso o elemento não pertença à lista, a própria lista é retornada.
(examples
 (check-equal? (remove-primeiro (list 1 2 3) 1) (list 2 3))
 (check-equal? (remove-primeiro (list 1 2 2 3) 2) (list 1 2 3))
 (check-equal? (remove-primeiro (list 1 2) 3) (list 1 2))
 (check-equal? (remove-primeiro empty 2) empty))
(define (remove-primeiro lst valor)
  (cond [(empty? lst) empty]
        [(equal? (first lst) valor) (rest lst)]
        [else (cons (first lst) (remove-primeiro (rest lst) valor))]))


;; (list) (Menor? esq dir) -> (list)
;;
;; Recebe uma lista e um predicado comparador menor? e a retorna ordenada. Menor? é uma
;; função que deve retornar #t se esq < dir ou #f caso contrário.
;;
;; O algoritmo implementado é a ordenação por inserção. A ordenação é estável.
(examples
 (check-equal? (ordena-por (list 3 1 4 2) <) (list 1 2 3 4))
 (check-equal? (ordena-por (list 9 8 7) <) (list 7 8 9))
 (check-equal? (ordena-por (list 1 2) <) (list 1 2))
 (check-equal? (ordena-por empty <) empty))
(define (ordena-por lst menor?)
  (cond [(empty? lst) empty]
        [else
         ; aqui TEM QUE SER foldl para que a ordenação seja estável
         (define menor (foldl (λ (elem menor) (if (menor? elem menor)
                                                  elem
                                                  menor)) (first lst) (rest lst)))
         (define resto (remove-primeiro lst menor))
         (cons menor (ordena-por resto menor?))]))


;; (list Resultado) -> (list String)
;;
;; Recebe uma lista de resultados lst-resultados e retorna uma lista contendo os nomes
;; dos times mencionados nos resultados, sem repetições.
;; 
;; Os times retornados estão ordenados por ordem alfabética.
(examples
 (check-equal? (encontra-times empty) empty)
 (check-equal? (encontra-times (list (resultado "Cuiaba" 2 "Juventude" 2)))
               (list "Cuiaba" "Juventude"))
 (check-equal? (encontra-times (list (resultado "Cuiaba" 2 "Juventude" 2)
                                     (resultado "Internacional" 2 "Cuiaba" 2)))
               (list "Cuiaba" "Internacional"  "Juventude")))
(define (encontra-times lst-resultados)
  (define times-a (map resultado-time-a lst-resultados))
  (define times-b (map resultado-time-b lst-resultados))
  ; append não está no resumo mas foi mostrado nos slides...
  (define times (deduplica (append times-a times-b)))
  ; string<? não está no resumo (mas string-ref, char-integer também não estão!!)
  (ordena-por times string<?))

;; Desempenho Natural -> Desempenho
;;
;; Atualiza o desempenho des fornecido com o saldo de gols de uma partida relativo ao
;; time especificado em des. Um saldo de gols representa exatamente o resultado de uma
;; partida: caso ele seja positivo, o time teve uma vitória e ganhou 3 pontos; caso seja
;; zero, houve um empate e o time ganha 1 ponto; caso contrário, o time perdeu a partida
;; e ganha 0 pontos.
(examples
 (check-equal? (atualiza-desempenho-com-saldo (desempenho "Botafogo" 0 0 0) 2)
               (desempenho "Botafogo" 3 1 2))
 (check-equal? (atualiza-desempenho-com-saldo (desempenho "Internacional" 13 3 4) 0)
               (desempenho "Internacional" 14 3 4))
 (check-equal? (atualiza-desempenho-com-saldo (desempenho "Chapecoense" 1 0 -1) -2)
               (desempenho "Chapecoense" 1 0 -3)))
(define (atualiza-desempenho-com-saldo des saldo-inc)
  (define vitorias-inc (if (> saldo-inc 0) 1 0))
  (define pontos-inc (cond [(> saldo-inc 0) 3]
                           [(= saldo-inc 0) 1]
                           [else 0]))
  (struct-copy desempenho des
               [pontos (+ (desempenho-pontos des) pontos-inc)]
               [vitorias (+ (desempenho-vitorias des) vitorias-inc)]
               [saldo (+ (desempenho-saldo des) saldo-inc)]))

;; Desempenho Resultado -> Desempenho
;;
;; Atualiza o desempenho des fornecido com o resultado da partida res. O desempenho
;; apenas é atualizado caso o time tenha jogado aquela partida como time da casa ou time
;; visitante.
;;
;; Os critérios de atualização estão especificados na documentação da função atualiza-
;; -desempenho-com-saldo.
(examples
 (check-equal? (atualiza-desempenho-com-resultado (desempenho "Botafogo" 0 0 0)
                                                  (resultado "Botafogo" 1 "Vasco" 0))
               (desempenho "Botafogo" 3 1 1))
 (check-equal? (atualiza-desempenho-com-resultado (desempenho "Botafogo" 0 0 0)
                                                  (resultado "Botafogo" 1 "Vasco" 1))
               (desempenho "Botafogo" 1 0 0))
 (check-equal? (atualiza-desempenho-com-resultado (desempenho "Botafogo" 0 0 0)
                                                  (resultado "Botafogo" 1 "Vasco" 2))
               (desempenho "Botafogo" 0 0 -1))
 (check-equal? (atualiza-desempenho-com-resultado (desempenho "Botafogo" 0 0 0)
                                                  (resultado "Flamengo" 0 "Botafogo" 1))
               (desempenho "Botafogo" 3 1 1))
 (check-equal? (atualiza-desempenho-com-resultado (desempenho "Botafogo" 0 0 0)
                                                  (resultado "Flamengo" 1 "Botafogo" 1))
               (desempenho "Botafogo" 1 0 0))
 (check-equal? (atualiza-desempenho-com-resultado (desempenho "Botafogo" 0 0 0)
                                                  (resultado "Flamengo" 2 "Botafogo" 1))
               (desempenho "Botafogo" 0 0 -1))
 (check-equal? (atualiza-desempenho-com-resultado (desempenho "Botafogo" 0 0 0)
                                                  (resultado "Flamengo" 0 "Gremio" 5))
               (desempenho "Botafogo" 0 0 0)))
(define (atualiza-desempenho-com-resultado des res)
  (cond [(equal? (resultado-time-a res) (desempenho-time des))
         (atualiza-desempenho-com-saldo des (- (resultado-gols-a res)
                                               (resultado-gols-b res)))]
        [(equal? (resultado-time-b res) (desempenho-time des))
         (atualiza-desempenho-com-saldo des (- (resultado-gols-b res)
                                               (resultado-gols-a res)))]
        [else des]))


;; ListaString ListaResultado -> ListaDesempenho
;;
;; Recebe uma lista de nomes de times e uma lista de resultados de partidas e computa o
;; desempenho de cada time naquela série de partidas. O desempenho é computado com base
;; nas regras do campeonato brasileiro.
;;
;; Detalhe de implementação: os desempenhos são retornados na mesma ordem em que os
;; times foram fornecidos.
(examples
 (check-equal? (calcula-desempenhos
                (list "Atletico-MG" "Flamengo" "Palmeiras" "Sao-Paulo")
                (list (resultado "Sao-Paulo" 1 "Atletico-MG" 2)
                      (resultado "Flamengo" 2 "Palmeiras" 1)
                      (resultado "Palmeiras" 0 "Sao-Paulo" 0)
                      (resultado "Atletico-MG" 1 "Flamengo" 2)))
               (list (desempenho "Atletico-MG" 3 1 0)
                     (desempenho "Flamengo" 6 2 2)
                     (desempenho "Palmeiras" 1 0 -1)
                     (desempenho "Sao-Paulo" 1 0 -1))))
(define (calcula-desempenhos lst-times lst-resultados)
  (define (calcula-desempenho time)
    (foldr (λ (res des) (atualiza-desempenho-com-resultado des res))
           (desempenho time 0 0 0)
           lst-resultados))
  (map (λ (time) (calcula-desempenho time)) lst-times))


;; ListaDesempenho -> ListaDesempenho
;;
;; Recebe uma lista de desempenhos lst-desempenhos de times em um campeonato e a retorna
;; ordenada em ordem de classificação de acordo com os seguintes critérios de desempate,
;; em ordem:
;;  - Número de pontos (decrescente);
;;  - Número de vitórias (decrescente);
;;  - Saldo de gols (decrescente);
;;  - Ordem alfabética (crescente).
(examples
 (check-equal? (classifica (list (desempenho "Atletico-MG" 3 1 0)
                                 (desempenho "Flamengo" 6 2 2)
                                 (desempenho "Palmeiras" 1 0 -1)
                                 (desempenho "Sao-Paulo" 1 0 -1)))
               (list (desempenho "Flamengo" 6 2 2)
                     (desempenho "Atletico-MG" 3 1 0)
                     (desempenho "Palmeiras" 1 0 -1)
                     (desempenho "Sao-Paulo" 1 0 -1))))
(define (classifica lst-desempenhos)
  ; ordena-por é estável, então podemos ordenar por critério
  ; em tese, em nosso programa não seria necessário ordenar por nome
  (define por-nome (ordena-por lst-desempenhos
                               (λ (esq dir) (string<? (desempenho-time esq)
                                                      (desempenho-time dir)))))
  (define por-saldo (ordena-por por-nome
                                (λ (esq dir) (> (desempenho-saldo esq)
                                                (desempenho-saldo dir)))))
  (define por-vitorias (ordena-por por-saldo
                                   (λ (esq dir) (> (desempenho-vitorias esq)
                                                   (desempenho-vitorias dir)))))
  (define por-pontos (ordena-por por-vitorias
                                 (λ (esq dir) (> (desempenho-pontos esq)
                                                 (desempenho-pontos dir)))))
  por-pontos)


;; String Natural -> String
;;
;; Adiciona espaços à direita da string str até que ela atinja um comprimento maior ou
;; igual a tam. Caso a string seja maior que tam, nada é feito.
(examples
 (check-equal? (pad-direita "oi" 5) "oi   ")
 (check-equal? (pad-direita "tchau" 3) "tchau")
 (check-equal? (pad-direita "olá !" 5) "olá !"))
(define (pad-direita str tam)
  (if (> (string-length str) tam)
      str
      (string-append str (make-string (- tam (string-length str)) #\space))))


;; String Natural -> String
;;
;; Adiciona espaços à esquerda da string str até que ela atinja um comprimento maior ou
;; igual a tam. Caso a string seja maior que tam, nada é feito.
(examples
 (check-equal? (pad-esquerda "oi" 5) "   oi")
 (check-equal? (pad-esquerda "tchau" 3) "tchau")
 (check-equal? (pad-esquerda "olá !" 5) "olá !"))
(define (pad-esquerda str tam)
  (if (> (string-length str) tam)
      str
      (string-append (make-string (- tam (string-length str)) #\space) str)))


;; (list) (Maior? esq dir) -> (list)
;;
;; Retorna o maior elemento da lista lst fornecida utilizando o predicado de comparação
;; Maior?. Maior? recebe dois elementos e deve retornar #t caso o elemento à esquerda
;; seja maior que o da direita e #f caso contrário. A lista deve possuir ao menos um
;; elemento.
(examples
 (check-equal? (maior > (list 1 2 3 4)) 4)
 (check-equal? (maior string>? (list "beatriz" "antônio" "carlos")) "carlos")
 (check-equal? (maior < (list 10 20 30)) 10))
(define (maior maior? lst)
  (foldr (λ (elem maior) (if (maior? elem maior)
                             elem
                             maior))
         (first lst) (rest lst)))


;; (list Desempenho) -> (list String)
;;
;; Recebe uma lista ordenada lst-des de desempenhos de times de um campeonato e retorna
;; uma tabela de strings com os campos alinhados.
(examples
 (check-equal? (gera-tabela-alinhada (list (desempenho "Flamengo" 6 2 2)
                                           (desempenho "Atletico-MG" 3 1 0)
                                           (desempenho "Palmeiras" 1 0 -1)
                                           (desempenho "Sao-Paulo" 1 0 -1)))
               (list "Flamengo     6  2   2"
                     "Atletico-MG  3  1   0"
                     "Palmeiras    1  0  -1"
                     "Sao-Paulo    1  0  -1"))
 (check-equal? (gera-tabela-alinhada (list (desempenho "Flamengo" 126 2 2)
                                           (desempenho "Atletico-MG" 3 1234 0)
                                           (desempenho "Palmeiras" 1 0 -13)
                                           (desempenho "Sao-Paulo" 1 0 -1)))
               (list "Flamengo     126     2    2"
                     "Atletico-MG    3  1234    0"
                     "Palmeiras      1     0  -13"
                     "Sao-Paulo      1     0   -1")))
(define (gera-tabela-alinhada lst-des)
  ;; Acessor -> Natural
  ;;
  ;; Gera um λ que retorna o comprimento do campo (fornecido como acessor).
  ;; O campo deve ser um string.
  (define (tam-campo-str campo)
    (λ (elem) (string-length (campo elem))))
  
  ;; Acessor -> Natural
  ;;
  ;; Gera um λ que retorna o comprimento do campo (fornecido como acessor).
  ;; O campo deve ser um string.
  (define (tam-campo-num campo)
    (λ (elem) (string-length (number->string (campo elem)))))

  ; encontramos os maiores comprimentos para cada campo da tabela...
  (define comp-nome (maior > (map (tam-campo-str desempenho-time) lst-des)))
  (define comp-pontos (maior > (map (tam-campo-num desempenho-pontos) lst-des)))
  (define comp-vitorias (maior > (map (tam-campo-num desempenho-vitorias) lst-des)))
  (define comp-saldo (maior > (map (tam-campo-num desempenho-saldo) lst-des)))

  ;; Desempenho -> String
  ;;
  ;; Converte um desempenho em uma representação textual alinhada do desempenho.
  ;; O alinhamento é feito em relação aos demais desempenhos de lst-des.
  (define (processa-desempenho des)
    (string-append (pad-direita (desempenho-time des) comp-nome)
                   (pad-esquerda (number->string (desempenho-pontos des))
                                 (+ comp-pontos 2))
                   (pad-esquerda (number->string (desempenho-vitorias des))
                                 (+ comp-vitorias 2))
                   (pad-esquerda (number->string (desempenho-saldo des))
                                 (+ comp-saldo 2))))
  (map processa-desempenho lst-des))


;; (list Resultado-String) -> (list String)
;;
;; Recebe uma lista de resultados resultados-str de jogos de futebol do campeonato
;; brasileiro e retorna uma tabela de classificação com base nos resultados fornecidos
;; no formato de uma lista de strings contendo o nome do time, a pontuação, o número
;; de vitórias e o saldo de gols, onde times que aparecem primeiro estão melhor
;; classificados do que times que aparecem depois. A tabela retornada é alinhada.
;;
;; A classificação dos times é feita de acordo com os critérios do brasileirão; veja
;; a função classifica para mais detalhes.
(examples
 (check-equal? (classifica-times
                (list "Sao-Paulo 1 Atletico-MG 2"
                      "Flamengo 2 Palmeiras 1"
                      "Palmeiras 0 Sao-Paulo 0"
                      "Atletico-MG 1 Flamengo 2"))
               (list "Flamengo     6  2   2"
                     "Atletico-MG  3  1   0"
                     "Palmeiras    1  0  -1"
                     "Sao-Paulo    1  0  -1")))
(define (classifica-times sresultados)
  (define resultados (map string->resultado sresultados))
  (define times (encontra-times resultados))
  (define desempenhos (calcula-desempenhos times resultados))
  (define classificacao (classifica desempenhos))
  (gera-tabela-alinhada classificacao))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Ponto de entrada
;;

(display-lines (classifica-times (port->lines)))