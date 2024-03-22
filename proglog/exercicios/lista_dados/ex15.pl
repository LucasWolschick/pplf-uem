% 15) Projete um predicado rotacionada(L, N, R) que é verdadeiro se R contém os
% elementos de L rotacionados N posições à esquerda. Exemplo
% ?- rotacionada([a, b, c, d, e, f, g, h], 3, R).
% R = [d, e, f, g, h, a, b, c]

:- use_module(library(clpfd)), use_module(library(plunit)).

%% rotaciona(?L, ?N, ?R) is nondet
%
%  Verdadeiro se R contém os elementos de L rotacionados N posições à esquerda.

rotaciona(L, N, R) :-
    length(Esq, N),
    append(Esq, Dir, L),
    append(Dir, Esq, R).