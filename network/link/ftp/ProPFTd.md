# ProTFPd
## Installation

### Intaller ProFTPd
```bash
apt-get install proftpd
```
Choisir :
- from inetd : Pour un serveur avec quelques connexions par jour
- standalone : Pour un serveur avec beaucoup de connexion


## Configuration
### Manuelle
```bash
vim /etc/proftpd/proftpd.conf
```
Avant :
```
	# Use this to jail all users in their homes
	# DefaultRoot                   ~
```
Après
```
	# Use this to jail all users in their homes
	DefaultRoot        /var/proftpd
```

## Option : désactiver l'IPv6
### Manuelle
Avant
```
	UseIPv6                         on
```
Après
```
	UseIPv6                         off
```


## Pour échanger les fichiers, un serveur FTP peut utiliser l'un de ces deux modes :

Mode actif : c'est le client FTP qui détermine sur quel port se feront les échanges de fichiers. Cette technique est la plus ancienne et pose bien souvent des problèmes à cause du pare-feu.

Mode passif : c'est le serveur FTP qui détermine le port d'échange des fichiers. C'est la technique recommandée aujourd'hui.


## informations
Utilisateur connecté
```bash
ftpwho
```
Statistiques
```bash
ftpstats
```

## Connection avec une interface graphique
- filezilla
- Nautilus


# FTPS
FTP avec chiffrement explicite
- La connexion s'effectue sur le port 21, le port de commande FTP standard, et soit :
- la commande "AUTH TLS" (anciennement "AUTH TLS-C") demande au serveur de chiffrer le transfert de commande en TLS, et le chiffrement du transfert de données se fait par la commande "PROT P" ;
- Cette approche est compatible avec les serveurs ou clients FTP ne supportant pas le chiffrement SSL/TLS, auquel cas une connexion non chiffrée pourra être utilisée ou bien refusée.

FTP avec chiffrement implicite (deprecated)
- La connexion au serveur se fait sur le port 990 qui est le port de commande et sur lequel la négociation SSL/TLS s'effectue. Le port de données est le 989 et est lui aussi chiffré.
- Cette approche plus ancienne que la méthode explicite n'est pas soutenue par l'IETF


## Création d'un certificat
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -out proftpd-rsa.pem -keyout proftpd-key.pem
```

## Restraindre les droit sur la clef
```bash
chmod 440 proftpd-key.pem
```
```bash
vim /etc/proftpd/proftpd.conf
```
Avant
```
#Include /etc/proftpd/tls.conf
```
Après
```
Include /etc/proftpd/tls.conf
```

# Avec LDAP
```bash
vim /etc/proftpd/proftpd.conf
```
Avant
```
#Include /etc/proftpd/ldap.conf
```
Après
```
Include /etc/proftpd/ldap.conf
```

```bash
vim /etc/proftpd/tls.conf
```
Avant
```
#TLSRSACertificateFile                   /etc/proftpd/ssl/certs/proftpd.crt
#TLSRSACertificateKeyFile                /etc/proftpd/ssl/private/proftpd.key
#TLSVerifyClient                         off
```
Après
```
TLSRSACertificateFile                   /etc/proftpd/ssl/certs/proftpd.crt
TLSRSACertificateKeyFile                /etc/proftpd/ssl/private/proftpd.key
TLSVerifyClient                         off
```



### Install
```
apt-get install ldap-utils php5-ldap phpldapadmin slapd
```

# limit speed
```
MaxClientsPerHost 1 "Only 1 simultaneous connection permitted from your host!"
#1500Ko/s en download
TransferRate RETR 1500:0
```

# config simple:
```
RequireValidShell       no
#debug log
#SyslogLevel                     debug
#SystemLog                       /var/log/proftpd/prodtpd.log
#ExtendedLog /var/log/proftpd/prodtpd.log ALL
# autorise la reprise apres echec upload
AllowStoreRestart on
# autorise la reprise apres echec download
AllowRetrieveRestart on
DefaultRoot                   ~
#connexions plus rapides
UseReverseDNS off
IdentLookups off
```

## Gestion des accès
restriction des droits en fonction du user ftp connecté (ftp_user fait ce qu'il veut dans /chemin/exemple/test (IN et OUT)

```
<Directory /chemin/exemple/test/IN>
  <Limit ALL>
    AllowUser ftp_user
  </Limit>
</Directory>
<Directory /chemin/exemple/test/OUT>
  <Limit ALL>
    AllowUser ftp_user
  </Limit>
</Directory>
<Directory /chemin/exemple/test/*>
    <Limit ALL>
      Order deny,allow
      DenyUser ftp_user
      AllowAll
    </Limit>
</Directory>
```

restriction des droits en fonction du user ftp connecté (seul ftp_exemple est refusé)
```
<Directory /chemin/exemple/test >
    <Limit ALL>
        Order Deny,Allow
        DenyUser ftp_exemple
        AllowAll
    </Limit>
</Directory>
```

restriction des droits en fonction du user ftp connecté (read only pour ftp_exemple)
```
<Directory  /chemin/exemple/test>
    <Limit CWD PWD DIRS READ>
      AllowAll
    </Limit>
    <Limit ALL>
      DenyUser ftp_exemple
    </Limit>
</Directory>
```

restriction des droits en fonction du user ftp connecté: ftp_user + class trust : ce user ne peut écrire que sous certaines IP
```
<Class trust>
    From *.exemple.com
    From 192.168.0.1
    From 192.168.1.1
</Class>
<IfUser ftp_user>
   <Limit WRITE>
      AllowClass trust
      DenyAll
   </Limit>
</IfUser>
<Directory /chemin/exemple >
    Umask 027 027
    <Limit SITE_CHMOD>
        AllowUser ftp_user
        DenyAll
    </Limit>
</Directory>
```

Umask (= chmod 770)
```
<Directory /chemin/exemple/test>
    Umask 007 007
</Directory>
```

anonymous
```
<Anonymous /chemin/exemple/test>
  User ftpuser
  Group www-data
  UserAlias                    anonymous ftpuser
  MaxClientsPerHost 1 "Only 1 simultaneous connection permitted from your host!"
  TransferRate RETR 1500:0
  <Directory *>
    <Limit WRITE>
      DenyAll
    </Limit>
  </Directory>
</Anonymous>
```
