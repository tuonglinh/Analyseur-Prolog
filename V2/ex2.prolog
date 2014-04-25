/* chargement des fichiers */
:- consult('adj.prolog').
:- consult('adverb.prolog').
:- consult('conjc.prolog').
:- consult('det.prolog').
:- consult('noun.prolog').
:- consult('prep.prolog').
:- consult('pronoun.prolog').
:- consult('verb.prolog').
:- consult('fait_maison.prolog').

nom(X, Y) --> [Mot], 
			  {noun(Mot, _, MotCanonique, _), Y =.. [MotCanonique, X]}.

adjectif(X, Y) --> [Mot], 
				   {adj(Mot, _, MotCanonique, _), Y =.. [MotCanonique, X]}.

pronRelatif(X) --> [X], 
				   {p_relatif(X, _, _, _)}.

conjCoord(X) --> [X],
			 	 {conjc(X, _, _, _)}.

adverbe(X, Y) --> [Mot], 
 				  {adverb(Mot, _, MotCanonique, _), Y =.. [MotCanonique, X]}.

aux(X) --> [X], 
		   {verb(X, _, 'être', _)}.

verbe(Z, X, Rep3) --> [Mot], 
					  {verb(Mot, _, MotCanonique, _), Rep3 =.. [MotCanonique, Z, X]}.


nom_propre(X) --> [jean].


determinant(X, Rep1, Rep2, existe(X, Rep1, Rep2)) --> [Mot], 
													 {det(Mot, _, _, _)}.




/* Grammaire */
phrase(Rep) --> gn(X, Rep1, Rep), gv(X, Rep1).


gn(X, _, _) --> nom_propre(X).
gn(X, Rep1, Rep) -->	determinant(X, Rep2, Rep1, Rep),
						nom_adj(X, Rep3),
						relative(X, Rep3, Rep2).
gn(et(X, Y), Rep1, Rep) --> nom_propre(X), 
	  	 		     conjCoord(Conj),
	  	 		     gn(Y, Rep1, Rep).
gn(et(X, Y), Rep1, Rep) --> determinant(X, Rep2, Rep1, Rep4),
					 nom_adj(X, Rep3),
					 relative(X, Rep3, Rep2),
	  	 		     conjCoord(Conj),
	  	 		     gn(Y, Rep4, Rep).


nom_adj(X, Rep) --> nom(X, Rep).
nom_adj(X, et(Rep1, Rep2, Rep3)) --> adjectifs(X, Rep2, Rep3), 
								     nom(X, Rep1).
nom_adj(X, et(Rep1, Rep2, Rep3)) --> nom(X, Rep1), 
									 adjectifs(X, Rep2, Rep3).
nom_adj(X, et(Rep1, Rep2, Rep3, Rep4, Rep5)) --> adjectifs(X, Rep2, Rep4), 
												 nom(X, Rep1), 
												 adjectifs(X, Rep3, Rep5).

/* J'ai un peu plus réfléchi,
 * pour éviter que Kevin fasse le petit chinois 
 * Avec cette récursivité, on met autant d'adjectifs qu'on veut
 * mais on a pas d'arbre vide qui se crée
 */
adjectifs(X, Rep1, _) --> adjectif(X, Rep1).
adjectifs(X, Rep1, Rep2) --> adjectif(X, Rep1), 
							 adjectifs(X, Rep2, Rep3).
adjectifs(X, Rep1, Rep2) --> adjectif(X, Rep1), 
							 conjCoord(Conj), 
							 adjectifs(X, Rep2, Rep3).


relative(X, Rep, Rep) --> [].
relative(X, Rep1, et(Rep1, Rep2)) -->	pronRelatif(Pr),
										gn(Z, Rep3, Rep2),
										gv(Z, Rep3).
relative(X, Rep1, et(Rep1, Rep2)) -->	pronRelatif(Pr),
										aux(Aux),
										complement(X, Rep2, Rep2).


gv(X, Rep) -->	verbe(X, Y, Rep1),
				gn(Y, Rep1, Rep).
gv(X, Rep) -->	aux(Aux),
				complement(X, Rep1, Rep).

complement(X, Rep, Rep) -->	adverbe(X, Rep).
complement(X, Rep, Rep) -->	adjectifs(X, Rep, Rep).
complement(X, Rep, Rep) -->	determinant(X, _, _, _), nom(X, Rep).
