# Kanboard
## Installation
```
cd /usr/local/src/
apt-get install -y php5-gd unzip
/etc/init.d/apache2 restart
wget 'https://github.com/fguillot/kanboard/archive/v1.0.29.tar.gz' -O kanboard_1.0.29.tar.gz
tar -xzf kanboard_1.0.29.tar.gz
mv kanboard-1.0.29 /home/www/framasoft/kanboard
cd /home/www/framasoft/kanboard

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
php composer.phar install --no-dev

cp config.default.php config.php
sed -i "
s/notifications@kanboard.local/kanboard@`hostname -f`/
s/'MAIL_TRANSPORT', 'mail/'MAIL_TRANSPORT', 'sendmail/
s/DB_DRIVER', 'sqlite/DB_DRIVER', 'postgres/
s/DB_USERNAME', 'root/DB_USERNAME', 'user_kanboard/
s/DB_PASSWORD', ''/DB_PASSWORD', 'pass_kanboard'/
s/DB_NAME', 'kanboard/DB_NAME', 'db_kanboard/
s/ENABLE_URL_REWRITE', false/ENABLE_URL_REWRITE', true/
" config.php

chown -R ftpuser.www-data .
find -type d -exec chmod 750 {} \;
find -type f -exec chmod 640 {} \;
find data/ -type d -exec chmod 770 {} \;
find data/ -type f -exec chmod 660 {} \;

su - postgres
createuser -SDlPR user_kanboard
> pass_kanboard
createdb -T template0 --encoding='UTF-8' --lc-collate='fr_FR.UTF-8' --lc-ctype='fr_FR.UTF-8' -O user_kanboard b_kanboard
exit
```

### Apache
```
        <Directory /home/www/framasoft/kanboard/*>
                php_admin_value open_basedir "/home/:/var/lib/php5:/tmp:/dev/urandom"
        </Directory>
```

The default login and password is admin/admin


### framanav
```
mkdir /home/www/framasoft/
cd /home/www/framasoft/
git clone https://framagit.org/framasoft/framanav.git framanav
```

## Upgrade
### backup
```
mv /home/www/kanboard.exemple.com .
mysqldump -u root -p db_kanboard > db_kanboard.sql
```

### install
```
cd /home/www/
wget https://kanboard.net/kanboard-latest.zip
unzip unzip kanboard-latest.zip
rm kanboard-latest.zip
mv kanboard kanboard.exemple.com.new
cp kanboard.exemple.com/config.php kanboard.exemple.com.new/
cp -r kanboard.exemple.com/data kanboard.exemple.com.new/
chown -R ftpuser:www-data kanboard.exemple.com.new
chmod -R 750 kanboard.exemple.com.new/
chmod -R 770 kanboard.exemple.com.new/data
mv kanboard.exemple.com kanboard.exemple.com.bak
mv kanboard.exemple.com.new kanboard.exemple.com
```
