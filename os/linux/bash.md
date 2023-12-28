# Bash
## supprimer extension d'un groupe de fichier
```bash
for i in *.new; do mv "$i" "${i/.new}"; done
```

## remove extensions
```bash
x="/foo/fizzbuzz.bar.quux"
y=${x%.*}
echo $y
```
/foo/fizzbuzz.bar
```bash
y=${x%%.*}
echo $y
```
/foo/fizzbuzz


## change password
```bash
echo -e "YYYYYY\nYYYYYY" | (passwd root)
echo ftp_test:test | chpasswd
```


## maths
```bash
echo "scale=2;($a-$b)*100/$b"|bc -l
nb=$(($nb_jeudi-`echo $old_jeudi|grep -c ""`))
```
```bash
echo $((8/2))
```
4

## comparaison de 2 sous-shell
```bash
diff -yb <(ls -1 /mnt/projet/) <(cat /mnt/rainbow/backup/listes/projets.txt)
```

## List les fichiers différents entre deux répertoires

```bash
diff --brief -Nr src/ src_new/
```

## base 64 encode
```bash
echo -n "epflr" | openssl enc -base64
echo -n "ZXBmbHI=" | openssl enc -base64 -d
```

## boucle for incrementale
inc +1
```bash
for ((a=1; a <= 15 ; a++)); do sleep 0.5; ps aux|grep nagios; done
inc +200
```
```bash
for ((a=0; a <= 6000 ; a+=200)); do php reindexation_metadata.php $a $((a+199)); done
```

## variables bash
- nb arguments = $#
- arguments passés = $* $@

## wrap program's arguments
```bash
cp /the/exe /the/exe.bak
echo >  /the/exe
echo '#!/bin/bash
echo "$@" > /tmp/exe.log
exec /the/exe.bak "$@"
'
```

```bash
[[ `whoami` != "postgres" ]] || { echo "Le script doit etre lance en user postgres" 2>&1; exit 1;}
sudo -iu postgres psql -lt
```

## conversion d'un epage de man vers un pdf avec man2pdf
```bash
man -t smb.conf | ps2pdf - smb.conf.pdf
```

## parse liste
liste de sites
```bash
SITES="
vm1.exemple.com
#vm2.exemple.com
vm3.exemple.com
"
```
filtrage
```bash
printf '%s\n' "$SITES"  | egrep -v "^#|^$" | while IFS= read -r site; do echo $site;done
```
