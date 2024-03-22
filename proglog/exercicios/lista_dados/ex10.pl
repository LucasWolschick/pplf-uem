% 10) Projete um predicado sequencia(L, N) que é verdadeiro se L é uma lista com os
% primeiros N números naturais em sequência.

:- use_module(library(clpfd)), use_module(library(plunit)).

%% sequencia(?L, ?N) is semidet
%
%  Verdadeiro se L é uma lista com os N primeiros números naturais em sequência.

:- begin_tests(sequencia).

test(sequenciaZero, nondet) :- sequencia([0], 0).
test(sequenciaUm, nondet) :- sequencia([0, 1], 1).
test(sequenciaDois, nondet) :- sequencia([0, 1, 2], 2).
test(sequenciaTres, [nondet, X == [0, 1, 2, 3, 4]]) :- sequencia(X, 4).
test(sequenciaDescobre, [nondet, X == 5]) :- sequencia([0, 1, 2, 3, 4, 5], X).

:- end_tests(sequencia).

sequencia([0], 0).
sequencia(L, X) :-
    X #> 0,
    X0 #= X - 1,
    append(LS, [X], L),
    sequencia(LS, X0).