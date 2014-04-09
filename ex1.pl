:- [morpho].

gNominalSimple --> det(P), adj_ou_vide(P), nom(P), adj_ou_vide(P).

adj_ou_vide(_) --> [].
adj_ou_vide(P) --> adj(P).

gNominalComplexe --> gNominalSimple, avec_sans_complement.

avec_sans_complement --> [].
avec_sans_complement --> conjc_ou_prep, gNominalSimple.
avec_sans_complement --> p_relatif, gVerbal.

conjc_ou_prep --> conjc.
conjc_ou_prep --> prep.

gVerbal --> verbe, gN_ou_vide.

gN_ou_vide --> [].
gN_ou_vide --> gNominalComplexe.


det(Personne) --> [X], {analyse(X, MotCanonique, 'déterminant', Temps, Personne)}.
adj(Personne) --> [X], {analyse(X, MotCanonique, adjectif, Temps, Personne)}.
nom(Personne) --> [X], {analyse(X, MotCanonique, nom, Temps, Personne)}.
verbe --> [X], {analyse(X, MotCanonique, verbe, Temps, Personne)}.
conjc --> [X], {analyse(X, MotCanonique, conjc, Temps, Personne)}.
prep --> [X], {analyse(X, MotCanonique, prep, Temps, Personne)}. 
p_relatif --> [X], {analyse(X, MotCanonique, 'pronom relatif', Temps, Personne)}.


phrase --> gNominalComplexe, gVerbal_ou_pas.

gVerbal_ou_pas --> [].
gVerbal_ou_pas --> gVerbal.
