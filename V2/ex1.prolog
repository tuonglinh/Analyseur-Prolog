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
phrase(X) --> adv_ou_non(Adv),
			gNominalComplexe(Gn, PersGn),
			gVerbal_ou_non(Gv, PersGv),
			{verif_phrase(X, Adv, Gn, Gv)}.

gNominalComplexe(GNC, Personne) --> adv_ou_non(Adv),
									gNominalSimple(Gn, Personne),
									avec_sans_complement(Compl, X, Personne),
									{verif_GNC(GNC, Adv, Gn, Compl, X)}.

gVerbal(GV1, Personne) --> pron_refl_ou_non(Pr),
						verbe(Verb, _, _, _),
						adv_ou_non(Adv),
						gN_ou_non(Gn, Personne2),
						{verif_GV1(GV1, Pr, Verb, Adv, Gn)}.

gVerbal(GV2, Personne) --> negation1_ou_pas(Neg1, Oui_ou_Non),
						pron_refl_ou_non(Prfl),
						aux(Aux, Personne, _, _),
						negation2_ou_pas(Neg2, Oui_ou_Non),
						adv_ou_non(Adv), pp(Pps, Personne, _, _),
						gn_ou_non(Gn, PersGn),
						{verif_GV2(GV2, Neg1, Prfl, Aux, Neg2, Adv, Pps, Gn)}.

gVerbal(GV3, Personne) --> negation1_ou_pas(Neg1, Oui_ou_Non),
						pron_refl_ou_non(Prfl),
						verbe(Verb, Personne, _, _),
						adv_ou_non(Adv),
						negation2_ou_pas(Neg2, Oui_ou_Non),
						verbe(Inf, _, _, inf),
						gn_ou_non(Gn, PersGn),
						{verif_GV3(GV3, Neg1, Prfl, Verb, Adv, Neg2, Inf, Gn)}.

gNominalSimple([], _) --> [].
gNominalSimple(groupe_nominal_simple(Pps), Personne) --> pronPers(Pps, Personne).
gNominalSimple(GNS, Personne) --> det_ou_non(Det, Personne),
								adjs_ou_vide(Adj, Adj2, Personne),
								nom_ou_pas(Nom, Personne),
								adjs_ou_vide(Adj3, Adj4, Personne),
								{verif_GNS(GNS, Det, Adj, Adj2, Nom, Adj3, Adj4)}.

gN_ou_non([], _) --> [].
gN_ou_non(Gn, Personne) --> gNominalComplexe(Gn, Personne).

gVerbal_ou_non([], _) --> [].
gVerbal_ou_non(Gv, Personne) --> gVerbal(Gv, Personne).

nom_ou_pas([], _) --> [].
nom_ou_pas(Nom, Personne) --> nom(Nom, Personne).

det_ou_non([], _) --> [].
det_ou_non(Det, Personne) --> dete(Det, Personne).

adjs_ou_vide([], [], _) --> [].
adjs_ou_vide(Adj, Adj2, Personne) --> adje(Adj, Personne),
									adjs_ou_vide(Adj2, AutreAdj, Personne).

adv_ou_non([]) --> [].
adv_ou_non(Adv) --> adve(Adv).

avec_sans_complement([], [], _) --> [].
avec_sans_complement(Compl, Gn, Personne) --> conjc_ou_prep(Compl), gNominalComplexe(Gn, Personne).
avec_sans_complement(Prl, Phrase, _) --> pronRelatif(Prl), phrase(Phrase).

conjc_ou_prep(Conjc) --> conjC(Conjc).
conjc_ou_prep(Prepo) --> prepo(Prepo).

pron_refl_ou_non([]) --> [].
pron_refl_ou_non(Prfl) --> pronRefl(prfl).

negation1_ou_pas([], _) --> [].
negation1_ou_pas(Adv, X) --> negation1(Adv, X).

negation2_ou_pas([], _) --> [].
negation2_ou_pas(Adv, X) --> negation2(Adv, X).


/* Fonctions annexes */
/* Phrase */
verif_phrase(phrase, [], [], []).
verif_phrase(phrase(Adv), Adv, [], []) :- Adv \== [].
verif_phrase(phrase(Gn), [], Gn, []) :- Gn \== [].
verif_phrase(phrase(Gv), [], [], Gv) :- Gv \== [].
verif_phrase(phrase(Adv, Gn), Adv, Gn, []) :- Adv \== [], Gn \== [].
verif_phrase(phrase(Adv, Gv), Adv, [], Gv) :- Adv \== [], Gv \== [].
verif_phrase(phrase(Gn, Gv), [], Gn, Gv) :- Gn \== [], Gv \== [].
verif_phrase(phrase(Adv, Gn, Gv), Adv, Gn, Gv) :- Adv \== [], Gn \== [], Gv \== [].


/* Groupe nominal complexe*/
verif_GNC([], [], [], [], []).

verif_GNC(gNComplexe(X), [], [], [], X) :- X \== [].
verif_GNC(gNComplexe(Compl), [], [], Compl, []) :- Compl \== [].
verif_GNC(gNComplexe(Gn), [], Gn, [], []) :- Gn \== [].
verif_GNC(gNComplexe(Adv), Adv, [], [], []) :- Adv \== [].

verif_GNC(gNComplexe(Adv, Gn), Adv, Gn, [], []) :- Adv \== [], Gn \== [].
verif_GNC(gNComplexe(Adv, Compl), Adv, [], Compl, []) :- Adv \== [], Compl \== [].
verif_GNC(gNComplexe(Gn, Compl), [], Gn, Compl, []) :- Gn \== [], Compl \== [].
verif_GNC(gNComplexe(Adv, X), Adv, [], [], X) :- Adv \== [], X \== [].
verif_GNC(gNComplexe(Gn, X), [], Gn, [], X) :- Gn \== [], X \== [].
verif_GNC(gNComplexe(Compl, X), [], [], Compl, X) :- Compl \== [], X \== [].

verif_GNC(gNComplexe(Adv, Gn, Compl), Adv, Gn, Compl, []) :- Adv \== [], Gn \== [], Compl \== [].
verif_GNC(gNComplexe(Adv, Gn, X), Adv, Gn, [], X) :- Adv \== [], Gn \== [], X \== [].
verif_GNC(gNComplexe(Adv, Compl, X), Adv, [], Compl, X) :- Adv \== [], Compl \== [], X \== [].
verif_GNC(gNComplexe(Gn, Compl, X), [], Gn, Compl, X) :- Gn \== [], Compl \== [], X \== [].

verif_GNC(gNComplexe(Adv, Gn, Compl, X), Adv, Gn, Compl, X) :- Adv \== [], Gn \== [], Compl \== [], X \== [].

/* Groupe Verbal 1 */
verif_GV1(gV(Verb), [], Verb, [], []).

verif_GV1(gV(Pr, Verb), Pr, Verb, [], []) :- Pr \= [].
verif_GV1(gV(Verb, Adv), [], Verb, Adv, []) :- Adv \== [].
verif_GV1(gV(Verb, Gn), [], Verb, [], Gn) :- Gn \== [].

verif_GV1(gV(Pr, Verb, Adv), Pr, Verb, Adv, []) :- Pr \= [], Adv \== [].
verif_GV1(gV(Pr, Verb, Gn), Pr, Verb, [], Gn) :- Pr \= [], Gn \== [].
verif_GV1(gV(Verb, Adv, Gn), [], Verb, Adv, Gn) :- Adv \== [], Gn \== [].

verif_GV1(gV(Pr, Verb, Adv, Gn), Pr, Verb, Adv, Gn) :- Pr \= [], Adv \== [], Gn \== [].

/* Groupe verbal 2 */
verif_GV2(gV(Pps), [], [], [], [], [], Pps, []).

/* 1 */
verif_GV2(gV(Neg1, Pps), [], [], [], [], [], Pps, []) :- Neg1 \== [].
verif_GV2(gV(Prfl, Pps), [], Prfl, [], [], [], Pps, []) :- Prfl \== [].
verif_GV2(gV(Aux, Pps), [], [], Aux, [], [], Pps, []) :- Aux \== [].
verif_GV2(gV(Neg2, Pps), [], [], [], Neg2, [], Pps, []) :- Neg2 \== [].
verif_GV2(gV(Adv, Pps), [], [], [], [], Adv, Pps, []) :- Adv \== [].
verif_GV2(gV(Pps, Gn), [], [], [], [], [], Pps, Gn) :- Gn \== [].

/* 2 */
verif_GV2(gV(Neg1, Prfl, Pps), Neg1, Prfl, [], [], [], Pps, []) :- Neg1 \== [],
																			Prfl \== [].
verif_GV2(gV(Neg1, Aux, Pps), Neg1, [], Aux, [], [], Pps, []) :- Neg1 \== [],
																			Aux \== [].
verif_GV2(gV(Neg1, Neg2, Pps), Neg1, [], [], Neg2, [], Pps, []) :- Neg1 \== [],
																			Neg2 \== [].
verif_GV2(gV(Neg1, Adv, Pps), Neg1, [], [], [], Adv, Pps, []) :- Neg1 \== [],
																			Adv \== [].
verif_GV2(gV(Neg1, Pps, Gn), Neg1, [], [], [], [], Pps, Gn) :- Neg1 \== [],
																		Gn \== [].

verif_GV2(gV(Prfl, Aux, Pps), [], Prfl, Aux, [], [], Pps, []) :- Prfl \== [],
																			Aux \== [].
verif_GV2(gV(Prfl, Neg2, Pps), [], Prfl, [], Neg2, [], Pps, []) :- Prfl \== [],
																			Neg2 \== [].
verif_GV2(gV(Prfl, Adv, Pps), [], Prfl, [], [], Adv, Pps, []) :- Prfl \== [],
																			Adv \== [].
verif_GV2(gV(Prfl, Pps, Gn), [], Prfl, [], [], [], Pps, Gn) :- Prfl \== [],
																		Gn \== [].

verif_GV2(gV(Aux, Neg2, Pps), [], [], Aux, Neg2, [], Pps, []) :- Aux \== [],
																			Neg2 \== [].
verif_GV2(gV(Aux, Adv, Pps), [], [], Aux, [], Adv, Pps, []) :- Aux \== [],
																		Adv \== [].
verif_GV2(gV(Aux, Pps, Gn), [], [], Aux, [], [], Pps, Gn) :- Aux \== [],
																		Gn \== [].

verif_GV2(gV(Neg2, Adv, Pps), [], [], [], Neg2, Adv, Pps, []) :- Neg2 \== [],
																			Adv \== [].
verif_GV2(gV(Neg2, Pps, Gn), [], [], [], Neg2, [], Pps, Gn) :- Neg2 \== [],
																		Gn \== [].

verif_GV2(gV(Adv, Pps, Gn), [], [], [], [], Adv, Pps, Gn) :- Adv \== [],
																		Gn \== [].

/* 3 */
verif_GV2(gV(Neg1, Prfl, Aux, Pps), Neg1, Prfl, Aux, [], [], Pps, []) :- Neg1 \== [],
																					Prfl \== [],
																					Aux \== [].
verif_GV2(gV(Neg1, Prfl, Neg2, Pps), Neg1, Prfl, [], Neg2, [], Pps, []) :- Neg1 \== [],
																					Prfl \== [],
																					Neg2 \== [].
verif_GV2(gV(Neg1, Prfl, Adv, Pps), Neg1, Prfl, [], [], Adv, Pps, []) :- Neg1 \== [],
																					Prfl \== [],
																					Adv \== [].
verif_GV2(gV(Neg1, Prfl, Pps, Gn), Neg1, Prfl, [], [], [], Pps, Gn) :- Neg1 \== [],
																				Prfl \== [],
																				Gn \== [].

verif_GV2(gV(Neg1, Aux, Neg2, Pps), Neg1, [], Aux, Neg2, [], Pps, []) :- Neg1 \== [],
																					Aux \== [],
																					Neg2 \== [].
verif_GV2(gV(Neg1, Aux, Adv, Pps), Neg1, [], Aux, [], Adv, Pps, []) :- Neg1 \== [],
																				Aux \== [],
																				Adv \== [].
verif_GV2(gV(Neg1, Aux, Pps, Gn), Neg1, [], Aux, [], [], Pps, Gn) :- Neg1 \== [],
																				Aux \== [],
																				Gn \== [].

verif_GV2(gV(Neg1, Neg2, Adv, Pps), Neg1, [], [], Neg2, Adv, Pps, []) :- Neg1 \== [],
																					Neg2 \== [],
																					Adv \== [].
verif_GV2(gV(Neg1, Neg2, Pps, Gn), Neg1, [], [], Neg2, [], Pps, Gn) :- Neg1 \== [],
																				Neg2 \== [],
																				Gn \== [].

verif_GV2(gV(Neg1, Adv, Pps, Gn), Neg1, [], [], [], Adv, Pps, Gn) :- Neg1 \== [],
																				Adv \== [],
																				Gn \== [].


verif_GV2(gV(Prfl, Aux, Neg2, Pps), [], Prfl, Aux, Neg2, [], Pps, []) :- Prfl \== [],
																					Aux \== [],
																					Neg2 \== [].
verif_GV2(gV(Prfl, Aux, Adv, Pps), [], Prfl, Aux, [], Adv, Pps, []) :- Prfl \== [],
																				Aux \== [],
																				Adv \== [].
verif_GV2(gV(Prfl, Aux, Pps, Gn), [], Prfl, Aux, [], [], Pps, Gn) :- Prfl \== [],
																				Aux \== [],
																				Gn \== [].

verif_GV2(gV(Prfl, Neg2, Adv, Pps), [], Prfl, [], Neg2, Adv, Pps, []) :- Prfl \== [],
																					Neg2 \== [],
																					Adv \== [].
verif_GV2(gV(Prfl, Neg2, Pps, Gn), [], Prfl, [], Neg2, [], Pps, Gn) :- Prfl \== [],
																				Neg2 \== [],
																				Gn \== [].

verif_GV2(gV(Prfl, Adv, Pps, Gn), [], Prfl, [], [], Adv, Pps, Gn) :- Prfl \== [],
																				Adv \== [],
																				Gn \== [].


verif_GV2(gV(Aux, Neg2, Adv, Pps), [], [], Aux, Neg2, Adv, Pps, []) :- Aux \== [],
																				Neg2 \== [],
																				Adv \== [].
verif_GV2(gV(Aux, Neg2, Pps, Gn), [], [], Aux, Neg2, [], Pps, Gn) :- Aux \== [],
																				Neg2 \== [],
																				Gn \== [].


verif_GV2(gV(Aux, Adv, Pps, Gn), [], [], Aux, [], Adv, Pps, Gn) :- Aux \== [],
																			Adv \== [],
																			Gn \== [].


verif_GV2(gV(Neg2, Adv, Pps, Gn), [], [], [], Neg2, Adv, Pps, Gn) :- Neg2 \== [],
																				Adv \== [],
																				Gn \== [].

/* 4 */
verif_GV2(gV(Aux, Neg2, Adv, Pps, Gn), [], [], Aux, Neg2, Adv, Pps, Gn) :- Aux \== [],
																					Neg2 \== [],
																					Adv \== [],
																					Gn \== [].
verif_GV2(gV(Prfl, Neg2, Adv, Pps, Gn), [], Prfl, [], Neg2, Adv, Pps, Gn) :- Prfl \== [],
																					Neg2 \== [],
																					Adv \== [],
																					Gn \== [].
verif_GV2(gV(Prfl, Aux, Adv, Pps, Gn), [], Prfl, Aux, [], Adv, Pps, Gn) :- Prfl \== [],
																					Aux \== [],
																					Adv \== [],
																					Gn \== [].
verif_GV2(gV(Prfl, Aux, Neg2, Pps, Gn), [], Prfl, Aux, Neg2, [], Pps, Gn) :- Prfl \== [],
																						Aux \== [],
																						Neg2 \== [],
																						Gn \== [].
verif_GV2(gV(Prfl, Aux, Neg2, Adv, Pps), [], Prfl, Aux, Neg2, Adv, Pps, []) :- Prfl \== [],
																						Aux \== [],
																						Neg2 \== [],
																						Adv \== [].


verif_GV2(gV(Neg1, Neg2, Adv, Pps, Gn), Neg1, [], [], Neg2, Adv, Pps, Gn) :- Neg1 \== [],
																						Neg2 \== [],
																						Adv \== [],
																						Gn \== [].
verif_GV2(gV(Neg1, Aux, Adv, Pps, Gn), Neg1, [], Aux, [], Adv, Pps, Gn) :- Neg1 \== [],
																					Aux \== [],
																					Adv \== [],
																					Gn \== [].
verif_GV2(gV(Neg1, Aux, Neg2, Pps, Gn), Neg1, [], Aux, Neg2, [], Pps, Gn) :- Neg1 \== [],
																						Aux \== [],
																						Neg2 \== [],
																						Gn \== [].
verif_GV2(gV(Neg1, Aux, Neg2, Adv, Pps), Neg1, [], Aux, Neg2, Adv, Pps, []) :- Neg1 \== [],
																						Aux \== [],
																						Neg2 \== [],
																						Adv \== [].


verif_GV2(gV(Neg1, Prfl, Adv, Pps, Gn), Neg1, Prfl, [], [], Adv, Pps, Gn) :- Neg1 \== [],
																						Prfl \== [],
																						Adv \== [],
																						Gn \== [].
verif_GV2(gV(Neg1, Prfl, Neg2, Pps, Gn), Neg1, Prfl, [], Neg2, [], Pps, Gn) :- Neg1 \== [],
																						Prfl \== [],
																						Neg2 \== [],
																						Gn \== [].
verif_GV2(gV(Neg1, Prfl, Neg2, Adv, Pps), Neg1, Prfl, [], Neg2, Adv, Pps, []) :- Neg1 \== [],
																							Prfl \== [],
																							Neg2 \== [],
																							Adv \== [].


verif_GV2(gV(Neg1, Prfl, Aux, Pps, Gn), Neg1, Prfl, Aux, [], [], Pps, Gn) :- Neg1 \== [],
																						Prfl \== [],
																						Aux \== [],
																						Gn \== [].
verif_GV2(gV(Neg1, Prfl, Aux, Adv, Pps), Neg1, Prfl, Aux, [], Adv, Pps, []) :- Neg1 \== [],
																						Prfl \== [],
																						Aux \== [],
																						Adv \== [].


verif_GV2(gV(Neg1, Prfl, Aux, Neg2, Pps), Neg1, Prfl, Aux, Neg2, [], Pps, []) :- Neg1 \== [],
																							Prfl \== [],
																							Aux \== [],
																							Neg2 \== [].

/* 5 */
verif_GV2(gV(Prfl, Aux, Neg2, Adv, Pps, Gn), [], Prfl, Aux, Neg2, Adv, Pps, Gn) :- Prfl \== [],
																							Aux \== [],
																							Neg2 \== [],
																							Adv \== [],
																							Gn \== [].
verif_GV2(gV(Neg1, Aux, Neg2, Adv, Pps, Gn), Neg1, [], Aux, Neg2, Adv, Pps, Gn) :- Neg1 \== [],
																							Aux \== [],
																							Neg2 \== [],
																							Adv \== [],
																							Gn \== [].
verif_GV2(gV(Neg1, Prfl, Neg2, Adv, Pps, Gn), Neg1, Prfl, [], Neg2, Adv, Pps, Gn) :- Neg1 \== [],
																								Prfl \== [],
																								Neg2 \== [],
																								Adv \== [],
																								Gn \== [].
verif_GV2(gV(Neg1, Prfl, Aux, Adv, Pps, Gn), Neg1, Prfl, Aux, [], Adv, Pps, Gn) :- Neg1 \== [],
																							Prfl \== [],
																							Aux \== [],
																							Adv \== [],
																							Gn \== [].
verif_GV2(gV(Neg1, Prfl, Aux, Neg2, Pps, Gn), Neg1, Prfl, Aux, Neg2, [], Pps, Gn) :- Neg1 \== [],
																								Prfl \== [],
																								Aux \== [],
																								Neg2 \== [],
																								Gn \== [].
verif_GV2(gV(Neg1, Prfl, Aux, Neg2, Adv, Pps), Neg1, Prfl, Aux, Neg2, Adv, Pps, []) :- Neg1 \== [],
																								Prfl \== [],
																								Aux \== [],
																								Neg2 \== [],
																								Adv \== [].

/* 6 */
verif_GV2(gV(Neg1, Prfl, Aux, Neg2, Adv, Pps, Gn), Neg1, Prfl, Aux, Neg2, Adv, Pps, Gn) :- Neg1 \== [],
																									Prfl \== [],
																									Aux \== [],
																									Neg2 \== [],
																									Adv \== [],
																									Gn \== [].


/* Groupe verbal 3 */
verif_GV3(gV(Verb, Inf), [], [], Verb, [], [], Inf, []).

/* 1 */
verif_GV3(gV(Neg1, Verb, Inf), Neg1, [], Verb, [], [], Inf, []) :- Neg1 \== [].
verif_GV3(gV(Prfl, Verb, Inf), [], Prfl, Verb, [], [], Inf, []) :- Prfl \== [].
verif_GV3(gV(Verb, Adv, Inf), [], [], Verb, Adv, [], Inf, []) :- Adv \== [].
verif_GV3(gV(Verb, Neg2, Inf), [], [], Verb, [], Neg2, Inf, []) :- Neg2 \== [].
verif_GV3(gV(Verb, Inf, Gn), [], [], Verb, [], [], Inf, Gn) :- Gn \== [].

/* 2 */
verif_GV3(gV(Neg1, Prfl, Verb, Inf), Neg1, Prfl, Verb, [], [], Inf, []) :- Neg1 \== [],
																					Prfl \== [].
verif_GV3(gV(Neg1, Verb, Adv, Inf), Neg1, [], Verb, Adv, [], Inf, []) :- Neg1 \== [],
																					Adv \== [].
verif_GV3(gV(Neg1, Verb, Neg2, Inf), Neg1, [], Verb, [], Neg2, Inf, []) :- Neg1 \== [],
																					Neg2 \== [].
verif_GV3(gV(Neg1, Verb, Inf, Gn), Neg1, [], Verb, [], [], Inf, Gn) :- Neg1 \== [],
																				Gn \== [].

verif_GV3(gV(Prfl, Verb, Adv, Inf), [], Prfl, Verb, Adv, [], Inf, []) :- Prfl \== [],
																					Adv \== [].
verif_GV3(gV(Prfl, Verb, Neg2, Inf), [], Prfl, Verb, [], Neg2, Inf, []) :- Prfl \== [],
																					Neg2 \== [].
verif_GV3(gV(Prfl, Verb, Inf, Gn), [], Prfl, Verb, [], [], Inf, Gn) :- Prfl \== [],
																				Gn \== [].

verif_GV3(gV(Verb, Adv, Neg2, Inf), [], [], Verb, Adv, Neg2, Inf, []) :- Adv \== [],
																					Neg2 \== [].
verif_GV3(gV(Verb, Adv, Inf, Gn), [], [], Verb, Adv, [], Inf, Gn) :- Adv \== [],
																				Gn \== [].

verif_GV3(gV(Verb, Neg2, Inf, Gn), [], [], Verb, [], Neg2, Inf, Gn) :- Neg2 \== [],
																				Gn \== [].

/* 3 */
verif_GV3(gV(Verb, Adv, Neg2, Inf, Gn), [], [], Verb, Adv, Neg2, Inf, Gn) :- Adv \== [],
																						Neg2 \== [],
																						Gn \== [].
verif_GV3(gV(Prfl, Verb, Neg2, Inf, Gn), [], Prfl, Verb, [], Neg2, Inf, Gn) :- Prfl \== [],
																						Neg2 \== [],
																						Gn \== [].
verif_GV3(gV(Prfl, Verb, Adv, Inf, Gn), [], Prfl, Verb, Adv, [], Inf, Gn) :- Prfl \== [],
																						Adv \== [],
																						Gn \== [].
verif_GV3(gV(Prfl, Verb, Adv, Neg2, Inf), [], Prfl, Verb, Adv, Neg2, Inf, []) :- Prfl \== [],
																						Adv \== [],
																						Neg2 \== [].

verif_GV3(gV(Neg1, Verb, Neg2, Inf, Gn), Neg1, [], Verb, [], Neg2, Inf, Gn) :- Neg1 \== [],
																						Neg2 \== [],
																						Gn \== [].
verif_GV3(gV(Neg1, Verb, Adv, Inf, Gn), Neg1, [], Verb, Adv, [], Inf, Gn) :- Neg1 \== [],
																						Adv \== [],
																						Gn \== [].
verif_GV3(gV(Neg1, Verb, Adv, Neg2, Inf), Neg1, [], Verb, Adv, Neg2, Inf, []) :- Neg1 \== [],
																						Adv \== [],
																						Neg2 \== [].

verif_GV3(gV(Neg1, Prfl, Verb, Inf, Gn), Neg1, Prfl, Verb, [], [], Inf, Gn) :- Neg1 \== [],
																						Prfl \== [],
																						Gn \== [].
verif_GV3(gV(Neg1, Prfl, Verb, Neg2, Inf), Neg1, Prfl, Verb, [], Neg2, Inf, []) :- Neg1 \== [],
																						Prfl \== [],
																						Neg2 \== [].

verif_GV3(gV(Neg1, Prfl, Verb, Adv, Inf), Neg1, Prfl, Verb, Adv, [], Inf, []) :- Neg1 \== [],
																						Prfl \== [],
																						Adv \== [].

/* 4 */
verif_GV3(gV(Prfl, Verb, Adv, Neg2, Inf, Gn), [], Prfl, Verb, Adv, Neg2, Inf, Gn) :- Prfl \== [],
																								Adv \== [],
																								Neg2 \== [],
																								Gn \== [].
verif_GV3(gV(Neg1, Verb, Adv, Neg2, Inf, Gn), Neg1, [], Verb, Adv, Neg2, Inf, Gn) :- Neg1 \== [],
																								Adv \== [],
																								Neg2 \== [],
																								Gn \== [].
verif_GV3(gV(Neg1, Prfl, Verb, Neg2, Inf, Gn), Neg1, Prfl, Verb, [], Neg2, Inf, Gn) :- Neg1 \== [],
																								Prfl \== [],
																								Neg2 \== [],
																								Gn \== [].
verif_GV3(gV(Neg1, Prfl, Verb, Adv, Inf, Gn), Neg1, Prfl, Verb, Adv, [], Inf, Gn) :- Neg1 \== [],
																								Prfl \== [],
																								Adv \== [],
																								Gn \== [].
verif_GV3(gV(Neg1, Prfl, Verb, Adv, Neg2, Inf), Neg1, Prfl, Verb, Adv, Neg2, Inf, []) :- Neg1 \== [],
																										Prfl \== [],
																										Adv \== [],
																										Neg2 \== [].

/* 5 */
verif_GV3(gV(Neg1, Prfl, Verb, Adv, Neg2, Inf, Gn), Neg1, Prfl, Verb, Adv, Neg2, Inf, Gn) :- Neg1 \== [],
																										Prfl \== [],
																										Adv \== [],
																										Neg2 \== [],
																										Gn \== [].
																										

/* Groupe Nomial Simple */
verif_GNS([], [], [], [], [], [], []).

/* 1 */
verif_GNS(gNSimple(Det), Det, [], [], [], [], []) :- Det \== [].
verif_GNS(gNSimple(Adj), [], Adj, [], [], [], []) :- Adj \== [].
verif_GNS(gNSimple(Adj2), [], [], Adj2, [], [], []) :- Adj2 \== [].
verif_GNS(gNSimple(Nom), [], [], [], Nom, [], []) :- Nom \== [].
verif_GNS(gNSimple(Adj3), [], [], [], [], Adj3, []) :- Adj3 \== [].
verif_GNS(gNSimple(Adj4), [], [], [], [], [], Adj4) :- Adj4 \== [].

/* 2 */
verif_GNS(gNSimple(Det, Adj), Det, Adj, [], [], [], []) :- Det \== [],
															Adj \== [].
verif_GNS(gNSimple(Det, Adj2), Det, [], Adj2, [], [], []) :- Det \== [],
															Adj2 \== [].
verif_GNS(gNSimple(Det, Nom), Det, [], [], Nom, [], []) :- Det \== [],
															Nom \== [].
verif_GNS(gNSimple(Det, Adj3), Det, [], [], [], Adj3, []) :- Det \== [],
															Adj3 \== [].
verif_GNS(gNSimple(Det, Adj4), Det, [], [], [], [], Adj4) :- Det \== [],
															Adj4 \== [].

verif_GNS(gNSimple(Adj, Adj2), [], Adj, Adj2, [], [], []) :- Adj \== [],
															Adj2 \== [].
verif_GNS(gNSimple(Adj, Nom), [], Adj, [], Nom, [], []) :- Adj \== [],
															Nom \== [].
verif_GNS(gNSimple(Adj, Adj3), [], Adj, [], [], Adj3, []) :- Adj \== [],
															Adj3 \== [].
verif_GNS(gNSimple(Adj, Adj4), [], Adj, [], [], [], Adj4) :- Adj \== [],
															Adj4 \== [].

verif_GNS(gNSimple(Adj2, Nom), [], [], Adj2, Nom, [], []) :- Adj2 \== [],
															Nom \== [].
verif_GNS(gNSimple(Adj2, Adj3), [], [], Adj2, [], Adj3, []) :- Adj2 \== [],
																Adj3 \== [].
verif_GNS(gNSimple(Adj2, Adj4), [], [], Adj2, [], [], Adj4) :- Adj2 \== [],
																Adj4 \== [].

verif_GNS(gNSimple(Nom, Adj3), [], [], [], Nom, Adj3, []) :- Nom \== [],
															Adj3 \== [].
verif_GNS(gNSimple(Nom, Adj4), [], [], [], Nom, [], Adj4) :- Nom \== [],
															Adj4 \== [].

verif_GNS(gNSimple(Adj3, Adj4), [], [], [], [], Adj3, Adj4) :- Adj3 \== [],
																Adj4 \== [].


/* 3 */
verif_GNS(gNSimple(Nom, Adj3, Adj4), [], [], [], Nom, Adj3, Adj4) :- Nom \== [],
																	Adj3 \== [],
																	Adj4 \== [].
verif_GNS(gNSimple(Adj2, Adj3, Adj4), [], [], Adj2, [], Adj3, Adj4) :- Adj2 \== [],
																		Adj3 \== [],
																		Adj4 \== [].
verif_GNS(gNSimple(Adj2, Nom, Adj4), [], [], Adj2, Nom, [], Adj4) :- Adj2 \== [],
																	Nom \== [],
																	Adj4 \== [].
verif_GNS(gNSimple(Adj2, Nom, Adj3), [], [], Adj2, Nom, Adj3, []) :- Adj2 \== [],
																	Nom \== [],
																	Adj3 \== [].

verif_GNS(gNSimple(Adj, Adj3, Adj4), [], Adj, [], [], Adj3, Adj4) :- Adj \== [],
																	Adj3 \== [],
																	Adj4 \== [].
verif_GNS(gNSimple(Adj, Nom, Adj4), [], Adj, [], Nom, [], Adj4) :- Adj \== [],
																	Nom \== [],
																	Adj4 \== [].
verif_GNS(gNSimple(Adj, Nom, Adj3), [], Adj, [], Nom, Adj3, []) :- Adj \== [],
																	Nom \== [],
																	Adj3 \== [].

verif_GNS(gNSimple(Adj, Adj2, Adj4), [], Adj, Adj2, [], [], Adj4) :- Adj \== [],
																	Adj2 \== [],
																	Adj4 \== [].
verif_GNS(gNSimple(Adj, Adj2, Adj3), [], Adj, Adj2, [], Adj3, []) :- Adj \== [],
																	Adj2 \== [],
																	Adj3 \== [].

verif_GNS(gNSimple(Adj, Adj2, Nom), [], Adj, Adj2, Nom, [], []) :- Adj \== [],
																	Adj2 \== [],
																	Nom \== [].



verif_GNS(gNSimple(Det, Adj3, Adj4), Det, [], [], [], Adj3, Adj4) :- Det \== [],
																	Adj3 \== [],
																	Adj4 \== [].
verif_GNS(gNSimple(Det, Nom, Adj4), Det, [], [], Nom, [], Adj4) :- Det \== [],
																	Nom \== [],
																	Adj4 \== [].
verif_GNS(gNSimple(Det, Nom, Adj3), Det, [], [], Nom, Adj3, []) :- Det \== [],
																	Nom \== [],
																	Adj3 \== [].

verif_GNS(gNSimple(Det, Adj2, Adj4), Det, [], Adj2, [], [], Adj4) :- Det \== [],
																	Adj2 \== [],
																	Adj4 \== [].
verif_GNS(gNSimple(Det, Adj2, Adj3), Det, [], Adj2, [], Adj3, []) :- Det \== [],
																	Adj2 \== [],
																	Adj3 \== [].

verif_GNS(gNSimple(Det, Adj2, Nom), Det, [], Adj2, Nom, [], []) :- Det \== [],
																			Adj2 \== [],
																			Nom \== [].


verif_GNS(gNSimple(Det, Adj, Adj4), Det, Adj, [], [], [], Adj4) :- Det \== [],
																	Adj \== [],
																	Adj4 \== [].
verif_GNS(gNSimple(Det, Adj, Adj3), Det, Adj, [], [], Adj3, []) :- Det \== [],
																	Adj \== [],
																	Adj3 \== [].

verif_GNS(gNSimple(Det, Adj, Nom), Det, Adj, [], Nom, [], []) :- Det \== [],
																Adj \== [],
																Nom \== [].


verif_GNS(gNSimple(Det, Adj, Adj2), Det, Adj, Adj2, [], [], []) :- Det \== [],
																	Adj \== [],
																	Adj2 \== [].


/* 4 */
verif_GNS(gNSimple(Adj2, Nom, Adj3, Adj4), [], [], Adj2, Nom, Adj3, Adj4) :- Adj2 \== [],
																			Nom \== [],
																			Adj3 \== [],
																			Adj4 \== [].
verif_GNS(gNSimple(Adj, Nom, Adj3, Adj4), [], Adj, [], Nom, Adj3, Adj4) :- Adj \== [],
																			Nom \== [],
																			Adj3 \== [],
																			Adj4 \== [].
verif_GNS(gNSimple(Adj, Adj2, Adj3, Adj4), [], Adj, Adj2, [], Adj3, Adj4) :- Adj \== [],
																			Adj2 \== [],
																			Adj3 \== [],
																			Adj4 \== [].
verif_GNS(gNSimple(Adj, Adj2, Nom, Adj4), [], Adj, Adj2, Nom, [], Adj4) :- Adj \== [],
																			Adj2 \== [],
																			Nom \== [],
																			Adj4 \== [].
verif_GNS(gNSimple(Adj, Adj2, Nom, Adj3), [], Adj, Adj2, Nom, Adj3, []) :- Adj \== [],
																			Adj2 \== [],
																			Nom \== [],
																			Adj3 \== [].

verif_GNS(gNSimple(Det, Nom, Adj3, Adj4), Det, [], [], Nom, Adj3, Adj4) :- Det \== [],
																			Nom \== [],
																			Adj3 \== [],
																			Adj4 \== [].
verif_GNS(gNSimple(Det, Adj2, Adj3, Adj4), Det, [], Adj2, [], Adj3, Adj4) :- Det \== [],
																			Adj2 \== [],
																			Adj3 \== [],
																			Adj4 \== [].
verif_GNS(gNSimple(Det, Adj2, Nom, Adj4), Det, [], Adj2, Nom, [], Adj4) :- Det \== [],
																			Adj2 \== [],
																			Nom \== [],
																			Adj4 \== [].
verif_GNS(gNSimple(Det, Adj2, Nom, Adj3), Det, [], Adj2, Nom, Adj3, []) :- Det \== [],
																			Adj2 \== [],
																			Nom \== [],
																			Adj3 \== [].

verif_GNS(gNSimple(Det, Adj, Adj3, Adj4), Det, Adj, [], [], Adj3, Adj4) :- Det \== [],
																			Adj \== [],
																			Adj3 \== [],
																			Adj4 \== [].
verif_GNS(gNSimple(Det, Adj, Nom, Adj4), Det, Adj, [], Nom, [], Adj4) :- Det \== [],
																		Adj \== [],
																		Nom \== [],
																		Adj4 \== [].
verif_GNS(gNSimple(Det, Adj, Nom, Adj3), Det, Adj, [], Nom, Adj3, []) :- Det \== [],
																		Adj \== [],
																		Nom \== [],
																		Adj3 \== [].

verif_GNS(gNSimple(Det, Adj, Adj2, Adj4), Det, Adj, Adj2, [], [], Adj4) :- Det \== [],
																			Adj \== [],
																			Adj2 \== [],
																			Adj4 \== [].
verif_GNS(gNSimple(Det, Adj, Adj2, Adj3), Det, Adj, Adj2, [], Adj3, []) :- Det \== [],
																			Adj \== [],
																			Adj2 \== [],
																			Adj3 \== [].

verif_GNS(gNSimple(Det, Adj, Adj2, Nom), Det, Adj, Adj2, Nom, [], []) :- Det \== [],
																		Adj \== [],
																		Adj2 \== [],
																		Nom \== [].


/* 5 */
verif_GNS(gNSimple(Adj, Adj2, Nom, Adj3, Adj4), [], Adj, Adj2, Nom, Adj3, Adj4) :- Adj \== [],
																					Adj2 \== [],
																					Nom \== [],
																					Adj3 \== [],
																					Adj4 \== [].
verif_GNS(gNSimple(Det, Adj2, Nom, Adj3, Adj4), Det, [], Adj2, Nom, Adj3, Adj4) :- Det \== [],
																					Adj2 \== [],
																					Nom \== [],
																					Adj3 \== [],
																					Adj4 \== [].
verif_GNS(gNSimple(Det, Adj, Nom, Adj3, Adj4), Det, Adj, [], Nom, Adj3, Adj4) :- Det \== [],
																				Adj \== [],
																				Nom \== [],
																				Adj3 \== [],
																				Adj4 \== [].
verif_GNS(gNSimple(Det, Adj, Adj2, Adj3, Adj4), Det, Adj, Adj2, [], Adj3, Adj4) :- Det \== [],
																					Adj \== [],
																					Adj2 \== [],
																					Adj3 \== [],
																					Adj4 \== [].
verif_GNS(gNSimple(Det, Adj, Adj2, Nom, Adj4), Det, Adj, Adj2, Nom, [], Adj4) :- Det \== [],
																				Adj \== [],
																				Adj2 \== [],
																				Nom \== [],
																				Adj4 \== [].
verif_GNS(gNSimple(Det, Adj, Adj2, Nom, Adj3), Det, Adj, Adj2, Nom, Adj3, []) :- Det \== [],
																					Adj \== [],
																					Adj2 \== [],
																					Nom \== [],
																					Adj3 \== [].

/* 6 */
verif_GNS(gNSimple(Det, Adj, Adj2, Nom, Adj3, Adj4), Det, Adj, Adj2, Nom, Adj3, Adj4) :- Det \== [],
																						Adj \== [],
																						Adj2 \== [],
																						Nom \== [],
																						Adj3 \== [],
																						Adj4 \== [].
