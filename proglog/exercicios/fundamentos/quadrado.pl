:- use_module(library(clpfd)).
:- use_module(library(plunit)).

%% quadrado(?X, ?Y) is semidet
%
% Verdadeiro se Y é o quadrado de X.

:- begin_tests(quadrado).

test(quadrado4) :- quadrado(4, 16).
test(quadrado4, fail) :- quadrado(4, 20).
test(quadrado3, Q == 9) :- quadrado(3, Q).

:- end_tests(quadrado).

quadrado(X, Y) :-
    Y #= X * X,
    label([X, Y]).
