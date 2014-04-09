#!/usr/bin/perl
use strict;
use warnings;
use Encode;
use utf8;


sub dico {
	open IN,"<dela-fr-public-u8.dic.xml" or die $!;
	open DIC_OUT,">>mots.pl" or die $!;
	open DIC_CONJS_OUT,">>conjs.pl" or die $!;
	open DIC_TERMS_OUT,">>terminaisons.pl" or die $!;

	my $doc = "";
	while (<IN>)
	{
		chomp $_;
		$doc .= decode("utf8","$_");
	}
	my @doct = split /<\/entry>/,$doc;

	my %h_mots = ();

	foreach my $entry (@doct)
	{
		my %h_derivation = ();
		my %h_types = ();
		my @t = split /<\/lemma>/,$entry;
		next unless ($#t == 1);

		# $t[0] contient le mot en fin de ligne.
		# $t[1] contient le type du mot, et les formes dérivées.
		my $mot = $1 if ($t[0] =~ m#<lemma>([^ '\d\\]+)$#);
		next unless $mot;
		# Si il y a un simple-quote dans le mot ou un chiffre ou un espace, on ne le référence pas.
		$mot =~ s/\\//;
		$h_mots{$mot} = \%h_types unless $h_mots{$mot};

		my $type;
		$type = $1 if ($t[1] =~ m#<pos name='([^ ']+)'/>#);
		next unless $type;
		next unless ($type eq "noun" || $type eq "adj" || $type eq "adverb"
			|| $type eq "conjc" || $type eq "det" || $type eq "pronoun" );
		# On ne garde que les adjectifs, les noms, les adverbes et les conjonctions de coordinations, les déterminants, les pronoms.
		$h_mots{$mot}{$type} = \%h_derivation unless $h_mots{$mot}{$type};
		
		my @inflecteds = split /<\/inflected>/,$entry;

		foreach my $inflected (@inflecteds) {

			my $derivation = $1 if ($inflected =~ m/<form>([^<]+)<\/form>/);
			$derivation =~ s/\\//;

			my $genre = $1 if ($inflected =~ m/<feat name='gender' value='([^ ']+)'\/>/);
			my $nombre = $1 if ($inflected =~ m/<feat name='number' value='([^ ']+)'\/>/);
			$genre = "" unless $genre;
			$nombre = "" unless $nombre;

			$h_mots{$mot}{$type}{$derivation." ! ".$genre." ! ".$nombre} = 1 unless $h_mots{$mot}{$type}{$derivation."#".$genre."#".$nombre};
		}
	}


		# mot(MotCanonique,NumRacine,Racine,Conj,Categorie),
		# conjugaison(Conj,Groupe,IdTerm,Personne,NumRacine,Auxiliaire),
		# terminaison(IdTerm,Term,Personne).
	my %h_terms = ();
	my $nombre_terms = 0;
	# En clef la terminaison en valeur son numéro (nb éléments dans la table au moment de l'ajout).
	# $h_terms{""} = 0;

	my %h_conjs = ();
	# Clef = personne, idTerm, NumRacine. Valeur = IdConj (nb éléments dans la table au moment de l'ajout).
	$h_conjs{"0 0 1"} = 0;

	my %prolog_mots = ();
	my %prolog_conjs = ();
	my %prolog_terms = ();
	$prolog_conjs{"conjugaison(d0, '', d0, 0, 0, '')."} = 1; # Ici on se fiche de la valeur.
	$prolog_terms{"terminaison(d0, '', 0)."} = 1; # Ici on se fiche de la valeur.

	while (my ($mot,$v) = each %h_mots)
	{	
	 	while (my ($type,$vv) = each %$v)
	 	{
	 		my %h_racines = (); # Clef = racine, valeur = numRacine.

			my %temph = %$vv;
			my @derivEtcT = keys %temph;
			foreach my $derivEtc (@derivEtcT) {
				my @tempt = split / ! /,$derivEtc;
				my $deriv = $tempt[0];

				print $deriv."\n";

				my $genre_et_nombre = "";
				$genre_et_nombre = $tempt[1]." ".$tempt[2] if ($tempt[1] and $tempt[2]);

				my $racine = "";
				my $term = "";
				my $mot_cpy = $mot;
				# On fait progresser la racine tant qu'elle reste racine de la dérivation.
				while ($deriv =~ m/^$racine.*/ and $racine ne $mot)
				{
					$racine .= substr($mot_cpy, 0, 1, '');
				}

				# Là on a un caractère en trop. Ou bien on est à la fin du mot.
				# my $r = substr $racine,0,-1;
				if ($deriv eq $mot) {
					$h_racines{$deriv} = scalar(keys %h_racines) unless $h_racines{$deriv};
				} else {
					chop $racine;
					$h_racines{$racine} = scalar(keys %h_racines) unless $h_racines{$racine};
				}

				$term = $1 if $deriv =~ m/^$racine(.*)/;
				$term =~ s/\\//g;
				if ($term ne "") {
					$h_terms{$term} = $nombre_terms++ unless $h_terms{$term};
				} else {
					$term = "-";
					$h_terms{$term} = $nombre_terms++ unless $h_terms{$term};
				}

				if ($type eq 'adverb') {
					# Dans ce cas la conjugaison exist déjà, c'est 0. Idem pour la terminaison.
					my $s = "mot('".encode("utf8","$mot")."', ".$h_racines{$racine}.", '".encode("utf8","$racine")."', d0, 'adverbe').";
					$prolog_mots{$s} = 1 unless $prolog_mots{$s};
				} elsif ($type eq 'conjc') {
					my $s = "mot('".encode("utf8","$mot")."', ".$h_racines{$racine}.", '".encode("utf8","$racine")."', d0, 'Conjonction de coordination').";
					$prolog_mots{$s} = 1 unless $prolog_mots{$s};
				} else {
					# Ici il faut vérifier et trouver le numéro de terminaison.
				
					my $personne = 1;
					$personne = 2 if ($genre_et_nombre eq 'masculine plural');
					$personne = 3 if ($genre_et_nombre eq 'feminine singular');
					$personne = 4 if ($genre_et_nombre eq 'feminine plural');

					my $groupe = "Masculin Singulier";
					$groupe = "Masculin Pluriel" if ($genre_et_nombre eq 'masculine plural');
					$groupe = "Feminin Singulier" if ($genre_et_nombre eq 'feminine singular');
					$groupe = "Feminin Pluriel" if ($genre_et_nombre eq 'feminine plural');

					my $type_m = "nom";
					$type_m = "adjectif" if ($type eq "adj");
					$type_m = "conjonction de coordination" if ($type eq "conjc");
					$type_m = "pronom" if ($type eq "pronoun");
					$type_m = encode("utf8","déterminant") if ($type eq "det");

					$h_conjs{$personne." ".$h_terms{$term}." ".$h_racines{$racine}} = scalar(keys %h_conjs) unless $h_conjs{$personne." ".$h_terms{$term}." ".$h_racines{$racine}};

					my $id_conj = $h_conjs{$personne." ".$h_terms{$term}." ".$h_racines{$racine}};
					my $id_term = $h_terms{$term};
					my $string_mot = "mot('".encode("utf8","$mot")."', ".$h_racines{$racine}.", '".encode("utf8","$racine")."', d$id_conj, '$type_m').";
					$prolog_mots{$string_mot} = 1 unless $prolog_mots{$string_mot};

					my $string_conj = "conjugaison(d$id_conj, '$groupe', d$id_term, $personne, ".$h_racines{$racine}.", '').";
					$prolog_conjs{$string_conj} = 1 unless $prolog_conjs{$string_conj};

					if ($term ne "-") {
						my $string_term = "terminaison(d$id_term, '".encode("utf8","$term")."', $personne).";
						$prolog_terms{$string_term} = 1 unless $prolog_terms{$string_term};
					} else {
						my $string_term = "terminaison(d$id_term, '', $personne).";
						$prolog_terms{$string_term} = 1 unless $prolog_terms{$string_term};
					}
				}
			}
		}
	}

	my @tpm = sort(keys %prolog_mots);
	foreach my $x (@tpm) {
		print DIC_OUT $x."\n";
	}

	my @tpc = sort(keys %prolog_conjs);
	foreach my $x (@tpc) {
		print DIC_CONJS_OUT $x."\n";
	}

	my @tpt = sort(keys %prolog_terms);
	foreach my $x (@tpt) {
		print DIC_TERMS_OUT $x."\n";
	}

	close IN;
	close DIC_OUT;
	close DIC_CONJS_OUT;
	close DIC_TERMS_OUT;
}

sub verbs {
	open WORDS,"<mots" or die $!;
	open CONJS,"<conjugaisons" or die $!;
	open W_OUT,">mots.pl" or die $!;
	open C_OUT,">conjs.pl" or die $!;

	my %words = ();
	my %conjs = ();

	# On charge les fichiers de mots et de conjugaisons pour pouvoir associer
	# les auxiliaires à la conjugaison plutôt qu'àla racine directement.

	# Chargement du fichier de mots.
	while (<WORDS>) {
		chomp $_;
		my @a         = split /[ ]+/,encode("utf8",$_),2;
		my @t         = split /[ ]+/,$a[1];
		$words{$a[0]} = \@t;
	}

	# Chargement du fichier de conjugaison.
	while (<CONJS>) {
		chomp $_;
		my @a = split /[ ]+[#][ ]+/,encode("utf8",$_),2;
		my @t = split /[ ]+[#][ ]+/,$a[1];
		
		my %h = ();
		foreach my $x (@t) {
			my @sx     = split /[ ]+/,$x,2;
			my @ltr    = split /[ ]+/,$sx[1];
			$h{$sx[0]} = \@ltr;
		}
		$conjs{$a[0]}  = \%h;
	}

	my %new_words = ();
	my %new_conjs = ();

	while (my ($k,$v) = each(%words)) {
		# $k contient un mot.
		# @$v est un tableau contenant le type du mot, la conjugaison associées et les racines du mot.
		# $v[0] contient le type du mot.
		# $v[1] contient le numéro de conjugaison associée au mot.
		my $num_racine = 1;
		my $mot_canonique = $k;
		my $type = shift @$v;
		my $id_conjugaison = shift @$v;

		# tableau qui converti l'ancien numero de racine vers le nouveau.
		my @convert_old_new_num_racine = (0);
		#tableau contenant les auxiliaires. L'indice correspond à l'ancien numéro de racine.
		my @t_auxiliaire = ('');
		
		#@$v ne contient plus que les racines du mot.
		foreach my $x (@$v) {
			my $racine = "";
			my $auxiliaire = "";

			if ($x =~ m/_/) {
				my @xx = split /_/,$x;
				unless ($x =~ m/_$/) {
					$racine = pop @xx;
					foreach my $xxx (@xx) {
						$auxiliaire .= $xxx." ";
					}
				} else {
					$racine = "";
					foreach my $xxx (@xx) {
						$auxiliaire .= $xxx." ";
					}
				}
			} else {
				$auxiliaire = "";
				$racine = $x;
				if ($racine eq "NULL") {
					$racine = "";
				}
			}

			unless (exists $new_words{$mot_canonique." ".$racine}) {
				unless ($racine eq "-") {
					$new_words{$mot_canonique." ".$racine} = "mot('$mot_canonique', $num_racine, '$racine', $id_conjugaison, '$type').\n";
					push @convert_old_new_num_racine, $num_racine;
					push @t_auxiliaire, $auxiliaire;
					++$num_racine;
				} else {
					push @convert_old_new_num_racine, -1;
					push @t_auxiliaire, $auxiliaire;
				}
			} else {
				push @convert_old_new_num_racine, ($num_racine - 1);
				push @t_auxiliaire, $auxiliaire;
			}
		}

		my $h_temps = $conjs{$id_conjugaison};
		while (my ($temps,$w) = each (%$h_temps)) {
			# $temps contient le temps.
			# $w contient un tableau avec l'identifiant de la terminaison et le liste des racines.
			$temps =~ s/_/ /g;
			my @ww = @$w;
			my $id_term = shift @ww;

			my $personne = 1;
			foreach my $old_num_racine (@ww) {
				# On veut récupéré le NOUVEAU numéro de racine ET l'auxiliaire.
				my $new_num_racine = $convert_old_new_num_racine[$old_num_racine];
				my $aux = "";
				$aux = $t_auxiliaire[$old_num_racine];
				unless ($new_num_racine) {
					$new_num_racine = 1;
				}
				if ($new_num_racine != -1) {
					if ($aux) {
						$new_conjs{"conjugaison($id_conjugaison, '$temps', $id_term, $personne, $new_num_racine, '$aux').\n"} = 1;
					} else {
						$new_conjs{"conjugaison($id_conjugaison, '$temps', $id_term, $personne, $new_num_racine, '').\n"} = 1;
					}
					++$personne;
				}
			}
		}
	}

	my @t = values %new_words;
	my @tt = sort @t;
	while (@tt) {
		print W_OUT shift @tt;
	}

	my @u = keys %new_conjs;
	my @uu = sort @u;
	while (@uu) {
		print C_OUT shift @uu;
	}

	close WORDS;
	close W_OUT;
	close CONJS;
	close C_OUT;

	open TERMS,"<terminaisons" or die $!;
	open T_OUT,">terminaisons.pl" or die $!;

	while (<TERMS>)
	{
		chomp $_;
		my @line = split / /,encode("utf8",$_);
		my $id_term = shift @line;
		my $personne = 1;
		foreach my $term (@line) {
			if ($term eq "NULL") {
				$term = "";
			}
			print T_OUT "terminaison($id_term, '$term', $personne).\n" unless ($term eq '-');
			++$personne;
		}
	}

	close TERMS;
	close T_OUT;
}

&verbs();
&dico();