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

nom(X, Y) --> [Mot], {noun(Mot, _, MotCanonique, _), Y =.. [MotCanonique, X]}.
adjectif(X, Y) --> [Mot], {adj(Mot, _, MotCanonique, _), Y =.. [MotCanonique, X]}.
pronRelatif(X) --> [X], {p_relatif(X, _, _, _)}.
nom_propre(X) --> [jean].
aux(X) --> [X], {verb(X, _, 'être', _)}.

verbe(Z, X, Rep3) --> [Z], {verb(Z, _, MotCanonique, _), Y =.. [MotCanonique, X, Rep3]}

adverbe(X, Y) --> [Mot], {adverb(Mot, _, _, _), Y =.. [Mot, X]}.

determinant(X,Rep1, Rep2, existe(X, Rep1, Rep2)) --> [un].


phrase(Rep) --> gn(X, Rep1, Rep), gv(X, Rep1).

gn(X, Rep1, Rep -->	determinant(X, Rep2, Rep1, Rep),
					nom_adj(X, Rep3),
					relative(X, Rep3, Rep2).

gn(X, Rep, Rep) --> nom_propre(X).

nom_adj(X, Rep) --> nom(X, Rep).

nom_adj(X, et(Rep1, Rep2)) --> adjectif(X, Rep2), nom(X, Rep1).
relative(X, Rep1, et(Rep1, Rep2)) -->	pronRelatif(que),
										gn(Z, Rep3, Rep2),
										verbe(Z, X, Rep3).
relative(X, Rep1, et(Rep1, Rep2)) -->	pronRelatif(Pr),
										aux(Aux),
										complement(X, Rep2, Rep2).
relative(X, Rep, Rep) --> [].

gv(X, Rep) -->	verbe(X, Y, Rep1),
				gn(Y, Rep1, Rep).

gv(X, Rep) -->	aux(Aux),
				complement(X, Rep1, Rep).

complement(X, Rep, Rep) -->	adverbe(X, Rep).
complement(X, Rep, Rep) -->	adjectif(X, Rep).
complement(X, Rep, Rep) -->	[un], nom(X, Rep).




