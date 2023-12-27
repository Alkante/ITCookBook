# FTP

Le FTP, ou File Transfer Protocol est un procole de communication réseau dédié au transfert de fichier et dossier

Le protocole n'est pas nativement sécurisé, il doit être encapsuler dans des protocoles de chiffrement :
- SFTP : FTP via SSH
- FTPS : FTP via SSL/TLS

Le logiciel ProFTPd supporte SFTP et FTPS ainsi que les mode d'authentification comme le RADIUS, LDAP ou SQL.
Il supporte aussi nativement l'IPv6, le chroot et l'utilisation de multiple serveur FTP.

## ProFTPd
Le plus connu et le plus ancien
Le plus paramétrable

## PureFTPd
Le plus simple

## vsftpd
Le plus d'utilisateur

## client FTP
### ncftp
```bash
apt-get install ncftp
echo "host vm.exemple.com
user ftp_user
pass XXXX" > login.cfg
ncftpget -v -f login.cfg local/ '/remote/*.php'
```

### recursive download
```bash
ncftpget -R -T -v -u "ftp_user@vm.exemple.com" -p XXXX ftp://192.168.0.1 .
```
### download a dmp.gz
```bash
ncftpget -T -u ftp_user -p XXXX vm.exemple.com ./ dump_bdd.dmp.gz
```
### upload
```bash
ncftpput -u ftp_user -p XXXX vm.exemple.com ./ dump_bdd.dmp.gz
```
