# Sonarqube
## Prerequis
### Java 1.8
Installer:

	jdk-1.8
	jre-1.8

### Mysql 5.6/5.7
	wget http://dev.mysql.com/get/mysql-apt-config_0.7.3-1_all.deb
	dpkg -i mysql-apt-config_0.7.3-1_all.deb
	apt-get update
	apt-get install mysql-community-server

## Installation
### mysql
	mysql -u root -p
	Enter password:
	mysql> CREATE DATABASE IF NOT EXISTS sonarqube CHARACTER SET utf8 COLLATE utf8_bin;
	mysql> CREATE USER 'sonarqube'@'127.0.0.1' IDENTIFIED BY 'sonarqube';
	mysql> GRANT ALL ON sonarqube.* TO 'sonarqube'@'127.0.0.1';
	mysql> quit;

### sonar
Télécharger :

	http://www.sonarqube.org/downloads/

Dézip :

	unzip sonarqube-6.0.zip
	unzip sonar-scanner-2.7.zip

Modifer les paramétres de base  :

	vim sonarqube-6.0/conf/sonar.properties

Mettre :

	# DATABASE
	sonar.jdbc.username=sonarqube
	sonar.jdbc.password=sonarqube
	#----- MySQL 5.6 or greater
	sonar.jdbc.url=jdbc:mysql://localhost:3306/sonarqube?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance

	# WEB SERVER
	sonar.web.host=127.0.0.1
	sonar.web.context=/sonar
	sonar.web.port=9000

Refaire la meme chose pour sonar scanner

	vim sonar-scanner-2.7/conf/sonar-scanner.properties

Mettre :

	#----- Default SonarQube server
	sonar.host.url=http://localhost:9000
	#----- Default source code encoding
	sonar.sourceEncoding=UTF-8
	#----- Global database settings (not used for SonarQube 5.2+)
	sonar.jdbc.username=sonarqube
	sonar.jdbc.password=sonarqube
	#----- MySQL
	sonar.jdbc.url=jdbc:mysql://localhost:3306/sonarqube?useUnicode=true&amp;characterEncoding=utf8


### service
	ln -s /opt/sonar/sonar-3.7.1/bin/linux-x86-32/sonar.sh /usr/bin/sonar

Créez le fichier /etc/init.d/sonar :

	#!/bin/sh
	/usr/bin/sonar $*

Puis

	chmod 755 /etc/init.d/sonar
	update-rc.d sonar defaults

## Utilisation :
	/etc/init.d/sonar start
