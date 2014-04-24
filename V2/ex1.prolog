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

/* Récupération des données pour la grammaire */
dete('déterminant'(X), Personne) --> [X], {det(X, Personne, _, _)}.
adje(adjectif(X), Personne) --> [X], {adj(X, Personne, _, _)}.
nom(noun(X), Personne) --> [X], {noun(X, Personne, _, _)}.
verbe(verb(X), Personne, MotCanonique, Temps) --> [X], {verb(X, Personne, MotCanonique, Temps)}.
conjC(conjonctionCoordination(X)) --> [X], {conjc(X, _, _, _)}.
prepo('préposition'(X)) --> [X], {prep(X, _, _, _)}. 
pronRelatif(pronomRelatif(X)) --> [X], {p_relatif(X, _, _, _)}.
pronPers(pronomPersonnel(X), Personne) --> [X], {pron_pers(X, Personne, _, _)}.
pronRefl(pronomReflechi(X)) --> [X], {pron_refl(X, _, _, _)}.
adve(adverbe(X)) --> [X], {adverb(X, _, _, _)}.

aux(auxiliaire(X), Personne, MotCanonique, Temps) --> [X], {verb(X, Personne, avoir, Temps)}.
aux(auxiliaire(X), Personne, MotCanonique, Temps) --> [X], {verb(X, Personne, 'être', Temps)}.
pp('participe_passé'(X), Personne, _, Temps) --> [X], {verb(X, Personne, _, ppast)}.

negation1(adverbe(ne), Oui_ou_Non) --> [ne].
negation2(adverbe(pas), Oui_ou_Non) --> [pas].



/* Grammaire */
phrase(X) --> adv_ou_non(Adv), gNominalComplexe(Gn, PersGn), gVerbal_ou_non(Gv, PersGv), {verif_phrase(X, Adv, Gn, Gv)}.

gNominalComplexe(GNC, Personne) --> adv_ou_non(Adv),
									gNominalSimple(Gn, Personne),
									avec_sans_complement(Compl, X, Personne),
									{verif_GNC(GNC, Adv, Gn, Compl, X)}.

gVerbal(groupe_verbal(Pr, Verb, Adv, Gn), Personne) --> pron_refl_ou_non(Pr), verbe(Verb, _, _, _),
														adv_ou_non(Adv),
														gN_ou_non(Gn, Personne2).

gVerbal(groupe_verbal(Neg1, Prfl, Aux, Neg2, Adv, Pps, Gn), Personne) --> negation1_ou_pas(Neg1, Oui_ou_Non),
																		pron_refl_ou_non(Prfl),
																		aux(Aux, Personne, _, _),
																		negation2_ou_pas(Neg2, Oui_ou_Non),
																		adv_ou_non(Adv), pp(Pps, Personne, _, _),
																		gn_ou_non(Gn, PersGn).

gVerbal(groupe_verbal(Neg1, Prfl, Verb, Adv, Neg2, Inf, Gn), Personne) --> negation1_ou_pas(Neg1, Oui_ou_Non),
																		pron_refl_ou_non(Prfl),
																		verbe(Verb, Personne, _, _),
																		adv_ou_non(Adv),
																		negation2_ou_pas(Neg2, Oui_ou_Non),
																		verbe(Inf, _, _, inf),
																		gn_ou_non(Gn, PersGn).

gNominalSimple(_, _) --> [].
gNominalSimple(groupe_nominal_simple(Pps), Personne) --> pronPers(Pps, Personne).
gNominalSimple(groupe_nominal_simple(Det, Adj, Adj2, Nom, Adj3, Adj4), Personne) --> det_ou_non(Det, Personne),
																					adjs_ou_vide(Adj, Adj2, Personne),
																					nom_ou_pas(Nom, Personne),
																					adjs_ou_vide(Adj3, Adj4, Personne).

gN_ou_non(_, _) --> [].
gN_ou_non(Gn, Personne) --> gNominalComplexe(Gn, Personne).

gVerbal_ou_non(_, _) --> [].
gVerbal_ou_non(Gv, Personne) --> gVerbal(Gv, Personne).

nom_ou_pas(_, _) --> [].
nom_ou_pas(Nom, Personne) --> nom(Nom, Personne).

det_ou_non(_, _) --> [].
det_ou_non(Det, Personne) --> dete(Det, Personne).

adjs_ou_vide(_, _, _) --> [].
adjs_ou_vide(Adj, Adj2, Personne) --> adje(Adj, Personne),
									adjs_ou_vide(Adj2, AutreAdj, Personne).

adv_ou_non(_) --> [].
adv_ou_non(Adv) --> adve(Adv).

avec_sans_complement(_, _, _) --> [].
avec_sans_complement(Compl, Gn, Personne) --> conjc_ou_prep(Compl), gNominalComplexe(Gn, Personne).
avec_sans_complement(Prl, Phrase, _) --> pronRelatif(Prl), phrase(Phrase).

conjc_ou_prep(Conjc) --> conjC(Conjc).
conjc_ou_prep(Prepo) --> prepo(Prepo).

pron_refl_ou_non(Prfl) --> [].
pron_refl_ou_non(Prfl) --> pronRefl(prfl).

negation1_ou_pas(_, _) --> [].
negation1_ou_pas(Adv, X) --> negation1(Adv, X).

negation2_ou_pas(_, _) --> [].
negation2_ou_pas(Adv, X) --> negation2(Adv, X).


/* Fonctions annexes */
/* Phrase */
verif_phrase(phrase(Adv, Gn, Gv), Adv, Gn, Gv).
verif_phrase(phrase(Adv, Gn), Adv, Gn, []) :- Adv \== [], Adv \== [].
verif_phrase(phrase(Adv, Gv), Adv, [], Gv) :- Adv \== [], Gv \== [].
verif_phrase(phrase(Gn, Gv), [], Gn, Gv) :- Gn \== [], Gv \== [].
verif_phrase(phrase(Adv), Adv, [], []) :- Adv \== [].
verif_phrase(phrase(Gn), [], Gn, []) :- Gn \== [].
verif_phrase(phrase(Gv), [], [], Gv) :- Gv \== [].
verif_phrase(phrase(), [], [], []).

/* Groupe nominal complexe*/
verif_GNC(gNComplexe(Adv, Gn, Compl, X), Adv, Gn, Compl, X) :- Adv \== [], Gn \== [], Compl \== [], X \== [].

verif_GNC(gNComplexe(Adv, Gn, Compl), Adv, Gn, Compl, []) :- Adv \== [], Gn \== [], Compl \== [].
verif_GNC(gNComplexe(Adv, Gn, X), Adv, Gn, [], X) :- Adv \== [], Gn \== [], X \== [].
verif_GNC(gNComplexe(Adv, Compl, X), Adv, [], Compl, X) :- Adv \== [], Compl \== [], X \== [].
verif_GNC(gNComplexe(Gn, Compl, X), [], Gn, Compl, X) :- Gn \== [], Compl \== [], X \== [].

verif_GNC(gNComplexe(Adv, Gn), Adv, Gn, [], []) :- Adv \== [], Gn \== [].
verif_GNC(gNComplexe(Adv, Compl), Adv, [], Compl, []) :- Adv \== [], Compl \== [].
verif_GNC(gNComplexe(Gn, Compl), [], Gn, Compl, []) :- Gn \== [], Compl \== [].
verif_GNC(gNComplexe(Adv, X), Adv, [], [], X) :- Adv \== [], X \== [].
verif_GNC(gNComplexe(Gn, X), [], Gn, [], X) :- Gn \== [], X \== [].
verif_GNC(gNComplexe(Compl, X), [], [], Compl, X) :- Compl \== [], X \== [].

verif_GNC(gNComplexe(X), [], [], [], X) :- X \== [].
verif_GNC(gNComplexe(Compl), [], [], Compl, []) :- Compl \== [].
verif_GNC(gNComplexe(Gn), [], Gn, [], []) :- Gn \== [].
verif_GNC(gNComplexe(Adv), Adv, [], [], []) :- Adv \== [].

verif_GNC(gNComplexe(), [], [], [], []).