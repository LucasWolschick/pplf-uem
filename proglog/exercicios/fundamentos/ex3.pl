pai(adao, abel).
pai(adao, caim).
pai(adao, sete).
pai(caim, enoque).
pai(enoque, irad).
pai(irad, meujael).
pai(meujael, metusael).
pai(metusael, lameque).
pai(lameque, jabal).
pai(lameque, jubal).
pai(lameque, tubalcaim).
pai(lameque, naama).
mae(eva, abel).
mae(eva, caim).
mae(eva, sete).
mae(ada, jabal).
mae(ada, jubal).
mae(zila, tubalcaim).
mae(zila, naama).
homem(sete).
homem(caim).
homem(jabal).
homem(jubal).
homem(tubalcaim).
mulher(naama).

% a
homem(X) :- pai(X).
% b
mulher(X) :- mae(X).
% c
irmaos(X, Y) :- pai(Z, X), pai(Z, Y).
irmaos(X, Y) :- mae(Z, X), mae(Z, Y).
% d
casados(X, Y) :- pai(X, Z), mae(Y, Z).
% e
avo(X, Y) :- pai(X, Z), pai(Z, Y).
% f
irma(X, Y) :- mulher(X), irmaos(X, Y).
% g
irmao(X, Y) :- homem(X), irmaos(X, Y).
% h
e_pai(X) :- pai(X, Z).
% i
e_mae(X) :- mae(X, Z).
% j
e_filho(X) :- pai(Z, X).
e_filho(X) :- mae(Z, X).
% k
ancestral(X, Y) :- pai(X, Y).
ancestral(X, Y) :- mae(X, Y).
ancestral(X, Y) :- ancestral(X, Z), ancestral(Z, Y).

