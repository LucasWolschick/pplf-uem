% 9) Projete um predicado parse(L, P) que é verdadeiro se L é uma lista com (na
% mesma ordem).

:- use_module(library(clpfd)), use_module(library(plunit)).

%% pares(?L, ?P) is nondet
%
%  Verdadeiro se P contém apenas os números pares da lista L, na
%  mesma ordem em que aparecem.

:- begin_tests(pares).

test(paresVazio, nondet) :- pares([], []).
test(paresUm, nondet) :- pares([0], [0]).
test(paresUm, nondet) :- pares([1], []).
test(pares, nondet) :- pares([1, 2, 3, 4], [2, 4]).

:- end_tests(pares).

pares([], []).
pares([L | LS], [L | PS]) :-
    L #= 2 * _,
    pares(LS, PS).
pares([L | LS], PS) :-
    L #= 2 * _ + 1,
    pares(LS, PS).