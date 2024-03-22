% 16) Projete um predicado fatores_primo(N, F) que é verdadeiro se F é uma lista com os
% fatores primos de N.

:- use_module(library(clpfd)), use_module(library(plunit)).

%% nao_divisivel(?N, ?M)
%
%  Verdadeiro se N não é divisível por nenhum número em 2..M.
nao_divisivel(_, 1).
nao_divisivel(N, M) :-
    N mod M #\= 0,
    M0 #= M - 1,
    nao_divisivel(N, M0).

%% primo(?N) is nondet
%
%  Verdadeiro se N é primo.
primo(N) :-
    N0 #= N - 1,
    nao_divisivel(N, N0).

% (100, 2, [])
% -> (50, 2, [2])
% -> (25, 2, [2, 2])
% -> (25, 3, [2, 2])
% -> ...
% -> (25, 5, [2, 2])
% -> (5, 5, [2, 2, 5])
% -> (1, 5, [2, 2, 5, 5]).