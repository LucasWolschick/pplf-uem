% 5) Projete um predicado palindromo(L) que é verdadeiro se a lista L é verdadeiro.
% Dica: projete um predicado auxiliar invertida(A, B) que é verdadeiro se a A é a
% lista B invertida.

:- use_module(library(plunit)).

%% palindromo(?L) is nondet
%
%  Verdadeiro se L é uma lista e L é palíndromo, isto é, se
%  o inverso de L é igual a L.

:- begin_tests(palindromo).

test(vazia, nondet) :- palindromo([]).
test(umElem, nondet) :- palindromo([_]).
test(doisElem, nondet) :- palindromo([X, X]).
test(doisElemDif, fail) :- palindromo([1, 2]).
test(tresElem, nondet) :- palindromo([X, _, X]).
test(tresElemDif, fail) :- palindromo([1, 2, 3]).

:- end_tests(palindromo).

palindromo([]).
palindromo([_]).
palindromo(L) :-
    append([X | Meio], [X], L),
    palindromo(Meio).