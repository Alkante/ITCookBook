# Replication mysql
Une simple replication master slave fonctionne que dans un sens

## Exemple de replication master-master
Configuration de mysql-server
* mysql0:

```
echo "server-id       = 1" >> /etc/mysql/mysql.conf.d/mysqld.cnf
echo "log-error     = /var/log/mysql/error.log" >> /etc/mysql/mysql.conf.d/mysqld.cnf
echo "log-bin " >> /etc/mysql/mysql.conf.d/mysqld.cnf
```
* mysql1:

```
echo "server-id       = 2" >> /etc/mysql/mysql.conf.d/mysqld.cnf
echo "log-error     = /var/log/mysql/error.log" >> /etc/mysql/mysql.conf.d/mysqld.cnf
echo "log-bin " >> /etc/mysql/mysql.conf.d/mysqld.cnf
```

Pour mysql0 :
```
mysql -u root -h $IP_MYSQL0 -p$PASSWORD_MYSQL -e "CREATE USER 'replication_user'@'$IP_MYSQL1' IDENTIFIED BY '$PASSWORD_MYSQL' ;"
mysql -u root -h $IP_MYSQL0 -p$PASSWORD_MYSQL -e "GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'$IP_MYSQL1' IDENTIFIED BY '$PASSWORD_MYSQL';"
mysql -u root -h $IP_MYSQL0 -p$PASSWORD_MYSQL -e "FLUSH PRIVILEGES;"
```
On récupère la position de mysql0 (offset des changements)
```
LOG_FILE=`mysql -u root -h $IP_MYSQL0 -p$PASSWORD_MYSQL -ss -e "SHOW MASTER STATUS;" |awk '{print $1}'`
LOG_POS=`mysql -u root -h $IP_MYSQL0 -p$PASSWORD_MYSQL -ss -e "SHOW MASTER STATUS;" |awk '{print $2}'`
```

Pour mysql1 :
```
mysql -u root -h $IP_MYSQL1 -p$PASSWORD_MYSQL -e "CREATE USER 'replication_user'@'$IP_MYSQL0' IDENTIFIED BY '$PASSWORD_MYSQL' ;"
mysql -u root -h $IP_MYSQL1 -p$PASSWORD_MYSQL -e "STOP slave;"
mysql -u root -h $IP_MYSQL1 -p$PASSWORD_MYSQL -e "CHANGE MASTER TO MASTER_HOST='$IP_MYSQL0', MASTER_USER='replication_user', MASTER_PASSWORD='$PASSWORD_MYSQL', MASTER_LOG_FILE='$LOG_FILE' , MASTER_LOG_POS=$LOG_POS;"
mysql -u root -h $IP_MYSQL1 -p$PASSWORD_MYSQL -e "START slave;"
mysql -u root -h $IP_MYSQL1 -p$PASSWORD_MYSQL -e "GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'$IP_MYSQL0' IDENTIFIED BY '$PASSWORD_MYSQL';"
mysql -u root -h $IP_MYSQL1 -p$PASSWORD_MYSQL -e "FLUSH PRIVILEGES;"
```
On récupère la position de mysql1 (offset des changements)
```
LOG_FILE=`mysql -u root -h $IP_MYSQL1 -p$PASSWORD_MYSQL -ss -e "SHOW MASTER STATUS;" |awk '{print $1}'`
LOG_POS=`mysql -u root -h $IP_MYSQL1 -p$PASSWORD_MYSQL -ss -e "SHOW MASTER STATUS;" |awk '{print $2}'`
```
On place mysql0 sur l'offset de mysql1
```
mysql -u root -h $IP_MYSQL0 -p$PASSWORD_MYSQL -e "STOP slave;"
mysql -u root -h $IP_MYSQL0 -p$PASSWORD_MYSQL -e "CHANGE MASTER TO MASTER_HOST='$IP_MYSQL1', MASTER_USER='replication_user', MASTER_PASSWORD='$PASSWORD_MYSQL', MASTER_LOG_FILE='$LOG_FILE' , MASTER_LOG_POS=$LOG_POS;"
mysql -u root -h $IP_MYSQL0 -p$PASSWORD_MYSQL -e "START slave;"
```

## Test
Vous devez avoir "Waiting for master to send event" pour les deux mysql/
```
mysql -u root -h $IP_MYSQL0 -p$PASSWORD_MYSQL -ss -e "SHOW SLAVE STATUS\G" |grep Slave_IO_State |sed 's/^\([ \t]*Slave_IO_State: \)//'
mysql -u root -h $IP_MYSQL0 -p$PASSWORD_MYSQL -ss -e "SHOW SLAVE STATUS\G" |grep Slave_IO_State |sed 's/^\([ \t]*Slave_IO_State: \)//'
```

## Bench
### Mysql vs Mariadb
Il y a une différence de fonctionnement avec mariadb, mysql fait la replication directement a la reception de la requete et il réponds ensuite. Alors que Mariadb répond directement et fait la replication quand il peut. Le fonctionnement de mysql génére beaucoup de latence.

* Bench :

Pour 10000 écriture et lecture.

| BDD     | write      | read       |
| ------- | ---------- | ---------- |
| mariadb | 3.40272sec | 0.07858sec |
| mysql   | 1h10min    | 0.15352sec |
