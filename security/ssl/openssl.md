# OpenSSL
<!-- TOC -->

- [OpenSSL](#openssl)
  - [Contexte](#contexte)
    - [Protocole](#protocole)
    - [Niveau de confiance des certificats](#niveau-de-confiance-des-certificats)
    - [Extentions de fichier](#extentions-de-fichier)
  - [Commandes usuelles](#commandes-usuelles)
    - [Aides](#aides)
    - [Affichage](#affichage)
    - [Afficher l'empreinte](#afficher-lempreinte)
  - [Création d'un certificat](#création-dun-certificat)
    - [Génération d'une paire de clé](#génération-dune-paire-de-clé)
      - [RSA](#rsa)
      - [DSA](#dsa)
      - [ECDSA](#ecdsa)
    - [Certificate Signing Request (CSR)](#certificate-signing-request-csr)
      - [Création d'un CSR](#création-dun-csr)
      - [Création d'un CSR non interactif](#création-dun-csr-non-interactif)
      - [CSR From certificate](#csr-from-certificate)
    - [Signature du CSR](#signature-du-csr)
      - [Autosigné depuis un CSR](#autosigné-depuis-un-csr)
      - [Autosigned sans CSR mais avec la clef privé (generated on the fly)](#autosigned-sans-csr-mais-avec-la-clef-privé-generated-on-the-fly)
      - [Multidomain (Wilcard) certificates](#multidomain-wilcard-certificates)
    - [Options : liste des extentions](#options--liste-des-extentions)
      - [Basic constraints](#basic-constraints)
      - [Key Usage (KU) or Extended Key Usage (EKU)](#key-usage-ku-or-extended-key-usage-eku)
      - [CRL Distribution Points](#crl-distribution-points)
      - [Certificate Policies](#certificate-policies)
      - [Authority Information Access (AIA)](#authority-information-access-aia)
      - [Subject Alternative Name (SAN)](#subject-alternative-name-san)
  - [Commandes de création de certificat avancées](#commandes-de-création-de-certificat-avancées)
    - [Standard](#standard)
    - [Avec ECDHE](#avec-ecdhe)
    - [Pour Windows](#pour-windows)
    - [ssl gen autosigned](#ssl-gen-autosigned)
    - [Generer un csr](#generer-un-csr)
    - [Autres : non-interactive openssl](#autres--non-interactive-openssl)
  - [Commandes avancées](#commandes-avancées)
    - [Modifie la passphrase](#modifie-la-passphrase)
      - [Change passphrase](#change-passphrase)
      - [Delete passphrase](#delete-passphrase)
    - [Convertion de format](#convertion-de-format)
    - [Verifications & Exports](#verifications--exports)
  - [Remote openssl](#remote-openssl)
    - [Commandes usuelles](#commandes-usuelles-1)
  - [Acceptation des cetificats par les clients](#acceptation-des-cetificats-par-les-clients)
    - [Chrome](#chrome)
    - [Debian general](#debian-general)
    - [Ajouter un certificat pour authentification client](#ajouter-un-certificat-pour-authentification-client)
  - [Cyphers](#cyphers)
  - [Perfomance](#perfomance)
  - [Best practices](#best-practices)

<!-- /TOC -->


<!-- ----------------------------------------------------------------------------- -->
<!-- ----------------------------------------------------------------------------- -->
<!-- ----------------------------------------------------------------------------- -->

## Contexte

### Protocole

Principe de communication chiffré signé
```schema
Client                                                    Serveur

------ Client hello (liste des ciphers supportées)     ----->
<----- Serveur Hello (Impossible | le cipher utilisé)  -----
       [ Pour TLS10 11 et 12 :                       ]
       [ ISS : premier cipher OK de la liste du client ]
       [ Apache : Premier cipher OK de la liste du serveur]
       [          Peut être changé avec SSLHonorCipherOrder]
------ Certificat server ...
Suite sur ....
www.ssi.gouv.fr/uploads/IMG/f/SSL_TLS_etat_des_lieux_et_recommandations.pdf
```

### Niveau de confiance des certificats

| Sigle | Nom | Niveau | Description |
|------ |---- |------- |------------ |
| other |-    | -      | Certificat autosigné |
| DV    | Domain validated | + | Gratuit avec Let's encrypt|
| OV    | Organization validated | ++ ||
| EV    | Extended validation | ++++ | E-commerce |


### Extentions de fichier

| Extensions | Ref |Portée | Compatililité| Encryption | description |
|---------- |---- |--- |------------ | ------------ |  ------------ |
| ```.key```| Clef privé               | Privé         | All      | No |  Clef privé seul et standard (= .pem avec seulement la clef privé))
| ```.cert .cer .crt```| Certificat    | Public        | Win./All | No | Certificat ou clef public signé  |
| ```.csr```|  =PKCS10 =RFC 2986       | Au signataire | All      | No | Certificate Signing Request : Demande de de signature |
| ```.crl```|                          | Privé         | All      | No | Certificate révocation |
|||
| ```.pem``` | RFC's 1421 through 1424 | Ca dépend     | Not Win. | No | ASCII, Peux contenir juste le certificat public, la clef public, tout, n'importe quoi y comprit un .csr|
| ```.pkcs12 .pfx .p12```   |-         | Privé         | All      | Oui(RSA) |   Clef public et privé et/ou chaine de certificat |
| ```.der``` |  cf .pem                | Ca dépend     | Not Win. | No | Binary, .pem = Base64_encode(.der) |
| ```.p7b``` | Defined in RFC 2315     | Public        | Win. & Java | No | |

Les 4 manières générales de représenter les certificats :

- PEM Governed by RFCs, it's used preferentially by open-source software. It can have a variety of extensions (.pem, .key, .cer, .cert, more)
- PKCS7 An open standard used by Java and supported by Windows. Does not contain private key material.
- PKCS12 A private standard that provides enhanced security versus the plain-text PEM format. This can contain private key material. It's used preferentially by Windows systems, and can be freely converted to PEM format through use of openssl.
- DER The parent format of PEM. It's useful to think of it as a binary version of the base64-encoded PEM file. Not routinely used by much outside of Windows.

<!-- ----------------------------------------------------------------------------- -->
<!-- ----------------------------------------------------------------------------- -->
<!-- ----------------------------------------------------------------------------- -->


## Commandes usuelles

### Aides
| Commande | Description |
|---------- |--------- |
| ```openssl version```    | Version d'open ssl |
| ```openssl version -a``` | Verbose version d'open ssl |
| ```openssl help``` | Aide générale |


### Affichage
show view crt:
| Opération       | Commande |
|---------------- |--------- |
| Afficher csr    | ```openssl req -noout -text -in server.csr```|
| Afficher crt list from CA  |awk -v cmd='openssl x509 -noout -subject' '/BEGIN/{close(cmd)};{print | cmd}' < /etc/ssl/certs/ca-certificates.crt |
| Afficher crt    | ```openssl x509 -in cdg.goplus.fr.crt -noout -text```|
| Afficher pem    | ```openssl x509 -in server.pem -text```|
| Afficher der    | ```openssl x509 -inform der -in server.der -text```|
| Afficher pkcs12 | ```openssl pkcs12 -in ~/cert.p12 -nodes```|
| Afficher pkcs8  | ```openssl pkcs8 -in ~/cert.p8```|

Les commandes précédantes peuvent être piper pour filter les données voulues: ```| openssl x509 -noout -subject```


### Afficher l'empreinte
| Opération       | Commande |
|---------------- |--------- |
| Afficher pem sha256  | openssl x509 -noout -fingerprint -sha256 -inform pem -in app1.exemple.com.cert.pem |
| Afficher pem sha1  | openssl x509 -noout -fingerprint -sha1 -inform pem -in app1.exemple.com.cert.pem |
| Afficher pem md5  | openssl x509 -noout -fingerprint -md5 -inform pem -in app1.exemple.com.cert.pem |

<!-- ----------------------------------------------------------------------------- -->
<!-- ----------------------------------------------------------------------------- -->
<!-- ----------------------------------------------------------------------------- -->


## Création d'un certificat


<!-- ----------------------------------------------------------------------------- -->

### Génération d'une paire de clé
#### RSA
Pour générer une cléf RSA, choisir :
- un nom de fichier de type *.key
- une taille de clef comme en 2^n suppérieur ou égale à 2048 (cf. clef depreciée)
- un algorithme de chiffrement symétrique pour protéger la clef (cf. passphrase) [AES128, AES192, AES256]
- une passphrase qui sera précisé interactivement

```bash
openssl genrsa -aes128 -out fd.key 2048
```

Afficher la clef chiffré (une passphrase est demandé interactivement)
```bash
openssl rsa -text -in fd.key
```

Généré la clef publique avec la clé privé (une passphrase est demandé interactivement)
```bash
openssl rsa -in fd.key -pubout -out fd-public.key
```
#### DSA

```bash
openssl dsaparam -genkey 2048 | openssl dsa -out dsa.key -aes128
```
#### ECDSA
Attention, les browser ne supporte que les curve secp256r1 et secp384r1
```bash
openssl ecparam -genkey -name secp256r1 | openssl ec -out ec.key -aes128
```

<!-- ----------------------------------------------------------------------------- -->


### Certificate Signing Request (CSR)

Création d'un certificat

#### Création d'un CSR


Création d'un CRS en mode intéractif. Pour metre un champs à vide il suffit de le renseigner par un '.'


| Type         | Description |
|------------- |------------ |
| C            | Country |
| ST           | State |
| L            | City |
| O            | Organization |
| OU           | Organization Unit |
| CN           | Common Name (eg: the main domain the certificate should cover) |
| emailAddress | main administrative point of contact for the certificate |


```bash
openssl req -new -key fd.key -out fd.csr
```
Afficher un CSR
```bash
openssl req -text -in fd.csr -noout
```
#### Création d'un CSR non interactif

```bash
echo "[req]
prompt = no
distinguished_name = distinguished_name
[distinguished_name]
CN = app1.exemple.com
emailAddress = webmaster@exemple.com
O = Exemple Ltd
L = London
C = GB" >  fd.cnf
```

```bash
openssl req -new -config fd.cnf -key fd.key -out fd.csr
```

#### CSR From certificate
```bash
openssl x509 -x509toreq -in fd.crt -out fd.csr -signkey fd.key
```


<!-- ----------------------------------------------------------------------------- -->

### Signature du CSR
#### Autosigné depuis un CSR
```bash
openssl x509 -req -days 365 -in fd.csr -signkey fd.key -out fd.crt
```

#### Autosigned sans CSR mais avec la clef privé (generated on the fly)
```bash
openssl req -new -x509 -days 365 -key fd.key -out fd.crt
```

#### Multidomain (Wilcard) certificates

Utiliser l'extention SAN
```bash
echo "subjectAltName = DNS:*.exemple.com, DNS:exemple.com" > fd.ext
```

```bash
openssl x509 -req -days 365 -in fd.csr -signkey fd.key -out fd.crt -extfile fd.ext
```

Afficher le résultat
```bash
openssl x509 -text -in fd.crt -noout
```

<!-- ----------------------------------------------------------------------------- -->

### Options : liste des extentions
#### Basic constraints
Non CA certificat ne peuvent signer d'autre certificat
Option par défaut à FALSE
```bash
X509v3 Basic Constraints: critical
CA:FALSE
```
#### Key Usage (KU) or Extended Key Usage (EKU)


Restriction de leur usage
```bash
X509v3 Key Usage: critical
   Digital Signature, Key Encipherment
X509v3 Extended Key Usage:
   TLS Web Server Authentication, TLS Web Client Authentication
```

Liste des usages de base (Key Usage)
| Valeur            | Description      |
|------------------ |----------------- |
| digitalSignature  | Pour authentifier l'origine du message a.k.a "entity authentication" |
| nonRepudiation    | Flag indiquant, par exemple, que l'authorité (le CA) ne va pas dire, "je n'ai jamais connu ce certificat" |
| keyEncipherment   | Quand une utilise la clef x501 pour chiffré une autre clef (symmétrique). Ex: SSL ou S/MIME |
| dataEncipherment  | Utiliser pour chiffrer de la donnée brute |
| keyAgreement      | Quand une utilise la clef x501 pour faire de l'échange de clef. Ex: Diffie-Hellman (utiliser dans le SSL) |
| keyCertSign       |Clef utilisé pour vérifier d'autre certificat (Seulement utilisé par les CAs) |
| cRLSign           | Signature de CRL (Seulement utilisé par les CAs)  |
| encipherOnly      | Utilisé seulement si "keyAgreement". Restraint la clef pub au enciphement lors d'un keyEncipherment  |
| decipherOnly      |  Utilisé seulement si "keyAgreement". Restraint la clef pub au deenciphement lors d'un keyEncipherment |


Liste des usages étendu (EKU)

Les EKU ne sont que des "Flag" et sont des usages/contraintes affinant les Key Usages.
Les EKU peuvent être type "Critical" (obligation d'utilisation) ou "non-critical"(conseillé).

| Valeur               |  Description                                      | Activé si les Keys Usages utilisé sont |
|--------------------- |---------------------------------------------------|-------------------------------- |
| serverAuth           |  SSL/TLS Web Server Authentication                | Digital signature, key encipherment or key agreement |
| clientAuth           |  SSL/TLS Web Client Authentication                | Digital signature and/or key agreement |
| emailProtection      |  E-mail Protection (S/MIME)                       | Digital signature |
| codeSigning          |  Code signing                                     | Digital signature, non-repudiation, and/or key encipherment or key agreement |
| timeStamping         |  Trusted Timestamping                             | Digital signature, non-repudiation |
| OCSPSigning          |  OCSP Signing                                     | TODO |
| ipsecIKE             |  ipsec Internet Key Exchange                      | TODO |
| msCodeInd            |  Microsoft Individual Code Signing (authenticode) | TODO |
| msCodeCom            |  Microsoft Commercial Code Signing (authenticode) | TODO |
| msCTLSign            |  Microsoft Trust List Signing                     | TODO |
| msEFS                |  Microsoft Encrypted File System)                 | TODO |




Exemple de table d'usage :

| Application | Usage étendu requis |
|------------ |-------------------- |
| SSL Client | Digital signature |
| SSL Server | Key encipherment |
| S/MIME Signing | Digital signature |
| S/MIME Encryption | Key encipherment |
| Certificate Signing | Certificate signing |
| Object Signing | Digital signature |






#### CRL Distribution Points
Liste ou l'on peut trouver le certificat de revocation (url sans ssl sinon ca boucle)
```bash
X509v3 CRL Distribution Points:
    Full Name:
        URI:http://crl.starfieldtech.com/sfs3-20.crl
```

#### Certificate Policies
Type de certificat -> DV, OV, EV, Other
```bash
X509v3 Certificate Policies:
  Policy: 2.16.840.1.114414.1.7.23.3
    CPS: http://certificates.starfieldtech.com/repository/
```
#### Authority Information Access (AIA)

- Online Certificate Status Protocol (OCSP)
    - to check CRL (revocation) en temps réel
- Subject Key Identifier and Authority Key Identifier
  - Clef maitre de la chaine pemetant d'en déduire la chaine de certificat

#### Subject Alternative Name (SAN)
Optionel mais les clients ne peuvent pas bien utiliser le Common name (CN) sans




<!-- ----------------------------------------------------------------------------- -->
<!-- ----------------------------------------------------------------------------- -->
<!-- ----------------------------------------------------------------------------- -->

## Commandes de création de certificat avancées
La commande suivante permet de générer un certificat avec les options suivantes :
- algorithme RSA
- Le CN (Common Name) est obligatoire
- extention SAN (Subject Alternative Names) pour compatibilité avec google chrome

Note :
- seul CN est obligatoire (option subj)
- Le SAN est fortement recommandé pour éviter les problèmes. Les clients l'utilises.


Commande **openssl req** :  

| Type   | Description |
|------- |------------ |
| -x509  | Type x509   |
| -newkey rsa:4096 | Options de génération d'une nouvelle clef |
| -keyout key.pem | Fichier de sortie de la clef privé |
| -out cert.pem | Fichier de sortie de certificat(clef publique autosigné) |
| -days 3650 | Période de validité |


### Standard
```bash
openssl req \
    -newkey rsa:4096 \
    -x509 \
    -nodes \
    -keyout server.key \
    -new \
    -out server.crt \
    -subj "/C=FR/ST=countyland/L=toto/O=toto rh/CN=*.toto.fr" \
    -reqexts SAN \
    -extensions SAN \
    -config <(cat /usr/lib/ssl/openssl.cnf \
        <(printf '[SAN]\nsubjectAltName=DNS:dev.mycompany.com')) \
    -sha256 \
    -days 3650
```


### Avec ECDHE
Ou mieux, avec ECDHE :
```bash
openssl req \
    -newkey ec:<(openssl ecparam -name secp384r1) \
    -x509 \
    -nodes \
    -keyout server.key \
    -new \
    -out server.crt \
    -subj "/C=FR/ST=countyland/L=toto/O=toto rh/CN=*.toto.fr" \
    -reqexts SAN \
    -extensions SAN \
    -config <(cat /usr/lib/ssl/openssl.cnf \
        <(printf '[SAN]\nsubjectAltName=DNS:dev.mycompany.com')) \
    -sha384 \
    -days 3650
```

### Pour Windows

```bash
openssl req \
    -newkey rsa:4096 \
    -x509 \
    -nodes \
    -keyout server.key \
    -new \
    -out server.crt \
    -subj /CN=dev.mycompany.com \
    -reqexts SAN \
    -extensions SAN \
    -config <(cat /System/Library/OpenSSL/openssl.cnf \
        <(printf '[SAN]\nsubjectAltName=DNS:dev.mycompany.com')) \
    -sha256 \
    -days 3650
```

### ssl gen autosigned

```bash
openssl req -days 365 -new -x509 -nodes \
 -out ssl.crt/server.crt \
 -keyout ssl.key/server.key
```


### Generer un csr

```bash
openssl req -new -newkey rsa:4096 -nodes -keyout app1.exemple.com.key -out app1.exemple.com.csr
```
Generer un csr/crt 2016 sha2
```bash
openssl req -nodes -newkey rsa:4096 -sha256 -keyout monserveur.key -out serveur.csr
```


### Autres : non-interactive openssl

```bash
openssl req -new -newkey rsa:4096 -nodes -sha256 \
 -keyout wildcard.key -out wildcard.csr \
 -subj "/C=FR/ST=Some-State/L=Ville/O=Entreprise/CN=*.exemple.com"
```

```bash
openssl req -new -newkey rsa:4096 -nodes -sha256 \
 -keyout wildcard.key -out wildcard.csr \
 -subj "/C=FR/ST=BRETAGNE/L=Ville/O=Entreprise/CN=*.exemple.com/emailAddress=admin@exemple.com"
```

```bash
openssl req -new -newkey rsa:4096 -nodes -sha256 \
 -keyout webmail.exemple.com.key -out webmail.exemple.com.csr \
 -subj "/C=FR/ST=BRETAGNE/L=Ville/O=Entreprise/CN=webmail.exemple.com/emailAddress=mairie@exemple.com"
```

## Commandes avancées

### Modifie la passphrase
#### Change passphrase
```bash
openssl rsa -aes256 -in server.key -out server.key.new
```

#### Delete passphrase
```bash
openssl rsa -in server.key -out server.key.new
```

### Convertion de format

| Opération       | Contrainte     | Commande |
|---------------- |--------------- |--------- |
| .crt to .pem    | Ancune         | ```openssl x509 -in mycert.crt -out mycert.pem -outform PEM``` |
| .key to .pem    | Ancune         | ```openssl rsa -in mycert.key -out mycert.key.pem -outform PEM`` |
| .pem to .der    | (public)       | ```openssl x509 -inform PEM -in fd.pem -outform DER -out fd.der``` |
|                 | (private)      | ```openssl rsa -inform PEM -in fd.pem -outform DER -out fd.der``` |
| .der to .pem    | Ancune         | ```openssl x509 -inform DER -in fd.der -outform PEM -out fd.pem``` |
| *.pem to PKCS12 | key+crt in pem | ```openssl pkcs12 -export -out fd.p12 -inkey fd.key -in fd.crt -certfile fd-chain.crt``` |
| PKCS12 to *.pem | +1             | ```openssl pkcs12 -in fd.p12 -out fd.pem -nodes``` |
| *.pem to PKCS7  | key+crt in pem | ```openssl crl2pkcs7 -nocrl -out fd.p7b -certfile fd.crt -certfile fd-chain.crt``` |
| PKCS7 to *.pem  | +1             | ```openssl pkcs7 -in fd.p7b -print_certs -out fd.pem``` |
| openssh .pub to pem | | ```ssh-keygen -f ~/.ssh/id_rsa.pub -e -m PEM >pubkey.pem``` |

1 : Séparer manuellement le (key+crt).pem résultant OU utiliser les commandes suivantes

```bash
openssl pkcs12 -in fd.p12 -nocerts -out fd.key -nodes
openssl pkcs12 -in fd.p12 -nokeys -clcerts -out fd.crt
openssl pkcs12 -in fd.p12 -nokeys -cacerts -out fd-chain.crt
```

### Verifications & Exports


| Type | Commandes |
|----- |---------- |
| verif CA/CRT | ```openssl verify -verbose -CAfile "$SSLDIR/CA_intermediate.pem"  "$SSLDIR/wildcard.crt"``` |
| verif CRT/KEY | ```(openssl x509 -noout -modulus -in "$SSLDIR/wildcard.crt"| openssl md5 ; openssl rsa -noout -modulus -in "$SSLDIR/wildcard.key" | openssl md5) | uniq``` |
| export CRT+KEY vers keystore java | ```openssl pkcs12 -export -name wildcardapp -in "$SSLDIR/wildcard.crt" -inkey "$SSLDIR/wildcard.key" -out /etc/tomcat7/keystore/wildcard.p12.$YEAR -password pass:$SSL_PWD``` |
| verif chaîne CA | `openssl verify -verbose -CAfile RootCert.pem -untrusted Intermediate.pem UserCert.pem` |
| convert to PFX (windows/ exchange) | ```openssl pkcs12 -export -out webmail.exemple.com.pfx -inkey webmail.exemple.com.key -in certificate-295508.crt -certfile StandardSSLCA2.pem``` |




## Remote openssl

Le principe est de lancer les commandes SSL à distance sur un serveur faisant autorité.


### Commandes usuelles

| Type | Commandes |
|----- |---------- |
| test port | ```openssl s_client -connect `zmhostname`:993 -ssl3``` |
| test port smtp/TLS | ```openssl s_client -connect `zmhostname`:25 -ssl3 -starttls smtp``` |
| show crt | ```openssl s_client -showcerts -servername webmail.exemple.com -connect webmail.exemple.com:443``` |
| show crt dates | ```openssl s_client -showcerts -servername webmail.exemple.com -connect webmail.exemple.com:443 | openssl x509 -noout -dates``` |
| wget public cert | ```true | openssl s_client -connect vm1.exemple.com:8443 2>/dev/null | openssl x509 -in /dev/stdin``` |



## Acceptation des cetificats par les clients
Il y a les certficats :
- Root
- Intermetidaire
- standard (SSL par abus du langage)

### Chrome
```bash
certutil -d sql:$HOME/.pki/nssdb -A -t "C,," -n "My Homemade CA" -i /path/to/CA/cert.file
```



### Debian general
```bash
cp my.crt /usr/local/share/ca-certificates/
update-ca-certificates
```


Chrome utilise le paquets

You will need libnss3-tools package on Debian/Ubuntu/Linux Mint or nss-tools on CentOS/Fedora/RHEL. Then use this script (add-cert.bash):

Pour faire accepter un cerficat ssl dans chrome sous li


```bash
apt-get install apt-get install libnss3-tools
```

En tant qu'utilisateur

```bash
cat <<'HERE' > /tmp/chrome_linux_accept_cerf.sh
 #!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 hostname"
    exit 1
fi

hostname=$1

 # Obtention du certificat
echo QUIT \
| openssl s_client -servername $hostname -connect $hostname:443 -showcerts 2>null \
| sed -ne '/BEGIN CERT/,/END CERT/p' \
>/tmp/cert-$hostname

 # Acceptation du certificat
 # "C,,"   pour les certificat Root
 # ",,"    pour les certificat intermediaire
 # "P,,"   pour les certificat autosigné

certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n $hostname -i /tmp/cert-$hostname

 # Affiche du certificat (pour vérification)
certutil -d sql:$HOME/.pki/nssdb -L

HERE
```

Accepter le certificat ssl d'une url
```bash
bash /tmp/chrome_linux_accept_cerf.sh iotds.mutu.local
```

Vérifier l'existance du certificat
```bash
certutil -d sql:$HOME/.pki/nssdb -L
```

Supprimer le certificat
```bash
certutil -d sql:$HOME/.pki/nssdb -D -n <certificate nickname>
```


Tester
```bash
google-chrome https://iotds.mutu.local
```

### Ajouter un certificat pour authentification client

```bash
pk12util -d sql:$HOME/.pki/nssdb -i PKCS12_file.p12
```


## Cyphers

- Kx : Élement secrete de session
- Au : Authentification des parties
- Enc : Chiffrement des données applicatives
- Mac : vérification de l'intégrité des données applicatives

Liste des ciphers utilisables supportés par le serveur
```bash
openssl ciphers -v 'ALL:COMPLEMENTOFALL'
openssl ciphers -V 'ALL:COMPLEMENTOFALL'
```

Exemple de configuration Apache
```bash
SSLHonorCipherOrder On
SSLCipherSuite "RC4-SHA:HIGH:!aNULL"
```


pour obtenir un A+ ici https://www.ssllabs.com/ssltest/
voilà ce qui est configuré de + en + sur nos serveurs (grâce à https://mozilla.github.io/server-side-tls/ssl-config-generator/ )
```
SSLCipherSuite ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS
```


## Perfomance

```bash
openssl-1.0.1c speed rsa
```

## Best practices


Secure Protocols
- SSL v2 is insecure
- SSL v3 is very old and obsolete
- TLS v1.0 is largely still secure
- TLS v1.1 and v1.2 are without known security issues

Secure Cipher Suites
- Anonymous Diffie-Hellman (ADH) suites do not provide authentication.
- NULL cipher suites provide no encryption.
- Export key exchange suites use authentication that can easily be broken.
- Suites with weak ciphers (typically of 40 and 56 bits) use encryption that can easily be
broken.
- RC4 is weaker than previously thought. 2 You should remove support for this cipher in
the near future.
- 3DES provides only 108 bits of security (or 112, depending on the source), which is be-
low the recommended minimum of 128 bits. You should remove support for this ci-
pher in the near future

Knows probleme
- Disable insecure renegotiation
- Disable TLS compression
- Mitigate information leakage stemming from HTTP compression
- Disable RC4
- Be aware of the BEAST attack
