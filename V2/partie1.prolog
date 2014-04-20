/* chargement des fichiers */
:- consult('adj.prolog').
:- consult('adverb.prolog').
:- consult('conjc.prolog').
:- consult('det.prolog').
:- consult('noun.prolog').
:- consult('prep.prolog').
:- consult('pronoun.prolog').
:- consult('verb.prolog').

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

aux(auxiliaire(X), Personne, _, Temps) --> [X], {verb(X, Personne, avoir, Temps)}.
aux(auxiliaire(X), Personne, _, Temps) --> [X], {verb(X, Personne, 'être', Temps)}.
pp('participe_passé'(X), Personne, _, Temps) --> [X], {verb(X, Personne, _, ppast)}.

negation1(adverbe(ne), Oui_ou_Non) --> [ne].
negation2(adverbe(pas), Oui_ou_Non) --> [pas].


/* Grammaire */
phrase(sentence(Gn, Gv)) --> gn_ou_non(Gn, PersonneGn), gv(Gv, PersonneGv), {personne(PersonneGn, PersonneGv)}.


/* Groupe nominal */
gn(groupe_nominale(Det, Adj, Conjc, Adj2, Nom, Adj3, Conjc2, Adj4), Personne) --> dete(Det, Personne), adje_ou_non(Adj, Conjc, Adj2, Personne), nom(Nom, Personne), adje_ou_non(Adj3, Conjc2, Adj4, Personne).
gn(groupe_nominale(Pp), Personne) --> pronPers(Pp, Personne).

/* Groupe verbal */
gv(groupe_verbal(Neg1, Prfl, Verb, Neg2, Adv, Gn), Personne) --> negation1_ou_pas(Neg1, Oui_ou_Non), pron_refl_ou_non(Prfl), verbe(Verb, Personne, _, _), negation2_ou_pas(Neg2, Oui_ou_Non), adv_ou_non(Adv), gn_ou_non(Gn, PersGn).
gv(groupe_verbal(Neg1, Prfl, Aux, Neg2, Adv, Pps, Gn), Personne) --> negation1_ou_pas(Neg1, Oui_ou_Non), pron_refl_ou_non(Prfl), aux(Aux, Personne, _, _), negation2_ou_pas(Neg2, Oui_ou_Non), adv_ou_non(Adv), pp(Pps, Personne, _, _), gn_ou_non(Gn, PersGn).
gv(groupe_verbal(Neg1, Prfl, Verb, Neg2, Adv, Inf, Gn), Personne) --> negation1_ou_pas(Neg1, Oui_ou_Non), pron_refl_ou_non(Prfl), verbe(Verb, Personne, _, _), negation2_ou_pas(Neg2, Oui_ou_Non), adv_ou_non(Adv), verbe(Inf, _, _, inf), gn_ou_non(Gn, PersGn).

/* Les dérivés */
gn_ou_non(Gn, Personne) --> gn(Gn, Personne).
gn_ou_non(_, _) --> [].

adje_ou_non(_, _, _, _) --> [].
adje_ou_non(Adj, _, _, Personne) --> adje(Adj, Personne).
adje_ou_non(Adj, Conjc, Adj2, Personne) --> adje(Adj, Personne), conjC(Conjc), adje(Adj2, Personne).


adv_ou_non(_) --> [].
adv_ou_non(Adv) --> adve(Adv).

conjc_prep(Conjc) --> conjC(Conjc).
conjc_prep(Prep) --> prepo(Prep).

pron_refl_ou_non(Prfl) --> [].
pron_refl_ou_non(Prfl) --> pronRefl(Prfl).

negation1_ou_pas(_, _) --> [].
negation1_ou_pas(Adv, X) --> negation1(Adv, X).

negation2_ou_pas(_, _) --> [].
negation2_ou_pas(Adv, X) --> negation2(Adv, X).

/* Gestion du nombre */
personne(PersGn, PersGv) :-
	(PersGn = '1'
		-> (PersGv = '1'
			-> !
		; (PersGv = '2'
			-> PersGv is 1,
		   		!
			; (PersGv = '3'
				-> PersGv is 1,
		   			!
				; nl)))
	; (PersGn = '3'
		-> (PersGv = '1'
			-> PersGv is 3,
		   		!
			; (PersGv = '2'
		  		-> PersGv is 3,
		   			!
				; (PersGv = '3'
		   			-> !
					; nl)))
		; (PersGn = '2'
			-> (PersGv = '4'
				-> PersGv is 2,
		   			!
				; (PersGv = '5'
		  			-> PersGv is 2,
		   				!
					; (PersGv = '6'
		   				-> PersGv is 2,
		   					!
						; nl)))
			; (PersGn = '4'
				-> (PersGv = '4'
					-> !
					; (PersGv = '5'
		  				-> PersGv is 4,
		   					!
						; (PersGv = '6'
		   					-> PersGv is 4,
		   						!
							; nl)))
				; !)))).