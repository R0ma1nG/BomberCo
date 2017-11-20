%%%% Artificial intelligence: choose in a Board the Move to play for Player (_)
%%%% This AI plays more or less randomly according to the version and does not care who is playing:
:- dynamic index/2.

initIndex(TaillePlateau) :-
    index(1,-TaillePlateau), %Haut
    index(2, TaillePlateau), %Bas
    index(3,1),              %Droite
    index(4,-1),             %Gauche
    index(5,0),              %PasBouger
    index(6,0).              %Bombe

posSafe(Pos, Board, TaillePlateau) :-
    (nth0(Pos+1, Board, Case), not(Case==2)),
    (nth0(Pos-1, Board, Case), not(Case==2)),
    (nth0(Pos+TaillePlateau, Board, Case), not(Case==2)),
    (nth0(Pos-TaillePlateau, Board, Case), not(Case==2)),
    ((nth0(Pos+1, Board, Case), Case==1); (nth0(Pos+2, Board, Case), not(Case==2))),
    ((nth0(Pos-1, Board, Case), Case==1); (nth0(Pos-2, Board, Case), not(Case==2))),
    ((nth0(Pos+TaillePlateau, Board, Case), Case==1); (nth0(Pos+TaillePlateau, Board, Case), not(Case==2))),
    ((nth0(Pos-TaillePlateau, Board, Case), Case==1); (nth0(Pos-TaillePlateau, Board, Case), not(Case==2))).

posAdjacentesPossibles(Pos, Board, TaillePlateau, )

posAdjacentesSafe([], posSafes). % condition de sortie : on a teste toutes les positions adjacentes possibles
testPosAdjacentes([X|ListeIndex], PosSafes) :- testPosAdjacentes(ListeIndex, Liste),posSafe(a,b,c), append(PosSafes, [X]). % la position adjacente est safe
testPosAdjacentes([X|ListeIndex], PosSafes) :- testPosAdjacentes(ListeIndex,PosSafes). % la position adjacente n'est pas safe



% iav1 : fait tout de maniere random
ia(Board, PosIndex, NewPosIndex, iav1) :- repeat, Move is random(7), index(Move, I), NewPosIndex is PosIndex+I, nth0(NewPosIndex, Board, Elem), Elem==0, !.

% iav2 : detecte et evite les zones de danger des bombes et bouge de maniere random tant qu'elle n'est pas sortie
ia(Board, PosIndex, NewPosIndex, TaillePlateau, iav2) :-
    repeat, (posSafe(PosIndex, Board, TaillePlateau) ->
            repeat, Move is random(7),index(Move, I), NewPosIndex is PosIndex+I, posSafe(NewPosIndex, Board, TaillePlateau);
            Move is random(5),index(Move, I), NewPosIndex is PosIndex+I),
    nth0(NewPosIndex, Board, Elem), Elem==0, !.

% iav3 : detecte et evite les zones de danger et cherche si un
% deplacement peut la mettre en securite
ia(Board, PosIndex, NewPosIndex, TaillePlateau, iav3) :-
    repeat, (posSafe(PosIndex, Board, TaillePlateau) ->
            repeat, Move is random(7),index(Move, I), NewPosIndex is PosIndex+I, posSafe(NewPosIndex, Board, TaillePlateau);
            Move is random(5),index(Move, I), NewPosIndex is PosIndex+I), testPosAdjacentes(PosAdjacentesPossibles, PosAdjacentesSafes),
    nth0(NewPosIndex, Board, Elem), Elem==0, !.

