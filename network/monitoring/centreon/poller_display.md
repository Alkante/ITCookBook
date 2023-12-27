# Poller Display
Poller display permet d'avoir un affichage web des équipements supervisé par celui-ci. Utilisé dans le cas ou le central tombe.

## Prérequis
- Un poller installer (voir la documentation)
- Les paquets suivants :

		yum install centreon-base-config-centreon-engine centreon-poller-display MariaDB-server MariaDB-client
- Timezone :
Modifier le fichier /etc/php.ini

		[Date]
		; Defines the default timezone used by the date functions
		; http://www.php.net/manual/en/datetime.configuration.php#ini.date.timezone
		date.timezone = Europe/Paris

- Les services :

		service httpd start
		service mysql start
		chkconfig httpd
		chkconfig mysql

## Configuration
La congiruation se fait  via l'url : http://[IP_du_poller]/centreon

Vous arrivez alors sur la meme page que l'installation de centreon
Laissé les informations déjà en place, remplissez les parties "Admin information" et "Database information" pour le mot de passe

### Installation du module poller-display
Administration->Extensions->Modules->Actions (engrenage)
Puis "Install Module" vous de devriez plus voir l'onglet "Configuration"

### Configuration du broker
Le reste de la configuration ce fait sur le centreon central

#### Poller-module
Dans Configuration->Poller->Broker Configuration
Modifier le poller-module

Ajout d'un Output de type IPv4

	Name: poller-display
	Connection port: 5672
	Host to connect: localhost
	Serialization protocol: BBDO Protocol

#### Poller-Display-Broker
Dans Configuration->Poller->Broker Configuration->Add
General

	Requester: Poller
	Name: Poller-Display-Broker
	Config file name: central-broker.xml
	Write thread id: No
Input: TCP IPv4

	Name: poller-display
	Connection port: 5672
Logger: Core - File

	Name of the logger: /var/log/centreon-broker/poller-display-broker.log
Output: SQL - Broker SQL database

	Name: poller-broker-sql-display
	DB type: Mysql
	Failover name: poller-broker-sql-display-failover
	DB host: localhost
	DB port: 3306
	DB user: centreon
	DB password: [mot de passe]
	DB name: centreon_storage
Output: Perfdata Generator

	Name: poller-broker-perfdata-display
	Failover name: poller-broker-perfdata-display-failover
	DB type: Mysql
	DB host: localhost
	DB port: 3306
	DB user: centreon
	DB password: [mot de passe]
	DB name: centreon_storage
Output: IPv4

	Name: poller-broker-rrd-display
	Connection port: 5670
	Host to connect: localhost
	Failover name: poller-broker-rrd-display-failover
Output: File

	Name: poller-broker-sql-display-failover
	File path: /var/lib/centreon-broker/poller-broker-sql-display-failover.retention
Output: File

	Name: poller-broker-perfdata-display-failover
	File path: /var/lib/centreon-broker/poller-broker-perfdata-display-failover.retention
Output: File

	Name: poller-broker-rrd-display-failover
	File path: /var/lib/centreon-broker/poller-broker-rrd-display-failover.retention

#### Poller-display-rrd
Dans Configuration->Poller->Broker Configuration->Add

General

	Requester: Poller
	Name: Poller-Display-rrd
	Config file name: central-rrd.xml
	Write thread id: No
Input: TCP IPv4

	Name: poller-rrd
	Connection port: 5670
Logger: Core - File

	Name of the logger: /var/log/centreon-broker/poller-display-rrd.log
Output: RRD - RRD file generator

	Name: poller-broker-rrd
	Failover name: poller-display-rrd-failover
-Output: File

	Name: poller-display-rrd-failover
	File path: /var/lib/centreon-engine/poller-display-rrd-failover.retention


## Vérification
Appliquez la configuration
Configuration-> Pollers -> Generate

Sur le poller activer les services:

	service cbd start
	service centengine restart

Vous pouvez maintenant vous connecter sur l'interface web du poller et visualiser les hosts supervisé (sur chaque host il faut définir le poller utilisé, central ou poller)

## Debug
Fichiers de configuraton de Centreon-Broker

	ls -l /etc/centreon-broker/
	total 20
	-rw-r--r-- 1 centreon        centreon        4155 26 janv. 11:32 central-broker.xml
	-rw-r--r-- 1 centreon        centreon        2363 26 janv. 11:32 central-rrd.xml
	-rw-rw-r-- 1 centreon-broker centreon-broker  504 12 janv. 09:51 master.run
	-rw-rw-r-- 1 centreon-broker centreon-broker 2791 26 janv. 11:32 poller1-module.xml
Configuration de Centreon-Engine

	cat /etc/centreon-engine/centengine.cfg | grep xml
	broker_module=/usr/lib64/nagios/cbmod.so /etc/centreon-broker/poller1-module.xml
Process Centreon-Broker

	ps aux | grep cbd
	496       27663  0.4  1.0 566984 10952 ?        Sl   07:19   0:01 /usr/sbin/cbd /etc/centreon-broker/central-rrd.xml
	496       27696  0.3  1.6 880452 16440 ?        Sl   07:19   0:00 /usr/sbin/cbd /etc/centreon-broker/central-broker.xml
	root      27841  0.0  0.0 105312   936 pts/0    S+   07:23   0:00 grep cbd
Flux TCP Centreon-Broker pour le poller

	netstat -an | grep 567
	tcp        0      0 0.0.0.0:5670                0.0.0.0:*                   LISTEN
	tcp        0      0 0.0.0.0:5672                0.0.0.0:*                   LISTEN
	tcp        0      0 127.0.0.1:5670              127.0.0.1:47353             ESTABLISHED
	tcp        0      0 127.0.0.1:42320             127.0.0.1:5672              ESTABLISHED
	tcp        0      0 127.0.0.1:47353             127.0.0.1:5670              ESTABLISHED
	tcp        0      0 127.0.0.1:5672              127.0.0.1:42320             ESTABLISHED
Flux TCP Centreon-Broker pour la communication avec le Central

	netstat -an | grep 5669
	tcp        0      0 192.168.209.114:43742        192.168.209.206:5669         ESTABLISHED

## Source
http://www.sugarbug.web4me.fr/atelier/techniques/ihmweb/centreon/centreon-poller-display/
