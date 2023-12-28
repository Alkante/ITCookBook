
# make

## Installation
```bash
apt-get update
apt-get install make
```


## Construction du Makefile

la commande make appelle/recherche automatiquement le fichier nommé 'Makefile' ou 'makefile' dans le répertoire courant.
Le makefile exécutant les commandes qu'elle contient en fonction de règle.
Les règles s'écrivent sous la forme :

```make
cible : dépendances_1 dépendances_2 ...
	commande 1
	commande 2
	...
```

les commandes sont précédées d'une tabulation et non d'espaces.
C'est très important.
Il est conseillé d'avoir un éditeur de texte affichant clairement les tabulations.

## Exécution simple

Le makefile est toujours exécuté en appelant une cible.
Si aucune n'est appelé, c'est la première cible qui est traité.
Si le makefile suis les best practices, la première cible s'appelle 'all'.

Exécution sans préciser la cible/
```bash
make
```

Appeler la cible all
```bash
make all
```

## Fonctionnemment
Quand une cible est appelé.
Ses dépendances sont considérés comme des fichiers.
Si le fichier dépendances_1 n'existe pas, il exécute la cible appelé dépendances_1 et attend sont retour.
Normalement, la cible dépendances_1 contruira le fichier dépendances_1.

Ensuite, il considère la cible comme un fichier.
Si ce dernier est plus récent que les dépendances il exécute les commandes.
Idem, ces commandes vont normalement construire le fichier ayant le nom de la cible.
Sinon, si tous les fichiers existes déjà et que le fichier ayant le nom de la cible est le plus vieux,
alors il n'y a rien à faire. 

Normal, si les fichiers sources n'ont pas été modifié depuis la dernière compilation, inutile de les recompiler.


## Commandes usuels

Les commandes suivantes ne sont valables que si le programmeur ayant fait le makefile a suivie les best practices.

### Compiler
La première cible (cible exécuté par défaut) est, en général, 'all'
```bash
make
```
Équivaux à 
```bash
make all
```

### Afficher l'aide
```bash
make help
```

### Installer
```bash
make install
```

### Netoyer/Supprimer les fichers de compilation
Ces fichiers correspondent au *.o en programme C?
```bash
make clean
```

### Netoyer/Supprimer tous les fichiers, dossiers et configuration de la compilation
Ces fichiers correspondent à tout les fichiers générés par le makefile, l'exécutable (le binaire) est parfois inclue dans la suppression.
```bash
make proper:w

```

