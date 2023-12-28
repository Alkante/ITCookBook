# grep


## Chercher un motif dans les fichiers d'un dossier et dans ses sous dossier:

-r, --recursive : recherche dans les sous dossiers

```bash
egrep -r 'patate' .
```


## La tabulation n'existe pas pour les regex POSIX donc utiliser :
```bash
egrep $'\t' exemple.txt   
```
ou dans une expression
```bash
egrep 'XXXX'$'\t''XXXX' exemple.txt
```
ou sous bash " ctrl+v <tab> " (ne marche pas en mode copier/coller car les tabulation deviennent des espaces)


## Advanced

Trouver une chaine dans un arborescence de fichiers
```bash
find /DIRECTORY -type f -exec grep -il 'STRING' {}  \;
```
