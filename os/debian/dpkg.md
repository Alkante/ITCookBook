# dpkg
Désinstaller proj sans enlever sa dépendance postgresql-8.1-postgis
```bash
dpkg -P --ignore-depends=postgresql-8.1-postgis proj
Installer tous les deb du répertoire /!\ dépendances
dpkg -iR java/
```

## force remove
```bash
apt-get --force-yes remove wkhtmltox
```

## voir les options de complilation du package
```bash
apt-get source proftpd
tar -xzvf proftpd-dfsg_1.3.1.orig.tar.gz
vi proftpd-dfsg-1.3.1/debian/rules
```

# apt-file
apt-file permet de rechercher un paquet en fonction d'un fichier qu'il contient et inversement
La recherche se fait sur toutes paquets et tous les dépôts (donc incluant ceux non intallées).

## Installer
```bash
apt-get install apt-file
```
## Usage

### Update des listes des fichiers/paquets
Cette command ne fonctionne qu'avec les dépôts fournisants les "Content file".
Si il n'y en a pas, le dépôt est ignoré.
```bash
apt-file update
```
Cette commande est necessaire pour avoir une liste de rechercher à jour.
Astuce : n'oublier par d'updater la liste de recherche pour qu'elle soit à jour.

### Trouver à quel paquet apartient ce fichier (RegEx)
```bash
apt-file search 'fstab'
```

### Lister le contenu des fichiers d'un paquet (même non installer)
```bash
apt-file list vim
```

### List initial des packets initialés ###
```bash
gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u
```
### backup/restore des des paquets
#### export
```bash
dpkg --get-selections > liste-des-paquets
```
#### restore
```bash
dpkg --set-selections < liste-des-paquets
apt-get -u dselect-upgrade
```

# apt-mark
### Afficher la list des paquets marqués installés manuellement
```bash
apt-mark showmanual
```

### Afficher la list des paquets marqués installés automatiquement
```bash
apt-mark showauto
```

### Afficher la list des paquets marqués vérouillés
```bash
apt-mark showhold
```

### bloquer la maj d'un paquet
```bash
echo bacula-fd hold | dpkg --set-selections
```

### Marquer un parquet comme manuel (match hard | match renenerique Ex: 'server*')
```bash
apt-mark manuel 'vim'
```

### Marquer un parquet comme auto (match hard | match renenerique Ex: 'server*')
```bash
apt-mark auto 'vim'
```

### Vérouiller un paquet (ne peut pas être isntaller automatiquement, upgrade ou désinstallé)
```
apt-mark 'vim'
#or cf: dkpg --set-selections
```

### Dévérouiller un paquet
```bash
apt-mark unhold 'vim'
```
### Date de la premier install (si le log rotate n'a pas effacer)
```
apt-mark showmanual | sort -ucat /var/log/dpkg.log | grep "\ install\ " | head -1 | cut -d" " -f1
awk '/ install / {print $1}' /var/log/dpkg.log | head -1
```
# apt-rdepends
Ce programme permet de générer des graphiques de dépendances de packet visualisable avec dotty.

## Génération du graphe
```bash
apt-rdepends -d tcpdump | dot > tcpdump.dot
```

## Affichage du graphe
```bash
dotty tcpdump.dot
```

# apt-cache

### Rechercher un paquet (Match générale dans le nom et la description du paquet)
```bash
apt-cache search 'vim'
```

### Rechercher un paquet (Match générale dans le nom)
```bash
apt-cache search -n 'vim'
```

### Afficher les informations de cache d'un paquet (match hard)
```bash
apt-cache show 'vim'
```
ou cf: dpkg --print-avail

### Afficher les informations détaillées d'un paquet (match hard)
```bash
apt-cache showpkg 'vim'
```

### Liste des paquets disponibles
```bash
apt-cache dumpavail 'vim'
```

### Affiche des informations détaillées du paquet
```bash
apt-cache showpkg 'vim'
```


### Affiche des informations sur la version et le dépot utilisé
```bash
apt-cache madison 'vim'
```

## contenu du paquet
### Trouver responsable du fichier (paquet)
```bash
dpkg -S /etc/xen
```
Resultat : xen-utils-common
```bash
dpkg -S '\/etc\/fstab'
```

### List des fichiers liées à un paquet installé
```bash
cat /var/lib/dpkg/info/MONPAQUET.list
```

### Réinstaller le parquet en regénérant les fichier de configuration ###
```bash
apt-get -o Dpkg::Options::="--force-confmiss" install --reinstall xen-utils-common
```
ou avec dpkg :
```bash
dpkg -i --force-confmiss xen-utils-common
```

## extraire un deb
```bash
ar vx mypackage.deb
```

## extraction de fichiers sans install
extraire dans le dossier courant ./
```bash
dpkg-deb -x wkhtmltox-0.12.1_linux-wheezy-i386.deb ./
```

## recompose deb
```bash
ar r bacula-fd_5.0.2-2.2+squeeze1_amd64_modcustom.deb debian-binary control.tar.gz data.tar.gz
```

## Liste le contenu d'un paquet deb.
```bash
dpkg-deb -c paq.deb
```
### Affiche la liste des fichiers installés qui appartiennent à paquet
```bash
dpkg-query -L paq
```
## Affiche le(s) champ(s) de contrôle d'un paquet.
```bash
dpkg-deb -f paq.deb
```

## download package only
```
apt-get -d install nagios-plugins-contrib

```
le deb est dans téléchargé dans /var/cache/apt/archives/

# depot
## keys
pb d'ID key lors de apt-get update
```bash
apt-get install debian-keyring debian-archive-keyring
```
## pb GPG PUBKEY
```bash
gpg --keyserver pgpkeys.mit.edu --recv-key XXXXXXXXXxXXXXX
gpg -a --export XXXXXXXXXxXXXXX | apt-key add -
```
## pb Release expiration
E: Le fichier Release a expiré, http://archive.debian.org/debian/dists/squeeze-lts/Release ignoré (non valable depuis 302d 18h 47min 5s)
```bash
echo 'Acquire::Check-Valid-Until "false";' >/etc/apt/apt.conf.d/90ignore-release-date
```
## ajout DVD dans apt
```bash
apt-cdrom add
```
## Créer un mini dépôt
tous les deb contenus dans le dossier java
```bash
dpkg-scanpackages java /dev/null | gzip -9c > java/Packages.gz
```
et ajouter dans sources.list deb file:/mnt/hdusb/java/ ./
```bash
apt-get update
```



## lenny backports
```bash
echo "deb http://archive.debian.org/debian-backports/ lenny-backports main contrib non-free" >> /etc/apt/sources.list
gpg --keyserver pgpkeys.mit.edu --recv-key YYYYYYYYYYYYY
gpg -a --export YYYYYYYYYYYYY | apt-key add -
```

## apt pinning
### ajout depot
depot normal
```
deb http://ftp.us.debian.org/debian/ lenny main contrib non-free
deb http://security.debian.org/ lenny/updates main contrib non-free
```
ajout Sid / Unstable pour mapserver

```
deb http://ftp.us.debian.org/debian unstable main non-free contrib
```
### regler le pinning
dans  /etc/apt/preferences:
```bash
Package: *
Pin: release a=stable
Pin-Priority: 700
Package: *
Pin: release a=testing
Pin-Priority: 650
Package: *
Pin: release a=unstable
Pin-Priority: 600
```
```bash
apt-get update
```
installer en choisissant un depôt
#### voir les règles de pinning
```bash
apt-cache policy mapserver-bin
```
#### installer le paquet du depôt instable sans les dépendances d'instable
```bash
apt-get install mapserver-bin/unstable
```
#### installer le paquet du depôt instable avec les dépendances d'instable
```bash
apt-get -t unstable install mapserver-bin
```

## Notes
### multiarch
http://wiki.debian.org/IntroDebianPackaging
http://blogs.nologin.es/rickyepoderi/index.php?/archives/68-Debian-Multiarch.html

### ppa
```bash
add-apt-repository ppa:ubuntugis/ppa
apt-get update
apt-get install qgis
```

## Installer un paquet avec une pré-configuration
```bash
echo "<CONFIG_DU_PAQUET>" | debconf-set-selections
apt-get install -y -q --force-yes <PAQUET>
```
Exemple :
```bash
echo "apt-cacher apt-cacher/mode select	daemon" | debconf-set-selections
apt-get install -y -q --force-yes apt-cacher
```
### Trouver la configuration
On a besoin de ```debconf-get-selections``` qui se trouve dans ```debconf-utils```
```bash
apt-get install debconf-utils
```
Puis on cherche la conf :
```bash
debconf-get-selections|grep <PAQUET>
```
