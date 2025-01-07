# Ldap with docker


<!-- TOC -->

- [Ldap with docker](#ldap-with-docker)
  - [Links](#links)
  - [Context](#context)
  - [Install](#install)
    - [Erase/Init/Erase data](#eraseiniterase-data)
  - [SSL](#ssl)
  - [CRYPT](#crypt)
  - [Run](#run)
    - [Start](#start)
    - [Debug](#debug)
    - [Stop](#stop)
  - [Configuration](#configuration)
    - [Generale option](#generale-option)
    - [Scheme option](#scheme-option)
    - [ldapsearch Option](#ldapsearch-option)
    - [ldapadd Options](#ldapadd-options)
    - [ldappasswd Options](#ldappasswd-options)
    - [ldapmodify Options](#ldapmodify-options)
    - [ldapdelete option](#ldapdelete-option)
    - [ldapwhoami](#ldapwhoami)
  - [Backcup/restore/import](#backcuprestoreimport)

<!-- /TOC -->


## Links

- Source code docker ldap:  https://github.com/osixia/docker-openldap
- Docker HUB ldap : https://hub.docker.com/r/osixia/openldap/
- simple efficient ldap tutorial: https://www.thegeekstuff.com/2015/02/openldap-add-users-groups/
- Exemple pour auth aec NSS , PAM: http://uid.free.fr/Ldap/ldap.html


## Context

Time series multi dimentional real time database

LDAP need config and database.
Both can be specified qith LDIF file.
By default, Both are save in directory/files format.

It's possible to change this and une reale database as backend (cf: **mdb** configuration)




DN is Distinguished name and is unique identifier for an entry

Data by defaul is saved in **/var/lib/ldap/** in **data.mdb** and **lock.mdb** files

## Install

### Erase/Init/Erase data

Init procedure
```bash
mkdir -p ./data/openldap/config ./data/openldap/database ./data/openldap/add_init_ldif
sudo chmod 755 ./data/openldap/config ./data/openldap/database ./data/openldap/add_init_ldif
#sudo chown 999:999 ./data/openldap/config ./data/openldap/database   # Not need
```

Erase all data if data exist (optional)
```bash
sudo rm -rf ./data/openldap/config/* ./data/openldap/database/*
```

Add add_init_ldif

```bash
docker-compose down
mkdir -p ./data/openldap/add_init_ldif/
sudo cp ./example/*.ldif ./data/openldap/add_init_ldif/
sudo chmod 777 -R ./data/openldap/add_init_ldif
docker-compose up -d
```

## SSL

tcp        0      0 127.0.0.1:389           0.0.0.0:*               LISTEN      0          20518      892/slapd
      - "389:389"  # Ldap and ldap+startTLS
      - "636:636"  # Ldap + SSL

Change ```/etc/default/slapd```
```ini
SLAPD_SERVICES="ldap:/// ldaps:/// ldapi:///"
```

olc_ssl.ldif
```ldif
dn: cn=config
add: olcTLSCACertificateFile
olcTLSCACertificateFile: /etc/apache2/ssl-cert/CA_intermediate.pem

dn: cn=config
add: olcTLSCertificateFile
olcTLSCertificateFile: /etc/apache2/ssl-cert/ssl.crt/wildcard.app1.crt

dn: cn=config
add: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /etc/apache2/ssl-cert/ssl.key/wildcard.app1.key

dn: cn=config
add: olcTLSVerifyClient
olcTLSVerifyClient: never
```

```bash
ldapmodify -QY EXTERNAL -H ldapi:/// -f olc_ssl.ldif
```

Check modification
```bash
ldapsearch  -x -D cn=admin,cn=config -w config -LLL -b cn=config cn=config
#or
ldapsearch -QY EXTERNAL -H ldapi:/// -LLL -b cn=config cn=config
```

## CRYPT

Default password hash is SSHA (sha1 + salt)

Pass to SHA512 + salt
link: https://rolandschnabel.de/blog/2016/09/password-encryption-in-openldap/

Use ./example/53-SHA512.ldif put il ./data/openldap/add_init.ldif

On the docker

```bash
cd /container/service/slapd/assets/config/bootstrap/ldif/custom
ldapmodify -Y EXTERNAL -H ldapi:/// -f 53-SHA512.ldif
```

C GNU support sha512.

Check : /etc/login.defs as **ENCRYPT_METHOD SHA512**.

Also OpenLDAP has to be compiled with crypt support (--enable-crypt).

```
ldapsearch  -x -D "cn=admin,dc=example,dc=org" -w admin -LLL -b cn=admin,dc=example,dc=org
```

Decode userPassword with base64
```bash
echo e1NTSEF9dGE4Y2FIK2VoM0M2cnVqZUNPM29LMndFS3c4NlI0aWY= |base64 -d
```
Give
```
{SSHA}ta8caH+eh3C6rujeCO3oK2wEKw86R4if
```

Change password admin
```
ldappasswd -x -D "cn=admin,dc=example,dc=org" -w admin -a admin -s admin
```

Change password config
```bash
docker exec -ti openldap bash
LDAP_CONFIG_PASSWORD_SHA=`slappasswd -h {SHA} -s $LDAP_CONFIG_PASSWORD`
cat << EOF > /tmp/reset_password.ldif
dn: olcDatabase={0}config,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: $LDAP_CONFIG_PASSWORD_SHA
EOF
ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/reset_password.ldif
rm /tmp/reset_password.ldif
exit
```

Decode userPassword with base64
```bash
echo XXXXXXXXXXXXXXXXxx=|base64 -d
```


## Run

### Start
```bash
docker-compose up -d
```

### Debug
Connection
```bash
docker exec -it openldap /bin/bash
```
Typical debug tools
```bash
apt update && apt install -y vim tree htop net-tools tcpdump
```

### Stop
```bash
docker-compose down
```
alias copyLastCmd='fc -ln -1 | awk '\''{$1=$1}1'\'' | pbcopy'

## Configuration

List all config
```bash
ldapsearch -Y EXTERNAL -H ldapi:/// -LLL -b cn=config
# or
ldapsearch  -x -D cn=admin,cn=config -w config -LLL -b cn=config
# or
slapcat -b "cn=config"
```

List all database
```bash
ldapsearch  -x -D "cn=admin,dc=example,dc=org" -w admin -LLL -b dc=example,dc=org
#or
slapcat
```


### Generale option
| Option | Descritpion|
|- |- |
| ```-x``` | Simple authentication. i.e. User(bindDN/passwrd) |
| ```-H``` | url to connect (sheme: ldap, ldaps) |
| ```-D``` | bind DN. i.e. Entry point to use for authentification |
| ```-w``` | Paswword. i.e. The userPassword of the bind D

### Scheme option
| Scheme | Descritpion|
|- |- |
| ```ldap://``` | Simple ldap protocol with default port 389 |
| ```ldaps://``` | SSL ldap protocol with default port 636 |
| ```ldapi://``` | UNIX-domain socket connection (/var/run/ldapi) (use with **-Y EXTERNAL** and need to be root user) |

### ldapsearch Option
| Option | Descritpion|
|- |- |
| ```-b``` | base DN scope for search. i.e. search sub tree |

Dispaly conf
```bash
ldapsearch -LLL -Y EXTERNAL -H ldapi:/// -Q -b cn=config dn
```

Simple recherche without query (i.e. without filter)
```bash
ldapsearch  -LLL -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -b dc=example,dc=org
```
result:
```
# extended LDIF
#
# LDAPv3
# base <dc=example,dc=org> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

[...]

# numResponses: 3
# numEntries: 2
```
Simple recherche wiiwth generique query (objectclass=*)
```bash
ldapsearch -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -b dc=example,dc=org "(objectclass=*)"
```




### ldapadd Options

| Option | Descritpion|
|- |- |
| ```-f``` | ldif filet to import (Containe a list of entry) |
| ```-Z``` | Start TLS request (-ZZ to require successful response) |

An ldif example contining one user **Billy** entry are in /container/service/slapd/assets/test/new-user.ldif.
Import user billy with :
```
ldapadd -H ldap://localhost -x -D "cn=admin,dc=example,dc=org" -w admin -f /container/service/slapd/assets/test/new-user.ldif
```

### ldappasswd Options

| Option | Descritpion|
|- |- |
| ```-x``` | User DN to change (must contain **userPassword**** attribut)" |
| ```-s``` | New password |



### ldapmodify Options

TODO:

```
ldapmodify -x -W -D "cn=admin,dc=example,dc=com" -f file1.ldif
```


### ldapdelete option

TODO:

###  ldapwhoami
Self test auth password
```bash
ldapwhoami -x -H ldap://localhost -D "cn=admin,dc=example,dc=org"  -w "admin"

```


## Backcup/restore/import

Put file in volume for database and config.

Backcup
```bash
slapcat -b cn=config -l config.ldif
slapcat  -l database.ldif
```
