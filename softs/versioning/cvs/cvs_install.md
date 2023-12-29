## Installation de CVS v1.12.1 release

## Récupérer le source cvs-1.12.1.tar.bz2
```
cp cvs-1.12.1.tar.bz2 /usr/local/src
cd /usr/local/src
tar -xjf cvs-1.12.1.tar.bz2
cd cvs-1.12.1
./configure
make
make install
```

##  l'install place les fichiers dans les répertoies par défaut (linuxement parlant)
/usr/bin, /usr/lib, etc...

##  Créez le dépôt (repository)
```
mkdir /data/cvs
```

##  Initialisez le dépôt
```
cvs -d /data/cvs init
```
ne jamais intervenir dans ce répertoire autrement qu'avec le client cvs.

##  initialiser une variable d'environnement
```
CVSROOT='/data/cvs'
export CVSROOT
```

##  utilisation du serveur a partir d'autres machines

###  Créer le fichier : /etc/xinetd.d/cvspserver
###  ajouter les lignes suivantes
```
service cvspserver
{
port = 2401
disable = no
socket_type = stream
protocol = tcp
wait = no
type = UNLISTED
user = root
group = cvs
env = HOME=/data/cvs
server = /usr/bin/cvs
server_args = --allow-root=/data/cvs -f pserver
}
```
ajouter la ligne suivante (si elle n'existe pas déjà) dans le fichier /etc/services
```
cvspserver 2401/tcp
```

redémarrer le service xinetd
```
cd /etc/rc.d/init.d
./xinetd restart
```

S'il y a plusieurs dépot, refaire la manip. avec un chemin

##  Création des utilisateurs
###  utiliser l'appli apache htpasswd
Pour ajouter un premier utilisateur
```
cd /data/cvs
htpasswd -c passwd nom_de_login
```
le mot de passe est demandé après validation. Pour ajouter d'autres utilisateurs, ne pas utiliser -c. Un fichier passwd est créé et contient une liste de type login:mot_de_passe_crypt

##  Pour accéder au serveur
```
cvs -d :pserver:mon_login@machine:/data/cvs login
```
le mot de passe est demandé après validation,
### une fois connecté
Exécution de commandes...
```
cvs -d :pserver:mon_login@machine:/data/cvs commit -m "SITRPDL" index.php
```

###  Ajouter sur la machine client, une variable environnement pour éviter de taper toute la chaine de connexion
```
CVSROOT='pserver:mon_login@machine:/data/cvs'
export CVSROOT

cvs commit -m "SITRPDL" index.php
```
