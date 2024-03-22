% um número é primo se seus divisores são 1 e ele mesmo, apenas.

:- use_module(library(clpfd)).

primo(N) :-
    N0 #= N - 1,
    coprimo(N, N0).

%% coprimo(+X, +Y) is nondet
%
%  Verdadeiro se X não é divisor de nenhum número
%  entre 2 e Y-1.

coprimo(_, 1).
coprimo(X, Y) :-
    Y #> 1,
    Y #< X,
    X mod Y #\= 0,
    Y0 #= Y - 1,
    coprimo(X, Y0).