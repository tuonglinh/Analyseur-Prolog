:- [morpho].

gNominalSimple --> [].
gNominalSimple --> pron_pers.
gNominalSimple --> det_ou_non(P), adj_ou_vide(P), nom_ou_pas(P), adj_ou_vide(P).

nom_ou_pas(_) --> [].
nom_ou_pas(P) --> nom(P).

det_ou_non(_) --> [].
det_ou_non(P) --> det(P).

adj_ou_vide(_) --> [].
adj_ou_vide(P) --> adj(P).
adj_ou_vide(P) --> adj(P), adj(P).

gNominalComplexe --> adv_ou_non, gNominalSimple, avec_sans_complement.

adv_ou_non --> [].
adv_ou_non --> adv.

avec_sans_complement --> [].
avec_sans_complement --> conjc_ou_prep, gNominalComplexe.
avec_sans_complement --> p_relatif, adv_ou_non, gN_ou_non, gVerbal.

conjc_ou_prep --> conjc.
conjc_ou_prep --> prep.

gVerbal --> pron_refl_ou_non, verbe, adv_ou_non, gN_ou_non.

pron_refl_ou_non --> [].
pron_refl_ou_non --> pron_refl.

gN_ou_non --> [].
gN_ou_non --> gNominalComplexe.

det(Personne) --> [X], {analyse(X, MotCanonique, 'déterminant', Temps, Personne)}.
adj(Personne) --> [X], {analyse(X, MotCanonique, adjectif, Temps, Personne)}.
nom(Personne) --> [X], {analyse(X, MotCanonique, nom, Temps, Personne)}.
verbe --> [X], {analyse(X, MotCanonique, verbe, Temps, Personne)}.
conjc --> [X], {analyse(X, MotCanonique, 'Conjonction de coordination', Temps, Personne)}.
prep --> [X], {analyse(X, MotCanonique, 'préposition', Temps, Personne)}. 
p_relatif --> [X], {analyse(X, MotCanonique, 'pronom relatif', Temps, Personne)}.
pron_pers --> [X], {analyse(X, MotCanonique, 'pronom personnel', Temps, Personne)}.
pron_refl --> [X], {analyse(X, MotCanonique, 'pronom réfléchi', Temps, Personne)}.
adv --> [X], {analyse(X, MotCanonique, 'adverbe', Temps, Personne)}.


phrase --> adv_ou_non, gNominalComplexe, gVerbal_ou_non.

gVerbal_ou_non --> [].
gVerbal_ou_non --> gVerbal.
