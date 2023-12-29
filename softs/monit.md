# Monit

## Contexte

Source : https://mmonit.com/monit/

doc : https://mmonit.com/monit/documentation/monit.html

## Installation

Bahs
```bash
apt install monit
```

## Configuration

La configuration se fait avec
```bash
editor /etc/monit/monitrc
```

Ce dernier inclue aussi les configuration dans le fichier 
```conf
include /etc/monit/conf.d/*
include /etc/monit/conf-enabled/*
```


Monit utilise un serveur web sur le port 2812:

L'acces peut être restreint avec :
```conf
set httpd port 2812
    use address 127.0.0.1  # only accept connection from localhost
    allow 0.0.0.0/0.0.0.0        # allow localhost to connect to the server and
    allow admin:monit      # require user 'admin' with password 'monit'
```

### Configurer les services

Structure des checks:
 
| Type | Commades |
|-- |-- |
| Process | ```CHECK PROCESS <unique name> <PIDFILE <path> | MATCHING <regex>>```

...
TODO
...

....

#### Apache

```bash
check process apache with pidfile /run/apache2.pid
    start program = "/etc/init.d/apache2 start" with timeout 60 seconds
    stop program  = "/etc/init.d/apache2 stop"
```

#### MySQL

```bash
check process mysqld with pidfile /var/run/mysqld/mysqld.pid
    start program = "/etc/init.d/mysql start"
    stop program = "/etc/init.d/mysql stop"
```

#### Nginx

```bash
check process nginx with pidfile /var/run/nginx.pid
    start program = "/etc/init.d/nginx start"
    stop program = "/etc/init.d/nginx stop"
```


## Usage


| Commandes usuelles | Description|
|--- |--- |
| ```monit``` | Démarrer monit |
| ```monit -c myconf``` | Démarrer monit avec un autre fichier de config |
| ```monit -t``` | Check la configuration |
| ```monit status``` | Afficher le status |
|
| ```monit start all``` | Démarre tout les programmes monitorés |
| ```monit start myprogramme``` | Démarre myprogramme |
| ```monit stop all``` | Stop tout les programmes monitorés |
| ```monit stop myprogramme``` | Stop myprogramme |
| ```monit restart all``` | Restart tout les programmes monitorés |
| ```monit restart myprogramme``` | Restart myprogramme |
| ```monit monitor all``` | Monitor tout les programmes monitorés |
| ```monit monitor myprogramme``` | Monitor myprogramme |
| ```monit unmonitor all``` | Unmonitor tout les programmes monitorés |
| ```monit unmonitor myprogramme``` | Unmonitor myprogramme |
|
| ```monit reload``` | Recharger la configuration monit |


## Prodige

### tomcat / geonetwork

Le problème avec geonetwork c'est qu'il y a des redirections.  
Donc imposible de faire une vérification sur le status ou le contenu de la page.  
Du coup, il faut passer par un script qui lui, va tester le bon fonctionnement.  

/etc/monit/testTomcat.sh
```
#!/bin/bash
if [[ $(wget -qO- http://localhost:8180/geonetwork|grep "javascript") == "" ]]; then exit 1; fi
```
```bash
chmod +x /etc/monit/testTomcat.sh
```

/etc/monit/conf.d/tomcat
```
#check host tomcat with address localhost
check process tomcat8 with pidfile /var/run/tomcat8.pid
  start program = "/etc/init.d/tomcat8 start"
  stop program = "/etc/init.d/tomcat8 stop"

check program testTomcat with path /etc/monit/testTomcat.sh
  with timeout 20 seconds
  start program = "/etc/init.d/tomcat8 start"
  stop program = "/etc/init.d/tomcat8 stop"
  if status = 1 then restart
```