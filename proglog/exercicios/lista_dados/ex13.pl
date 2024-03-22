% 13) Projete um predicado inserido_em(L, X, I, R) que é verdadeiro se R é a lista L com
% o elemento X inserido da posição I.

:- consult(ex12).

inserido_em(L, X, I, R) :-
    removido_em(R, X, I, L).