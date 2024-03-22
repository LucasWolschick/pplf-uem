mulher(vincent).
mulher(mia).
homem(jules).
pessoa(X) :- homem(X); mulher(X).
ama(X, Y) :- pai(X, Y).
pai(Y, Z) :- homem(Y), filho(Z, Y).
pai(Y, Z) :- homem(Y), filha(Z, Y).

% n de fatos = 3
% n de regras = 4
% n de clausulas = 7
% n de predicados = 7

% regra pessoa:
% cabeça : pessoa(X)
% metas : homem(X) ou mulher(X)

% regra ama:
% cabeça : ama(X,Y)
% metas: pai(X,Y)

% regra pai(Y,Z) (1):
% cabeça : pai(Y,Z)
% metas : homem(Y) e filho(Z, Y)

% regra pai(Y,Z) (1):
% cabeça : pai(Y,Z)
% metas : homem(Y) e filha(Z, Y)
