% 8) Projete um predicado maximo(XS, M) que é verdadeiro se M é o valor máximo da lista
% XS.

:- use_module(library(clpfd)), use_module(library(plunit)).

%% maximo(?XS, ?M) is nondet
%
%  Verdadeiro se M é o maior valor da lista XS.

:- begin_tests(maximo).

test(maximo0, fail) :- maximo([], _).
test(maximo1, nondet) :- maximo([1], 1).
test(maximo2, nondet) :- maximo([1, 2], 2).
test(maximo3, nondet) :- maximo([2, 1], 2).
test(maximo4, nondet) :- maximo([1, 3, 2], 3).

:- end_tests(maximo).

maximo([X], X).
maximo([X | XS], X) :-
    dif(XS, []),
    maximo(XS, N),
    X #> N.
maximo([X | XS], N) :-
    dif(XS, []),
    maximo(XS, N),
    N #>= X.