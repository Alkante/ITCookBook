# Nagios
## Installation
	apt-get install nagios3

Url: http://localhost/nagios3

## Configuration
### Ajout d'un utilisateur:
	sudo htpasswd -c /etc/nagios3/htpasswd.users <username>
Donner les droits d'accès avec le fichier /etc/nagios3/cgi.cfg

* authorized_for_system_information: indiquent quels sont les utilisateurs pouvant voir l'état des services
* authorized_for_configuration_information: indiquent quels sont les utilisateurs pouvant voir la configuration de serveur Nagios
* authorized_for_system_commands: indiquent quels sont les utilisateurs pouvant exécuter des commandes systèmes au travers de l'interface de Nagios
* authorized_for_all_services: indiquent quels sont les utilisateurs pouvant voir l'état de tout les services (par défaut, on voit uniquement les services pour lesquels l'utilisateur est une personne de contact)
* authorized_for_all_hosts: idem que ci-dessus mais pour les hôtes (les machines)
* authorized_for_all_service_commands: indiquent quels sont les utilisateurs pouvant exécuter des commandes pour tous les services (par défaut, on peut exécuter des commandes uniquement sur les services pour lesquels l'utilisateur est une personne de contact)
* authorized_for_all_host_commands: idem que ci-dessus mais pour les hôtes (les machines)

### Fichier de configuration de base
Dans /etc/nagios3/conf.d

* contacts_nagios2.cfg: Les personnes physiques à contacter en cas d'incident
* extinfo_nagios2.cfg:
* generic-host_nagios2.cfg: Liste des machines
* hostgroups_nagios2.cfg: Liste des groupes de machines
* services_nagios2.cfg: Les services à surveiller, toujours attachés à un hote ou un groupe d'hotes
* timeperiods_nagios2.cfg: Les périodes de temps qui préoccupe le serveur (horaire de travail ...)

### Ajout de commande
Fichier /etc/nagios3/commands.cfg

Pour ajouter une commande vous pouvez vous baser sur la liste des commandes deja présentes dans les fichiers /etc/nagios-plugins/config/
Aussi présentes via l'interface web localhost/nagios3->System->Configuration->Object Type : Commands

## Autres
	#!/bin/bash
	/usr/bin/perl -w /usr/local/nagios/libexec/check_graph_http.pl -H vm1.exemple.com -u http://www.ville-st-jacques-de-la-lande.fr -w 5 -c 15 -t 20

#recuperer les OID
	snmpwalk -v 2c -c public -m ALL 192.168.0.4
