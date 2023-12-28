# Compression, décompression et archivage



## Différence entre archivage et compression

La compression et l'archivage sont différents mais complémentaires.

La compression permet de diminuer la taille d'un fichier en le réécrivant.
Le principe de compression repose sur la redondance des données.
Ainsi, plus un fichier est redondant plus il est compressible.
Les fichiers les moins redondant sont les films, les musiques et les images puisqu'ils sont déjà encodés par un algorithme de compression qui leur est spécifique.



L'archivage permet de regrouper les fichiers en un seul.
Il y a de nombreux avantages à utiliser qu'un fichier :
* Il est plus facile à transmettre puisque le transfert de nombreux petit fichier sur le réseau peut prendre du temps à cause de la difficulté d'utilisation de la couche tcp.
	Les principaux programmes scp, srync, ... transfert les fichiers de manière séquentielle en envoyant des requêtes à chaque début et fin d'écriture de fichier, faisant exploser le temps de téléchargement.
* L'archivage améliore la compression parceque la redondance est plus élevée si la compression se fait sur l'ensemble des fichiers et non sur chaque fichier indépendament les un des autres.
	Donc, normalement les fichiers sont archivés puis compressés.

Les algorithmes de compression sont comparées sur plusieurs critères :
* Ratio de compression (en fonction du type de fichier)
* Vitesse de compression
* Vitesse de décompression

Liste :
- tar
- Gzip
- Bzip2
- ZIP
- Lzma2(7z)
- RAR


| Capacités et disponibilité  | Ordre     |
| --------------------------------------- | ----------------------------- |
| Vitesse de décompression (vite > lent)  | gzip, zip > 7z > rar > bzip2  |
| Vitesse de compression  (vite > lent)   | gzip, zip > bzip2 > 7z > rar  |
| Ratio de compression (meilleur > pire)  | 7z > rar, bzip2 > gzip > zip  |
| Disponibilité (unix)                    | gzip > bzip2 > zip > 7z > rar |
| Disponibilité (windows)                 | zip > rar > 7z > gzip, bzip2  |



## Compression/Décompression #################################

| Extention | Type | Compression | Décompression |
|---- |---- | ---- |---- |
|.tar.gz | tar gzip | ```tar czvf archive.tar.gz fichier1 fichier2``` | ```tar xzvf archive.tar.gz``` |
|.gz | gzip | ```gzip fichier1``` | ```gzip fichier1.gz``` |
|.tar.bz2 | tar bzip2 | ```tar cjvf archive.tar.bz2 fichier1 fichier2``` | ```tar xjvf archive.tar.bz2``` |
|.bz2 | bzip2 | ```bzip2 -v fichier1 fichier2``` | ```bzip2 -d fichier1.bz2``` |
|.tar.xz | tar lzma2 | ```tar cJvf archive.tar.xz fichier1 fichier2``` | ```tar xJvf archive.tar.xz``` |
|.xz | lzma2 | ```xz -k9 fichier1``` | ```xz -d fichier1.xz``` |
|.zip | ZIP | ```zip archive archive.zip fichier1 fichier2``` ou ```zip archive -r archive.zip dossier```  | ```unzip archive.zip``` ou ```unzip archive.zip -d dossier_de_reception```|



## ZIP options

### zip password
```bash
zip -P password file.zip file
```
### zip recursive
```bash
zip -r name_of_your_directory.zip name_of_your_directory
```


## Master Tricks

### compression d'un repertoire, exclusion avec exclude.txt, découpage en multi
```bash
tar cvzX /home/bak/exclude.txt  . | split -a 3 -b 500000000 - /home/bak/backup.tar.gz-
tar cvzX tar/exclude.txt  tar/ | split -d -b 50MB - backup.tar.gz-
```
Pour reconstituer:
```
cat backup.tar.gz-* > backup.tar.gz
```

### creation archive avec motif d'exclusion
```bash
tar -cvf /tmp/test.tar --exclude 'dns' /home/statistiques/configuration/
tar -czvf client1.tgz --exclude=client1/upload --exclude=CVS client1/
```

### archivage des fichiers recents
```bash
find /home/www/queue/upload/log/ -type f -ctime -1 | xargs tar -T - -czvf /home/share/upload/log/log`date '+%y%m%d-%H%M'`.tar.gz
```

### creation avec liste d'inclusion
```bash
tar -T liste3 -czvf statwin.tgz
```

### extraction en perdant les permissions
```bash
tar --no-same-perm --no-same-owner -xzvf client1.tgz
```

### ajout de fichiers a la fin de test.tar
```bash
tar -v --append --file=/tmp/test.tar /home/statistiques/scripts/
```

### zip entre 2 dates
```bash
find -ctime -86 -a -ctime +71 | zip cvharrys -@
```

### tar fichiers recents
```bash
find . -type f -ctime -3 | xargs tar -T - -czvf /tmp/test.tar
```


### couper un fichier
```bash
split -a 1 -d -b 40MB app1_1.0.0.tar.gz app1_1.0.0.tar.gz.
for i in app1_1.0.0.tar.gz.*; do cat $i >> app1_1.0.0.tar.gz;done
```
