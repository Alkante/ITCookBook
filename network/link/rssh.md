# rssh
Restricted shell for providing limited access to a host via ssh

## Installer rssh
```bash
apt-get install rssh
```

## Ajouter un utilisateur utilisant rssh
```bash
useradd -m -d /home/toto -s /usr/bin/rssh -c "Utilisateur TOTO" toto
```
```
 -m, --create-home        :  Créé le répertoire personnel de l'utilisateur s'il n'existe pas
 -d, --home RÉP_PERSO     : Défini le répertoire de connexion
 -s, --shell INTERPRÉTEUR :  Le nom de l'interpréteur de commandes initial de l'utilisateur (« login shell »). Le comportement par défaut est de laisser ce champ vide. Le système sélectionnera alors l'interpréteur par défaut indiqué par la variable SHELL dans /etc/default/useradd, ou une chaîne vide par défaut.
 -c, --comment COMMENTAIRE
```
Password:
```bash
passwd toto
```

## Vérifier/Modifier les informations
```bash
vim /etc/passwd
```
```
toto:x:1009:1003:Utilisateur:/home/toto:/bin/rssh
```


## Changer le shell utilisateur
```bash
usermod -s /usr/bin/rssh toto
```
ou
```bash
chsh -s /usr/bin/rssh toto
```

## Essayer de ce connecter
```bash
sftp didi@my.backup.server.com
```
ou
```bash
ssh didi@my.backup.server.com
```
Résultat :
```
This account is restricted by rssh.
This user is locked out.
```

## Ajouter des droits sftp et scp
```bash
vim /etc/rssh.conf
```
```
allowscp
allowsftp
```

## Tester les nouveaux droits
```bash
scp /path/to/file didi@my.backup.server.com:/.
```
ou
```bash
sftp didi@my.backup.server.com:/.
```

## Astuces
### Liste des droits attribuables
```
allowscp   : scp
allowsftp  : sftp
allowcvs   : cvs
allowrdist : rdist
allowrsync : rsync
```

### fix rssh_chroot_helper[29426]: chroot() failed
```bash
chmod u+s /usr/lib/rssh/rssh_chroot_helper
```



### chroot binaries
set root of chroot:
```bash
mkdir /pool01/client1
```
adduser as usaual with ssh
```
useradd -M user_client1  group_o2o -d /pool01/client1 -s /usr/bin/rssh
chown root.group_o2o /pool01/client1
chmod 750 /pool01/client1
cd /pool01/client1
chown root:group_o2o backup
chmod 770 backup
mkdir .ssh
echo "mykey" >> .ssh/authorized_keys
chown user_client1.group_o2o -R .ssh
chmod 700 .ssh
chmod 600 .ssh/*
```

add binaries + libs
```bash
CP="rsync -RLa"
$CP /usr/bin/rssh /pool01/client1/
$CP /lib64/ld-linux-x86-64.so.2 /pool01/client1/
$CP /lib/x86_64-linux-gnu/libc.so.6 /pool01/client1/

$CP /bin/bash /pool01/client1/
$CP /lib/x86_64-linux-gnu/libtinfo.so.5 /pool01/client1/
$CP /lib/x86_64-linux-gnu/libdl.so.2 /pool01/client1/
$CP /lib/x86_64-linux-gnu/libc.so.6 /pool01/client1/
$CP /lib64/ld-linux-x86-64.so.2 /pool01/client1/

$CP /usr/bin/sftp /pool01/client1/
$CP /usr/lib/x86_64-linux-gnu/libedit.so.2 /pool01/client1/
$CP /lib/x86_64-linux-gnu/libc.so.6 /pool01/client1/
$CP /lib/x86_64-linux-gnu/libbsd.so.0 /pool01/client1/
$CP /lib64/ld-linux-x86-64.so.2 /pool01/client1/


$CP /usr/bin/rsync /pool01/client1/
$CP /lib/x86_64-linux-gnu/libacl.so.1 /pool01/client1/
$CP /lib/x86_64-linux-gnu/libpopt.so.0 /pool01/client1/
$CP /lib/x86_64-linux-gnu/libattr.so.1 /pool01/client1/

$CP /usr/lib/openssh/sftp-server /pool01/client1/
$CP /usr/lib/rssh/rssh_chroot_helper /pool01/client1/

cd  /pool01/client1/
mkdir dev
mknod dev/null c 1 3
chmod 666 dev/null
mkdir etc
grep o2o /etc/passwd > etc/passwd
grep o2o /etc/group > etc/group

$CP /lib/x86_64-linux-gnu/libnss_compat.so.2 /pool01/client1/
$CP /lib/x86_64-linux-gnu/libnss_files.so.2 /pool01/client1/
```
log sftp : ajouter dans /etc/rsyslog.conf:
```
$AddUnixListenSocket /pool01/client1/dev/log
local7.info /var/log/sftp
```
restart rsyslog
```bash
mkdir /var/log/sftp
chmod 777 /var/log/sftp
/etc/init.d/rsyslog
```
