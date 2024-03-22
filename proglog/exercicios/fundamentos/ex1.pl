% a. bread = bread
% unifica

% b. 'Bread' = bread
% não unifica, 'Bread' =/= bread.

% c. 'bread' = bread
% unifica.

% d. Bread = bread
% unifica, Bread = bread.

% e. bread = sausage
% não unifica.

% f. food(bread) = bread
% não unifica.

% g. food(bread) = X
% unifica, X = food(bread).

% h. food(X) = food(bread)
% unifica, X = bread.

% i. food(bread, X) = food(Y, sausage)
% unifica, X = sausage, Y = bread.

% j. food(bread, X, beer) = food(Y, sausage, X)
% não unifica.

% k. food(bread, X, beer) = food(Y, kahuna_burger)
% não unifica.

% l. food(X) = X
% não unifica (definição recursiva infinita) 

% m. meal(food(bread), drink(beer)) = meal(X,Y)
% unifica, X = food(bread), Y = drink(beer).

% n. meal(food(bread), X) = meal(X,drink(beer))
% não unifica.
