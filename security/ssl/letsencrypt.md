# Let's encrypt


<!-- TOC -->

- [Let's encrypt](#lets-encrypt)
  - [Fonctionnement](#fonctionnement)
    - [Le défis](#le-défis)
      - [Apache](#apache)
      - [Nginx](#nginx)
  - [Installation](#installation)
  - [Utilisation](#utilisation)
    - [Apache :](#apache-)
    - [Nginx :](#nginx-)
  - [Astuce](#astuce)
    - [Test](#test)
    - [Limit](#limit)
  - [Source :](#source-)
  - [Script acme](#script-acme)
    - [Installation](#installation-1)
    - [Création du certificat](#création-du-certificat)
    - [Apache < 2.4.8](#apache--248)
    - [Apache >= 2.4.8](#apache--248)
    - [Nginx](#nginx-1)
    - [List cert for acme](#list-cert-for-acme)
    - [Renouvellement](#renouvellement)
    - [Désactivation du renouvellement](#désactivation-du-renouvellement)
  - [MAJ script acme.sh](#maj-script-acmesh)

<!-- /TOC -->

## Fonctionnement

Pour obtenir un certificat, `letsencrypt` :
- génère une paire de clefs et une demande de signature de certificat (_Certificate Signing Request_, `CSR`) ;
- envoie la demande à un serveur `ACME` ;
- répond aux défis d’authentification (challenges) posés par le serveur, permettant au demandeur de prouver qu’il contrôle le(s) domaine(s) demandé(s) ;
- reçoit le certificat signé en retour.

### Le défi

Il faut rendre accessible via le port 80 (http), un fichier du type `.well-known/acme-challenge/aze5r465zt34-5dsg43sd5fg1sdfg2-jhk132nb-w3x`

Le token est une valeur aléatoire générée pour le serveur `ACME`

Le client `letencrypt` gère cela, il peut ouvrir lui même le port 80 ou ajouter le fichier a la racine du site existant.

#### Apache

VirtualHost port 80 :

```apacheconf
    # letsencrypt
    Alias /.well-known/acme-challenge/ /home/www/nothing/.well-known/acme-challenge/
    <Directory "/home/www/nothing/.well-known/acme-challenge/">
        Require all granted
        Options None
        AllowOverride None
        ForceType text/plain
        RedirectMatch 404 "^(?!/\.well-known/acme-challenge/[\w-]{43}$)"
    </Directory>
    RewriteEngine On
    RewriteCond %{REQUEST_URI} !^/.well-known/acme-challenge [NC]
    RewriteRule ^(.*)$ https://%{HTTP_HOST}$1 [R=permanent,L]
```

/!\ pour apache < 2.4.8, remplacer :  

```apacheconf
Require all granted
```

par

```apacheconf
Allow from all
```

#### Nginx

```nginx
    location / {
        return 301 https://app1.exemple.com$request_uri;
    }

    location ~ "/.well-known/acme-challenge/([\w-]{43})" {
        default_type "text/plain";
        root /home/www/app1.exemple.com/;
    }
```


## Installation

Client officiel certbot :

```bash
apt-get install certbot
```

Il existe d'autres implémentations voir plus bas, script acme.sh.

## Utilisation

```bash
certbot certonly  --noninteractive --agree-tos --webroot --webroot-path /home/www/app1.exemple.com/ --email mail@exemple.com -d app1.exemple.com --config-dir /etc/letsencrypt --work-dir /var/lib/letsencrypt --logs-dir /var/logs/letsencrypt
```
### Apache :

```apacheconf
SSLCertificateFile /etc/letsencrypt/live/app1.exemple.com-0001/fullchain.pem
SSLCertificateKeyFile /etc/letsencrypt/live/app1.exemple.com-0001/privkey.pem
```
### Nginx :

```nginx
ssl_certificate /etc/letsencrypt/live/app1.exemple.com-0001/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/app1.exemple.com-0001/privkey.pem;
```

## Astuce

### Test

Pour du test utiliser l'option `--staging`, avec cette option, le client passe par toutes les étapes mentionnées ci-dessus, mais le certificat obtenu est signé par une pseudo-CA (“happy hacker fake CA”) réservés aux tests. Permet de passer outre la limitation de cinq certificats par semaine pour un domaine donné

### Limit
- Certificates per Registered Domain, 50 par semaine, exemple avec <truc>.exemple.com, 50 truc possible
- Names per Certificate, 1 certificat a une limite de 100 domaine
- Duplicate Certificate, pour un même certificat, la régénération est limité a 5 par semaine
- Failed Validation, limite de 5 erreur par compte, par hote et par heure
- Overall Requests, les requêtes "new-reg", "new-authz" et "new-cert" sont limités a 20 par secondes
- Accounts per IP Address, limite de 10 comptes toutes les 3 heures ( 500 pour l'ipv6 /48)

Si vous avez atteint une limite d’utilisation, nous n’avons aucun moyen de la réinitialiser temporairement. Vous devez attendre que la limite d’utilisation expire au bout d’une semaine.

## Source :
linuxfr : https://linuxfr.org/users/gouttegd/journaux/reparlons-de-let-s-encrypt


## Script `acme.sh`

[Git](https://github.com/acmesh-official/acme.sh)

### Installation

```bash
cd /usr/local/src
tags=$(wget -qO- "https://api.github.com/repos/acmesh-official/acme.sh/tags")
offset=3
line=$(echo -e "$tags"| head -n $offset |tail -n 1)
while [[ "${line:13:1}" == "v" ]]; do
    offset=$((offset + 10))
    line=$(echo -e "$tags"| head -n $offset |tail -n 1)
done
version=${line:13:-2}
echo "DL version : $version"
echo "wget -q https://api.github.com/repos/acmesh-official/acme.sh/tarball/$version -O acme.sh.tar.gz"
wget -q https://api.github.com/repos/acmesh-official/acme.sh/tarball/$version -O acme.sh.tar.gz
tar -xvf acme.sh.tar.gz
rm -rf acme.sh.tar.gz
mkdir /etc/letsencrypt
cd acmesh-official-acme.sh-*
./acme.sh --install --home /etc/letsencrypt
./acme.sh --config-home /etc/letsencrypt --set-default-ca --server letsencrypt
#./acme.sh --upgrade --auto-upgrade
cd ../
rm -rf acmesh-official-acme.sh-*
chmod 750 /etc/letsencrypt
mkdir -p /home/www/nothing/.well-known/acme-challenge/
```

### 1 - Création du certificat

/!\ le premier `-d` doit indiquer l'adresse du site et les autres `-d` sont pour les alias

```bash
acme.sh --home /etc/letsencrypt --server letsencrypt --issue -d app1.exemple.com -d alias.app1.exemple.com \
-w /home/www/nothing/ \
--keylength 4096
```

NB : désormais `acme.sh` utilise les certificats `ZeroSSL` par défaut d'où le `--server letsencrypt`.

### 2 - installation du certificat - si Apache < 2.4.8

```bash
acme.sh --home /etc/letsencrypt --install-cert -d app1.exemple.com \
--cert-file /etc/ssl-cert/ssl.crt/app1.exemple.com.crt  \
--fullchain-file /etc/ssl-cert/ssl.crt/app1.exemple.com.chain.crt  \
--ca-file /etc/ssl-cert/ssl.ca/app1.exemple.com.ca  \
--key-file       /etc/ssl-cert/ssl.key/app1.exemple.com.key  \
--reloadcmd     "service apache2 force-reload"
```


### 2 - installation du certificat - si Apache >= 2.4.8

```bash
acme.sh --home /etc/letsencrypt --install-cert -d app1.exemple.com \
--fullchain-file /etc/ssl-cert/ssl.crt/app1.exemple.com.chain.crt  \
--key-file       /etc/ssl-cert/ssl.key/app1.exemple.com.key  \
--reloadcmd     "service apache2 force-reload"
```

NB : dans le cas d'une intervention manuelle sur un serveur géré par `Ansible`
le chemin est `/etc/ssl-cert/ssl.*` (sans `/apache2/`).

### 2 - installation du certificat - si Nginx

```bash
acme.sh --home /etc/letsencrypt --install-cert -d app1.exemple.com \
--fullchain-file /etc/ssl-cert/ssl.crt/app1.exemple.com.chain.crt  \
--key-file       /etc/ssl-cert/ssl.key/app1.exemple.com.key  \
--reloadcmd     "service nginx force-reload"
```

### List cert for acme

```bash
acme.sh --home /etc/letsencrypt --list
```

### Renouvellement

/!\ Il n'y a pas besoin de la faire c'est automatiquement fait tous les 60 jours. Mais vous pouvez le forcer par

```bash
acme.sh --renew -d example.com --force
```

NB : c'est la commande donnée lors du `--reloadcmd` de l'`--install-cert` qui est réutilisée lors des renouvellements donc pour changer cette commande (par exemple lors d'un passage d'Apache à Nginx) il faut refaire l'étape d'installation avec la nouvelle commande désirée.

### Désactivation du renouvellement

```bash
acme.sh --remove -d example.com
```

### Supprimer le dossier du site dans `/etc/letsencrypt` si plus utilisé

```bash
rm -rf /etc/letsencrypt/app1.exemple.com
```

### Certificat wildcard avec api ovh
Création api ovh : https://api.ovh.com/createToken/?GET=/domain/zone/exemple.com/*&POST=/domain/zone/exemple.com/*&PUT=/domain/zone/exemple.com/*&GET=/domain/zone/exemple.com&DELETE=/domain/zone/exemple.com/record/*

Sur Frt1
```bash
echo "
SAVED_OVH_AK='app key'
SAVED_OVH_AS='app secret'
SAVED_OVH_CK='consumer key'
" > /etc/letsencrypt/account.conf
/etc/letsencrypt/acme.sh --home /etc/letsencrypt --server letsencrypt --issue -d exemple.com -d '*.exemple.com' \
--dns dns_ovh \
--keylength 4096
/etc/letsencrypt/acme.sh --home /etc/letsencrypt --install-cert -d exemple.com \
--fullchain-file /etc/ssl-cert/ssl.crt/wildcard.exemple.com.chain.crt  \
--key-file       /etc/ssl-cert/ssl.key/wildcard.exemple.com.key  \
--reloadcmd     "service apache2 force-reload"

## MAJ script `acme.sh`

MAJ du code `acme` en précisant le dossier où il était installé :

```bash
/etc/letsencrypt/acme.sh --upgrade --home "/etc/letsencrypt"
```

## Migration de l'API v1 à v2

### Symptômes

Symptôme :
```bash
root@x126:/etc/letsencrypt# /etc/letsencrypt/acme.sh --renew -d app1.exemple.com --server letsencrypt
[mercredi 23 juin 2021, 16:14:18 (UTC+0200)] Renew: 'app1.exemple.com'
[mercredi 23 juin 2021, 16:14:18 (UTC+0200)] Using CA: https://acme-v01.api.letsencrypt.org/directory
[mercredi 23 juin 2021, 16:14:18 (UTC+0200)] Single domain='app1.exemple.com'
[mercredi 23 juin 2021, 16:14:18 (UTC+0200)] Getting domain auth token for each domain
[mercredi 23 juin 2021, 16:14:19 (UTC+0200)] Could not get nonce, let's try again.
[mercredi 23 juin 2021, 16:14:23 (UTC+0200)] Could not get nonce, let's try again.
[mercredi 23 juin 2021, 16:14:25 (UTC+0200)] Could not get nonce, let's try again.
[mercredi 23 juin 2021, 16:14:28 (UTC+0200)] Could not get nonce, let's try again.
```

Autre symptôme :
```bash
./acme.sh --renew -d app1.exemple.com
[lundi 26 juillet 2021, 13:59:28 (UTC+0200)] Renew: 'app1.exemple.com'
[lundi 26 juillet 2021, 13:59:28 (UTC+0200)] 'app1.exemple.com' is not an issued domain, skip.
```

`acme.sh --debug 2 ...` permet de voir le besoin de passer à la version 2.

### Solution

```bash
/etc/letsencrypt/acme.sh --home /etc/letsencrypt/ --upgrade
sed -i 's/acme-v01/acme-v02/' /etc/letsencrypt/*/*.conf
sed -i '/LinkOrder/d' /etc/letsencrypt/*/*.conf
sed -i '/LinkCert/d' /etc/letsencrypt/*/*.conf
for domain in $(/etc/letsencrypt/acme.sh --list --home /etc/letsencrypt/ | tail -n +2 |awk '{ print $1}'); do echo "/etc/letsencrypt/acme.sh  --home /etc/letsencrypt --config-home /etc/letsencrypt --renew -d $domain --server letsencrypt --force"; done
```

Lancer les commandes de la sortie standard du for
