%% mini_sudoku(?A, ?B, ?C, ?D, ?E, ?F, ?G, ?H, ?I, ?J ?K, ?L, ?M, ?N, ?O, ?P) is nondet
%
% Verdadeiro se
%   A B | C D
%   E F | G H
%   ---------
%   I J | K L
%   M N | O P
% é uma solução para um Sudoku 4x4 válida.

num(1).
num(2).
num(3).
num(4).


quatro_dif(A, B, C, D) :-
    dif(A, B), dif(A, C), dif(A, D), dif(B, C), dif(B, D), dif(C, D).

mini_sudoku(A, B, C, D,
            E, F, G, H,
            I, J, K, L,
            M, N, O, P) :-
                num(A), num(B), num(C), num(D),
                num(E), num(F), num(G), num(H),
                num(I), num(J), num(K), num(L),
                num(M), num(N), num(O), num(P),

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
                quatro_dif(K, L, O, P).
