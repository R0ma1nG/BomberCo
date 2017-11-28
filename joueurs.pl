%%%%% Positionne les joueurs dans les coins du plateau
initJoueurs:-
	taillePlateau(TaillePlateau),
	nbJoueurs(NbJoueurs),
	(joueursSav(_,_,_) -> retractall(joueursSav(_,_,_)); true),
	(NbJoueurs < 5,NbJoueurs >1),

	Position is TaillePlateau +1, assert(joueursSav(0,Position,-1)),
	Position2 is TaillePlateau*TaillePlateau-TaillePlateau-2, assert(joueursSav(1,Position2,-1)),
	(NbJoueurs < 3 ; (Position3 is TaillePlateau*2-2), assert(joueursSav(2,Position3,-1))),
	(NbJoueurs < 4 ; (Position4 is TaillePlateau*TaillePlateau-TaillePlateau*2+1, assert(joueursSav(3,Position4,-1)))).

actualiserJoueur(IdJoueur,NewPosJoueur):-
	retract(joueursSav(IdJoueur,_,StatusPrec)),assert(joueursSav(IdJoueur,NewPosJoueur,StatusPrec)).

joueurSuivant(IdJoueur,IdJoueurSuivant):-
	nbJoueurs(NbJoueurs),
	Id is IdJoueur + 1,
	IdJoueurSuivant is mod(Id,NbJoueurs).

plusieursEnVie:-joueursSav(X,_,-1),joueursSav(Y,_,-1),Y\==X.

exploserBombes:-
	findall(IdJoueur,joueursSav(IdJoueur,_,_),ListeId),
	% TODO : Oh c'est moche!!
	exploserBombes(ListeId).

exploserBombes([]).
exploserBombes([Id|Ids]):-
	taillePlateau(TaillePlateau),
	plateauSav(Plateau),
	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ-1), bombes(PositionB, 0), write(PositionJ), write(" explose\n"), tuer(Id)) ; true),
	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ-2), PositionE is PositionB-1, nth0(PositionE, Plateau, 1), bombes(PositionB, 0), write(PositionJ), write(" explose\n"),tuer(Id)) ; true),
	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ+1), bombes(PositionB, 0), write(PositionJ), write(" explose\n"),tuer(Id)) ; true),
	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ+2), PositionE is PositionB+1, nth0(PositionE, Plateau, 1), bombes(PositionB, 0), write(PositionJ), write(" explose\n"),tuer(Id)) ; true),
	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ-TaillePlateau), bombes(PositionB, 0), write(PositionJ), write(" explose\n"),tuer(Id)) ; true),
	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ-2*TaillePlateau), PositionE is PositionB-TaillePlateau, nth0(PositionE, Plateau, 1), bombes(PositionB, 0), write(PositionJ), write(" explose\n"),tuer(Id)) ; true),
	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ+TaillePlateau), bombes(PositionB, 0), write(PositionJ), write(" explose\n"),tuer(Id)) ; true),
	((joueursSav(Id, PositionJ, Status), PositionB is (PositionJ+2*TaillePlateau), PositionE is PositionB+TaillePlateau, nth0(PositionE, Plateau, 1), bombes(PositionB, 0), write(PositionJ), write(" explose\n"),tuer(Id)) ; true),
	exploserBombes(Ids).

tuer(IdJoueur):-
	retract(joueursSav(IdJoueur, Position, _)),
	assert(joueursSav(IdJoueur, Position, 0)).
