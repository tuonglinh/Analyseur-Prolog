:- consult('adj.prolog').
:- consult('adverb.prolog').
:- consult('conjc.prolog').
:- consult('det.prolog').
:- consult('noun.prolog').
:- consult('prep.prolog').
:- consult('pronoun.prolog').
:- consult('verb.prolog').

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

det(Personne) --> [X], {det(X, Personne, _, _)}.
adj(Personne) --> [X], {adj(X, Personne, _, _)}.
nom(Personne) --> [X], {noun(X, Personne, _, _)}.
verbe --> [X], {verb(X, Personne, _, Temps)}.
conjc --> [X], {conjc(X, _, _, _)}.
prep --> [X], {prep(X, _, _, _)}. 
p_relatif --> [X], {p_relatif(X, Personne, _, _)}.
pron_pers --> [X], {pron_pers(X, Personne, _, _)}.
pron_refl --> [X], {pron_refl(X, Personne, _, _)}.
adv --> [X], {adverb(X, _, _, _)}.


phrase --> adv_ou_non, gNominalComplexe, gVerbal_ou_non.

gVerbal_ou_non --> [].
gVerbal_ou_non --> gVerbal.
