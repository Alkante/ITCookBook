# Joomla


	cd /var
	mkdir www.monsite.fr
	cd www.monsite.fr


### Installer la dernière version de Joomla
	wget https://github.com/joomla/joomla-cms/releases/download/3.5.0/Joomla_3.5.0-Stable-Full_Package.zip


	apt-get install -y unzip
	unzip Joomla_3.5.0-Stable-Full_Package.zip

	rm Joomla_3.5.0-Stable-Full_Package.zip



### Apache mod_rewrite
	a2enmod rewrite
	service apache2 restart


### Utiliser Mysql
	mysql -u root -p
	CREATE DATABASE joomla;
	CREATE USER 'user_joomla'@'localhost' IDENTIFIED BY 'xxxxxxxxxxxxxxxxxxxxxx';
	GRANT ALL PRIVILEGES ON joomla.* TO 'user_joomla'@'localhost';
	exit

#### Test connection
	mysql -u user_joomla -p


### Installer les plugon apachessudo

apt-get install libapache2-mod-auth-mysql php5-mysql

### Utiliser PostgreSQL 9.1+
	su -l postgres
	psql
	CREATE DATABASE joomla;

	pwgen -cns 20
	CREATE ROLE user_joomla LOGIN PASSWORD 'xxxxxxxxxxxxxxxxxxxx';

	\q
	mkdir 9.4/main/base/tab_joomla
	psql
	CREATE TABLESPACE tab_joomla OWNER user_joomla LOCATION '/var/lib/postgresql/9.4/main/base/tab_joomla';
	CREATE DATABASE joomla OWNER=user_joomla ENCODING='UTF8' TABLESPACE=tab_joomla;




### Changer les locales si necessaire
	apt-get install locales-all
	dpkg-reconfigure locales
	# + Changer le template -> UNICODe UTF8
