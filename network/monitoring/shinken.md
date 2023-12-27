# Shinken
## Installation
	apt-get install python-pip python-pycurl python-cherrypy3 python-setuptools python-crypto -y
	adduser shinken
	pip install shinken
	su shinken
	shinken --init
	shinken install webui
	shinken install auth-cfg-password
	shinken install sqlitedb

Modifier le fichier /etc/shinken/brokers/broker-master.cfg pour activer le module webUI:

	modules     webui

Modifier le fichier /etc/shinken/modules/webui.cfg pour activer les modules d’authentification et de la base de données SQLite:

	modules         auth-cfg-password,SQLitedb
Puis :

	shinken restart

### Plugin de monitoring 
	wget --no-check-certificate https://www.monitoring-plugins.org/download/monitoring-plugins-2.1.1.tar.gz
	tar -xvf monitoring-plugins-2.1.1.tar.gz
	cd monitoring-plugins-2.1.1/
	./configure --with-nagios-user=shinken --with-nagios-group=shinken --enable-libtap --enable-extra-opts --enable-perl-modules --libexecdir=/usr/lib/nagios/plugins
	make install

### Fichier de configuration

- Hosts, services ... : /etc/shinken
- Ajout d'un mobule : /etc/shinken/brokers/broker-master.cfg
- Ajout d'un mobule web : /etc/shinken/modules/webui.cfg

### Installation d'un nouveau module 
	shinken search [votre mobule ou "all"] 
	shinken install [votre module]

