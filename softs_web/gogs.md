# Gogs

## Installer Gogs

### Install git
	apt-get install git

### Ajouter l'utilisateur git et de ces repertoire
	useradd -d /home/git git
	mkdir -p /home/git/repositories
	chown -R git:git /home/git

### Télécharger la dernière realise de gogs

	cd /home/git
	wget https://github.com/gogits/gogs/releases/download/v0.9.13/linux_amd64.tar.gz
	tar xvf linux_amd64.tar.gz
	chown -R git:git /home/git/gogs

	rm linux_amd64.tar.gz


### Configurer gogs
Le fichier de configuration est implémenté directement dans la librairie.
Pour faire sont propre fichier de configuration, il faut en creer un dans custom/* pour pouvoir le surcharger.

	cd /home/git/gogs
	mkdir -p custom/conf
	chown -R git:git /home/git

Editer notre fichier de configuration personnelle custom/conf/app.ini

	editor custom/conf/app.ini

Ajouter

	[repository]
	ROOT = /home/git/repositories

### Création de la base de donnée:
Nous utiliseront SQlite3

	apt-get install sqlite
Création du repertoire acceuil la base de donnée

### Création du repertoire de log

	mkdir -p /var/log/gogs
	chown -R git:git /var/log/gogs

### Première exécution
	su -l git -c "/home/git/gogs/gogs web"

### Exécution automatique au démarage du serveur
	cd /etc/init.d
Faire un scripts de démarage et d'arret automatique
	vim /etc/ini.d/gogs

Programme obtenur sur github : https://gist.github.com/infostreams/69f73ae6655e1fa6193fœ

	#! /bin/sh
	### BEGIN INIT INFO
	# Provides:             gogs
	# Required-Start:       $remote_fs $syslog
	# Required-Stop:        $remote_fs $syslog
	# Default-Start:        2 3 4 5
	# Default-Stop:         0 1 6
	# Short-Description:    Git repository manager Gogs
	# Description:          Starts and stops the self-hosted git repository manager Gogs
	### END INIT INFO

	# PATH should only include /usr/* if it runs after the mountnfs.sh script
	PATH=/sbin:/usr/sbin:/bin:/usr/bin
	DESC="Git repository manager Gogs"
	NAME=gogs

	# DIR is the gogs installation directory. Change if necessary.
	DIR=/etc/gogs/
	DAEMON=$DIR$NAME
	DAEMON_ARGS="web"
	PIDFILE=/var/run/$NAME.pid
	SCRIPTNAME=/etc/init.d/$NAME

	# The daemon will be run as this user
	USER=git
	HOME=$(grep "^$USER:" /etc/passwd | cut -d: -f6)
	USER_ID=$(id -u $USER)
	GROUP_ID=$(id -g $USER)

	# Exit if the package is not installed
	[ -x "$DAEMON" ] || exit 0

	# Read configuration variable file if it is present
	[ -r /etc/default/$NAME ] && . /etc/default/$NAME

	# Load the VERBOSE setting and other rcS variables
	. /lib/init/vars.sh

	# Define LSB log_* functions.
	# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
	# and status_of_proc is working.
	. /lib/lsb/init-functions

	#
	# Function that starts the daemon/service
	#
	do_start()
	{
	        # Return
	        #   0 if daemon has been started
	        #   1 if daemon was already running
	        #   2 if daemon could not be started
	        export USER HOME
	        start-stop-daemon --start --pidfile $PIDFILE --make-pidfile --user $USER --chdir $DIR --exec $DAEMON --test > /dev/null \
	                || return 1
	        start-stop-daemon --start --background --pidfile $PIDFILE --make-pidfile --user $USER --chdir $DIR --chuid $USER_ID:$GROUP_ID --exec $DAEMON -- \
	                $DAEMON_ARGS \
	                || return 2
	}

	#
	# Function that stops the daemon/service
	#
	do_stop()
	{
	        # Return
	        #   0 if daemon has been stopped
	        #   1 if daemon was already stopped
	        #   2 if daemon could not be stopped
	        #   other if a failure occurred
	        start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --pidfile $PIDFILE --name $NAME
	        RETVAL="$?"
	        [ "$RETVAL" = 2 ] && return 2
	        # Wait for children to finish too if this is a daemon that forks
	        # and if the daemon is only ever run from this initscript.
	        # If the above conditions are not satisfied then add some other code
	        # that waits for the process to drop all resources that could be
	        # needed by services started subsequently.  A last resort is to
	        # sleep for some time.
	        start-stop-daemon --stop --quiet --oknodo --retry=0/30/KILL/5 --exec $DAEMON
	        [ "$?" = 2 ] && return 2
	        # Many daemons don't delete their pidfiles when they exit.
	        rm -f $PIDFILE
	        return "$RETVAL"
	}

	#
	# Function that sends a SIGHUP to the daemon/service
	#
	do_reload() {
	        #
	        # If the daemon can reload its configuration without
	        # restarting (for example, when it is sent a SIGHUP),
	        # then implement that here.
	        #
	        start-stop-daemon --stop --signal 1 --quiet --pidfile $PIDFILE --name $NAME
	        return 0
	}

	case "$1" in
	  start)
	        [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
	        do_start
	        case "$?" in
	                0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
	                2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	     esac
	     ;;
	  stop)
	        [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
	        do_stop
	        case "$?" in
	                0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
	                2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
	        esac
	        ;;
	  status)
	        status_of_proc "$DAEMON" "$NAME" && exit 0 || exit $?
	        ;;
	  #reload|force-reload)
	        #
	        # If do_reload() is not implemented then leave this commented out
	        # and leave 'force-reload' as an alias for 'restart'.
	        #
	        #log_daemon_msg "Reloading $DESC" "$NAME"
	        #do_reload
	        #log_end_msg $?
	        #;;
	  restart|force-reload)
	        #
	     # If the "reload" option is implemented then remove the
	     # 'force-reload' alias
	     #
	        log_daemon_msg "Restarting $DESC" "$NAME"
	        do_stop
	        case "$?" in
	          0|1)
	                do_start
	                case "$?" in
	                        0) log_end_msg 0 ;;
	                        1) log_end_msg 1 ;; # Old process is still running
	                        *) log_end_msg 1 ;; # Failed to start
	                esac
	                ;;
	          *)
	                # Failed to stop
	                log_end_msg 1
	                ;;
	        esac
	        ;;
	  *)
	        #echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
	        echo "Usage: $SCRIPTNAME {start|stop|status|restart|force-reload}" >&2
	        exit 3
	        ;;
	esac

	:



### Changer les droits
	chmod 755 /etc/init.d/gogs

### Charger le service
	update-rc.d gogs defaults

### Démarer le service
	service gogs start

### Vérifier
	ps aux |egrep gogs

### Première connexion
	http://0.0.0.0:3000



#### Installation
	Database Type : SQLite3
	Path /home/git/gogs/data/gogs.db

	Application Name : Exemple repositories
	Repository Root Path : /home/git/repositories
	Run User : git
	Domain : git.exemple.com
	SSH Port : 22
	HTTP Port : 3000
	Application URL : git.exemple.com

	Log Path : /var/log/gogs

Admin Account Settings :

* Username : user
* Password : xxxx
* Confirm Password : xxxx
* Admin Email : xxxx


#### Ajouter git.exemple.com
Paramétrer votre dns en ajoutant git.exemple.com


#### Mettre en place un proxy appache port 80->3000

	editor /etc/apache2/sites-available/git.exemple.com.conf

Configuration :

	<VirtualHost 0.0.0.0:80>
		ProxyPreserveHost On
		ProxyRequests off
		ProxyPass / http://localhost:3000/
		ProxyPassReverse / http://localhost:3000/

		ServerName git.exemple.com
		ServerAlias git

		ServerAdmin admin@exemple.com

		ErrorLog ${APACHE_LOG_DIR}/git.exemple.com-error.log
		CustomLog ${APACHE_LOG_DIR}/git.exemple.com-access.log combined
	</VirtualHost>

	#<IfModule mod_ssl.c>
	#<VirtualHost 0.0.0.0:433>
	#
	#	ProxyPreserveHost On
	#	ProxyRequests off
	#	ProxyPass / https://localhost:3000/
	#	ProxyPassReverse / https://localhost:3000/
	#
	#	ServerName git.alaknte.al
	#	ServerAlias git
	#
	#	ServerAdmin admin@exemple.com
	#
	#	ErrorLog ${APACHE_LOG_DIR}/error.log
	#	CustomLog ${APACHE_LOG_DIR}/access.log combined
	#	SSLEngine on
	#
	#	SSLCertificateFile /etc/letsencrypt/live/git.exemple.com/fullchain.pem
	#	SSLCertificateKeyFile /etc/letsencrypt/live/git.exemple.com/privkey.pem
	#
	#Include /etc/letsencrypt/options-ssl-apache.conf
	#</VirtualHost>

	#</IfModule>



#### Ajouter le site à apache
	a2ensite git.exemple.com.conf
	a2enmod proxy
	a2enmod proxy_http

	apachectl configtest
	service apache2 restart

Vérifier

	service apache2 status


### OPTION
Vous pouver modifier tout les parametres que vous voulez dans /home/git/custom/conf/app.ini.
Il est facile d'utilisation puisque ce fichier a été genéré quand le service a été démarré.


## FIN
Connecter vous à git.exemple.com
