
# Apache2

<!-- TOC -->

- [Apache2](#apache2)
  - [Tester la configuration](#tester-la-configuration)
  - [Liste de règle et de principe](#liste-de-règle-et-de-principe)
    - [Alias](#alias)
    - [.htaccess & AllowOverride](#htaccess--allowoverride)
    - [Options](#options)
    - [Droit](#droit)
  - [Modules](#modules)
    - [Rewrite : mod_rewrite](#rewrite--mod_rewrite)
      - [Règles patern](#règles-patern)
  - [Rewrite](#rewrite)
    - [Test .htaccess](#test-htaccess)
    - [Redirection serveralias](#redirection-serveralias)
    - [Redirection permanente vers une autre adresse](#redirection-permanente-vers-une-autre-adresse)
    - [Redirection sauf pour une ip](#redirection-sauf-pour-une-ip)
    - [redirection sauf pour plusieurs ips](#redirection-sauf-pour-plusieurs-ips)
    - [Redirection vers page de maintenance sauf une IP](#redirection-vers-page-de-maintenance-sauf-une-ip)
    - [Redirection serveralias vers servername](#redirection-serveralias-vers-servername)
    - [Directory renamed](#directory-renamed)
    - [Maintenance pour tout le monde (sauf IP) pour le VH app2.exemple.com + pour les pages non maintenance + pour les chemins qui ne commencent pas par CDG35](#maintenance-pour-tout-le-monde-sauf-ip-pour-le-vh-wwwcdg35fr--pour-les-pages-non-maintenance--pour-les-chemins-qui-ne-commencent-pas-par-cdg35)
    - [Maintenance pour tout le monde (sauf IP) sauf css png...](#maintenance-pour-tout-le-monde-sauf-ip-sauf-css-png)
    - [Modif du directory index conditionne](#modif-du-directory-index-conditionne)
    - [Redirection vers bipel.com pour les autres pages de l'ancien site](#redirection-vers-bipelcom-pour-les-autres-pages-de-lancien-site)
    - [Robots.txt pour ancien site (desindex google en cours)](#robotstxt-pour-ancien-site-desindex-google-en-cours)
    - [Filtre robot et url (pas testé)](#filtre-robot-et-url-pas-testé)
    - [Redirect all to 404](#redirect-all-to-404)
    - [Redirect mapserv (NT:not case sensitive, PT: url et non fichier, QSA: conserve les paramètres de l'url, apres le ?)](#redirect-mapserv-ntnot-case-sensitive-pt-url-et-non-fichier-qsa-conserve-les-paramètres-de-lurl-apres-le-)
  - [Htpasswd](#htpasswd)
    - [Authentification LDAP](#authentification-ldap)
    - [log des alias ex:/lizmap](#log-des-alias-exlizmap)

<!-- /TOC -->

## Tester la configuration
```bash
apache2ctl configtest
```


## Liste de règle et de principe

### Alias

Les allias permet de faitre pointer un chemin vers n'importe quel répertoire du serveur.

Si le chemin doit matcher une regex, utiliser **AliasMatch**


### .htaccess & AllowOverride

**AllowOverride** défini les les règle utilisable dans le **.htaccess**
- ```AllowOverride All``` Permet les réécritue via **.htaccess**
- ```AllowOverride None``` Interdit les réécritue via **.htaccess**
- ```AllowOverride x,y``` Permet de réécrire les règle x et y via **.htaccess**

Exemple limitation d'un access a un dossier :
```
AuthType Basic
AuthName "Restricted Files"
AuthBasicProvider file
AuthUserFile "/usr/local/apache/passwd/passwords"
Require valid-user
ForceType application/octet-stream
```
Création d'un user :
```
htpasswd -c /usr/local/apache/passwd/passwords expocommerce
```

### Options
Les options peuvent etre ajoutées avec ```+``` et envelées avec ```-```:web
| Options | description |
|-------- |------------ |
| ```Options +Indexes``` | Affiche un explorateur de fichier si aucune page n'est présente|
| ```Options +FollowSymLinks``` | Permet de suivre les liens symbolique (pas de limitaiton) |
| ```Options +ExecCGI ``` | Authorize l'exécution de scripts cgi |
| ```Options +MultiViews``` | si la page xxxx/toto n'existe pas, elle permet d'affiche la page avant comme pattern```.*toto.*``` |

### Droit
Les droit en font en fonction de l'host de connexion
**Order défini dans quel ordre sont appliqué les règles.

Ancienne version
```apache
Order allow,deny
Allow from all
Deny from env=GoAway
```


## Modules


### Rewrite : mod_rewrite

Analyse du full path avec X rules et Y conditions
| Code | description |
|----- |------------ |
|```RewriteEngine On``` | Activation |
|```RewriteBase "/myapp/"``` | Contexte/chrooting, (abstraction des règles en ignorant '/myapp/') |
|```RewriteRule "^index\.html$"  "welcome.html"``` | réécriture via regex |



#### Règles patern
**RewriteRule patern substitution flags**
substitution :
* Remplace le motif matché par le patern
* Chemin obsolu vers un fichier cible
* L'URL intégrale pour faire une redirection
* utilisé '-' pour ne rien remplacer

```apache
RewriteRule "^/my/patern$" "http://site2.example.com/voirproduits.html" [R]
```

## Rewrite

### Test .htaccess
RewriteRule ^test\.html http://192.168.0.18/? [R=301,L]

RewriteEngine on
RewriteCond %{HTTP_HOST} ^support\.exemple\.com
RewriteRule ^(.*)$ https://support.exemple.com/$1 [R=permanent,L]

### Redirection serveralias
```
<VirtualHost *:80>
    ServerName exemple.com
    ServerAlias www.exemple-formation.fr
    ServerAlias www.exemple.com exemple.com
    ServerAlias www.exemple.net exemple.net
    ServerAlias www.exemple.org exemple.org
    Redirect permanent / http://www.exemple.com/
</VirtualHost>
```

### Redirection permanente vers une autre adresse
```
RedirectMatch permanent (.*) http://app1.exemple.com$1
```

### Redirection sauf pour une ip
```
RewriteEngine on
RewriteCond %{REMOTE_ADDR} !193.251.20.2
RewriteCond %{REQUEST_URI} ^(.*)$
RewriteRule ^(.*)$ http://app1.exemple.com
```

### redirection sauf pour plusieurs ips
```
RewriteEngine on
RewriteCond %{REQUEST_URI} ^/admin
RewriteCond %{REMOTE_ADDR} !X.X.X.X
RewriteCond %{REMOTE_ADDR} !Y.Y.Y.Y
RewriteRule .* / [R=302,L]
```

### Redirection vers page de maintenance sauf une IP
```
RewriteBase /
RewriteCond %{REMOTE_HOST} !^193\.251\.20\.2
RewriteCond %{REQUEST_URI} !/index_maintenance\.htm$
RewriteRule .* /index_maintenance.htm [R=302,L]

RewriteEngine On
RewriteBase /
RewriteCond %{REQUEST_URI} !^/maintenance\.htm$
RewriteRule ^(.*)$ http://app1.exemple.com/maintenance.htm [R=307,L]
```

### Redirection serveralias vers servername
```
RewriteEngine on
RewriteCond %{HTTP_HOST} ^app2\.exemple\.fr
RewriteRule ^(.*)$ https://app1.exemple.com/$1 [R=permanent,L]
```

### Directory renamed
```
RewriteEngine On
RewriteRule ^mantis-1.0.8/(.*)$ http://support.exemple.com/mantis/$1 [R=301,L]
```

### Maintenance pour tout le monde (sauf IP) pour le VH app2.exemple.com + pour les pages non maintenance + pour les chemins qui ne commencent pas par ADMIN
```
RewriteCond %{REMOTE_HOST} !^193\.251\.20\.2
RewriteCond %{REQUEST_URI} !^/maintenance\.html$
RewriteCond %{REQUEST_URI} !^/ADMIN
RewriteCond %{HTTP_HOST} ^app2.exemple.com$
RewriteRule ^(.*)$ http://app2.exemple.com/maintenance.html [R=307,L]
```

### Maintenance pour tout le monde (sauf IP) sauf css png...
```
RewriteBase /
RewriteCond %{REMOTE_HOST} !^X\.X\.X\.X
RewriteCond %{REQUEST_URI} !/maintenance\.html
RewriteCond %{REQUEST_URI} !/media/images/logi\.png
RewriteCond %{REQUEST_URI} !/styles/home\.css$
RewriteCond %{REQUEST_URI} !/media/images/interfacev2/image\.png$
RewriteRule .* /maintenance.html [R=302,L]
```


### Modif du directory index conditionne
```
RewriteCond %{HTTP_HOST} ^app1.exemple.com$
RewriteRule ^index.php$ resultats.html
```

### Redirection vers app1.exemple.com pour les autres pages de l'ancien site
```
RewriteCond %{REQUEST_URI} !^/robots\.txt$
RewriteCond %{REQUEST_URI} !^/robots2\.txt$
RewriteCond %{HTTP_HOST} ^app2.exemple.com
RewriteRule ^(.*)$ http://app1.exemple.com/accueil [R=301,L]
```

### Robots.txt pour ancien site (desindex google en cours)
```
RewriteCond %{HTTP_HOST} app2.exemple.com
RewriteRule robots.txt http://app2.exemple.com/robots2.txt [R,L]
```

### Filtre robot et url (pas testé)
```
RewriteCond %{HTTP_HOST} app3.exemple.com$ [NC]
RewriteCond %{HTTP_USER_AGENT} Googlebot [OR]
RewriteCond %{HTTP_USER_AGENT} Exabot [OR]
RewriteCond %{REQUEST_URI} ^/ot
RewriteRule .* http://app3.exemple.com [L,R=301]
```

### Redirect all to 404
```
RedirectMatch 404 ^/.*$
#404 en fonction du query string
RewriteCond %{QUERY_STRING}     ^$              [OR]
RewriteCond %{QUERY_STRING}     ^editor=ckeditor&ServerPath=.*\.\..*$ [OR]
RewriteCond %{QUERY_STRING}     ^editor=ckeditor&ServerPath=\/(?!upload).*$
RewriteRule ^.*$  -  [F]
```


### Redirect mapserv (NT:not case sensitive, PT: url et non fichier, QSA: conserve les paramètres de l'url, apres le ?)
```
RewriteEngine On
RewriteRule ^/map/(.*)$ /cgi-bin/mapserv?map=/home/app4/data/app4/Publication/$1.map [NC,PT,QSA]
```

## Htpasswd

```
htpasswd -D /home/sites/app/.htpasswd app_user
htpasswd -mb /home/sites/app/.htpasswd app_user XXXX

#maxclients # apache2ctl -l
<IfModule mpm_prefork_module>
ServerLimit 512
MaxClients  512
</IfModule>


SetEnvIfNoCase User-Agent ProoXiBot badbot
<Directory "/home/pnom/project_app4/web">
    AllowOverride All
    Order allow,deny
    Allow from all
    Deny from env=badbot
</Directory>

<Directory /usr/share/phpmyadmin>
        AuthUserFile /usr/share/phpmyadmin/.htpasswd
        AuthName "Please Log In"
        AuthType Basic
        require valid-user
        Order allow,deny
        Allow from X.X.X.X Y.Y.Y.Y
        satisfy any
</Directory>

<Directory /home/www/www.exemple.com/app6/clients/configurateur3d>
   AuthName "Page protégée"
   AuthType Basic
   AuthUserFile "/home/www/www.exemple.com/app6/clients/configurateur3d/.htpasswd"
   Require valid-user
   Require all denied
   Require ip X.X.X.X Y.Y.Y.Y
   satisfy any
</Directory>


AuthUserFile /var/www/pass/.htpasswd
AuthName "Acces restreint"
AuthType Basic
<Limit GET POST>
Require valid-user
</Limit>

#Création du fichier .htpasswd
htpasswd -c /home/www/intra.exemple.com/.htpasswd ermontuser


#debug
ps auxw | grep apache | awk '{print"-p " $2}' | xargs strace -c
ps auxw | grep apache | awk '{print"-p " $2}' | xargs strace -tt -T

#Request URI too long"
LimitRequestLine 32768

#apache 2.2 et X-Forwarded-For
apt-get install libapache2-mod-rpaf
RPAFproxy_ips IPPUBLIQUE_DU_CLIENT
```

### Authentification LDAP
Exemple :
```
<Limit POST PUT DELETE>
    AuthType Basic
    AuthBasicProvider ldap
    AuthName "LDAP Authentication"
    AuthLDAPGroupAttribute member
    AuthLDAPGroupAttributeIsDN On
    AuthLDAPUrl ldap://ldap.exemple.com:389/ou=Utilisateurs,dc=exemple,dc=com?sAMAccountName?sub?(objectClass=*) TLS
    AuthLDAPBindDN CN=read-only,OU=Utilisateurs,DC=exemple,DC=com
    AuthLDAPBindPassword "YYYYYY"
    Require ldap-group CN=groupAdmin,OU=Groupes,DC=exemple,DC=com
</Limit>
```

### log des alias ex:/lizmap
```
SetEnvIfNoCase Request_URI "^/lizmap/" lizmaplog
CustomLog "${INSTALL_DIR}/logs/access_lizmap.log" combined env=lizmaplog
```
