% 7) Projete um predicado meio(L, X) que é verdadeiro se X é o elemento do meio da
% lista L.

:- use_module(library(clpfd)).
:- use_module(library(plunit)).

%% meio(?L, ?X) is nondet
%
%  Verdadeiro se X é o elemento na posição central da lista L.
%  A lista só possui uma posição central se seu comprimento é ímpar.

meio(L, X) :-
    Len #= 2 * K + 1,
    length(L, Len),
    nth0(K, L, X).