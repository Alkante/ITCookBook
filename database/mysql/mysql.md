# MyQSL
## Installation
```bash
apt-get update
apt-get install mysql
```

## Connexion

### Connexion au serveur
```bash
mysql -u root -p
```

## Voyager dans les bases;
```mysql
SHOW DATABASES;
USE my_database;
SHOW TABLES;
DESCRIBE my_table;
SELECT * FROM my_table;
```
## create db
```sql
CREATE DATABASE `bdd_site` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
```

## Sortir
```sql
exit;
```


# Droits utilisateurs
## Afficher les utilisateur/host
```sql
select user,host from mysql.user;
```
## Afficher les droits d'un utilisateur
```sql
show grants for "root"@"localhost";
```

## Ajouter un utilisateur/host
### Définir un password utilisateur (En bash)
```bash
pwgen -cns 30 1
```
## Users et roles

### Afficher les utilisateur/host
```SQL
select user,host from mysql.user;
```

### Afficher les droits d'un utilisateur
```SQL
show grants for "root"@"localhost";
```

### Ajouter les droits de l'utilisateur (exemple en localhost) (Cette commande créer l'utilisateur si il n'existe pas)
```sql
GRANT ALL PRIVILEGES ON ma_base.* TO 'user_ma_base'@'localhost' IDENTIFIED BY 'mypass';
```
### REVOKE
```
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'user_bdd'@'192.1.1.1';
```

### Générer le Hash du password
```sql
select password ('XXXXXXXXXXX');

+-------------------------------------------+
| password ('XXXXXXXXXXX')                  |
+-------------------------------------------+
| *E9BF07543352977F96ECB105B77CCFCDAE31F768 |
+-------------------------------------------+
```

### Change pass
```sql
SET PASSWORD FOR `user_1`@`localhost` = PASSWORD('mypass');
```

### Password socket unix_socket
Sans password :
```sql
UPDATE mysql.user SET plugin = 'unix_socket' WHERE user = 'root' AND host = 'localhost';
FLUSH PRIVILEGES;
```
Avec password :
```sql
UPDATE mysql.user SET plugin = '' WHERE user = 'root' AND host = 'localhost';
FLUSH PRIVILEGES;
```

### Vérifier les droits
```sql
SELECT user,host,password FROM mysql.user;
```
### Supprimer user
```sql
DROP USER my_user;
```
ou
```sql
DELETE FROM mysql.user WHERE user="my_user"
```
### Changer le password
Générer le Hash du password
```SQL
select password ('mypassword');
```
Puis faire un insert et vérifier
```SQL
SELECT user,host,password FROM mysql.user;
```

### Ajouter les droits de l'utilisateur (exemple en localhost)
```SQL
GRANT ALL PRIVILEGES ON ma_base.* TO 'user_ma_base'@'localhost';
flush privileges;
```

### Ajouter les droits de l'utilisateur plus GRANT
```SQL
GRANT ALL PRIVILEGES ON my_database.* TO 'my_user'@'localhost' WITH GRANT OPTION;
flush privileges;
```

### privileges
```SQL
grant all privileges on bdd_app1.* to 'user_app1'@'localhost' identified by 'XXXXX';
```

### Supprimer user
```SQL
DROP USER my_user;
```
ou
```SQL
DELETE FROM mysql.user WHERE user="my_user"
```

## Databases

### renommer base
```SQL
mysqldump bdd_app1 -p | mysql -D bdd_app2 -p
```

## Configuration


### Changer l'IP découte
 Éditer le ficher de configuration principal
vim /etc/mysql/my.cnf
IP d'écoute sur la boucle local (par défaut)
```text
 bind-address = 127.0.0.1
```
ou  : autre IP d'écoute
```text
bind-address = 192.168.0.5
```
ou  : sur plusieurs IPs
```text
bind-address = 0.0.0.0
```
On ne peux restreindre directement sur 2,3,... IPs avec mysql.
Essuite restreindre les IP avec le firewall et les droits utilisateur/host
Sécurité :  Ne pas utiliser les % pour les hosts


# Import / Export
## Sauvegarder la base
```bash
mysqldump -p --databases ma_base > dump-hostname-ma_base-date.sql
mysqldump -p -f --opt --databases ${db} | gzip -c > backup.dmp.gz
mysqldump --user=root --password=<password> --databases bdd_app1 | gzip > MYSQL_abdd_app1.sql.gz

```
## Restaurer

### restaurer la base
```bash
mysql -u root -p -D ma_base  < dump-hostname-ma_base-date.sql
```

### importer à la volée un tar.gz
```bash
tar -xzOf mysql_dump.tgz | mysql -u root --password=XXXXX -D database > log 2>&1 &
```
autre solution pour un fichier sql gzippé :
```bash
zcat mysql_dump.tgz | mysql -u root --password=XXXXX -D database > log 2>&1 &
```

### importer à la volée un tar.gz en omettant une table
```bash
tar -xzOf mysql_dump.tgz | grep -v "INSERT INTO \`user\`" |mysql -u root --password=XXXXX -D ezprod > log 2>&1 &
```
### import failed   1. ERROR 1005 (HY000): Can't create table 'Table.frm' (errno: 150)
Insérer au début du dump  
```sql
SET FOREIGN_KEY_CHECKS = 0; -- TOP
```
Insérer à la fin du dump
```sql  
SET FOREIGN_KEY_CHECKS = 1; -- BOTTOM  
```



# Commandes d'administration
## show process
```sql
SHOW PROCESSLIST;
```

## send commands
```sql
mysql $MYSQL_OPT -e "TRUNCATE \`DATA_ENTREPRISE\`;TRUNCATE \`DATA_LABO\`;TRUNCATE \`DATA_PLATEFORME\`;TRUNCATE \`DATA_ADRESSE\`"
```

## kill les connections d'un utilisateur
```sql
SELECT CONCAT('KILL ',id,';') AS run_this FROM information_schema.processlist WHERE user='user';
```
## repair all
```bash
mysqlcheck -u root -p --auto-repair --optimize --all-databases
```
Peut etre utiliser en cas de lenteur

## renommer base
```bash
mysqldump database -p | mysql -D database -p
```

## reset root password (si perdu)
```bash
/etc/init.d/mysql stop
/usr/bin/mysqld_safe --skip-grant-tables &
mysql -u root
```
```SQL
use mysql;
update user set Password=PASSWORD('new-password-here') WHERE User='root';
flush privileges;
exit;
```
pour mysql >= 5.7:
```SQL
use mysql;
update user set authentication_string=password('newpass') where user='root';
flush privileges;
exit;
```

## mysql > 5.2 : préparer le debug queries dans `/etc/mysql/my.cnf`

```
general_log = OFF
general_log_file = /var/log/mysql/general.log
/etc/init.d/mysql restart
```

### activer debug

```bash
mysql $MYSQL_OPT -e "SET GLOBAL general_log = 'ON';"
```

### désactiver debug

```bash
mysql $MYSQL_OPT -e "SET GLOBAL general_log = 'OFF';"
```

## Requêtes SQL trop longues (durée supérieure à 1 seconde ou plus)

### MySQL 5.0 : debug

```
log = /var/log/mysql/mysqldebug.log
log_slow_queries      = /var/log/mysql/mysqlslow.log
long_query_time = 1
```

### MySQL 5.5 (Debian 8 - Jessie)

Dans `/etc/mysql/my.cnf` :

```
# Here you can see queries with especially long duration
slow_query_log_file = /var/log/mysql/mysql-slow.log
slow_query_log      = 1
long_query_time = 1
#log_queries_not_using_indexes
```

```bash
systemctl restart mysql
```

ou pour nettoyer le fichier :

```bash
systemctl stop mysql && rm /var/log/mysql/mysql-slow.log && systemctl start mysql
```

## show process
```SQL
SHOW PROCESSLIST;
```
+----+------+-----------------+--------+---------+------+-------+------------------+
| Id | User | Host            | db     | Command | Time | State | Info             |
+----+------+-----------------+--------+---------+------+-------+------------------+
|  3 | root | localhost       | webapp | Query   |    0 | NULL  | show processlist |
|  5 | root | localhost:61704 | webapp | Sleep   |  208 |       | NULL
```SQL
show status where `variable_name` = 'Threads_connected';
```
+-------------------+-------+
| Variable_name     | Value |
+-------------------+-------+
| Threads_connected | 4     |
+-------------------+-------+
1 row in set (0.00 sec)


## Kill les connections myuser1
```SQL
SELECT CONCAT('KILL ',id,';') AS run_this FROM information_schema.processlist WHERE user='myuser1';
```
select concat('KILL ',id,';') from information_schema.processlist where State='Sending data';

# Configuration
## IPs d'écoute

### Éditer le ficher de configuration principal /etc/mysql/my.cnf
IP d'écoute sur la boucle local (par défaut)
```bash
bind-address = 127.0.0.1
```
ou  : autre IP d'écoute
```bash
bind-address = 192.168.0.5
```
ou  : sur plusieurs IPs
```bash
bind-address = 0.0.0.0
```
(On ne peux restreindre directement sur 2,3,... IPs avec mysql.)
### Access denied for user 'magento'@'127.0.0.1'
- si 127.0.0.1 est demandé par l'appli au lieu de localhost
- si 127.0.0.1 localhost n'est pas la dernière ligne dans /etc/hosts
- si skip-name-resolve est configuré dans my.cnf

### Redémarer le service
un reload du service est insufisant si l'IP à changée
```bash
service mysql restart
```
### Vérifier l'IP, et le port découte
```bash
netstat -taupen |egrep '.+mysql.+|$'
```
## insensibilité à la casse
lower-case-table-names=1

## encoding
```sql
SHOW CREATE DATABASE bdd_app1;
```

## check syntax /etc/mysql/my.cnf
```bash
mysqld --help | more
```

## Montrer variables
```sql
SHOW VARIABLES LIKE 'max_connections';
```

## Fixer variable à la volée
```sql
SET GLOBAL max_connections = 300;
```

## purger les binary logs
si bin-log activé dans my.cnf:
```
SHOW BINARY LOGS;
PURGE BINARY LOGS BEFORE DATE_SUB( NOW( ), INTERVAL 14 DAY);
```

# mysql request

## export sans header
```
mysql -sN -e "my request;"
```
