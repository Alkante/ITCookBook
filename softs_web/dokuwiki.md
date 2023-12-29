# Dokuwiki
<!-- TOC -->

- [Dokuwiki](#dokuwiki)
    - [Installation](#installation)
        - [Paramétrage apache](#paramétrage-apache)
    - [Extention](#extention)
        - [Markdowku](#markdowku)
        - [Gitbacked plugin](#gitbacked-plugin)
        - [Plain CAS Auth Plugin](#plain-cas-auth-plugin)
            - [Astuce : désactiver le cas](#astuce--désactiver-le-cas)
            - [#TODO Paramétrer les groups du CAS avec les CAL](#todo-paramétrer-les-groups-du-cas-avec-les-cal)

<!-- /TOC -->
## Installation

Les étapes d'installation sont décrites ici [https://www.dokuwiki.org/install](https://www.dokuwiki.org/install).


Télécharger la dernière version stable
[https://download.dokuwiki.org/](https://download.dokuwiki.org/)

```bash
cd /var/www
wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
tar xzvf dokuwiki-stable.tgz
rm dokuwiki-stable.tgz
```

Renommer le dossier

```bash
mv dokuwiki-2017-02-19b dokuwiki
cd dokuwiki
chown -R www-data: .
```


### Paramétrage apache

```bash
vim /etc/apache2/sites-available/dokuwiki.exemple.com.conf
```

```bash
<VirtualHost *:80>
    ServerAdmin admin@exemple.com
    ServerName dokuwiki.exemple.com
    DocumentRoot /var/www/dokuwiki
    DirectoryIndex index.php

    <Directory />
            Options FollowSymLinks
            AllowOverride None
    </Directory>
    <Directory /var/www/dokuwiki>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride none
            Order allow,deny
            allow from all
    </Directory>

    #LogFormat "%h %l %u %t \"%r\" %s %b \"%{Referer}i\" \"%{User-Agent}i\"" custom
    CustomLog /var/log/apache2/dokuwiki_exemple.com__access.log custom
    ErrorLog /var/log/apache2/dokuwiki_exemple.com__error.log
</VirtualHost>
```

Recharger apache
```bash
a2ensite dokuwiki.exemple.com.conf
service apache2 reload
service apache2 status
```



## Extention

Les extentions sont installables via l'interface web : Administer->Gestionnaire d'extensions

### Markdowku

Markdowku Permet de supporter nativement le markdown dans les pages

Installer le via le gestionnaire d'extentions.



### Gitbacked plugin

Suivre la documentation officiel : [https://www.dokuwiki.org/plugin:gitbacked](https://www.dokuwiki.org/plugin:gitbacked)


Changer les options du plugins dans l'interface d'administration : Administrer->Paramètres de configuration
- pushAfterCommit = Enable
- repoPath = ./data/gitrepo
- repoWorkDir = ./data/gitrepo/wiki


Changer les répertoires de dokuwiki pour évité des problèmes

```bash
cd /var/www/dokuwiki/data
mkdir -p gitrepo/wiki
mv pages gitrepo/wiki/.
mv media gitrepo/wiki/.
```

Créer un projet git avec un utilisateur, renseigner sa clef ssh et ces droit d'accès.
```bash
cd /var/www/dokuwiki/data/gitrepo
ls -al
```
Devrait afficher les répertoires ```.git``` et  ```wiki```.

Puis tester

### Plain CAS Auth Plugin

Le PlainCASAuth Plugin permet d'interface un CAS user/group avec le système d'authentification et le système d'ACL de dokuwiki.


Changer les options du plugins dans l'interface d'administration : Administrer->Paramètres de configuration
Options du plugin:
- plugin.authplaincas.server = cas4.exemple.com
- plugin.authplaincas.rootcas = /cas427
- plugin.authplaincas.rootcas = 8443
- handlelogoutrequest = enable

Options du générale:
- authtype = authplaincas

Télécharger CAS sur  [wiki.jasig.org](https://wiki.jasig.org/display/CASC/phpCAS)
```bash
cd /var/www/dokuwiki/lib/plugins/authplaincas
mkdir phpCAS
cd phpCAS

wget https://developer.jasig.org/cas-clients/php/current/CAS-1.3.5.tgz
tar xvf CAS-1.3.5.tgz
mv CAS-1.3.5/CAS .
mv CAS-1.3.5/CAS.php .

rm CAS-1.3.5.tgz
rm -r CAS-1.3.5
```


Vérifier les droits sur les fichiers.


Copier le fichier de conf dans la conf centrale
```bash
cp  /var/www/dokuwiki/lib/plugins/authplaincas/plaincas.settings.php /var/www/dokuwiki/conf/plaincas.settings.php
```


Modifier le fichier de conf centrale
```bash
vim /var/www/dokuwiki/conf/local.php
```

Ajouter la ligne
```bash
$conf['plugin']['authplaincas']['settings_file'] = './conf/plaincas.settings.php';
```

Configurer le serveur CAS pour qu'il accepte les connections de ce service.


#### Astuce : désactiver le cas

Si il y un ploblème avec le cas, Pour le désactiver il suffit de changer le fichier conf centrale
```bash
vim /var/www/dokuwiki/conf/local.php
```

Modifier la ligne
```php
$conf['authtype'] = 'authplaincas';
```
Par
```php
$conf['authtype'] = 'authplain';
```


Enjoy


#### #TODO Paramétrer les groups du CAS avec les CAL
