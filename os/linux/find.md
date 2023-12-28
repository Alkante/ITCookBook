


# Find


<!-- TOC -->

- [Find](#find)
  - [date](#date)
    - [trouver les derniers fichiers modifies dans une arbo](#trouver-les-derniers-fichiers-modifies-dans-une-arbo)
    - [Liste toutes les modifations de moins de 24 heures concernant les fichiers dans un repertoire](#liste-toutes-les-modifations-de-moins-de-24-heures-concernant-les-fichiers-dans-un-repertoire)
    - [zip entre 2 dates](#zip-entre-2-dates)
    - [tar fichiers recents](#tar-fichiers-recents)
    - [find files dans arbo et tri par date](#find-files-dans-arbo-et-tri-par-date)
  - [Size](#size)
    - [find les fichiers qui ont une taille de 45 octets](#find-les-fichiers-qui-ont-une-taille-de-45-octets)
    - [trouver les plus gros fichiers en octest dans une arbo](#trouver-les-plus-gros-fichiers-en-octest-dans-une-arbo)
    - [sommer le poids des fichiers d'une année:](#sommer-le-poids-des-fichiers-dune-année)
    - [find espace à la racine](#find-espace-à-la-racine)
  - [inodes](#inodes)
    - [compter inodes (espace disque)](#compter-inodes-espace-disque)
    - [effacer par inode](#effacer-par-inode)
    - [find empty dir](#find-empty-dir)
    - [directory index full](#directory-index-full)
  - [perm owner](#perm-owner)
    - [find perm : fichiers pour lesquels le group ne peut écrire](#find-perm--fichiers-pour-lesquels-le-group-ne-peut-écrire)
    - [find fichier appartenant ni à apache ni à ftpuser](#find-fichier-appartenant-ni-à-apache-ni-à-ftpuser)
  - [noms chemins extensions](#noms-chemins-extensions)
    - [suppression de certains types de fichiers](#suppression-de-certains-types-de-fichiers)
    - [find certains types de fichiers png ou htm ou x hexa](#find-certains-types-de-fichiers-png-ou-htm-ou-x-hexa)
    - [find certains types de fichiers 32hexa](#find-certains-types-de-fichiers-32hexa)
    - [find sauf dans certains subdir](#find-sauf-dans-certains-subdir)
  - [chainer find avec d'autres commandes](#chainer-find-avec-dautres-commandes)
    - [find chmod recursif (plus rapide)](#find-chmod-recursif-plus-rapide)

<!-- /TOC -->


## date
### trouver les derniers fichiers modifies dans une arbo
```bash
find app1_mpr/ -printf '%CY%Cm%Cd.%CH%CM %p\n'|sort -n |tail -2
```
### Liste toutes les modifations de moins de 24 heures concernant les fichiers dans un repertoire
find /etc -mtime -1 -ls

### zip entre 2 dates
```bash
find -ctime -86 -a -ctime +71 | zip cvharrys -@
```
### tar fichiers recents
```bash
find . -type f -ctime -3 | xargs tar -T - -czvf /tmp/test.tar
```
### find files dans arbo et tri par date
```bash
find . -printf "%T@ %Tc %p\n" | sort -n
```


## Size

### find les fichiers qui ont une taille de 45 octets
```bash
find * -maxdepth 0 -size 45c
```
### trouver les plus gros fichiers en octest dans une arbo
```bash
find ./ -type f -printf '%s %p\n'|sort -nr |head -10
```

### sommer le poids des fichiers d'une année:
en Ko, en 2016:
```
find uploader/ -printf '%CY_ %k %p\n'|sort -n |awk '/^2016_/ { sum += $2 } END { print sum }'
```

### find espace à la racine
```bash
for i in `find / -mount -maxdepth 1 -type d|egrep -v "proc|srv|home|initrd|mnt|boot|sys|media|dev|/$"`;do du -hs $i;done
```
## inodes
### compter inodes (espace disque)
```bash
for i in `ls -1A`; do echo "`find $i | sort -u | wc -l` $i"; done | sort -rn | head -5
```
### effacer par inode
```bash
find -type f -cmin -5 -exec ls -li {} \;
find . -inum 554094 -exec rm -i {} \;
```
### find empty dir
```bash
find . -type d -empty
```
### directory index full
```bash
find . -type d | while read dir; do n=`find $dir/ -type f -maxdepth 1| grep -c ""`; echo "$n $dir";done | sort -n
```
## perm owner
### find perm : fichiers pour lesquels le group ne peut écrire
```bash
find ! -perm /g+w
```
### find fichier appartenant ni à apache ni à ftpuser
```bash
find www.exemple.com/ \( ! -user ftpuser -a ! -user www-data \)
```

## noms chemins extensions
### suppression de certains types de fichiers
```bash
find /home/mapimage -maxdepth 1 \( -name "*.png" -o -regex '.*/[a-f0-9][a-f0-9]*$' -o -name "*.htm*" \) -exec rm -f {} \;
find -ctime +2 -regextype posix-egrep -regex "^\.\/([0-9]|[a-f]){32}$" -exec rm -f {} \;  
```
### find certains types de fichiers png ou htm ou x hexa
```bash
find /home/mapimage -maxdepth 1 \( -name "*.png" -o -regex '.*/[a-f0-9][a-f0-9]*$' -o -name "*.htm*" \)
```
### find certains types de fichiers 32hexa
```bash
find -ctime +2 -regextype posix-egrep -regex "^\.\/([0-9]|[a-f]){32}$" -exec rm -f {} \;  
```
### find sauf dans certains subdir
```bash
find -type f -name gallery.xml ! -wholename "*Bayeux*"  ! -wholename "*Province*"
```

## chainer find avec d'autres commandes
### find chmod recursif (plus rapide)
```bash
find "${1}" -type f -print0 | xargs -0 -r chmod 660
```
### replace if found
```bash
find etc/ -type f -exec grep -q "${OLD}" "{}" \; -print0 | xargs -0 -r sed -i "s/"${OLD}"/"${NEW}"/g"
```

#### Mise à jour des droits sur les fichiers seulement de manière récursive
```bash
find . -type f -exec chmod 660 \;
```

#### Mise à jour des droits sur les dossiers seulement de manière récursive
```bash
find . -type d -exec chmod 770 \;
```

#### Afficher les inodes des fichiers et dossier
```bash
ls -i
```

#### Suprimer le ficher ou le dossier via l'inode
```bash
find . -inum [inodenumber] -exec rm -i {} \;
```
