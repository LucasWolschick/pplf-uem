% Projete um predicado lista_soma(XS, A, YS) que é verdadeiro se a lista YS é a lista
% XS + A (cada elemento de XS somado com A). Exxemplo
% ?- lista_soma([1, 4, 23], -3, YS).
% YS = [-2, 1, 20].

:- use_module(library(clpfd)), use_module(library(plunit)).

%% lista_soma(?XS, ?A, ?YS) is nondet
%
%  Verdadeiro se YS é a lista XS com cada elemento somado em A.

:- begin_tests(lista_soma).

test(vazio) :- lista_soma([], _, []).
test(exemplo, YS == [-2, 1, 20]) :- lista_soma([1, 4, 23], -3, YS).

:- end_tests(lista_soma).

lista_soma([], _, []).
lista_soma([X | XS], A, [Y | YS]) :-
    Y #= X + A,
    lista_soma(XS, A, YS).