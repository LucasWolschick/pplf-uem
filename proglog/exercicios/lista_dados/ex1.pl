% 1) Projete um predicado ultimo(L, X) que é verdadeiro se X é o último elemento da lista L.

:- use_module(library(plunit)).

%% ultimo(?L, ?X) is nondet
%
%  Verdadeiro se X é o último elemento da lista L.

:- begin_tests(ultimo).

test(ultimoVazia, fail) :- ultimo([], _).
test(ultimo1) :- ultimo([1], 1).
test(ultimo2) :- ultimo([1, 2], 2).
test(ultimo3, X == 4) :- ultimo([1, 2, 3, 4], X).

:- end_tests(ultimo).

ultimo([X], X).

ultimo([_ | XS], X) :-
    dif(XS, []),
    ultimo(XS, X).
