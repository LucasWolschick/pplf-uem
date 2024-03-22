% Projete um predicado removido_em(L, X, I, R) que é verdadeiro se R é a lista L com o
% elemento X removido da posição I.
%   AKA: nth0/4.

:- use_module(library(clpfd)), use_module(library(plunit)).

%% removido_em(?L, ?X, ?I, ?R) is semidet
%
%  Verdadeiro se R é a lista L com o elemento X removido da posição I.

:- begin_tests(removido_em).

test(removido_em_contem) :- removido_em([1, 2, 3], 1, 0, [2, 3]).
test(removido_em_contem, fail) :- removido_em([1, 2, 3], 1, 1, [1, 2, 3]).

:- end_tests(removido_em).

removido_em(L, X, I, R) :-
    length(Esq, I),
    append(Esq, [X | Dir], L),
    append(Esq, Dir, R).