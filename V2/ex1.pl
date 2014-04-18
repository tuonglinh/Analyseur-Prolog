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
gn(groupe_nominale(Det, Adj, Adj2, Nom, Compl)) --> dete(Det, Personne), adje_ou_non(Adj, Personne), nom(Nom, Personne), adje_ou_non(Adj2, Personne), complement_ou_non(Compl).


/* Groupe verbal */
gv(groupe_verbal(Verb, Gn)) --> verbe(Verb, _, _, _), gn_ou_non(Gn).
gv(groupe_verbal(Aux, Pps, Gn)) --> aux(Aux, _, _, _), pp(Pps, _, _, _), gn(Gn).
gv(groupe_verbal(Verb, Inf, Gn)) --> verbe(Verb, _, _, _), verbe(Inf, _, _, inf), gn(Gn).

/* Les dérivés */
gn_ou_non(_) --> [].
gn_ou_non(Gn) --> gn(Gn).

/*adjes_ou_non(Adj, Personne) --> adje_ou_non(Adj, Personne).*/
/*adjes_ou_non(Adj, Adj2, Personne) --> adje(Adj, Personne), adje(Adj2, Personne).*/

adje_ou_non(_, _) --> [].
adje_ou_non(Adj, Personne) --> adje(Adj, Personne).

complement_ou_non(_) --> [].
complement_ou_non(ConjcPrep, Gn) --> conjc_prep(ConjcPrep), gn(Gn).
complement_ou_non(Prl, Phrase) --> p_relatif(Prl), phrase(Phrase).

conjc_prep(Conjc) --> conjC(Conjc).
conjc_prep(Prep) --> prepo(Prep).