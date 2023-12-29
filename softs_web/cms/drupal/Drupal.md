# Drupal

### Préparer des dossier du site
	mkdir -p /var/www/www.exemple.fr
	cd /var/www/www.exemple.fr


### Télécharger Drupal
	wget https://ftp.drupal.org/files/projects/drupal-7.43.tar.gz
	tax xvf drupal-7.43.tar.gz
	rm drupal-7.43.tar.gz

	mv drupal-7.43/* .
	mv drupal-7.43/.* .

	rmdir drupal-7.43o

	chown -R www-data: /var/www/www.exemple.fr


### Parametrer apache
	#---
	a2ensite www.exemple.fr.conf
	apachectl configtest
	service apache2 restart
	service apache2 status


### Utiliser Mysql
	mysql -u root -p
	CREATE DATABASE drupal;
	CREATE USER 'user_drupal'@'localhost' IDENTIFIED BY 'xxxxxxxxxxxxxxxxxxxxxx';
	GRANT ALL PRIVILEGES ON drupal.* TO 'user_drupal'@'localhost';
	exit

#### Test connection
	mysql -u user_drupal -p

### Install extention
	apt-get update
	apt-get install php5-gd
	service apache2 restart
	service apache2 status
