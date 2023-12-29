# PHP
## Liste des modules chargés
php -m

## sessions
côté serveur
```
session.gc_maxlifetime 1800
```
côté client
```
session_set_cookie_params(1800, '/');
```

## upload cgi app
Aligner les variables suivantes
```
upload_tmp_dir = /var/lib/php5
session.save_path = /var/lib/php5
```
Et vérifier que /usr/bin/perl existe (ou présence d'un lien symbolique)
Puis dans la conf apache:
```
<Directory /home/www/xxxx/scripts/app/cgi-bin>
     Options ExecCGI
     AddHandler cgi-script cgi
</Directory>
```

## variables php serveur
HTTP_HOST  app1.exemple.com:8080

SERVER_NAME  app1.exemple.com

SERVER_PORT  8080

## phpinfo command line
```
echo "<?php phpinfo();?>" | php
```
phpinfo avec conf apache
```
echo "<?php phpinfo(); ?>" | php -c /etc/php5/apache2/php.ini |egrep "map|ogr"
```

## desactive affichage des erreurs
```
sed -i "s/^display_errors = On/;display_errors = On/g" /etc/php5/apache2/php.ini
sed -i "/;display_errors = On/ i\display_errors = Off" /etc/php5/apache2/php.ini
```
## activation log
```
sed -i "s/^log_errors = Off/;log_errors = Off/g" /etc/php5/apache2/php.ini
sed -i "/;log_errors = Off/ i\log_errors = On" /etc/php5/apache2/php.ini
```

## Upload size
post_max_size integer = Définit la taille maximale des données reçues par la méthode POST. Cette option affecte également les fichiers chargés. Pour charger de gros fichiers, cette valeur doit être plus grande que la valeur de upload_max_filesize. Si la limitation de mémoire est activée par votre script de configuration, memory_limit affectera également les fichiers chargés.

De façon générale, memory_limit doit être plus grand que post_max_size. Lorsqu'un entier est utilisé, sa valeur est mesurée en octets

memory_limit > post_max_size > upload_max_filesize
## memory_limit
```
sed -i "s/^memory_limit = /;memory_limit = /g" /etc/php5/apache2/php.ini
sed -i "/^;memory_limit = / i\memory_limit = 80M" /etc/php5/apache2/php.ini
```
## post_max_size = 12M
```
sed -i "s/^post_max_size = /;post_max_size = /g" /etc/php5/apache2/php.ini
sed -i "/^;post_max_size = / i\post_max_size = 85M" /etc/php5/apache2/php.ini
```
## upload_max_filesize = 10M
```
sed -i "s/^upload_max_filesize = /;upload_max_filesize = /g" /etc/php5/apache2/php.ini
sed -i "/^;upload_max_filesize = / i\upload_max_filesize = 80M" /etc/php5/apache2/php.ini
```
## Verif de la conf:
```
egrep "memory_limit|post_max_size|upload_max_filesize" /etc/php5/apache2/php.ini
egrep "^memory_limit|^post_max_size|^upload_max_filesize" /etc/php5/apache2/php.ini
```

## POST nombre de variables
```bash
echo 'max_input_vars = 6000' >> /etc/php5/apache2/php.ini
```

deprecated : error_reporting  =  E_ALL & ~E_NOTICE & ~E_DEPRECATED & ~E_USER_DEPRECATED

## Drapeaux php
### Variables booleans :
Utiliser php_admin_flag / php_flag dans les conf / .htaccess
### Autres variables :
Utiliser php_admin_value / php_value dans les  conf / .htaccess

### compatibilite php4 vers php5
```
  <Directory /home/app2>  
    php_admin_value magic_quotes_gpc on
    php_admin_value short_open_tag on
    php_admin_value zend.ze1_compatibility_mode on
  </Directory>
```

## flush php5-memcache
```
echo "flush_all" | /bin/netcat -q 2 127.0.0.1 11212
```

## HTTP 301 Redirect permanent in PHP
```
<?php
header("HTTP/1.1 301 Moved Permanently");
header("Location: http://www.exemple.com/");
exit();
?>
```
## force sendmail from (return path)
```
php_admin_value sendmail_path "/usr/sbin/sendmail -t -i -fuser@domain2.com"
```
