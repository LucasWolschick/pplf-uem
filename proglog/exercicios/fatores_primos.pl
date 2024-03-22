% 19) Projete um predicado fatores_primo(N, F) que é verdadeiro se F é uma lista com os
% fatores primos de N.
%
% ?- fatores_primos(315, F).
% F = [3, 3, 5, 7]

:- use_module(library(clpfd)), use_module(library(plunit)).

%% fatores_primos(?F, +N) is nondet
%
%  Verdadeiro se F é uma lista com os fatores primos do natural N, se F está em ordem
%  não-decrescente e seus elementos são todos positivos.

:- begin_tests(fatores_primos).

test(fatores_primos0, nondet) :- fatores_primos([], 0).
test(fatores_primos1, [nondet, X == []]) :- fatores_primos(X, 1).
test(fatores_primos15, nondet) :- fatores_primos([3, 5], 15).
test(fatores_primos315, [nondet, X == [3, 3, 5, 7]]) :- fatores_primos(X, 315).

:- end_tests(fatores_primos).

fatores_primos([], N) :- N < 2.
fatores_primos(F, N) :-
    N >= 2,
    fatores_primos(N, R, [], 2),
    reverse(F, R).

%% fatores_primos(+N, ?F, +AccF, +Fator)
%
%  Verdadeiro se ??????????????????????????????????

fatores_primos(1, F, F, _).

fatores_primos(N, F, AccF, Fator) :-
    N > 1,
    N mod Fator =:= 0,
    K is N // Fator,
    fatores_primos(K, F, [Fator | AccF], Fator).

fatores_primos(N, F, AccF, Fator) :-
    N > 1,
    N mod Fator =\= 0,
    Fator0 is Fator + 1,
    fatores_primos(N, F, AccF, Fator0).