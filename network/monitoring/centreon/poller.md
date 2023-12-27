# Ajout d'un poller (satellite)
## Installation du poller
Pour mon installation j'ai utiliser CES qui permet de choisir soit une installation complete ou alors juste le poller.

Le poller peut aussi etre installé sur d'autre distribution.
Install sur debian : http://www.sugarbug.web4me.fr/atelier/installations/debian/package_debian/poller/

## Liaison centreon le serveur Central et le satellite
	[root@CES-central ~]# su - centreon
	[centreon@CES-central ~]$ ssh-keygen
	[centreon@CES-central ~]$ ssh-copy-id -i /var/spool/centreon/.ssh/id_rsa.pub centreon@<ip du poller>
Test de la conexion sans mot de passe :

	[centreon@CES-central ~]$ ssh centreon@<ip du poller>
	[centreon@CES-poller ~]$

## Ajout poller dans centreon (21.10.0)
Dans configuraton -> Pollers -> Add

Suivre l'assistant :
Ajouter un collecteur Centreon
Nom : Poller_truc
Adresse IP du serveur : IP
Adresse IP du Central : 192.168.0.126

Récupérer la configuration à installer sur le serveur :
Sur la ligne du nouveau poller, Actions, Gorgone configuration
Coller les lignes sur le poller (/etc/centreon-gorgone/config.d/40-gorgoned.yaml)

Démarrer le service :
```
systemctl start gorgoned
systemctl enable gorgoned
```

## (OLD) Ajout du poller dans centreon
Dans configuration -> Pollers -> Add

	Poller Name : "votre poller"
	IP Address : [ip du poller]
Effacer la ligne Perfdata file
Puis save

Dans Configuration -> Pollers -> Engine configuration -> "votre poller"
Puis dans l'onglet Data -> Multiple Broker Module -> Add a new entry :

	/usr/lib64/nagios/cbmod.so /etc/centreon-broker/poller-module.xml
Save !

Dans Configuration -> Pollers -> Broker configuration
Copier le "central-module-master" puis modifier les champs suivant :

Onglet General:

	Requester : "votre poller"
	Name : poller-module
	Config file name: poller-module.xml

Onglet Logger:

	Name of the logger : /var/log/centreon-broker/poller-module.log
Onglet Output:
Output 1 - IPv4

	Name : poller-module-output
	Host to connect to : < ip du serveur central >
	Failover name : poller-module-output-failover

Onglet Output:
Output 2 - File

	Name : poller-module-output-failover
	File path : /var/lib/centreon-engine/poller-module-output.retention
Puis Save

## Génération de conf
Lorsque vous créez un hosts vous devez l'affecter à un poller
Un host est donc lié à un seul poller

Dans Configuration -> Pollers -> Apply configuration

	Pollers : "votre poller"
	Move Export Files
	Restart Monitoring Engine

Export !

Enfin sur le poller :

	service centreontrapd start


## Récupération des clés SSH du central
	scp /var/lib/centreon-engine/.ssh/id_dsa centreon@<ip du poller>:/var/lib/centreon-engine/.ssh
	scp /var/lib/centreon-engine/.ssh/id_dsa.pub centreon@<ip du poller>:/var/lib/centreon-engine/.ssh
	scp /var/lib/centreon-engine/.ssh/known_hosts centreon@<ip du poller>:/var/lib/centreon-engine/.ssh

## Problèmes rencontrés
- L'icone "poller not running" + "database not update" alors que c est le cas
Syncrhoniser les dates du central et du poller

		service ntpd stop
		ntpdate ntp.exemple.com
		service ntpd start
