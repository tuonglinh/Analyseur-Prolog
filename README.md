#Analyseur-Prolog

##Analyseur syntaxique et sémantique du français en Prolog

###Première partie
En utilisant l'analyseur morphologique écrit en Prolog dans le cadre du mini-projet précédent, concevez dans un premier temps un analyseur syntaxique du français que vous écrirez sous forme d'une DCG. Voici quelques exemples relativement simples de modèles de phrases que vous devriez pouvoir reconnaître :

  - Le chat mange la souris.
  - Le chat tiens la souris.
  - Le chat regarde la souris et le chien mange le poulet.
  - Le grand chat bleu mange la belle petite souris blanche.
  - Le grand chat bleu, qui est très rapide, mange la belle petite souris blanche, qui était pourtant très mignonne.
  - Un grand aviateur malin, qui était très doué, volait rapidement vers le nord.
  - Tous les étudiants de l3 informatique vont quitter Saint-Etienne à la fin de l'année.
 

L'analyseur devra permettre de construire l'arbre syntaxique de la phrase, si celle-ci est correcte.
L'analyseur devra également permettre de vérifier l'accord correct en genre et en nombre au sein d'une phrase. Par exemple les phrases très simples ci-dessous ne doivent pas être acceptées :

  - Le chats mange la souris
  - Le chat mangent la souris
  - le chat mange le souris
  

_ATTENTION_ je ne vous demande pas de reconnaitre exactement ces phrases, mais de définir votre propre lexique, et votre propre grammaire afin de proposer un certain nombre de phrases simples d'abord, puis de plus en plus compliquées, reconnues par votre analyseur.

_ATTENTION_ chaque groupe doit proposer sont propre jeu de démonstration, suffisamment distinct de celui des autres groupes.

La notation tiendra compte de l'éventail de phrases reconnues par votre analyseur syntaxique.

###Deuxième partie
L'étape suivante de ce mini-projet consiste à construire une représentation sémantique de chaque phrase analysée. Vous utiliserez le formalisme des arbres à 3 branches. Il est fort possible que vous ayez à imaginer des arbres que je n'ai pas montré en cours pour traiter les situations particulières de certaines phrases particulières.

Là aussi la notation tiendra compte du nombre de situations générales et particulière traitées par votre analyseur sémantique.

###Troisième partie (épreuve de créativité)
L'étape ultime de ce mini-projet consiste à imaginer (et implémenter) une petite application utilisant la représentation sémantique des phrases traitées par votre analyseur. L'application est libre, elle doit montrer l'intérêt de construire des représentations sémantiques des phrases. Vous pouvez vous inspirer des applications évoquées en cours, mais également imaginer votre propre application, démontrant ainsi votre grandre créativité ! 
