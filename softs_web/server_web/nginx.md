# Nginx
## Outil :
### Convertisseur htaccess vers nginx
https://winginx.com/en/htaccess

## Aide :
### Afficher les configurations des sites disponibles
```
ls /etc/nginx/sites-available
```

### Afficher les configurations des sites activées
```
ls /etc/nginx/sites-enabled
```

### Activer un site disponible
```
cd /etc/nginx/site-enabled
ln -s ../site-available/mon-site.conf mon-site.conf
```

### Désactiver un site actif
```
cd /etc/nginx/site-enabled
rm mon-site.conf
```

### Vérifier un fichier de configuration
```
nginx -t -c /etc/nginx/site-availables/mon-site.conf
```

## Bonne pratique
### Worker processes
```
echo "worker_processes `grep processor /proc/cpuinfo | wc -l`;" >> /etc/nginx/nginx.conf
```

### Maximize worker_connections
a confirmer
```
echo "worker_processes 1024;" >> /etc/nginx/nginx.conf
```

### Activer gzip
```
echo "gzip on;
gzip_proxied any;
gzip_types text/plain text/xml text/css application/x-javascript;
gzip_vary on;
gzip_disable \"MSIE [1-6]\.(?!.*SV1)\";" > /etc/nginx/conf.d/gzip.conf
```

### Activer le cache pour les fichiers static
/etc/nginx/sites-available/sitename
```
location ~*  \.(jpg|jpeg|png|gif|ico|css|js)$ {
   expires 365d;
}
```

### Désactiver les logs
```
echo "access_log off;" >> /etc/nginx/nginx.conf
```

### Fichier du site
- "root" a l'exterieur location
- Une seul directive "index"
- ne pas utiliser de "if"
    * check si le fichier existe avec "try_files"

## Conf ssl
https://mozilla.github.io/server-side-tls/ssl-config-generator/

## Convert apache htaccess to nginx :
https://winginx.com/en/htaccess

## Configure ldap acces
Activer le module auth-pam dans le ficher /etc/nginx/nginx.conf
```
include modules-enabled/50-mod-http-auth-pam.conf;
```
Installer le paquet libpam-ldap
```
apt install libpam-ldap
```
Configurer le fichier /etc/pam_ldap.conf
```
base OU=Utilisateurs,DC=exemple,DC=com
uri ldap://ldap.exemple.com:389
binddn CN=read-only,OU=Utilisateurs,DC=exemple,DC=com
bindpw YYYYYY
pam_groupdn CN=groupAdmin,OU=Groupes,DC=exemple,DC=com
pam_member_attribute member
ssl start_tls
```
Ajouter le CA exemple.com :
```
vim /usr/local/share/ca-certificates/CA_intermediate.crt
```
Puis update des certs
```
/usr/sbin/update-ca-certificates
```

# server precedence
first match : listen. Then : server_name

## listen
if undefined = 0.0.0.0:80
if listen 192.168.1.1 => listen 192.168.1.1:80
if listen 8888 => listen 0.0.0.0:8888

## server_name

exact match, then leading *, then trailing *, then regex, then default
### exact
exact server_name is searched first

if multiple exact server_name match => first wins

### leading
server_name *.domain.org;

if multiple leading wildcard server_name match => longest wins

### trailing
server_name www.domain.*;

if multiple trailing wildcard server_name match => longest wins

### regex
server_name ~ [a-z].domain.org

if multiple regex server_name match => first wins


## location syntax
syntax: location modifier request_uri { ... }

### modifier list:
- (none): prefix match
- = : exact match
- ~ : case-sensitive regex
- ~* : case-insensitive regex
- ^~ : empêche que d'autre location match l'uri que vous avez configurer

### location precedence

```
1 non regex
  11 exact =
  12 LONGEST prefix ~^
2 regex
  21 FIRST regex ( case-sensitive ~ or case-insensitive ~* )
3 LONGEST prefix (none)

when not exact : regex > prefix
prefix : longuest wins
regex : first wins
```

1. =
2. ^~
3. ~
4. ~*
5. (none)
