encoding('utf8').
:- [mots].
:- [terminaisons].
:- [conjs].

analyse(X,MotCanonique,Categorie,Groupe,Personne) :- 
	name(X,LX),
	append(LX1,LX2,LX),
	append(LX3,LX4,LX1),
	name(Auxiliaire,LX3),
	name(Racine,LX4),
	name(Term,LX2),
	mot(MotCanonique,NumRacine,Racine,Conj,Categorie),
	conjugaison(Conj,Groupe,IdTerm,Personne,NumRacine,Auxiliaire),
	terminaison(IdTerm,Term,Personne).

affiche_analyse(X) :-
	(\+analyse(X,MotCanonique,Categorie,Groupe,Personne)
	-> write('Aucune analyse pour ce mot')
	; analyse(X,MotCanonique,Categorie,Groupe,Personne),
		write(X),
		write(' : '),
		write(Categorie),
		write(', '),
		write(MotCanonique),
		(Categorie \= 'Conjonction de coordination'
		-> write(', '),
			write(Groupe)
		; write('')),
		(Categorie = 'verbe'
		-> (Personne = 1
			-> write(', première personne du singulier.')
			; Personne = 2
			-> write(', deuxième personne du singulier.')
			; Personne = 3
			-> write(', troisième personne du singulier.')
			; Personne = 4
			-> write(', première personne du pluriel.')
			; Personne = 5
			-> write(', deuxième personne du pluriel.')
			; Personne = 6
			-> write(', troisième personne du pluriel.'))
		; write('.')),
	nl).

genere(X,MotCanonique,Categorie,Groupe,Personne) :-
	conjugaison(Conj,Groupe,IdTerm,Personne,NumRacine,Auxiliaire),
	mot(MotCanonique,NumRacine,Racine,Conj,Categorie),
	terminaison(IdTerm,Term,Personne),
	name(Auxiliaire,LA),
	name(Racine,LR),
	name(Term,LT),
	append(LA,LR,LX1),
	append(LX1,LT,LX),
	name(X,LX).