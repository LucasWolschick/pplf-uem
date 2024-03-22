% 14) Projete um predicado sub_lista(L, I, J, S) que é verdadeiro se S é uma sub lista
% de L com os elementos das posições de I a J (inclusive). Exemplo
% ?- sub_lista([a, b, c, d, e, f, g, h, i, k], 3, 7, S).
% S = [d, e, f, g, h].

:- use_module(library(plunit)), use_module(library(clpfd)).

%% sub_lista(?L, ?I, ?J, ?S) is nondet
%
%  Verdadeiro se S é uma sub lista de L com os elementos das posições de I a J
%  (inclusive).

sub_lista(L, I, J, S) :-
    length(Esq, I),
    LenMeio #= J - I + 1,
    length(S, LenMeio),
    append(Esq, S, EsqMeio),
    append(EsqMeio, _, L).