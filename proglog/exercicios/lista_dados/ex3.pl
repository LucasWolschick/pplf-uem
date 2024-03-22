% 3) Uma lista é dobrada se ele é constituída de dois blocos consecutivos de
% elementos iguais. Projete um predicado dobrada(L) que é verdadeiro se L é
% uma lista dobrada

:- use_module(library(plunit)).
:- use_module(library(clpfd)).

%% dobrada(?L) is nondet
%
%  Verdadeiro se L é uma lista dobrada, onde a primeira metade
%  de L é igual à segunda metade de L.

:- begin_tests(dobrada).

test(dobradaVazia, nondet) :- dobrada([]).
test(dobrada1, [fail, nondet]) :- dobrada([1]).
test(dobrada2, nondet) :- dobrada([1, 1]).
test(dobrada4, nondet) :- dobrada([1, 2, 1, 2]).

:- end_tests(dobrada).

dobrada([]).

dobrada([X | XS]) :-
    L = [X | XS],
    length(L, N),
    N2 * 2 #= N,
    nth0(N2, L, X, R),
    nth0(0, R, X, L2),
    dobrada(L2).
