# Oxidized
Projet github : https://github.com/ytti/oxidized

## Installation

Packages :
```
apt-get install ruby ruby-dev libsqlite3-dev libssl-dev pkg-config cmake libssh2-1-dev
gem install oxidized
gem install oxidized-script oxidized-web
```

Ajout de l'utilisateur oxidized :
```
useradd -d /etc/oxidized oxidized
su oxidized
cd
ln -s /var/lib/gems/2.3.0/gems/oxidized-0.20.0/lib/oxidized/model /etc/oxidized/model
chown -R oxidized: /etc/oxidized/
chown -R oxidized: /var/lib/gems/2.3.0/gems/oxidized-*
```
Test oxidized
```
oxidized
```
## Oxidized en daemon

Fichier : /etc/init.d/oxidized

```
#!/bin/sh
#
# Written by Stefan Schlesinger / sts@ono.at / http://sts.ono.at
#
### BEGIN INIT INFO
# Provides:          oxidized
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start Oxidized at boot time
# Description:       Oxidized - Network Device Configuration Backup Tool
### END INIT INFO

set -e
OXIDIZED_HOME=/etc/oxidized
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
DAEMON=$(which oxidized)
NAME="oxidized"
DESC="Oxidized - Network Device Configuration Backup Tool"
ARGS=""
USER="oxidized"

test -x $DAEMON || exit 0

. /lib/lsb/init-functions

if [ -r /etc/default/$NAME ]; then
	. /etc/default/$NAME
fi

CONFIG="${CONFIG:-/etc/oxidized/config}"

PIDFILE=/var/run/$NAME.pid

do_start()
{
       start-stop-daemon --start --quiet --background --pidfile $PIDFILE --make-pidfile  \
       --oknodo --chuid $USER --exec $DAEMON -- -c $CONFIG $ARGS
}

do_stop()
{
       start-stop-daemon --oknodo --stop --quiet -v --pidfile $PIDFILE \
       --chuid $USER --retry KILL/10 -- -c $CONFIG $ARGS
}

case "$1" in
 start)
       if [ "$ENABLED" = "no" ]; then
               log_failure_msg "Not starting $DESC: disabled via /etc/default/$NAME"
               exit 0
       fi

       log_daemon_msg "Starting $DESC..." "$NAME"
       if do_start ; then
               log_end_msg 0
       else
               log_end_msg 1
       fi
       ;;
 stop)
       log_daemon_msg "Stopping $DESC..." "$NAME"
       if do_stop ; then
               log_end_msg 0
       else
               log_end_msg 1
       fi
       ;;

 restart|force-reload)
       $0 stop
       sleep 1
       $0 start
       ;;
 status)
	status_of_proc -p $PIDFILE $DAEMON $NAME
	;;
 *)
	N=/etc/init.d/$NAME
	echo "Usage: $N {start|stop|restart|force-reload|status}" >&2
	exit 1
	;;
esac

exit 0
```
Puis
```
chmod +x /etc/init.d/oxidized
```
Fichier : /lib/systemd/system/oxidized.service
```
[Unit]
Description=Oxidized - Network Device Configuration Backup Tool
After=network-online.target multi-user.target
Wants=network-online.target

[Service]
Environment=OXIDIZED_HOME=/etc/oxidized
PermissionsStartOnly=true
ExecStartPre=-/bin/mkdir /run/oxidized
ExecStartPre=/bin/chown oxidized:oxidized /run/oxidized
ExecStart=/usr/local/bin/oxidized
User=oxidized
KillSignal=SIGKILL

[Install]
WantedBy=multi-user.target


```
## Apache configuration

Fichier : /etc/apache2/site-available/001-oxidized.conf
```
<VirtualHost *:80>
  ServerAdmin admin@example.com
  ServerName oxidized.exemple.com
  ServerAlias oxidized

  ProxyPass /  http://127.0.0.1:8888/
  ProxyPassReverse / http://127.0.0.1:8888/

  <Proxy *>
      Order deny,allow
      Allow from all
      AuthBasicProvider ldap
      AuthUserFile /dev/null
      AuthType Basic
      AuthName "DSI"
      AuthLDAPURL "ldap://ldap.exemple.com:389/ou=Administration, ou=People, dc=exemple, dc=com?uid"
      AuthLDAPGroupAttribute uniqueMember
      AuthLDAPGroupAttributeISDN on
      require ldap-group cn=ESCsi, ou=Tests, ou=Groups, dc=exemple, dc=com
      AuthLDAPBindDN "cn=Apache,ou=DIT Roles,dc=exemple,dc=com"
      AuthLDAPBindPassword "***************"
  </Proxy>

  ErrorLog /var/log/apache2/oxidized_error.log
  CustomLog /var/log/apache2/oxidized_access.log combined

</VirtualHost>
```
Puis :
```
a2ensite 001-oxidized.conf
```
## Clé ssh pour switch alcatel

Sur la machine oxidized :
```
ssh-keygen -t dsa
```
Copier le contenu de .ssh/id_dsa.pub sur le switch dans le fichier /flash/network/pub/admin_dsa.pub

Commande ssh :
```
ssh -oHostKeyAlgorithms=+ssh-dss -oKexAlgorithms=+diffie-hellman-group1-sha1 admin@switch1.exemple.com
```

### Source
https://dokuwiki.alu4u.com/doku.php?id=english:ssh_key_aos_r6


## Configuration

* Fichier de configuration principal : /etc/oxidized/config

Exemple :
```
---
username: admin
password: admin
model: junos
interval: 86400
use_syslog: false
log: /var/log/oxidized.log
debug: false
threads: 30
timeout: 15000
retries: 3
prompt: !ruby/regexp /(^[\w.@-]+\s?[#>]\s?)$/
rest: 127.0.0.1:8888
next_adds_job: false
vars: {}
groups: {}
models:
 aos:
   username: admin
pid: "/run/oxidized/oxidized.pid"
input:
 default: ssh, telnet
 debug: false
 ssh:
   secure: false
output:
 default: git
 git:
   user: Oxidized
   email: oxidized@example.com
   repo: "/var/lib/oxidized/devices.git"
source:
 default: csv
 csv:
   file: "/etc/oxidized/router.db"
   delimiter: !ruby/regexp /:/
   map:
     name: 0
     model: 1
   gpg: false
model_map:
 cisco: ios
 juniper: junos
```

* Liste des équipements réseau : /etc/oxidized/router.db
* Log d'oxidized : /var/log/oxidized.log

### Git:
```
apt-get install  zlib1g zlib1g-dev -y
gem uninstall rugged
gem install rugged
```
```
hooks:
 push_to_remote:
  type: githubrepo
  events: [post_store]
  remote_repo: git@gitlab.exemple.com:admin/oxidized-data.git
  publickey: ~/.ssh/id_rsa.pub
  privatekey: ~/.ssh/id_rsa
```
