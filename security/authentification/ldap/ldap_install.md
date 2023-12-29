# LDAP et phpldapadmin

## Contexte

LDAP fournit un modèle d'organisation des données.
Ces données sont organisées sous forme hiérarchique.
L'arbre est nommé Directory Information Tree (DIT).
Le sommet (racine), contient le "suffixe". Chaque noeud représente une "entrée" ou "Directory Entry Service" (DSE).


Chaque noeud à un DN (Distinguished Name) et un RDN (Relative Distinguished Name).

Le DN c'est comme le chemin absolue d'un élément, ce qui permet de l'identifier sans ambiguité.
Ex: "uid=john.doe,ou=People,dc=example,dc=com"

Le RDN, c'est comme le chemin relatif
Ex: "uid=john.doe"




### Connexion


Pour ce connecter au ldap, il y a 3 manière:
- Par socket UNIX (ldapi://) dont seulement utilisable en local (souvent en mode trust pour pouroir ce connecter sans password)
- Par réseau (ldap://) non chiffré donc normalement que pour des connexions locales
- Par réseau + SSL : (ldaps://)  donc chiffré.

### Authentification

Par défault, ldap utilise une authentification SASL. Pour la désactivé l'authentification côte client il faut utiliser l'option "-x".



## Commande usuel

| Commande | Descrition!
|- |- |
| ```ldapsearch -H ldap://127.0.0.1 -x``` | Command anonyme sans recherche (permet d'avoir la version du ldap)``` |
| ```ldapwhoami -w "ThePassword" -D "cn=admin,cn=config"``` | Authentification à un noeud (permet de testetr l'authentification) |



## Configuration

Le dossier contenant la configuration est **/etc/ldap/slapd.d/**.

Ce dossier replace le fichier de configuratiuon historiqye slapd.conf.

- **cn=config/**:


### cn=config DIT
http://www.zytrax.com/books/ldap/ch6/slapd-config.html
slapd > 2.3 : on-line configuration (OLC)  in slapd.d is replacing the historical statically config slapd.conf


## Install
```bash
apt-get install slapd ldap-utils
```

Reconfigure slapd
```bash
dpkg-reconfigure slapd
```
```
Voulez-vous omettre la configuration d'OpenLDAP ? Non
Nom de domaine : exemple.com
Nom d'entité (« organization ») : Entreprise
Mot de passe de l'administrateur : ******
Mot de passe de l'administrateur : ******
Module de base de données à utiliser : MDB
Faut-il supprimer la base de données lors de la purge du paquet ? Non
Faut-il déplacer l'ancienne base de données ? Oui
Faut-il autoriser le protocole LDAPv2 ? Non
```
En version non-interactive:
```bash
export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<EOF
slapd slapd/internal/generated_adminpw password $LDAP_PWD
slapd slapd/password2 password $LDAP_PWD
slapd slapd/internal/adminpw password $LDAP_PWD
slapd slapd/password1 password $LDAP_PWD
slapd slapd/domain string $LDAP_DOMAIN
slapd shared/organization string $LDAP_ORGA
EOF
apt-get install -qqy slapd
```


### Modifier les valeurs par défaut de l'interface web
```bash
vim /etc/phpldapadmin/config.php
```
Mofdifier :
```
$servers->setValue('server','name','Entreprise LDAP Serveur');
$servers->setValue('server','host','127.0.0.1');
$servers->setValue('server','base',array('dc=exemple,dc=com'));
$servers->setValue('login','bind_id','cn=admin,dc=exemple,dc=com');
```

```bash
/etc/init.d/slapd restart
```


## phpldapadmin
Go to : http://app1.exemple.com/phpldapadmin

## client:
apache directory studio

## commandes ldap:
### ldapadd
use SASL Quiet mode (Q) SASL mechanism (EXTERNAl)
```bash
ldapadd -Q -Y EXTERNAL -H ldapi:/// -f exemple.com.ldif
```
Simple authentication (x)  bind password (w) bind DN (D)
```bash
ldapadd -x -H ldap://localhost/ -D "cn=admin,dc=exemple,dc=com" -w "$LDAP_PWD" -f import_init.ldif
```

### ldapmodify
Auth sasl
```bash
echo -e 'dn: CN=pnom,OU=Utilisateurs,DC=test,DC=exemple,DC=com\nchangetype: modify\nreplace: scriptPath\nscriptPath: pnom.bat' | ldapmodify -h app1.exemple.com -p 389  -Y GSSAPI
```

### ldapsearch
LLL       print responses in LDIF format without comments
```bash
ldapsearch -LLL -h debianjessy.exemple.com -p 389  -Y GSSAPI -b ou=SUDOers,dc=test,dc=exemple,dc=com '(&(objectClass=sudoRole)(|(!(sudoHost=*))(sudoHost=ALL)(sudoHost=debian1)(sudoHost=debian1.exemple.com)(sudoHost=192.168.66.18)(sudoHost=192.168.64.0/19)(sudoHost=fe80::a00:27ff:2dc6:1698)(sudoHost=fe80::/64)(sudoHost=+*)(|(sudoHost=*\\*)(sudoHost=*?*)(sudoHost=*\2A*)(sudoHost=*[*]*))))' cn sudoCommand sudoHost sudoUser sudoOption sudoRunAs sudoRunAsUser sudoRunAsGroup sudoNotBefore sudoNotAfter sudoOrder uSNChanged
```
simple auth
```bash
ldapsearch -x -h 127.0.0.1 -b OU=auto.master,OU=automount,DC=test,DC=exemple,DC=com -D CN=Administrator,CN=Users,DC=test,DC=exemple,DC=com -w YYYYY -LLL '(&(automountKey=*)(objectclass=automount))' objectClass automountKey automountInformation
```
rechercher le user "manger" dans la base des users
```bash
ldapsearch -x -h 127.0.0.1 -b uid=manger,ou=Users,dc=exemple,dc=com -D "cn=admin,dc=exemple,dc=com" -w XXXXXX -LLL
```

## ldapdelete
remove pnom
```bash
ldapdelete -x -h 127.0.0.1 -D "cn=admin,dc=exemple,dc=com" -w XXXXXX "uid=pnom,ou=Users,dc=exemple,dc=com"
```
## slappasswd
générer un password ssha avec le password "YYYYYY"
```bash
slappasswd -h {SSHA} -s YYYYYY
```

# backup

## Find out what databases are configured
```bash
slapcat -b cn=config | grep "^dn: olcDatabase="
```

## Backup of cn=config
```bash
slapcat -b cn=config -l cn=config.master.ldif
```
## trouver les databases
```bash
slapcat -b cn=config | grep "^dn: olcDatabase=\|^olcSuffix"
```
## Backing up database(s)
```bash
slapcat dc=exemple,dc=com -l /back/app.ldif
```


## probleme de checksum lors du backup (si la base contient de mauvais CRC, car on a édité des ldif au lieu d'utiliser ldapmodify)
```
5899f8c7 ldif_read_file: checksum error on "/etc/ldap/slapd.d/cn=config.ldif"
```
On génère le nouveau CRC à partir de la ligne 3 du fichier
```bash
apt-get install libarchive-zip-perl
crc32 <(cat "/etc/ldap/slapd.d/cn=config.ldif" | tail -n +3)
439a9493
```
On remplace ligne 2 le CRC par celui calculé


## Génération password dans un ldif
Exemple d'un mot de passe SHA-256 avec salt
```bash
mkpasswd -m sha-256 --salt `head -c 40 /dev/random | base64 | sed -e 's/+/./g' |  cut -b 10-25` 'pnom'
```
Dans le ldif:
- '$5' : SHA-256
- '$QbOuGTW0jqsdf2dn7' :
```
userPassword: {CRYPT}$5$QbOuGTW0jqsdf2dn7$.lxgJXg3ko6.0/B7sjdsLjd4Dm6l6sNsGK793B1
```

## Restore
```
/etc/init.d/slapd stop
rm -rf /etc/ldap/slapd.d
mkdir /etc/ldap/slapd.d
slapadd -F /etc/ldap/slapd.d -b cn=config -l LDAP_cn\=config.ldif
chown -R openldap:openldap /etc/ldap/slapd.d
rm -rf /var/lib/ldap
mkdir /var/lib/ldap
slapadd -F /etc/ldap/slapd.d -b dc=exemple,dc=com -l LDAP_dc\=exemple\,dc\=domexemple.ldif
chown -R openldap:openldap /var/lib/ldap
/etc/init.d/slapd start
```

## Log level (debug)
Modification dans le ldap directement :
```bash
ldapmodify -Q -H ldapi:/// -Y EXTERNAL <<EOF
dn: cn=config
changetype: modify
replace: olcLogLevel
olcLogLevel: stats
EOF
```
olcLogLevel :
- (0x1 trace) trace function calls
- (0x2 packets) debug packet handling
- (0x4 args) heavy trace debugging (function args)
- (0x8 conns) connection management
- (0x10 BER) print out packets sent and received
- (0x20 filter) search filter processing
- (0x40 config) configuration file processing
- (0x80 ACL) access control list processing
- (0x100 stats) connections, LDAP operations, results (recommended)
- (0x200 stats2) stats2 log entries sent
- (0x400 shell) print communication with shell backends
- (0x800 parse) entry parsing

source : https://manpages.debian.org/bullseye-backports/slapd/slapd-config.5.en.html

Suivi des logs :
```bash
journalctl -u slapd -f
```
