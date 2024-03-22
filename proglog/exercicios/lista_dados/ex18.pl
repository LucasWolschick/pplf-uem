% 18) Projete um predicado num_folhas(T, S) que é verdadeiro se S é o número de folhas
% da árvore binária T.

:- use_module(library(plunit)), use_module(library(clpfd)).
:- consult(ex17).

%% num_folhas(?T, ?S) is nondet
%
%  Verdadeiro se S é o número de folhas da árvore binária T.

:- begin_tests(num_folhas).

test(vazio) :- num_folhas(nil, 0).
test(um) :- num_folhas(t(0, nil, nil), 1).
test(dois) :- num_folhas(t(0, t(0, nil, nil), nil), 2).
test(tres) :- num_folhas(t(0, t(0, nil, nil), t(0, nil, nil)), 3).

:- end_tests(num_folhas).

num_folhas(nil, 0).
num_folhas(t(_, L, R), S) :-
    S #> 0,
    SL #>= 0,
    SR #>= 0,
    S #= 1 + SL + SR,
    num_folhas(L, SL),
    num_folhas(R, SR).