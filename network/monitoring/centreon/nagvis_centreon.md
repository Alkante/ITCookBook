# Nagvis dans centreon
## Installation :
Pour l'instant je vous conseil d'utiliser la version 1.7 de nagvis (mai 2016), il y a encore des soucis avec le backendcentreonbroker dans les versions 1.8 et 1.9


### Prérequis :
	yum install graphviz

### Installtion :
	cd /usr/local/
	wget http://sourceforge.net/projects/nagvis/files/NagVis%201.7/nagvis-1.7.10.tar.gz
	tar -xzvf nagvis-1.7.10.tar.gz
	mv nagvis-1.7.10 nagvis
	cd nagvis/
	./install.sh

Script :

	Do you want to proceed? [y]: y
	Please enter the path to the nagios base directory [/usr/local/nagios]: /usr/share/centreon/
	Please enter the path to NagVis base [/usr/local/nagvis]:
	Do you want to update the backend configuration? [n]:
	Please enter the web path to NagVis [/nagvis]:
	Please enter the name of the web-server user [apache]:
	Please enter the name of the web-server group [apache]:
	create Apache config file [y]:
	Do you want the installer to update your config files when possible? [y]:
	Remove backup directory after successful installation? [n]:
	Do you really want to continue? [y]: y

Puis :

	service httpd restart

Vous pouvez maintenant vous connectez : http://ip_du_serveur/nagvis

login: admin | pwd : admin

#### Configuration de nagvis avec centreon
Suppression des démos :

	rm /usr/local/nagvis/etc/maps/*.cfg

### Connecteur centreon-broker
	yum install git-core
	cd /usr/local/src
	git clone -b 1.0.x https://github.com/centreon/centreon-nagvis-backend.git

	mv /usr/local/src/centreon-nagvis-backend/GlobalBackendcentreonbroker.php /usr/local/nagvis/share/server/core/classes/
	chown apache: /usr/local/nagvis/share/server/core/classes/GlobalBackendcentreonbroker.php
	chmod 664 /usr/local/nagvis/share/server/core/classes/GlobalBackendcentreonbroker.php

### Configuration de nagvis
	cd /usr/local/nagvis/etc/
	mv nagvis.ini.php nagvis.ini.php.bak
	vi nagvis.ini.php

Coller cette configuration :

	##############################################################################
	######################## fichier : nagvis.ini.php ############################
	#############################################################################

	; <?php return 1; ?>
	; the line above is to prevent
	; viewing this file from web.
	; DON'T REMOVE IT!

	; ----------------------------
	; Default NagVis Configuration File
	; At delivery everything here is commented out. The default values are set in the NagVis code.
	; You can make your changes here, they'll overwrite the default settings.
	; ----------------------------

	; ----------------------------
	; !!! The sections/variables with a leading ";" won't be recognised by NagVis (commented out) !!!
	; ----------------------------

	[global]
	authmodule="CoreAuthModSQLite"
	authorisationmodule="CoreAuthorisationModSQLite"
	dateformat="Y-m-d H:i:s"
	file_group="apache"
	file_mode=660
	language_detection="user,session,browser,config"
	language="en_US"
	refreshtime=60
	sesscookiedomain="auto-detect"
	sesscookiepath="/"
	sesscookieduration=86400
	startmodule="Overview"
	startaction="view"

	[paths]
	base="/usr/local/nagvis/"
	htmlbase="/nagvis"
	htmlcgi="/centreon"

	[defaults]
	backend="centreonbroker"
	backgroundcolor="#ffffff"
	contextmenu=1
	contexttemplate="default"
	event_on_load=0
	event_repeat_interval=0
	event_repeat_duration=-1
	eventbackground=0
	eventhighlight=1
	eventhighlightduration=30000
	eventhighlightinterval=500
	eventlog=0
	eventloghidden=1
	eventscroll=1
	headermenu=1
	headertemplate="default"
	headerfade=1
	hovermenu=1
	hovertemplate="default"
	hoverdelay=0
	hoverchildsshow=1
	hoverchildslimit=10
	hoverchildsorder="asc"
	hoverchildssort="s"
	icons="std_medium"
	onlyhardstates=0
	recognizeservices=1
	showinlists=1
	showinmultisite=1
	urltarget="_parent"
	hosturl="[htmlcgi]/main.php?p=20201&o=svc&host_search=[host_name]&search=&poller=&hostgroup=&output_search="
	hostgroupurl="[htmlcgi]/main.php?p=20209&o=svcOVHG"
	serviceurl="[htmlcgi]/main.php?p=20201&o=svcd&host_name=[host_name]&service_description=[service_description]"
	servicegroupurl="[htmlcgi]/main.php?p=20212&o=svcOVSG"
	mapurl="[htmlcgi]/main.php?p=403&map=[map_name]"
	view_template="default"
	label_show=1

	[index]
	backgroundcolor="#ffffff"
	cellsperrow=4
	headermenu=1
	headertemplate="default"
	showmaps=1
	showgeomap=0
	showrotations=1
	showmapthumbs=0

	[automap]

	[wui]
	maplocktime=5
	grid_show=0
	grid_color="#D5DCEF"
	grid_steps=32

	[worker]
	interval=10
	requestmaxparams=0
	requestmaxlength=1900
	updateobjectstates=30

	[backend_centreonbroker]
	backendtype="centreonbroker"
	statushost=""
	dbhost="localhost"
	dbport=3306
	dbname="centreon_storage"
	dbuser="centreon"
	dbpass="votre-mot-de-passe"
	dbinstancename="default"
	htmlcgi="/centreon"

	[states]

	; -------------------------
	; EOF
	; -------------------------

/!\\ Modifier, dans le context [backend_centreonbroker], le mot de passe de votre base de donnée centreon (variable dbpass)

### Plugin centreon-nagvis:
	yum install centreon-nagvis

Dans l'interface de centreon allez dans "Administration" puis "Extensions", cliquez sur l'engrenage puis "Installer le module"
Dans "Administration" vous avez désormais un nouvel onglet nommé "Nagvis"

Deux configuration sont possible :

- Single user : Utilisation d'un compte créé directement dans l’application Nagvis.
- Centreon User : Géree le multi-utilisateurs en associant un utilisateur Centreon à un utilisateur Nagvis, ceci permet de gérer différents niveaux de droits.

Utiliser "Centreon User" permet de ne pas avoir à se connecter sur nagvis

Connectez-vous sur l'interface http://ip_du_serveur/nagvis

Dans "Menu personnel" et "Gérer les utilisateurs". Dans la zone "Créer un utilisateur", indiquez votre utilisateur centreon et choisissez un mot de passe (n'a pas d'importance). Cliquez sur "Créer un utilisateur".
Dans la zone "Modifier un utilisateur", sélectionnez l'utilisateur que l’on vient de créer et passé le roles "Users (read-only)" dans les "roles selectionnés". Cliquez sur "Modifier un utilisateur".

Dans le fichier /usr/local/nagvis/share/server/core/defines/global.php modifier :
```
// NagVis session name
define('SESSION_NAME', 'nagvis_session');
```
par
```
// NagVis session name
define('SESSION_NAME', 'PHPSESSID');
```

### Problèmes :
* Si vous n'avez pas d'onglet Nagvis dans Monitoring :

		mysql -u centreon -p centreon
		mysql> INSERT INTO topology (topology_id, topology_name, topology_icone, topology_parent, topology_page, topology_order, topology_group, topology_url, topology_url_opt, topology_popup, topology_modules, topology_show) VALUES ('', 'Nagvis', NULL, 2, 243, 20, 1, './modules/centreon-nagvis/index.php', NULL, '0', '1', '1');

Modifions le fichier /usr/share/centreon/www/modules/centreon-nagvis/nagvis.ihtml

	function resizeMap() {
	  var height = jQuery('html').height();
	  jQuery('#map').height(0);

	  /* Header */
	  height = height - jQuery('#header').height() - jQuery('#forMenuAjax').height();

	  /* lignes à commenter */
	  /* Footer */
	  /* height = height - jQuery('#footer').height() - 10; */
	  /* height = height - jQuery('#contener').height(); */

	  jQuery('#map').height(height);
	}

* Si dans nagvis vous avez l'erreur : "ERROR SQLSTATE : Column not found"
Modifier le fichier /usr/local/nagvis/share/server/core/classes/GlobalBackendcentreonbroker.php :

	- Remplacer les deux hg.alias par hg.name as alias
	- Remplacer sg.alias par sg.name as alias

### Nagvis automap
Dans le fichier /usr/local/nagvis/share/server/core/classes/GlobalBackendcentreonbroker.php
Ajouter les lignes suviantes dans la classe GlobalBackendcentreonbroker :

	public function getProgramStart() {
		return -1;
	}

Puis dans créer votre fichier automap dans /usr/local/nagvis/etc/maps/automap.cfg
Ce fichier doit contenir :

	define global {
	    sources=automap
	    alias=Automap
	    root=Centreon-Server
	    iconset=std_medium
	    backend_id=centreonbroker
	    label_show=1
	    label_border=transparent
	    # Automap specific parameters
	    render_mode=directed
	    rankdir=TB
	    width=1200
	    height=600
	}

Le paramètre root est est important , il doit définir l'hote parent le plus haut

#### Utilisation de l'automap avec un poller
La génération de map ne fonctionne pas avec les hosts d'un poller
Pour contourner le problème j'ai utilisé le cache de nagvis :

- Placer tous les hosts du poller sur le central
- Exporter votre configuration

Ancienne méthode :- Supprimer les caches de nagvis
```
rm -f /usr/local/nagvis/var/map-*
rm -f /usr/local/nagvis/var/source-*
```

- Générer le schéma sur l'interface web de nagvis, se rendre sur la carte à mettre à jour, "Editer la carte", "Options de la carte", "Save"
- Vérifier que nagvis a bien générer un schéma dans centreon
- Replacer tous les hosts du poller, comme au debut
- Exporter votre configuration

### Convert to static map
Dans nagvis "Actions" -> "export to static map"

## Maj centreon + nagvis 1.9.30
La doc est toujours bonne, il suffit d'adapter la version
Le répertoire /usr/local/nagvis à juste été déplacé dans  /usr/share/nagvis

En ligne cette doc donne + d'explication sur les différents fixe à faire pour rendre compatible nagvis et centreon :
https://www.sugarbug.fr/atelier/techniques/ihmweb/cartographie_supervision/centreon-web2010x_nagvis-19x/
