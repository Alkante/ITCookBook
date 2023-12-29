# FusionInventory
## Instatllation sur le server
Télécharger le plugin et le placer dans /var/www/html/glpi/plugin

Dans Configuration->Plugins, il faut l'installer et l'activer

### Configuration
* Transfert en mode complète:
Administration->Entités->Root entity->Fusioninventory
	* Modèle pour le transfert automatique ... : Complete
	* URL d'accès au service : http://192.168.0.101/glpi

* Configuration de la fréquence d'inventaire
Plugins->FusionInventory->Général->Configuration général
	* Fréquence des inventaire: 1
	* Extra-debug: oui

* Module des agents :
Plugins->FusionInventory->Général->Configuration général->Modules des agents

	* WakeOnLan
	* Inventaire ordinateur
	* Inventaire distant des hotes VMware
	* Inventaire réseau (SNMP)
	* Découverte réseau
	* Déploiement du paquet
	* Collecte de donnée

* Règle d'importation

/!\\ Si les règles sont mal configuré, il y aura des doublons d'ordinateurs
Plugins->Fusioninventory->Règles->Règles d'import et de liaison des matériels
Mettre toutes les règles en mode oui (toutes les pages)

Gestion des équipements non géré:

Désactivation de la régles "Global import denied"
Ajout d'une règle pour les doublons d'IP :

	Critères : Matériel à importer: IP -> est déjà présent dans GLPI
	Actions : Liaison FUsionInventory -> Importation refusée
Ajout d'une règle pour les doublons de nom :

	Critères : Matériel à importer: Nom -> est déjà présent dans GLPI
	Actions : Liaison FUsionInventory -> Importation refusée

## Installation de l agent
###  Paquets

	wget -O - http://debian.fusioninventory.org/debian/archive.key | apt-key add -
	apt-get install lsb-release
	echo "deb http://debian.fusioninventory.org/debian/ `lsb_release -cs` main" >> /etc/apt/sources.list
	apt-get update
	apt-get install fusioninventory-agent
Pour la découverte du réseau :

	apt-get install fusioninventory-agent-task-network

### Service
Pour FusionInventory en tant que service, modifer le fichier /etc/default/fusioninventory-agent

	MODE=cron
En :

	MODE=daemon
Puis :

	service fusioninventory-agent restart

### Configuration
Dans le fichier /etc/fusioninventory/agent.cfg modifier les champs suivants :

	server = http://192.168.0.101/glpi/plugins/fusioninventory


### Utilisation
	fusioninventory-agent --server http://192.168.0.101/glpi/plugins/fusioninventory

### glpi url :
  http://glpi.exemple.com/plugins/fusioninventory

### Utilisation
	fusioninventory-agent --server http://glpi.exemple.com/plugins/fusioninventory

## Découverte du réseau
### Configuration
Plugins->FusionInventory->Taches->Gestion des taches->Ajouter

	Nom
	Actif
	Horaire
Configuration des jobs->Ajouter un job

	Nom
	Méthode du module : Découverte réseau
	Cibles: exemple.com (défini dans FusionInventory->Réseau->Plage IP)
	Acteurs: agent fusioninventory (il s'agit de l'agent qui va éffectuer la découverte du réseau)

/!\\ Par défaut chaque agent a 1 threads, on peut modifier le nombre dans Plugins->FusionInventory->Général->Gestion des agents->"Votre agent"->Nombre de threads

### Utilisation
Configuration->Actions automatique->taskscheduler->Executer
Il faut ensuite executer sur la machine de l'agent la commande :
	fusioninventory-agent

### Automatisation
1- S'assurer que dans Configuration->Actions automatique->taskscheduler soit en mode d'exécution CLI et définir la fréquence d'exécution

2- Configuration d'une tache CRON

* Lister le contenu : crontab -u www-data -l
* Modifier crontab : crontab -u www-data -e
* Ajouter les lignes : \*/1 \* \* \* \* /usr/bin/php5 /var/www/html/glpi/front/cron.php &>/dev/null

3- Lié l'agent à la machine
Plugins->FusionInventory->Gestion des agents->"Votre machine"
Lié à l ordinateur: "Votre machine"

/!\\ Si le reveil des agents ne fonctionne pas installer la derniere version des fusioninventory-agent.
