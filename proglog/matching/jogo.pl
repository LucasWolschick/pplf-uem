
%% Universidade Estadual de Maringá
%% Paradigma de Programação Lógica e Funcional
%%
%% Trabalho 2 - Resolvedor de Jogo de Quebra-cabeça
%% Lucas Wolschick
%%
%% Este programa implementa um solucionador eficiente para um jogo de quebra-cabeça
%% de combinar blocos.
%%
%% Feito para o segundo trabalho da disciplina de Paradigma de Programação Lógica e
%% Funcional.

:- use_module(library(plunit)).
:- use_module(library(clpfd)).

% Um jogo é representado por uma estrutura jogo com 3 argumentos. O primeiro é
% o número de linhas (L), o segundo o número de colunas (C) e o terceiro uma
% lista (Blocos - de tamanho linhas x colunas) com os blocos do jogo. Nessa
% representação os primeiros L elementos da lista Blocos correspondem aos
% blocos da primeira linha do jogo, os próximos L blocos correspondem aos
% blocos da segunda linha do jogo e assim por diante.
%
% Dessa forma, em jogo com 3 linhas e 5 colunas (total de 15 blocos), os
% blocos são indexados da seguinte forma:
%
%  0  1  2  3  4
%  5  6  7  8  9
% 10 11 12 13 14
%
% Cada bloco é representado por uma estrutura bloco com 4 argumentos. Os
% argumentos representam os valores da borda superior, direita, inferior e
% esquerda (sentido horário começando do topo). Por exemplo o bloco
%
% |  3  |
% |4   6|  é representado por bloco(3, 6, 7, 4).
% |  7  |
%
% Dizemos que um bloco está em posição adequada em relação a um bloco vizinho somente se
% os lados que se encostam do bloco e do vizinho possuem o mesmo número. Por exemplo:
%
% |  3  ||  5  |    Ambos os blocos estão adequados em relação ao outro, já que os lados
% |4   6||6   1| -> que se encostam (o lado direito do bloco à esquerda e o lado esquer-
% |  7  ||  2  |    do do bloco à direita) possuem o mesmo número, 6.
%
% Dizemos que um bloco está em posição adequada se, para todo vizinho seu, o bloco está
% adequado em relação ao vizinho. Os vizinhos de um bloco são os blocos à esquerda, à
% direita, acima e abaixo do bloco, caso estes vizinhos existam. Isto é, um bloco no
% canto do tabuleiro possui no máximo dois vizinhos e um bloco em um dos lados do
% tabuleiro possui no máximo três vizinhos.

%% jogo_solucao(+JogoInicial, ?JogoFinal) is nondet
%
%  Verdadeiro se JogoInicial é uma estrutura jogo(L, C, Blocos) e JogoFinal é
%  uma estrutura jogo(L, C, Solucao), onde Solucao é uma solução válida para o
%  JogoInicial, isto é, os blocos que aparecem em Solucao são os mesmos de
%  Blocos e estão em posições adequadas.

jogo_solucao(JogoInicial, JogoFinal) :-
    JogoInicial = jogo(L, C, Blocos),
    JogoFinal = jogo(L, C, Solucao),
    
    length(Blocos, N),
    length(Solucao, N),

    blocos_adequados(JogoFinal),
    bfs(JogoInicial, 0, Ordem),
    resolve(Ordem, Blocos, Solucao).

:- begin_tests(pequeno).

test(j1x1, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(3, 6, 7, 5)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(1, 1, Inicial), jogo(1, 1, Final)).


test(j2x2, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(3, 4, 7, 9),
        bloco(6, 9, 5, 4),
        bloco(7, 6, 5, 2),
        bloco(5, 3, 1, 6)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(2, 2, Inicial), jogo(2, 2, Final)).

test(j3x3, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(7, 3, 4, 9),
        bloco(3, 4, 8, 3),
        bloco(7, 4, 2, 4),
        bloco(4, 4, 8, 5),
        bloco(8, 3, 6, 4),
        bloco(2, 2, 7, 3),
        bloco(8, 9, 1, 3),
        bloco(6, 6, 6, 9),
        bloco(7, 8, 5, 6)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(3, 3, Inicial), jogo(3, 3, Final)).

:- end_tests(pequeno).


:- begin_tests(medio).

test(j4x4, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(7, 7, 4, 8),
        bloco(3, 0, 2, 7),
        bloco(7, 9, 1, 0),
        bloco(1, 6, 3, 9),
        bloco(4, 2, 5, 5),
        bloco(2, 4, 5, 2),
        bloco(1, 5, 7, 4),
        bloco(3, 8, 0, 5),
        bloco(5, 5, 8, 0),
        bloco(5, 5, 9, 5),
        bloco(7, 6, 7, 5),
        bloco(0, 2, 1, 6),
        bloco(8, 7, 9, 5),
        bloco(9, 2, 8, 7),
        bloco(7, 3, 3, 2),
        bloco(1, 0, 4, 3)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(4, 4, Inicial), jogo(4, 4, Final)).

test(j5x5, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(1, 6, 7, 5),
        bloco(4, 0, 0, 6),
        bloco(9, 2, 0, 0),
        bloco(8, 3, 5, 2),
        bloco(0, 4, 5, 3),
        bloco(7, 1, 2, 6),
        bloco(0, 4, 5, 1),
        bloco(0, 0, 3, 4),
        bloco(5, 1, 1, 0),
        bloco(5, 3, 2, 1),
        bloco(2, 9, 1, 0),
        bloco(5, 5, 5, 9),
        bloco(3, 2, 2, 5),
        bloco(1, 0, 6, 2),
        bloco(2, 9, 0, 0),
        bloco(1, 0, 7, 0),
        bloco(5, 0, 7, 0),
        bloco(2, 4, 8, 0),
        bloco(6, 9, 4, 4),
        bloco(0, 0, 6, 9),
        bloco(7, 0, 2, 5),
        bloco(7, 2, 0, 0),
        bloco(8, 6, 1, 2),
        bloco(4, 4, 6, 6),
        bloco(6, 5, 8, 4)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(5, 5, Inicial), jogo(5, 5, Final)).

test(j6x6, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(3, 0, 2, 4),
        bloco(9, 5, 5, 0),
        bloco(1, 1, 8, 5),
        bloco(4, 2, 0, 1),
        bloco(4, 3, 2, 2),
        bloco(8, 0, 0, 3),
        bloco(2, 2, 3, 9),
        bloco(5, 9, 1, 2),
        bloco(8, 2, 3, 9),
        bloco(0, 2, 3, 2),
        bloco(2, 9, 8, 2),
        bloco(0, 6, 9, 9),
        bloco(3, 1, 6, 9),
        bloco(1, 2, 2, 1),
        bloco(3, 0, 8, 2),
        bloco(3, 5, 8, 0),
        bloco(8, 7, 8, 5),
        bloco(9, 4, 8, 7),
        bloco(6, 0, 6, 9),
        bloco(2, 4, 5, 0),
        bloco(8, 7, 6, 4),
        bloco(8, 3, 7, 7),
        bloco(8, 7, 2, 3),
        bloco(8, 7, 1, 7),
        bloco(6, 3, 9, 0),
        bloco(5, 1, 9, 3),
        bloco(6, 9, 8, 1),
        bloco(7, 7, 0, 9),
        bloco(2, 0, 6, 7),
        bloco(1, 3, 7, 0),
        bloco(9, 9, 8, 7),
        bloco(9, 0, 6, 9),
        bloco(8, 1, 6, 0),
        bloco(0, 9, 7, 1),
        bloco(6, 1, 7, 9),
        bloco(7, 8, 1, 1)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(6, 6, Inicial), jogo(6, 6, Final)).

:- end_tests(medio).


:- begin_tests(grande).

test(j7x7, [nondet, Final = Blocos]) :-
    Blocos = [
        bloco(4, 1, 0, 8),
        bloco(7, 8, 1, 1),
        bloco(0, 3, 5, 8),
        bloco(4, 0, 9, 3),
        bloco(9, 7, 1, 0),
        bloco(6, 8, 3, 7),
        bloco(3, 5, 2, 8),
        bloco(0, 9, 5, 8),
        bloco(1, 4, 9, 9),
        bloco(5, 1, 6, 4),
        bloco(9, 3, 1, 1),
        bloco(1, 5, 6, 3),
        bloco(3, 3, 2, 5),
        bloco(2, 0, 4, 3),
        bloco(5, 1, 8, 8),
        bloco(9, 6, 8, 1),
        bloco(6, 5, 2, 6),
        bloco(1, 8, 6, 5),
        bloco(6, 4, 9, 8),
        bloco(2, 8, 2, 4),
        bloco(4, 1, 8, 8),
        bloco(8, 1, 5, 4),
        bloco(8, 2, 0, 1),
        bloco(2, 0, 2, 2),
        bloco(6, 4, 8, 0),
        bloco(9, 7, 7, 4),
        bloco(2, 8, 5, 7),
        bloco(8, 0, 7, 8),
        bloco(5, 6, 0, 8),
        bloco(0, 9, 4, 6),
        bloco(2, 2, 2, 9),
        bloco(8, 9, 5, 2),
        bloco(7, 1, 5, 9),
        bloco(5, 2, 0, 1),
        bloco(7, 9, 6, 2),
        bloco(0, 7, 5, 8),
        bloco(4, 7, 5, 7),
        bloco(2, 9, 1, 7),
        bloco(5, 7, 5, 9),
        bloco(5, 5, 4, 7),
        bloco(0, 8, 5, 5),
        bloco(6, 8, 7, 8),
        bloco(5, 7, 9, 6),
        bloco(5, 0, 2, 7),
        bloco(1, 4, 6, 0),
        bloco(5, 3, 2, 4),
        bloco(4, 9, 6, 3),
        bloco(5, 8, 1, 9),
        bloco(7, 8, 0, 8)
    ],
    reverse(Blocos, Inicial),
    jogo_solucao(jogo(7, 7, Inicial), jogo(7, 7, Final)).

:- end_tests(grande).


%% blocos_adequados(?Jogo) is nondet
%
%  Verdadeiro se Jogo é uma estrutura jogo(L, C, Blocos), e todos os blocos de
%  Blocos estão em posições adequadas.

:- begin_tests(blocos_adequados).

test(pequeno1x1, nondet) :- blocos_adequados(jogo(1, 1, [
        bloco(3, 6, 7, 5)
    ])).

test(pequeno2x2, nondet) :- blocos_adequados(jogo(2, 2, [
        bloco(3, 4, 7, 9),
        bloco(6, 9, 5, 4),
        bloco(7, 6, 5, 2),
        bloco(5, 3, 1, 6)
    ])).

test(pequeno3x3, nondet) :- blocos_adequados(jogo(3, 3, [
        bloco(7, 3, 4, 9),
        bloco(3, 4, 8, 3),
        bloco(7, 4, 2, 4),
        bloco(4, 4, 8, 5),
        bloco(8, 3, 6, 4),
        bloco(2, 2, 7, 3),
        bloco(8, 9, 1, 3),
        bloco(6, 6, 6, 9),
        bloco(7, 8, 5, 6)
    ])).

test(pequeno3x3, fail) :- blocos_adequados(jogo(3, 3, [
        bloco(7, 3, 4, 9),
        bloco(3, 4, 8, 3),
        bloco(7, 4, 2, 4),
        bloco(4, 4, 8, 5),
        bloco(8, 3, 6, 4),
        bloco(2, 2, 7, 3),
        bloco(8, 9, 1, 3),
        bloco(7, 8, 5, 6),
        bloco(6, 6, 6, 9)
    ])).

:- end_tests(blocos_adequados).

blocos_adequados(Jogo) :-
    jogo(L, C, _) = Jogo,
    T is L * C - 1,
    blocos_adequados(Jogo, T).

%% blocos_adequados(+Jogo, +T) is nondet
%
%  Verdadeiro se Jogo é uma estrutura jogo(L, C, Blocos), e todos os blocos de
%  Blocos com índices em Blocos menores ou iguais a T estão em posições adequadas.

blocos_adequados(Jogo, T) :-
    T >= 0,
    bloco_adequado(Jogo, T),
    T0 is T - 1,
    blocos_adequados(Jogo, T0).
blocos_adequados(_, -1).
    
%% bloco_adequado(?Jogo, ?P) is nondet
%
%  Verdadeiro se Jogo é uma estrutura jogo(L, C, Blocos), e o bloco na posição
%  P de Blocos está em uma posição adequada.

:- begin_tests(bloco_adequado).

test(bloco_adequado1x1, nondet) :- bloco_adequado(jogo(1, 1, [
        bloco(3, 6, 7, 5)
    ]), 0).

test(bloco_adequado2x2, all(X == [0, 1, 2, 3])) :- bloco_adequado(jogo(2, 2, [
        bloco(3, 4, 7, 9), bloco(6, 9, 5, 4),
        bloco(7, 6, 5, 2), bloco(5, 3, 1, 6)
    ]), X).

:- end_tests(bloco_adequado).

bloco_adequado(Jogo, P) :-
    ok_abaixo(Jogo, P),
    ok_acima(Jogo, P),
    ok_esquerda(Jogo, P),
    ok_direita(Jogo, P).

%% ok_abaixo(+Jogo, ?P) is nondet
%
%  Verdadeiro se o bloco na posição P está adequado em relação ao bloco abaixo dele,
%  ou se não existe bloco abaixo dele.

:- begin_tests(ok_abaixo).

test(ok_abaixo1x1) :- ok_abaixo(jogo(1, 1, [
        bloco(1, 1, 1, 1)
    ]), 0).

test(ok_abaixo1x2, [set(X == [0, 1])]) :- ok_abaixo(jogo(1, 2, [
        bloco(1, 2, 3, 4), bloco(5, 6, 7, 8)
    ]), X), label([X]).

test(ok_abaixo2x1, [set(X == [0, 1])]) :- ok_abaixo(jogo(2, 1, [
        bloco(1, 2, 3, 4),
        bloco(3, 5, 6, 7)
    ]), X), label([X]).

test(ok_abaixo2x1f, fail) :- ok_abaixo(jogo(2, 1, [
        bloco(1, 2, 3, 4),
        bloco(4, 5, 6, 7)
    ]), 0).

test(ok_abaixo2x2, [set(X == [0, 2, 3])]) :- ok_abaixo(jogo(2, 2, [
        bloco(1, 2, 3, 4), bloco(5, 6, 7, 8),
        bloco(3, 4, 5, 6), bloco(1, 2, 3, 4)
    ]), X), label([X]).

:- end_tests(ok_abaixo).

ok_abaixo(jogo(L, C, Blocos), P) :-
    Max #= L * C - 1, 
    P in 0..Max,
    PVizinho #= P + C,
    PVizinho #< L * C,
    nth0(P, Blocos, bloco(_, _, X, _)),
    nth0(PVizinho, Blocos, bloco(X, _, _, _)).
ok_abaixo(jogo(L, C, _), P) :-
    Max #= L * C - 1,
    P in 0..Max,
    PVizinho #= P + C,
    PVizinho #>= L * C.

%% ok_esquerda(+Jogo, ?P) is nondet
%
%  Verdadeiro se o bloco na posição P está adequado em relação ao bloco à sua esquerda,
%  ou se não existe bloco à sua esquerda.

:- begin_tests(ok_esquerda).

test(ok_esquerda1x1) :- ok_esquerda(jogo(1, 1, [
        bloco(1, 1, 1, 1)
    ]), 0).

test(ok_esquerda1x2, fail) :- ok_esquerda(jogo(1, 2, [
        bloco(1, 2, 3, 4), bloco(5, 6, 7, 8)
    ]), 1).

test(ok_esquerda2x1, [set(X == [0, 1])]) :- ok_esquerda(jogo(2, 1, [
        bloco(1, 2, 3, 4),
        bloco(3, 5, 6, 7)
    ]), X), label([X]).

test(ok_esquerda2x1f) :- ok_esquerda(jogo(2, 1, [
        bloco(1, 2, 3, 4),
        bloco(4, 5, 6, 7)
    ]), 0).

test(ok_esquerda2x2, [set(X == [0, 2, 3])]) :- ok_esquerda(jogo(2, 2, [
        bloco(1, 2, 3, 4), bloco(5, 6, 7, 8),
        bloco(3, 4, 5, 6), bloco(1, 2, 3, 4)
    ]), X), label([X]).

:- end_tests(ok_esquerda).

ok_esquerda(jogo(L, C, Blocos), P) :-
    Max #= L * C - 1,
    P in 0..Max,
    P mod C #> 0,
    PVizinho #= P - 1,
    nth0(P, Blocos, bloco(_, _, _, X)),
    nth0(PVizinho, Blocos, bloco(_, X, _, _)).
ok_esquerda(jogo(L, C, _), P) :-
    Max #= L * C - 1,
    P in 0..Max,
    P mod C #=< 0.

%% ok_acima(+Jogo, ?P) is nondet
%
%  Verdadeiro se o bloco na posição P está adequado em relação ao bloco acima dele,
%  ou se não existe bloco acima dele.

:- begin_tests(ok_acima).

test(ok_acima1x1) :- ok_acima(jogo(1, 1, [
        bloco(1, 1, 1, 1)
    ]), 0).

test(ok_acima1x2, [set(X == [0, 1])]) :- ok_acima(jogo(1, 2, [
        bloco(1, 2, 3, 4), bloco(5, 6, 7, 8)
    ]), X), label([X]).

test(ok_acima2x1, [set(X == [0, 1])]) :- ok_acima(jogo(2, 1, [
        bloco(1, 2, 3, 4),
        bloco(3, 5, 6, 7)
    ]), X), label([X]).

test(ok_acima2x1f, fail) :- ok_acima(jogo(2, 1, [
        bloco(1, 2, 3, 4),
        bloco(4, 5, 6, 7)
    ]), 1).

test(ok_acima2x2, [set(X == [0, 1, 2])]) :- ok_acima(jogo(2, 2, [
        bloco(1, 2, 3, 4), bloco(5, 6, 7, 8),
        bloco(3, 4, 5, 6), bloco(1, 2, 3, 4)
    ]), X), label([X]).

:- end_tests(ok_acima).

ok_acima(jogo(L, C, Blocos), P) :-
    Max #= L * C - 1, 
    P in 0..Max,
    PVizinho #= P - C,
    PVizinho #>= 0,
    nth0(P, Blocos, bloco(X, _, _, _)),
    nth0(PVizinho, Blocos, bloco(_, _, X, _)).
ok_acima(jogo(L, C, _), P) :-
    Max #= L * C - 1,
    P in 0..Max,
    PVizinho #= P - C,
    PVizinho #< 0.

%% ok_direita(+Jogo, ?P) is nondet
%
%  Verdadeiro se o bloco na posição P está adequado em relação ao bloco à sua direita,
%  ou se não existe bloco à sua direita.

:- begin_tests(ok_direita).

test(ok_direita1x1) :- ok_direita(jogo(1, 1, [
        bloco(1, 1, 1, 1)
    ]), 0).

test(ok_direita1x2, fail) :- ok_direita(jogo(1, 2, [
        bloco(1, 2, 3, 4), bloco(5, 6, 7, 8)
    ]), 0).

test(ok_direita2x1, [set(X == [0, 1])]) :- ok_direita(jogo(2, 1, [
        bloco(1, 2, 3, 4),
        bloco(3, 5, 6, 7)
    ]), X), label([X]).

test(ok_direita2x1f) :- ok_direita(jogo(2, 1, [
        bloco(1, 2, 3, 4),
        bloco(4, 5, 6, 7)
    ]), 0).

test(ok_direita2x2, [set(X == [1, 2, 3])]) :- ok_direita(jogo(2, 2, [
        bloco(1, 2, 3, 4), bloco(5, 6, 7, 8),
        bloco(3, 4, 5, 6), bloco(1, 2, 3, 4)
    ]), X), label([X]).

:- end_tests(ok_direita).

ok_direita(jogo(L, C, Blocos), P) :-
    Max #= L * C - 1,
    P in 0..Max,
    P mod C #< C - 1,
    PVizinho #= P + 1,
    nth0(P, Blocos, bloco(_, X, _, _)),
    nth0(PVizinho, Blocos, bloco(_, _, _, X)).
ok_direita(jogo(L, C, _), P) :-
    Max #= L * C - 1,
    P in 0..Max,
    P mod C #>= C - 1.
    
%% resolve(+Ordem, +Blocos, ?Solucao) is nondet
%
%  Verdadeiro se a lista de blocos Solucao é uma permutação da lista de blocos Blocos.
%  A permutação Solucao é montada na ordem dos índices listados na lista Ordem.
%
%  Este predicado só possui sentido se usado em regras associado com outras restrições.

resolve([I | IS], Blocos, Solucao) :-
    nth0(I, Solucao, Bloco),
    select(Bloco, Blocos, Blocos1),
    resolve(IS, Blocos1, Solucao).
resolve([], [], _).

:- begin_tests(resolve).

test(resolve1, [Solucao = [d, c, b, a]]) :-
    resolve([3, 2, 1, 0], [a, b, c, d], Solucao), !.

test(resolve1, [Solucao = [a, d, c, b]]) :-
    Solucao = [a, _, _, _],
    resolve([3, 2, 1, 0], [a, b, c, d], Solucao), !.

:- end_tests(resolve).

%% bfs(jogo(+L, +C, _), +S, ?Visitados) is nondet
%
%  Verdadeiro se Visitados é a lista dos vértices visitados em uma busca em largura a
%  partir de S em ordem. A busca é feita no grafo representado por Jogo. Os vizinhos de
%  um vértice são visitados na ordem definida pelo predicado vizinhos (acima, direita,
%  abaixo, esquerda).

:- begin_tests(bfs).

test(bfs1, [Visitados == [0, 1, 3, 2, 4, 6, 5, 7, 8], nondet]) :- 
    bfs(jogo(3,3,_), 0, Visitados). 

test(bfs2, [Visitados == [1, 2, 4, 0, 5, 7, 3, 8, 6], nondet]) :- 
    bfs(jogo(3,3,_), 1, Visitados).  

test(bfs3, [Visitados == [2, 5, 1, 8, 4, 0, 7, 3, 6], nondet]) :- 
    bfs(jogo(3,3,_), 2, Visitados). 

test(bfs4, [Visitados == [3, 0, 4, 6, 1, 5, 7, 2, 8], nondet]) :- 
    bfs(jogo(3,3,_), 3, Visitados). 

test(bfs5, [Visitados == [4, 1, 5, 7, 3, 2, 0, 8, 6], nondet]) :- 
    bfs(jogo(3,3,_), 4, Visitados). 

test(bfs6, [Visitados == [5, 2, 8, 4, 1, 7, 3, 0, 6], nondet]) :- 
    bfs(jogo(3,3,_), 5, Visitados). 

test(bfs7, [Visitados == [6, 3, 7, 0, 4, 8, 1, 5, 2], nondet]) :- 
    bfs(jogo(3,3,_), 6, Visitados). 

test(bfs8, [Visitados == [7, 4, 8, 6, 1, 5, 3, 2, 0], nondet]) :- 
    bfs(jogo(3,3,_), 7, Visitados). 

test(bfs9, [Visitados == [8, 5, 7, 2, 4, 6, 1, 3, 0], nondet]) :- 
    bfs(jogo(3,3,_), 8, Visitados).  

:- end_tests(bfs).

%%% BFS(G, S)
%%% 1   Visited = {s}
%%% 4   Q = [s]
%%% 6   Visited, Q = BFS_Step(G, Visited, Q)
%%% 7   return Visited

bfs(JogoFinal, S, Visitados) :-
    bfs_step(JogoFinal, [S], [S], Visitados0, _),
    reverse(Visitados0, Visitados).

%% BFS_Step(G, Visited, Queue)
%% 1    if Queue = []
%% 2        return Visited, []
%% 3    else
%% 4       U, Queue = Queue
%% 5       Visited, Q = BFS_VisitNeighbors(G.adj[u], Visited, Q)
%% 6       return BFS_Step(G, Visited, Q)

%% bfs_step(+JogoFinal, +Visited, +Queue, -NewVisited, -NewQueue) is nondet
%
%  Verdadeiro se o estado NewVisited-NewQueue é o resultado do processamento do vértice
%  na frente da fila Queue, e de seus vizinhos a partir do estado Visited-Queue, de acordo
%  com a estratégia de busca em largura.

bfs_step(_, Visited, [], Visited, []).
bfs_step(JogoFinal, Visited, [U | Queue], NewVisited, NewQueue) :-
    vizinhos(JogoFinal, U, UAdj),
    bfs_visit_neighbors(UAdj, Visited, Queue, Visited1, Queue1),
    bfs_step(JogoFinal, Visited1, Queue1, NewVisited, NewQueue).

%% BFS_VisitNeighbors(UAdj, Visited, Queue)
%% 1    if UAdj == []
%% 2        return Visited, Queue
%% 3    else
%% 4        v, UAdj = UAdj
%% 5        Visited, Queue = BFS_Visit(v, Visited, Queue)
%% 6        return BFS_VisitNeighbors(UAdj, Visited, Queue)

%% bfs_visit_neighbors(+UAdj, +Visited, +Queue, -NewVisited, -NewQueue) is nondet
%
%  Verdadeiro se o estado NewVisited-NewQueue é o resultado do processamento do primeiro
%  vértice da lista UAdj, a partir do estado Visited-Queue.

bfs_visit_neighbors([], Visited, Queue, Visited, Queue).
bfs_visit_neighbors([V | UAdj], Visited, Queue, NewVisited, NewQueue) :-
    bfs_visit(V, Visited, Queue, Visited1, Queue1),
    bfs_visit_neighbors(UAdj, Visited1, Queue1, NewVisited, NewQueue).

%% BFS_Visit(v, Visited, Queue)
%% 1    if not in visited
%% 2        return Visited U v, Queue U v
%% 3    else
%% 4        return Visited, Queue

%% bfs_visit(+V, +Visited, +Queue, -NewVisited, -NewQueue) is nondet
%
%  Verdadeiro se o estado NewVisited-NewQueue é o resultado da visitação do vértice V a
%  partir do estado Visited-Queue. Se o vértice já foi visitado, o estado não é alterado.
%  Se o vértice não foi visitado, os seus vizinhos são adicionados à fila e ele é marcado
%  como visitado.

bfs_visit(V, Visited, Queue, [V | Visited], NewQueue) :-
    nao_contem(Visited, V),
    append(Queue, [V], NewQueue).
bfs_visit(V, Visited, Queue, Visited, Queue) :-
    memberchk(V, Visited).

%% nao_contem(+L, ?X) is nondet
%
%  Verdadeiro se a lista L não contém o elemento X.

:- begin_tests(nao_contem).

test(nao_contem1, fail) :- nao_contem([1, 2, 3], 1).
test(nao_contem2) :- nao_contem([1, 2, 3], 4).
test(nao_contem3) :- nao_contem([], 1).

:- end_tests(nao_contem).

nao_contem([], _).
nao_contem([Y | XS], X) :-
    dif(X, Y),
    nao_contem(XS, X).

%% vizinhos(+Jogo, +P, ?Vizinhos) is nondet
%
%  Verdadeiro se Vizinhos é a lista dos indíces vizinhos de P em Jogo.
%  Os vizinhos devem estar listados em sentido horário a partir do vizinho
%  superior.

:- begin_tests(vizinhos).

test(vizinhos1x1, [nondet, Vizinhos == []]) :-
    vizinhos(jogo(1, 1, _), 0, Vizinhos).

test(vizinhos1x2, [nondet, Vizinhos == [1]]) :-
    vizinhos(jogo(1, 2, _), 0, Vizinhos).

test(vizinhos2x1, [nondet, Vizinhos == [1]]) :-
    vizinhos(jogo(2, 1, _), 0, Vizinhos).

test(vizinhos3x3tl, [nondet, Vizinhos == [1, 3]]) :-
    vizinhos(jogo(3, 3, _), 0, Vizinhos).

test(vizinhos3x3t, [nondet, Vizinhos == [2, 4, 0]]) :-
    vizinhos(jogo(3, 3, _), 1, Vizinhos).

test(vizinhos3x3tr, [nondet, Vizinhos == [5, 1]]) :-
    vizinhos(jogo(3, 3, _), 2, Vizinhos).

test(vizinhos3x3l, [nondet, Vizinhos == [0, 4, 6]]) :-
    vizinhos(jogo(3, 3, _), 3, Vizinhos).

test(vizinhos3x3m, [nondet, Vizinhos == [1, 5, 7, 3]]) :-
    vizinhos(jogo(3, 3, _), 4, Vizinhos).

test(vizinhos3x3r, [nondet, Vizinhos == [2, 8, 4]]) :-
    vizinhos(jogo(3, 3, _), 5, Vizinhos).

test(vizinhos3x3bl, [nondet, Vizinhos == [3, 7]]) :-
    vizinhos(jogo(3, 3, _), 6, Vizinhos).

test(vizinhos3x3b, [nondet, Vizinhos == [4, 8, 6]]) :-
    vizinhos(jogo(3, 3, _), 7, Vizinhos).

test(vizinhos3x3br, [nondet, Vizinhos == [5, 7]]) :-
    vizinhos(jogo(3, 3, _), 8, Vizinhos).

:- end_tests(vizinhos).

% quadro 1x1
vizinhos(jogo(1, 1, _), 0, []).

% quadro 1xN
vizinhos(jogo(1, N, _), 0, [1]) :- N > 1.
vizinhos(jogo(1, N, _), N1, [N2]) :-
    N > 1,
    N1 =:= N - 1,
    N2 is N1 - 1.
vizinhos(jogo(1, N, _), N1, [N2, N3]) :-
    N > 1,
    N1 > 0,
    N1 < N - 1,
    N2 is N1 + 1,
    N3 is N1 - 1.

% quadro Nx1
vizinhos(jogo(N, 1, _), 0, [1]) :- N > 1.
vizinhos(jogo(N, 1, _), N1, [N2]) :-
    N > 1,
    N1 =:= N - 1,
    N2 is N1 - 1.
vizinhos(jogo(N, 1, _), N1, [N2, N3]) :-
    N > 1,
    N1 > 0,
    N1 < N - 1,
    N2 is N1 + 1,
    N3 is N1 - 1.

% quadro NxM
% Canto superior esquerdo
vizinhos(jogo(L, C, _), 0, [1, C]) :- L > 1, C > 1.
% Lado superior
vizinhos(jogo(L, C, _), C1, [C2, C3, C4]) :-
    L > 1, C > 1,
    C1 > 0,
    C1 < C - 1,
    C2 is C1 + 1,
    C3 is C1 + C,
    C4 is C1 - 1.
% Canto superior direito
vizinhos(jogo(L, C, _), C1, [C2, C3]) :-
    L > 1, C > 1,
    C1 =:= C - 1,
    C2 is C1 + C,
    C3 is C1 - 1.
% Lado esquerdo
vizinhos(jogo(L, C, _), C1, [C2, C3, C4]) :-
    L > 1, C > 1,
    C1 mod C =:= 0,
    C1 > 0,
    C1 < L * C - C,
    C2 is C1 - C,
    C3 is C1 + 1,
    C4 is C1 + C.
% Meio
vizinhos(jogo(L, C, _), C1, [C2, C3, C4, C5]) :-
    L > 1, C > 1,
    C1 mod C > 0,
    C1 mod C < C - 1,
    C1 >= C,
    C1 < L * C - C,
    C2 is C1 - C,
    C3 is C1 + 1,
    C4 is C1 + C,
    C5 is C1 - 1.
% Lado direito
vizinhos(jogo(L, C, _), C1, [C2, C3, C4]) :-
    L > 1, C > 1,
    C1 mod C =:= C - 1,
    C1 < L * C - 1,
    C1 > C,
    C2 is C1 - C,
    C3 is C1 + C,
    C4 is C1 - 1.
% Canto inferior esquerdo
vizinhos(jogo(L, C, _), C1, [C2, C3]) :-
    L > 1, C > 1,
    C1 =:= L * C - C,
    C2 is C1 - C,
    C3 is C1 + 1.
% Lado inferior
vizinhos(jogo(L, C, _), C1, [C2, C3, C4]) :-
    L > 1, C > 1,
    C1 > L * C - C,
    C1 < L * C - 1,
    C2 is C1 - C,
    C3 is C1 + 1,
    C4 is C1 - 1.
% Canto inferior direito
vizinhos(jogo(L, C, _), C1, [C2, C3]) :-
    L > 1, C > 1,
    C1 =:= L * C - 1,
    C2 is C1 - C,
    C3 is C1 - 1.