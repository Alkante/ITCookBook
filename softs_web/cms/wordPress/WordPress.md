# WordPress

### Création du répertoire du site

	mkdir -p /var/www/www.exemple.fr
	cd /var/www/www.exemple.fr

### Télécharger WordPress

	wget https://fr.wordpress.org/wordpress-4.4.2-fr_FR.tar.gz
	tar xvf tar xvf wordpress-4.4.2-fr_FR.tar.gz

	rm wordpress-4.4.2-fr_FR.tar.gz
	mv wordpress/* .
	rmdir wordpress
	own -R www-data: /var/www/site2.exemple.com



### Apache mod_rewrite
	a2enmod rewrite
	service apache2 restart


### Utiliser Mysql
	mysql -u root -p
	CREATE DATABASE wordpress;
	CREATE USER 'user_wordpress'@'localhost' IDENTIFIED BY 'xxxxxxxxxxxxxxxxxxxxx';
	GRANT ALL PRIVILEGES ON wordpress.* TO 'user_wordpress'@'localhost';
	exit

#### Test connection
	mysql -u user_wordpress -p
