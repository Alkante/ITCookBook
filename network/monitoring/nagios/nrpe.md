
# NRPE

<!-- TOC -->

- [NRPE](#nrpe)
    - [Contexte](#contexte)
    - [Coté Nagios](#coté-nagios)
        - [Installation check_nrpe pour nagios](#installation-check_nrpe-pour-nagios)
    - [Coté remote](#coté-remote)
        - [Installation](#installation)
        - [Configuration IP d'écoute](#configuration-ip-découte)
        - [Installer les check de skyscrapers (ro_mount, ...)](#installer-les-check-de-skyscrapers-ro_mount-)
        - [Installer check_postgres](#installer-check_postgres)
        - [Installer check_apache2](#installer-check_apache2)
        - [inclures les commandes dans nrpe](#inclures-les-commandes-dans-nrpe)

<!-- /TOC -->

## Contexte



```
     Machine nagios          Machine à monitorer
+-----------------------+     +---------------+
|                       |     |               |
|  Nagios - check_nrpe -------- service nrpe  |
|                       |     |               |
+-----------------------+     +---------------+
```

## Coté Nagios
### Installation check_nrpe pour nagios

```bash replay
apt-get install install nagios-nrpe-plugin
```

Ajouter dans le /usr/local/nagios/etc/commands.cfg
remplacer les variables.

```bash no-replay
cat <<EOF >> /etc/nagios/nrpe.cfg

######
# NRPE
######

# 'check_nrpe' command definition
define command{
command_name check_nrpe
command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}
EOF
```



## Coté remote

### Installation
Installer le ervice NRPE sur la machine à monitorer

```bash
apt-get install nagios-nrpe-server
apt-get install nagios-plugins
```

### Configuration IP d'écoute
Ajouter un ip à écouter avec allowed_host (Décommenter et ajouter ```, myip```)

Remplacer $MYIP par l'ip du serveur nagios
```bash replay
sed -r 's/^([\t ]*#[\t ]*)(allowed_hosts=)(.*)$/\2127.0.0.1, $MYIP/gm' /etc/nagios/nrpe.cfg
```

### Installer les check de skyscrapers (ro_mount, ...)

```bash
cd /usr/lib/nagios/plugins
git clone https://github.com/skyscrapers/monitoring-plugins.git
chown -R root: monitoring-plugins/
chmod -R go-w monitoring-plugins/
```

### Installer check_postgres
```bash
cd /usr/lib/nagios/plugins
wget http://bucardo.org/downloads/check_postgres-2.22.0.tar.gz$ -O check_postgres-2.22.0.tar.gz
tar xvf check_postgres-2.22.0.tar.gz
rm check_postgres-2.22.0.tar.gzip
chown -R root: check_postgres-2.22.0/
chmod -R go-w check_postgres-2.22.0/
```

### Installer check_apache2
```bash
cd /usr/lib/nagios/plugins
wget https://exchange.nagios.org/components/com_mtree/attachment.php?link_id=619&cf_id=24 -O check_apache2.sh
chown -R root: check_apache2.sh
chmod 0755 check_apache2.sh
```

### inclures les commandes dans nrpe
Ajouter les lignes suivantes à la fin du fichier **/etc/nagios/nrpe.cfg**

```text not-replay
cat <<EOF >> /etc/nagios/nrpe.cfg

# Peronnal Commandes
command[check_disk]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /
command[check_disk_database]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /mnt/data
command[check_apache2_nb_connection]=/usr/lib/nagios/plugins/check_apache2.sh -H 10.7.5.196 -wr 50 -cr 100
command[check_http_certificat]=/usr/lib/nagios/plugins/check_http -H iotds.mutu.local -C 60
command[check_load]=/usr/lib/nagios/plugins/check_load -r
command[check_memory]=/usr/lib/nagios/plugins/monitoring-plugins/check_memory -w 20 -c 5
command[check_ro_mounts]=/usr/lib/nagios/plugins/monitoring-plugins/check_ro_mounts -X tmpfs
command[check_postgres_connection_test]=/usr/lib/nagios/plugins/check_postgres-2.22.0/check_postgres.pl -H 127.0.0.1 -p 5432 -db bdd_app2 -u user_app -dbpass XXXXXXXX --action connection
command[check_postgres_connection_nb]=/usr/lib/nagios/plugins/check_postgres-2.22.0/check_postgres.pl -H 127.0.0.1 -p 5432 -db bdd_app2 -u user_app -dbpass XXXXXXXX --action backends
command[check_postgres_remontee_last]=/usr/lib/nagios/plugins/check_postgres-2.22.0/check_postgres.pl -H 127.0.0.1 -p 5432 -db bdd_app2 -u user_app -dbpass XXXXXXXX --action custom_query --critical 144000 --query "SELECT round(EXTRACT(EPOCH FROM timezone('UTC', now())) - EXTRACT(EPOCH FROM t.time)) AS result FROM ( SELECT id, time FROM jmaplink_remontee ORDER BY id DESC LIMIT 1) AS t"
EOF
```


Liste des commandes nrpe :

| type | commandes nrpe |
|----- |--------------- |
| Charge CPU                      | ```check_load``` |
| RAM                             | ```check_memory``` |
| Disque /                        | ```check_disk``` |
| Disque base de données          | ```check_disk_database``` |
| Droit des points de montage disque | ```check_ro_mounts``` |
|||
| Nombre de connexion sur apache2 | ```check_apache2_nb_connection``` |
| Validité certificat ssl         | ```check_http_certificat``` |
| Connexion base de données       | ```check_postgres_connection_test``` |
| Nombre de connexion base de données | ```check_postgres_connection_nb``` |
| Dernière remontée en base de données | ```check_postgres_remontee_last``` |

Redémarer le service :

```bash
sevice nagios-nrpe-server reload
```


Tester les commandes nrpe coté remote (Ex: test de check_disk)
```bash test
/usr/lib/nagios/plugins/check_nrpe -H 127.0.0.1 -c check_disk
```
