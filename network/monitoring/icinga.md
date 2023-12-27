# Icinga
## Installation
	add-apt-repository ppa:formorer/icinga
	apt-get update
	apt-get install icinga2
	service icinga2 start
	apt-get install mysql-server mysql-client

Configuration de la BDD :

	mysql -u root -p
	mysql> CREATE DATABASE icinga;
	mysql> GRANT SELECT, INSERT, UPDATE, DELETE, DROP, CREATE VIEW, INDEX, EXECUTE ON icinga.* TO 'icinga'@'localhost' IDENTIFIED BY 'icinga';

	apt-get install icinga2-ido-mysql
	mysql -u root -p icinga < /usr/share/icinga2-ido-mysql/schema/mysql.sql
	icinga2 feature enable command
	service icinga2 restart

	cd /usr/share/
	git clone git://git.icinga.org/icingaweb2.git
	cd icingaweb2

	./bin/icingacli setup config webserver apache --document-root /usr/share/icingaweb2/public
	addgroup --system icingaweb2
	usermod -a -G icingaweb2 www-data 

	./bin/icingacli setup token create
	./bin/icingacli setup token show

La fin de l'installation ce fait via l'url http://localhost/icingaweb2/setup 

Placer votre token précédemment afficher

Requirements :

- Defaut timezone :
Editer le fichier /etc/php5/apache2/php.ini :

		date.timezone = Europe/Paris
- Module INTL :

		apt-get install php5-intl
- Module IMAGICK :

		apt-get install php5-imagick
- Module SQL :

		apt-get install php5-pgsql






