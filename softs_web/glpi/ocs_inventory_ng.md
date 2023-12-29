# OCS Inventory NG
## Installation
	apt-get install ocsinventory-server
	apt-get install mysql-server
	apt-get install libcompress-zlib-perl
	apt-get install libxml-libxml-perl

	mysql -u root -p
	> GRANT ALL PRIVILEGES ON *.* TO 'ocs'@'localhost' IDENTIFIED BY 'mot de passe' WITH GRANT OPTION;

La suite se fait via l'affichage web :
http://localhost/ocsreports

Apache :

	a2ensite ocsinventory-reports.conf
	a2ensite z-ocsinventory-server.conf

### Login par défaut
* Par défaut
* admin/admin
* normal/normal
* tech/tech

### Installation dans GLPI
Télécharger le plugin et le placer dans /var/www/html/glpi/plugin

Dans Configuration->Plugins, il faut l'installer et l'activer

Les droits sur le serveur OCSNG :

Administration->profils->Admin->OCSNG->Cocher les cases

Ajout d'un serveur OCSNG:

Administration->OCS Inventory NG->Configuration->Ajouter

Autoriser TRACE_DELETED :

localhost/ocsreports->Config->server-> TRACE_DELETED : ON

Vérifier la connexion avec la base de donnée

Administration->OCS Inventory NG->Configuration->Test

## Client
### Installation
	apt-get install ocsinventory-agent

choisir HTTP comme mode avec l'@IP du serveur
/!\\ En IPv6 spécifier l'adresse entre crochet

Forcer la remontée d'information

	sudo ocsinventory-agent

### Reconfiguration
	dpkg-reconfigure ocsinventory-agent

## Importation OCS vers GLPI
### Configuration
Administration->OCS Inventory NG->Configuration->Options d'importation et information générales

Remplir ce que vous souhaitez

### Importation
Administration->OCS Inventory NG->Importation de nouveaux ordinateurs

### Information d'importation
* UUID : identifiant de chaque périphérique de stockage et partition (calculer en fonction de l ordinateur hote a la creation/formatage de la partition), avec une machine virtuel, c est l'uuid du disque virtuel
* Numero de serie: Récupérable avec la commande lshw

## Source
https://doc.ubuntu-fr.org/ocs_inventory

http://www.fastfire.org/2014/06/06/ocs-inventory-ng-on-ubuntu-14-04/
