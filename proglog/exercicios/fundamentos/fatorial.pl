:- use_module(library(clpfd)).
:- use_module(library(plunit)).

%% fatorial(?N, ?F) is nondet 
%
% Verdadeiro se F é o fatorial de N, N!.

:- begin_tests(fatorial).

test(fatorial0, nondet) :- fatorial(0, 1).
test(fatorial1, nondet) :- fatorial(1, 1).
test(fatorial10, nondet) :- fatorial(10, 3628800).
test(fatorial2, [nondet, fail]) :- fatorial(2, 3).
test(fatorial5, [nondet, F == 120]) :- fatorial(5, F).
test(fatorial5, [nondet, N == 5]) :- fatorial(N, 120).

:- end_tests(fatorial).

fatorial(0, 1).
fatorial(N, F) :-
    N #> 0,
    N0 #= N - 1,
    F #= N * F0,
    fatorial(N0, F0).
