:- use_module(library(clpfd)).

send_more_money(S, E, N, D, M, O, R, Y) :-
    all_distinct([S, E, N, D, M, O, R, Y]),
    [S, E, N, D, O, R, Y] ins 0..9,
    M in 1..9,

    S * 1000 + E * 100 + N * 10 + D
    +
    M * 1000 + O * 100 + R * 10 + E
    #=
    M * 10000 + O * 1000 + N * 100 + E * 10 + Y,

    label([S, E, N, D, M, O, R, Y]).
    
