# Horde


```
apt-get install php-horde-webmail
#apt-get install php-horde-groupware
a2disconf php-horde
service apache2 reload


cd /etc/horde/
cd horde
cp conf.php.dist conf.php
chown www-data conf.php
```



# Prérequis

Installer apache et php
```
apt-get install apache2 php5 php-gettext
```

Configuration apache
```
AcceptPathInfo On
```

## Intallation

Configure php init

```bash
vim /etc/php5/apache2/php.ini
```
Vérify
```bash
file_uploads = On
```

Changer
```bash
upload_tmp_dir = /tmp
upload_max_filesize = 10M
```
