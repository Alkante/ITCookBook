# Centreon CES
Centreon CES est la version entreprise, il s'agit d'un OS complet basé sur centOS

## Installation
Télécharger l'ISO : https://download.centreon.com/
Démarrez l'installation à partir de l'image ISO:

+ "Install or updgrade an existing system"
+ Disc found : skip
+ Suivez les étapes de l'installation graphique
+ Sur la page du "nome d'hote" vous pouvez dirrectement configurer le réseau
+ Par la suite vous aurez le choix de votre installation :

	* Central server with database
	* Central server without database
	* Poller server
	* Database server
+ L'installation est terminé

Maintenant en ligne de commande :
```bash
yum -y update
```
Modifier le fichier
```
vi /etc/php.ini
```
Par:
```
[Date]
; Defines the default timezone used by the date functions
; http://www.php.net/manual/en/datetime.configuration.php#ini.date.timezone
date.timezone = Europe/Paris
```

```bash
service httpd reload
```

```bash
yum -y install centreon-lang-fr_FR
```

La suite ce fait via l'interface web

http://IP_du_serveur/centreon

Remplissez les champs marqué comme obligatoire

Vous pouvez maintenant vous connectez à l'interface de centreon

## Source :
http://www.sugarbug.web4me.fr/atelier/installations/ces/installation-ces3_3/
