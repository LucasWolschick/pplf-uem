% 4) Projete um predicado soma_zero(L, A, B) que é verdadeiro A e B são elementos
% distintos da lista L e a soma de A e B é zero.

:- use_module(library(plunit)).
:- use_module(library(clpfd)).

%% soma_zero(?L, ?A, ?B) is nondet.
%
%  Verdadeiro se A e B pertencem à L, são distintos e se sua soma são 0.

:- begin_tests(soma_zero).

test(vazio, fail) :- soma_zero([], _, _).
test(um, fail) :- soma_zero([1], _, _).
test(doisIguais, fail) :- soma_zero([0, 0], _, _).
test(naoOpostos, fail) :- soma_zero([0, 1, 2], _, _).
test(opostos, nondet) :- soma_zero([-1, 0, 1, 2], -1, 1).
test(opostos, nondet) :- soma_zero([-1, 0, 1, 2], 1, -1).

:- end_tests(soma_zero).

soma_zero(L, A, B) :-
    member(A, L),
    member(B, L),
    dif(A, B),
    A + B #= 0.