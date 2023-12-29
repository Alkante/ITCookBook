# NextCloud

## Installation

### Installer les paquets utile
```bash
apt-get install apache2 mariadb-server libapache2-mod-php5
apt-get install php5-gd php5-json php5-mysql php5-curl
apt-get install php5-intl php5-mcrypt php5-imagick
apt-get install unzip sudo
```
```bash
apt-get install php5-pgsql php5-gd
```


### Télécharger la dernière version
```bash
wget https://download.nextcloud.com/server/releases/nextcloud-11.0.0.zip
```
### Vérifier le hash
```bash
wget https://download.nextcloud.com/server/releases/nextcloud-11.0.0.zip.md5
md5sum -c nextcloud-11.0.0.zip.md5 < nextcloud-11.0.0.zip
```

### Vérfier la signature

```bash
wget https://download.nextcloud.com/server/releases/nextcloud-11.0.0.zip.asc
gpg --import nextcloud-11.0.0.zip.asc
gpg --verify nextcloud-11.0.0.zip.asc  nextcloud-11.0.0.zip
```

```bash
rm nextcloud-11.0.0.zip.md5 nextcloud-11.0.0.zip.asc
```

### Placer les sources
```bash
cp nextcloud-11.0.0.zip /var/www/
cd /var/www/
unzip nextcloud-11.0.0.zip
rm nextcloud-11.0.0.zip
chown -R www-data: nextcloud
mv nextcloud nextcloud.exemple.fr
```


### Configurer apache2

```bash
cd /etc/apache2/sites-available/
vim nextcloud.exemple.fr.conf
```

Ajouter
```text conf
<VirtualHost *:80>
        ServerName nextcloud.exemple.fr

        ServerAdmin admin@exemple.fr
        DocumentRoot /var/www/nextcloud

        <Directory /var/www/nextcloud/>
          Options +FollowSymlinks
          AllowOverride All

         <IfModule mod_dav.c>
          Dav off
         </IfModule>

         SetEnv HOME /var/www/nextcloud
         SetEnv HTTP_HOME /var/www/nextcloud

        </Directory>

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/nextcloud.exemple.fr.error.log
        CustomLog ${APACHE_LOG_DIR}/nextcloud.exemple.fr.access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For exemple the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
```
Tester la conf
```bash
apache2ctl configtest
```

Activé les mods utile
```bash
a2ensite nextcloud.phytosiberie.fr.conf
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime
a2enmod setenvif
```


Rédémarer apache2
```bash
service apache2 restart
```



### Restriction de permission maximal

```bash
vim rigth.sh
```

```bash
#!/bin/bash
ncpath='/var/www/nextcloud'
htuser='www-data'
htgroup='www-data'
rootuser='root'

printf "Creating possible missing Directories\n"
mkdir -p $ncpath/data
mkdir -p $ncpath/assets
mkdir -p $ncpath/updater

printf "chmod Files and Directories\n"
find ${ncpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ncpath}/ -type d -print0 | xargs -0 chmod 0750

printf "chown Directories\n"
chown -R ${rootuser}:${htgroup} ${ncpath}
chown -R ${htuser}:${htgroup} ${ncpath}/apps/
chown -R ${htuser}:${htgroup} ${ncpath}/assets/
chown -R ${htuser}:${htgroup} ${ncpath}/config/
chown -R ${htuser}:${htgroup} ${ncpath}/data/
chown -R ${htuser}:${htgroup} ${ncpath}/themes/
chown -R ${htuser}:${htgroup} ${ncpath}/updater/

chmod +x ${ncpath}/occ

printf "chmod/chown .htaccess\n"
if [ -f ${ncpath}/.htaccess ]
 then
  chmod 0644 ${ncpath}/.htaccess
  chown ${rootuser}:${htgroup} ${ncpath}/.htaccess
fi
if [ -f ${ncpath}/data/.htaccess ]
 then
  chmod 0644 ${ncpath}/data/.htaccess
  chown ${rootuser}:${htgroup} ${ncpath}/data/.htaccess
fi
```

```bash
sh rigth.sh
rm rigth.sh
```



```
mkdir /opt/data
chown -R www-data: /opt/data
chmod -R o-rwx /opt/data
```



### Configuration via command

```bash
sudo -u www-data php occ  maintenance:install --database "pgsql" --database-name "nextcloud"  --database-user "postgres" --database-pass "passwordpostgres" --admin-user "admin" --admin-pass "passwordadmin"
```

### Domain
```bash
vim config/config.php
```
Ajouter l'url du domaine
AVANT
```bash
  'trusted_domains' =>
  array (
    0 => 'localhost',
  ),
```
APRES
```bash
  'trusted_domains' =>
  array (
    0 => 'localhost',
    1 => 'nextcloud.exemple.fr',
  ),
```


### Utilisation de keeweb
#### Keeweb-desktop
Modifier le fichier /home/www/nextcloud/lib/base.php
```
                //$incompatibleUserAgents = [
                //      // OS X Finder
                //      '/^WebDAVFS/',
                //];
                $incompatibleUserAgents = [
                        // OS X Finder
                        '/^WebDAVFS/',
                        // KeeWeb client
                        '/KeeWeb\/\d+\.\d+\.\d+/',
                ];
```
#### Keeweb plugin Nextcloud
Nextcloud ne prend pas en compte le "user-agent" de keeweb , il ne peut donc pas faire de webdav



## Upgrade :
### nxt 9.0.56 -> nxt 10.0.4
```
cd /usr/local/src/
rm -rf nextcloud
wget https://download.nextcloud.com/server/releases/nextcloud-10.0.4.tar.bz2 -O nextcloud-10.0.4.tar.bz2
tar -xjf nextcloud-10.0.4.tar.bz2
cd /home/www/
sudo -u www-data php owncloud/occ maintenance:mode --on
mv nextcloud nextcloud.bak.9.0.54
mv /usr/local/src/nextcloud .
cp nextcloud.bak.9.0.54/config/config.php nextcloud/config/config.php
cd nextcloud
chown www-data: -R .
chmod 770 -R .
sudo -u www-data php occ upgrade -v
sudo -u www-data php occ maintenance:mode --off
sudo -u www-data php occ maintenance:singleuser --on
```

### maj wheezy -> jessie


### nxt 10.0.4 -> nxt 11.0.2
```
cd /usr/local/src/
rm -rf nextcloud
wget https://download.nextcloud.com/server/releases/nextcloud-11.0.2.tar.bz2 -O nextcloud-11.0.2.tar.bz2
tar -xjf nextcloud-11.0.2.tar.bz2
cd /home/www/
```


### bug 0 octet webdav win 10
Sabre\DAV\Exception: HTTP/1.1 500 No subsystem set a valid HTTP status code. Something must have interrupted the request without providing further detail.
cf https://github.com/nextcloud/server/issues/2887#issuecomment-275846679
```
vi /home/www/owncloud/3rdparty/sabre/dav/lib/DAV/Server.php +491
-        if ($response->getStatus() === null) {
+        if ($response->getStatus() === null && !($method === "LOCK" || $method === "UNLOCK")) {
```

### nxt 11.0.2 -> nxt 12.0.5
```
cd /usr/local/src/
rm -rf nextcloud
wget https://download.nextcloud.com/server/releases/nextcloud-12.0.5.tar.bz2
tar -xjf nextcloud-12.0.5.tar.bz2
cd /home/www/
sudo -u www-data php nextcloud/occ maintenance:mode --on
mv nextcloud nextcloud.bak.11.0.2
mv /usr/local/src/nextcloud .
cp nextcloud.bak.11.0.2/config/config.php nextcloud/config/config.php
cd nextcloud
chown www-data: -R .
chmod 770 -R .
sudo -u www-data php occ upgrade -v
sudo -u www-data php occ maintenance:mode --off
```

## API

### get file password protected
dossier partagé par le lien https://nextcloud.exemple.com/s/XXXXXXXXXXX, avec password MOTDEPASSE, et qui contient le fichier archive.tar:
```
curl -u "XXXXXXXXXXX:MOTDEPASSE" "https://nextcloud.exemple.com/public.php/webdav/archive.tar" -o archive.tar
```

### admin
#### add user password
```
curl -H "OCS-APIREQUEST: true" -X POST -u "login:yyyy" "https://nextcloud.exemple.com/ocs/v1.php/cloud/users" -d userid=password -d password=password
```

#### set user quota
```
curl -X PUT -u "login:yyyy" -H "OCS-APIREQUEST: true" "https://nextcloud.exemple.com/ocs/v1.php/cloud/users/password" -d key="quota" -d value="20Gb"
```

#### set user mail
```
curl -X PUT -u "login:yyyy" -H "OCS-APIREQUEST: true" "https://nextcloud.exemple.com/ocs/v1.php/cloud/users/password" -d key="email" -d value="p.nom@exemple.com"
```

#### set user display name
```
curl -X PUT -u "login:yyyy" -H "OCS-APIREQUEST: true" "https://nextcloud.exemple.com/ocs/v1.php/cloud/users/password" -d key="display" -d value="Prénom NOM"
```

#### set user group
```
curl -X POST -u "login:yyyy" "https://nextcloud.exemple.com/ocs/v1.php/cloud/users/password/groups" -d groupid="GROUPADMIN"
```

#### create folder inside user
```
curl -X MKCOL -k -u "login2:xxxx" "https://nextcloud.exemple.com/remote.php/webdav/folder/subfolder"
```

#### share SHARE1/NOM_prenom from login2 user to password user:
```
curl -X POST -u "login2:xxxx" "https://nextcloud.exemple.com/ocs/v1.php/apps/files_sharing/api/v1/shares" -d "path=/SHARE1/NOM_prenom&shareType=0&shareWith=password&permissions=1"
```


## Astuces

### unlock file

Situation où un fichier est lock.  
Exemple où il y a un lock sur le fichier /home/pnom/Nextcloud/monfichierlock.txt  

On calcule la key :  
```
echo -n "home::pnom::files/monfichierlock.txt" |md5sum
# YYYYYYYYYYYYYYYYYYYYY  -
```

On se connecte au serveur et à la BDD :
```
ssh user@nextcloud.exemple.com
su
less /home/www/nextcloud.exemple.com/config/config.php
# on note dbpassword
mysql -u user_owncloud -p -D db_owncloud
```

On vérifie l'état du lock :  
```
SELECT * FROM `oc_file_locks` WHERE `key` LIKE 'files/YYYYYYYYYYYYYYYYYYYYY';
```
On supprime le lock :  
```
DELETE FROM `oc_file_locks` WHERE `key` LIKE 'files/YYYYYYYYYYYYYYYYYYYYY';
```
