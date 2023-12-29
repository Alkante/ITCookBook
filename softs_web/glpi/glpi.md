# GLPI
## Installation 
	apt-get install apache2 php5 libapache2-mod-php5
	apt-get install php5-imap php5-ldap php5-curl
	apt-get install mysql-server php5-mysql

	mysql -u root -p
	> create database glpidb;
	> grant all privileges on glpidb.* to glpiuser@localhost identified by 'mot_de_passe_du_glpiuser';

Telecharger sur le site officiel glpi-project.org ou https://github.com/glpi-project/glpi/releases

Décompression

	tar -xvzf glpi-X.X.X.tar.gz -C  /var/www/html 
	chown -R www-data /var/www/html/glpi

Les dernière étape d'installation se font en interface web :
http://localhost/glpi

Une fois l'installation fini les comptes utilisateurs par défaut sont : 

* glpi/glpi
* tech/tech
* normal/normal
* post-only/postonly

