homem(albert).
homem(edward).

mulher(alice).
mulher(victoria).

pais(edward, victoria, albert).
pais(alice, victoria, albert).

irma_de(X, Y) :-
	mulher(X),
	pais(X, M, F),
	pais(Y, M, F).
