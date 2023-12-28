# Date
## calcul dates
```bash
annee=`date --date '1 month ago' '+%Y'`
```
```bash
aamm=`date --date=yesterday '+%y%m'`
```
```bash
date '+%Y-%m' --date '2 month ago'
```
```bash
DATE=`date '+%y%m%d'`
```

## appliquer une date
```bash
date -s "22 OCT 2019 17:30:00"
```
mardi 22 octobre 2019, 17:30:00 (UTC+0200)


## dates POSIX
ls -l == modify == mtime
```bash
ls -l ./48e34335_3d9_1.png
```
```
-rwxrwx--- 1 ftp_user www-data 19306 2008-10-01 11:30 ./48e34335_3d9_1.png
```
```bash
stat ./48e34335_3d9_1.png
```
Access: 2010-05-26 18:18:59.000000000 +0200 : accès en read (cat, pas more, pas vi) --> ls -lu
Modify: 2008-10-01 11:30:29.000000000 +0200 : contenu changé. alors ctime change aussi --> ls -l
Change: 2010-05-26 18:14:58.000000000 +0200 : inode changé (rename, mv), attributs changés (touch, change timestamp) --> ls -lc

## changer la date d'un fichier (mtime)
```bash
touch -t 200805101024
```

## régler horloge bios
```bash
hwclock --set --date="2015-09-02 14:59:05"
```

## date unix
### calcul pour conversion des dates
timestamp=(date-25569)*86400

date=(timestamp/86400)+25569

### trouver date à partir timestamp
```bash
timestamp=`date +%s`
date -d @$timestamp +'%d/%m/%Y (%A) at %X (UTC %:z)'
```
