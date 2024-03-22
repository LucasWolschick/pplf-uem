% Projete um predicado mergesort(A, S) que é verdadeiro se S é A ordenada. Implemente
% a ordenação utilizando o algoritmo de ordenação mergesort.

:- use_module(library(clpfd)).
:- use_module(library(plunit)).

%% merge(?L, ?R, ?T) is nondet
%
%  Verdadeiro se T é uma lista que contém os elementos de
%  L e R em ordem não decrescente.
%  Assume que L e R são ordenadas.
merge([], [], []).
merge([], R, R).
merge(L, [], L).
merge([L | LS], [R | RS], [L | TS]) :-
    L #=< R,
    merge(LS, [R | RS], TS).
merge([L | LS], [R | RS], [R | TS]) :-
    L #> R,
    merge([L | LS], RS, TS).

%% mergesort(?A, ?S) is nondet
%
%  Verdadeiro se S é a lista A ordenada em ordem não decrescente.
mergesort([], []).
mergesort([X], [X]).
mergesort(A, S) :-
    length(A, Len),
    Len #> 1,
    LenL #= Len // 2,
    length(L, LenL),
    append(L, R, A),
    mergesort(L, SL),
    mergesort(R, SR),
    merge(SL, SR, S).
