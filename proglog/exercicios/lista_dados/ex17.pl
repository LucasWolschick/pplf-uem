% 17) Projete um predicado arvore(T) que é verdadeiro se T é uma árvore binária (de
% acordo com a definição das notas de aula).

:- use_module(library(plunit)).

%% arvore(?T) is nondet
%
%  Verdadeiro se T é uma árvore binária.

:- begin_tests(arvore).

test(nil) :- arvore(nil).
test(umNo) :- arvore(t(0, nil, nil)).
test(doisNos) :- arvore(t(1, t(0, nil, nil), nil)).

:- end_tests(arvore).

arvore(nil).
arvore(t(_, L, R)) :-
    arvore(L),
    arvore(R).