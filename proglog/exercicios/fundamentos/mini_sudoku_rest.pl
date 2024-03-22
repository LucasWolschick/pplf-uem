:- use_module(library(clpfd)).

%% mini_sudoku(?A, ?B, ?C, ?D, ?E, ?F, ?G, ?H, ?I, ?J ?K, ?L, ?M, ?N, ?O, ?P) is nondet
%
% Verdadeiro se
%   A B | C D
%   E F | G H
%   ---------
%   I J | K L
%   M N | O P
% é uma solução para um Sudoku 4x4 válida.

quatro_dif(A, B, C, D) :-
    all_different([A, B, C, D]).

mini_sudoku(A, B, C, D,
            E, F, G, H,
            I, J, K, L,
            M, N, O, P) :-
                [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P] ins 1..4,

                quatro_dif(A, B, C, D),
                quatro_dif(E, F, G, H),
                quatro_dif(I, J, K, L),
                quatro_dif(M, N, O, P),

                quatro_dif(A, E, I, M),
                quatro_dif(B, F, J, N),
                quatro_dif(C, G, K, O),
                quatro_dif(D, H, L, P),

                quatro_dif(A, B, E, F),
                quatro_dif(C, D, G, H),
                quatro_dif(I, J, M, N),
                quatro_dif(K, L, O, P),

                label([A, B, C, D,
                       E, F, G, H,
                       I, J, K, L,
                       M, N, O, P]).