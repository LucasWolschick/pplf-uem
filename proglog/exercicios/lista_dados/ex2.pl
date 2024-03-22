% Projete um predicado duplicada(L, D) que é verdadeiro se D tem os elementos de L
% duplicados. Exemplo:
% ?- duplicada([a, b, c, c, d], D).
% D = [a, a, b, b, c, c, c, c, d, d].

:- use_module(library(plunit)).

%% duplicada(?L, ?D) is nondet
%
%  Verdadeiro se a lista D é a lista L,
%  onde cada elemento ocorre duas vezes.

:- begin_tests(duplicada).

test(duplicadaVazio) :- duplicada([], []).
test(duplicada1) :- duplicada([1], [1, 1]).
test(duplicada2) :- duplicada([1, 2], [1, 1, 2, 2]).

:- end_tests(duplicada).

duplicada([], []).

duplicada([X | XS], [X, X | YS]) :-
    duplicada(XS, YS).