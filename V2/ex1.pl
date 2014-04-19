:- [mots].

/* Récupération des données pour la grammaire */
dete('déterminant'(X), Personne) --> [X], {det(X, Personne, _, _)}.
adje(adjectif(X), Personne) --> [X], {adj(X, Personne, _, _)}.
nom(noun(X), Personne) --> [X], {noun(X, Personne, _, _)}.
verbe(verb(X), Personne, MotCanonique, Temps) --> [X], {verb(X, Personne, MotCanonique, Temps)}.
conjC(conjonctionCoordination(X)) --> [X], {conjc(X, _, _, _)}.
prepo('préposition'(X)) --> [X], {prep(X, _, _, _)}. 
p_relatif(pronomRelatif(X)) --> [X], {prelat(X, _, _, _)}.
pron_pers(pronomPersonnel(X), Personne) --> [X], {ppers(X, Personne, _, _)}.
pron_refl(pronomReflechi(X)) --> [X], {prefl(X, _, _, _)}.
adve(adverbe(X)) --> [X], {adverb(X, _, _, _)}.

aux(auxiliaire(X), Personne, _, Temps) --> [X], {verb(X, Personne, avoir, Temps)}.
aux(auxiliaire(X), Personne, _, Temps) --> [X], {verb(X, Personne, 'être', Temps)}.

pp('participe_passé'(X), Personne, _, Temps) --> [X], {verb(X, Personne, _, ppast)}.


/* Grammaire */
phrase(sentence(Gn, Gv)) --> gn_ou_non(Gn), gv(Gv).


/* Groupe nominal */
gn(groupe_nominale(Det, Adj, Conjc, Adj2, Nom, Adj3, Conjc2, Adj4)) --> dete(Det, Personne), adje_ou_non(Adj, Conjc, Adj2, Personne), nom(Nom, Personne), adje_ou_non(Adj3, Conjc2, Adj4, Personne).


/* Groupe verbal */
gv(groupe_verbal(Verb, Gn)) --> verbe(Verb, _, _, _), gn_ou_non(Gn).
gv(groupe_verbal(Aux, Adv, Pps, Gn)) --> aux(Aux, _, _, _), adv_ou_non(Adv), pp(Pps, _, _, _), gn_ou_non(Gn).
gv(groupe_verbal(Verb, Adv, Inf, Gn)) --> verbe(Verb, _, _, _), adv_ou_non(Adv), verbe(Inf, _, _, inf), gn_ou_non(Gn).

/* Les dérivés */
gn_ou_non(Gn) --> gn(Gn).
gn_ou_non(_) --> [].

adje_ou_non(_, _, _, _) --> [].
adje_ou_non(Adj, _, _, Personne) --> adje(Adj, Personne).
adje_ou_non(Adj, Conjc, Adj2, Personne) --> adje(Adj, Personne), conjC(Conjc), adje(Adj2, Personne).


adv_ou_non(_) --> [].
adv_ou_non(Adv) --> adve(Adv).

conjc_prep(Conjc) --> conjC(Conjc).
conjc_prep(Prep) --> prepo(Prep).