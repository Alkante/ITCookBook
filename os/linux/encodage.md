# renommage du nom de fichier
## changement d'encodage
from iso to utf
```
convmv -f iso-8859-1 -t utf-8 -r $1/ --notest 2>&1 >> $LOG
```
## on vire les accents
```
find $1/ -depth -execdir rename -v 's/é|è|ë|ê/e/g' "{}" \;
find $1/ -depth -execdir rename -v 's/à|â|ä/a/g' "{}" \;
find $1/ -depth -execdir rename -v 's/ï|î/i/g' "{}" \;
find $1/ -depth -execdir rename -v 's/ù|û|ü/u/g' "{}" \;
find $1/ -depth -execdir rename -v 's/ô|ö/o/g' "{}" \;
find $1/ -depth -execdir rename -v 's/ç/c/g' "{}" \;
find $1/ -depth -execdir rename -v 's/\)|\(|\ |\+|\;|\:|\*|\?|\"|\'//g' "{}" \;
```

# remplacement du contenu d'un fichier
## changement d'encodage
### iconv
from iso to utf
```
iconv -f iso-8859-1 -t utf-8 -o $i.new $i
```
### python
```
import sys
print sys.stdin.read().decode('utf-8').encode('iso-8859-1', 'ignore')   # ignore permet d'ignorer les caractères éventuellement non disponibles en latin-1 
cat dumpct | python conv.py > dumpct.latin1
```
