# Postgresql
<!-- TOC -->

- [Postgresql](#postgresql)
  - [Installation](#installation)
  - [Connexion](#connexion)
    - [Connexion à l'utilisateur system postgres](#connexion-à-lutilisateur-system-postgres)
    - [Changer mot de passe utilisateur system postgres](#changer-mot-de-passe-utilisateur-system-postgres)
    - [Connexion à l'interpréteur SQL](#connexion-à-linterpréteur-sql)
    - [Excéuter un commande SQL via bash](#excéuter-un-commande-sql-via-bash)
    - [Changer mot de passe postgres](#changer-mot-de-passe-postgres)
  - [Commandes psql d'affichage](#commandes-psql-daffichage)
  - [Commandes usuelles bash](#commandes-usuelles-bash)
    - [Configuration des connexions sortantes](#configuration-des-connexions-sortantes)
  - [Users et roles](#users-et-roles)
    - [Lister les users](#lister-les-users)
    - [Creation super user](#creation-super-user)
    - [Creation d'un role sans droit de connexion](#creation-dun-role-sans-droit-de-connexion)
    - [Création d'un role avec droit de connexion](#création-dun-role-avec-droit-de-connexion)
    - [Création d'un role en read only](#création-dun-role-en-read-only)
    - [Ajout user dans groupe](#ajout-user-dans-groupe)
    - [Générer un password chiffré](#générer-un-password-chiffré)
    - [Suppression d'un role](#suppression-dun-role)
    - [Show grants for user](#show-grants-for-user)
    - [Ajout de droits](#ajout-de-droits)
    - [inherits privileges:](#inherits-privileges)
    - [revoke all priv and drop user:](#revoke-all-priv-and-drop-user)
    - [Changement du mot de passe d'un user](#changement-du-mot-de-passe-dun-user)
    - [Changement du nom d'utilisateur](#changement-du-nom-dutilisateur)
    - [Changer l'utilisateur auquel sont associés les droits dans une base](#changer-lutilisateur-auquel-sont-associés-les-droits-dans-une-base)
  - [Tablespaces](#tablespaces)
    - [Création d'un tablespace](#création-dun-tablespace)
    - [Supprimer un tablespace](#supprimer-un-tablespace)
    - [Changer le nom d'un tablespace](#changer-le-nom-dun-tablespace)
    - [Changer le propriétaire d'un tablespace](#changer-le-propriétaire-dun-tablespace)
    - [Changer une option d'un tablespace](#changer-une-option-dun-tablespace)
  - [Databases](#databases)
    - [Création d'une base sur un tablespace](#création-dune-base-sur-un-tablespace)
    - [Supression de la base de données](#supression-de-la-base-de-données)
    - [Copier une base sql](#copier-une-base-sql)
    - [Changer le nom d'une base de données](#changer-le-nom-dune-base-de-données)
    - [Changer le propriétaire d'une base de données](#changer-le-propriétaire-dune-base-de-données)
    - [Duplication d'une Base de données](#duplication-dune-base-de-données)
    - [Disable connexion à une base](#disable-connexion-à-une-base)
    - [Enable connexion à une base](#enable-connexion-à-une-base)
    - [Limiter le nombre de connexions pour un user](#limiter-le-nombre-de-connexions-pour-un-user)
    - [show limits by role](#show-limits-by-role)
  - [Schema](#schema)
    - [Create Schema](#create-schema)
    - [Changer owner schema](#changer-owner-schema)
    - [Move table to schema](#move-table-to-schema)
    - [modifier template0 : déverouiller](#modifier-template0--déverouiller)
  - [copy schema to another database](#copy-schema-to-another-database)
  - [Tables](#tables)
    - [Création de tables](#création-de-tables)
    - [list](#list)
    - [Suppression de tables](#suppression-de-tables)
    - [Changement de droit sur une table](#changement-de-droit-sur-une-table)
    - [Show grants for table](#show-grants-for-table)
    - [Change owner](#change-owner)
  - [Indexes](#indexes)
    - [list indexes](#list-indexes)
  - [Dump et Restore](#dump-et-restore)
    - [Export prod vers qualif](#export-prod-vers-qualif)
      - [Sur la meme machine:](#sur-la-meme-machine)
    - [export TOUT](#export-tout)
    - [export](#export)
    - [dump d'une base](#dump-dune-base)
    - [Insertion csv](#insertion-csv)
    - [Export csv](#export-csv)
    - [Export selectif](#export-selectif)
    - [Import](#import)
    - [Sauvegarde d'une liste de tables](#sauvegarde-dune-liste-de-tables)
    - [select les shemas](#select-les-shemas)
  - [Monitoring](#monitoring)
    - [Uptime](#uptime)
    - [Nombre de connexion courante](#nombre-de-connexion-courante)
    - [List des query de plus de 1 min](#list-des-query-de-plus-de-1-min)
    - [Debug/Logging all queries for a database:](#debuglogging-all-queries-for-a-database)
    - [Logging slow queries:](#logging-slow-queries)
    - [Affichage des connexions \& Kill](#affichage-des-connexions--kill)
    - [Taille d'une base de données](#taille-dune-base-de-données)
    - [Taille d'un schéma](#taille-dun-schéma)
    - [Taille d'une table](#taille-dune-table)
    - [Affichage des OID](#affichage-des-oid)
    - [Number of commits and rollbacks pout une base de données:](#number-of-commits-and-rollbacks-pout-une-base-de-données)
    - [Summaries of number of inserts/updates/deletes](#summaries-of-number-of-insertsupdatesdeletes)
    - [Liste query plans](#liste-query-plans)
    - [Liste des locks held](#liste-des-locks-held)
  - [Tunning for performance](#tunning-for-performance)
    - [shm kernel](#shm-kernel)

<!-- /TOC -->

<!-- ------------------------------ Installation ------------------------------ -->

## Installation
```bash
apt-get update
apt-get install postgresql
```



<!-- ------------------------------- Connexion ----------------------------- -->

## Connexion

### Connexion à l'utilisateur system postgres
```bash
su -l postgres
```
### Changer mot de passe utilisateur system postgres
```bash
sudo passwd postgres
```

### Connexion à l'interpréteur SQL

```bash
psql
```
### Excéuter un commande SQL via bash
```bash
su - postgres -c "SELECT * FROM mytable"
```

batch output:
```
psql -tA -P pager=off -c "SELECT datname FROM pg_database;"
```

### Changer mot de passe postgres
Via le terminal bash
```bash
sudo -u postgres psql
```
Puis
```SQL
ALTER USER postgres PASSWORD 'mypassword1'
```


<!-- ---------------------------- Commandes usuelles -------------------------------- -->

## Commandes psql d'affichage
| Commande              | Descrition |
|---------------------- |--------------------------------------------------- |
| ```\h```              | Affiche l'aide SQL|
| ```\?```              | Affiche l'aide psql|
| ```;``` ou ```\g```   | Termine l'instruction|
| ```\i```              | Exécution d'un fichier de commandes SQL |
|```\q```               | Quite|
|||
| ```\db```             | Liste les tablespaces |
| ```\l```              | Liste les base de données |
| ```\c mydatabase```   | Connexion à une base de données
| ```\dn ```            | liste schema
| ```SET search_path TO myscheam;```  | select schema
| ```\dt mytable*```    | Liste la/les tables |
| ```\d+  mytable```    | Décrit la table|
| ```\du```             | Liste des roles |
|||
| ```\d```              | Liste des relations : tables, vues et séquences|
| ```\d mytable```      | Liste des relations d'une table, index, séquence, vue |


## Commandes usuelles bash

| Commande | Descrition |
|-------- | -------|
| ```pg_lscluster```  | Liste des cluster PostgreSQL  (port, status, version de sql executé sur le host)  |
|||
| ```pg_createcluster```  | Création d'un cluster PostgreSQL |
| ```pg_ctlcluster```  | Marche/Arrêt des clusters PosteSQL |



### Configuration des connexions sortantes
Par défaut, les connexions à la base de donnée sont désactivées.
Les options de configurations sont dans les fichiers suivants : postgresql.conf, pg_hba.conf.


Décommenter et configurer "listen_addresses" du fichier postgresql.conf

<!-- -------------------------  Users et roles ----------------------------------- -->

## Users et roles


### Lister les users

```SQL
SELECT * FROM pg_user;
```

### Creation super user
```bash
createuser -sdrlPE admin
psql
```


### Creation d'un role sans droit de connexion
```bash
createuser -SDRlP -U user user
```
ou
```SQL
CREATE ROLE myuser1;
```

### Création d'un role avec droit de connexion
```SQL
CREATE ROLE myuser1 LOGIN PASSWORD 'mypassword1';
```

### Création d'un role en read only
Voir le dossier script->  create_readonly_pg.sh

```
CREATE USER user_read WITH PASSWORD 'XXXXXXX';
GRANT CONNECT ON DATABASE schema TO user_read;
\c database
GRANT USAGE ON SCHEMA schema TO user_read;
GRANT SELECT ON ALL TABLES IN SCHEMA schema TO user_read;
ALTER DEFAULT PRIVILEGES IN SCHEMA schema GRANT SELECT ON TABLES TO user_read;
```

### Ajout user dans groupe
```bash
psql -c "CREATE ROLE ${user_bdd} ENCRYPTED PASSWORD 'md5${md5pass}' LOGIN IN ROLE role_group;"
```

### Générer un password chiffré
Exemple avec le crédental myuser/mypassword
```bash
U=myuser; P=mypassword; echo -n md5; echo -n $P$U | md5sum | cut -d' ' -f1
```


### Suppression d'un role

```bash
DROP ROLE myuser1;
```

### Show grants for user
```SQL
SELECT table_catalog, table_schema, table_name, privilege_type FROM   information_schema.table_privileges WHERE  grantee = 'user';
```

### Ajout de droits
```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON table1, table2, table3 TO user;
```

### inherits privileges:
Toutes les nouvelles tables créées par admin seront lisibles par user_ro:
```
ALTER DEFAULT PRIVILEGES FOR ROLE admin IN SCHEMA public GRANT SELECT ON TABLES TO user_ro;
```
afficher les defaults priv:
```
\ddp
```

revoke:
```
ALTER DEFAULT PRIVILEGES FOR ROLE admin IN SCHEMA public REVOKE SELECT ON TABLES FROM user_ro;
ALTER DEFAULT PRIVILEGES FOR ROLE admin IN SCHEMA public REVOKE SELECT, USAGE ON SEQUENCES FROM user_ro ;
```

### revoke all priv and drop user:
```
for username in file_list; do
    for sch in schema1 schema2 public; do
        psql -d database -c "REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA $sch FROM \"$username\";"
        psql -d database -c "REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA $sch FROM \"$username\";"
        psql -d database -c "REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA $sch FROM \"$username\";"
        psql -d database -c "REVOKE USAGE ON SCHEMA $sch FROM \"$username\";"
    done
     psql -d database -c "DROP OWNED BY \"$username\";"
     dropuser $username
done
```

### Changement du mot de passe d'un user
```SQL
ALTER ROLE myuser1 WITH PASSWORD 'mypassword12';
```

```SQL
ALTER USER user WITH encrypted password 'myencryptedpassword';
```
### Changement du nom d'utilisateur
```SQL
ALTER USER user_old RENAME TO user_new;
```
et change pass dans la foulée:
```SQL
ALTER ROLE user_new WITH PASSWORD 'XXXXXXXXXx';
```

### Changer l'utilisateur auquel sont associés les droits dans une base
```SQL
REASSIGN OWNED BY ancien_role [, ...] TO nouveau_role
```
Ne change que le proprio des objets de la base à laquelle on est connectée
Il faut également faire un
```
alter database mybase owner to nouveau_role;
```



<!-- --------------------------- Tablespaces --------------------------------- -->

## Tablespaces

### Création d'un tablespace

```bash
mkdir main/base/mytablespace1
psql
```

```SQL
CREATE TABLESPACE mytablespace1 OWNER myuser1 LOCATION 'main/base/mytablespace1';
```

### Supprimer un tablespace
```SQL
DROP TABLESPACE mytablespace1
```

### Changer le nom d'un tablespace
```SQL
ALTER TABLESPACE mytablespace1 RENAME TO mytablespace2
```

### Changer le propriétaire d'un tablespace
```SQL
ALTER TABLESPACE mytablespace1 OWNER myuser1
```
ou sur l'ensemble de la base :
```SQL
select 'alter table "' || t.tablename || '" owner to user_ars;' from pg_tables t where t.schemaname='public' and t.tableowner='postgres';
```

### Changer une option d'un tablespace
```SQL
ALTER TABLESPACE mytablespace1 SET (LOCATION='/main/base/mytablespace2')
```

<!-- ----------------------------- Databases ------------------------------- -->

## Databases


### Création d'une base sur un tablespace

En psql
```psql
createdb -E UTF8 -U myuser1 -D mytablespace1 mydatabase1
```
Ou en SQL
```SQL
CREATE DATABASE CREATE DATABASE test OWNER=myuser1 ENCODING='UTF8' TABLESPACE=mytablespace1;
```

### Supression de la base de données

En psql
```psql
dropdb -U myuser1 mydatabase1;
```
Ou en SQL
```SQL
DROP DATABASE mydatabase1;
```

### Copier une base sql
```bash
createdb -T src dest
```

### Changer le nom d'une base de données
```SQL
ALTER DATABASE mydatabase1 RENAME TO mydatabase2;
```

### Changer le propriétaire d'une base de données
```SQL
ALTER DATABASE mydatabase1 OWNER TO myuser2;
```


### Duplication d'une Base de données
```bash
createdb -T mydatabase1 mydatabase2
createdb -T sy_sterne2_bombina2 -O user_obla -D tab_sy_sterne2_obla sy_sterne2_obla
```

### Disable connexion à une base
```SQL
ALTER DATABASE "mydatabase1" WITH CONNECTION LIMIT = 0;
```
### Enable connexion à une base
```SQL
ALTER DATABASE "mydatabase1" WITH CONNECTION LIMIT = -1;
```
### Limiter le nombre de connexions pour un user
```
alter user <user name> with CONNECTION LIMIT 2;
```

### show limits by role
```
SELECT rolname, rolconnlimit FROM pg_roles
```

<!-- ----------------------------- Schema ------------------------------- -->


## Schema

### Create Schema
```SQL
CREATE SCHEMA myschema AUTHORIZATION myuser
```
### Changer owner schema
```SQL
ALTER SCHEMA myschema OWNER TO myuser;
```

### Move table to schema

```SQL
ALTER TABLE myschema.distributors SET SCHEMA yourschema;
```

### modifier template0 : déverouiller

```SQL
UPDATE pg_database SET datallowconn = TRUE WHERE datname = 'template0';
```


## copy schema to another database
```
pg_dump -v -n shema -c -Fc base_source | pg_restore -v -c -d base_destination
```


<!-- ----------------------------- Tables ------------------------------- -->


## Tables

### Création de tables

```SQL
CREATE TABLE mytable1 (
    mychamp1    serial PRIMARY KEY,
    mychamp2    varchar(40),
    mychamp3    varchar(40),
    mychamp4    date, -- Date de naissance
);
```
### list
```
SELECT * FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';
```
### Suppression de tables

```SQL
DROP TABLE mytable1;
```

### Changement de droit sur une table
```SQL
ALTER TABLE public.mytable OWNER TO user_admin;
```

### Show grants for table

```SQL
SELECT grantee, privilege_type, table_name
FROM information_schema.role_table_grants
WHERE table_name='geometry_columns'
```

### Change owner
```bash
shema="schema"
DB="database"
user_bdd="$user_bdd"
for tbl in `psql -qAt -c "select tablename from pg_tables where schemaname = '$shema';" $DB` ; do  psql -c "alter table $shema.$tbl owner to $user_bdd" $DB ; done
for tbl in `psql -qAt -c "select sequence_name from information_schema.sequences where sequence_schema = '$shema';" $DB` ; do  psql -c "alter table $shema.$tbl owner to $user_bdd" $DB ; done
for tbl in `psql -qAt -c "select table_name from information_schema.views where table_schema = '$shema';" $DB` ; do  psql -c "alter table $shema.$tbl owner to $user_bdd" $DB ; done
```

## Indexes

### list indexes
```
psql -tA -P pager=off -d database -c "select * from pg_indexes where schemaname = 'public';" > /tmp/postgres.indexes
```

<!-- ----------------------------- Dump et Restore ------------------------------- -->

## Dump et Restore
`pg_dump` permet de faire un dump dans une autre base de donnée ou directement dans un fichier.

Le format de sauvegarde est soit un script SQL (**.sql**), soit une archive.

Pour la restoration :
- ```psql``` est utilisé pour les scripts,
- ```pg_restore``` est utilisé pour les archives.

`pg_restore` permet de sélectionner les parties à restaurer contrairement à `psql`.


Par défaut, pg_dump sauvegarde la base de donnée spécifiée ainsi que le schéma associé.


Options importantes :

| Options de Dump   | Description                              | Type de restauration          |
|------------------ |----------------------------------------- |------------------------------ |
|                   | Comme ```plain``` par défaut             | Non sélective ```psql``` |
| ```-F plain```    | Sortie en .sql                           | Non sélective ```psql```      |
| ```-F custom```   | Sortie archive(un fichier )              | Sélective ```pg_restore```    |
| ```-F directory```| Sortie archive avec un fichier par table | Sélective ```pg_restore```    |
| ```-F tar```      | Comme directory avec de la compression   | Sélective ```pg_restore```    |
| ```-C```          | Active les commande de création de la base de données  | Les deux (utiliser aussi ```-C``` ici)   |

| Options de Restore  | Description                                     |
|-------------------- |------------------------------------------------ |
| ```-C```            | Crée la base de données                         |
| ```-c```            | Supprime la base de données si elle existe déjà |
| ```--no-owner```    | Ne joue pas les commandes set owner             |
| ```--role=user_x``` | Lance la restauration en tant que user_x        |

**Exemple de Dump/Restore**

|Dump| Restore | Descrition |
|---------------- |--------------- |------------|
| ```pg_dump database1 > file1.sql``` | ```psql -d database2 -f file1.sql``` | |
| ```pg_dump -C -F custom database1 -f file.dmp``` |```pg_restore -v -C -d postgres file.dmp```| Avec création de base de données |
| ```pg_dump -C -F custom database1 -f file.dmp``` |```pg_restore -v -C -s -d postgres file.dmp; pg_restore -v -a --disable-triggers -d <database> file.dmp```| Avec création de base de données (structure + data) |
| ```pg_dump -F custom -t MonSchema.MaTable -f file.dump MaDatabase``` | ```pg_restore -d MaDatabase file.dump``` | Exporte une seule table. Pour l'import,il faut supprimer la table si elle existe. |
| ```pg_dumpall -f all.sql``` | ```psql -f all.sql``` | Export de tout. Cas utile lors de postgres avec réplication, pour l'import dans le slave |


Autre exemple :
`pg_restore -v -cC  --no-owner --role=user_x  -d postgres file.dmp`
- Création de base / suppression et recréation si existante
- utilisation du user user_x (qui doit être superuser) pour créer la base et set le owner sur tous les éléments
- restauration structure + data
Attention, renvoie une erreur si la base n'existe pas car il ne peut pas la supprimer.


Attention, si la restoration crash, nessitez-pas à fair un `pg_restore --clean` pour netoyer.

### Export prod vers qualif
#### Sur la meme machine:
```bash
createdb -T database_prod database_qualif
```
Avec changement d'utilisateur
```bash
createdb -T database_prod -D tablespace -O user_qualif database_qualif
psql
\c database_qualif
REASSIGN OWNED BY user_prod to user_qualif;
```

### export des roles/droits/tabalespace sans la data
```bash
pg_dumpall -h localhost -p 5432 -v --globals-only > /tmp/users.dmp
```

### export de tout
```bash
pg_dumpall -h localhost -p 5432 -v > /tmp/dumpall.dmp
```

### export
```bash
su - postgres -c "/usr/local/pgsql/bin/pg_dump -C database" | gzip -c > /database.dmp.gz
```

### dump d'une base
```bash
su - postgres -c "pg_dump -h postgres.exmple.com -C database" | gzip -c > /tmp/database.dmp.gz
```



### Insertion csv
```SQL
COPY historic FROM '/tmp/dump_demo.csv.mod' WITH DELIMITER ',' CSV;
```
### Export csv
```bash
psql -P format=unaligned -P tuples_only -P fieldsep=\, -c "select * from tableName" > tableName_exp.csv -U <USER> -d <DB_NAME>
psql -d database -c "set search_path to schema;COPY (SELECT * from table) TO 'export.csv' WITH DELIMITER ';' CSV HEADER QUOTE '\"';"
```
### Export selectif
```bash
psql -d database -c "COPY (select * from table where device_id in (select device from table where id=20)) TO '/var/lib/postgresql/export.csv';"
```
### Import
```bash
psql -d database -c "COPY table FROM '/tmp/export.csv';"
```
continuer si erreur
```
sudo -u postgres psql -d "${1}" -f /usr/share/postgresql/8.4/contrib/postgis-1.5/spatial_ref_sys.sql -v ON_ERROR_ROLLBACK=on >> "${2}" 2>&1
```

### Sauvegarde d'une liste de tables
```bash
#!/bin/bash
CUR=`date '+%y%m%d-%H%M'`
psql -d database -c "\dt lyr_7*" |awk -F "|" '/^ public/ { print $2 }'| sed 's/^ //' >  liste.txt
#exporter cette liste de table
for i in `cat liste.txt`
do
  echo $i
  DEST="backup_manuel_$CUR.sql"
  touch $DEST
  echo $DEST
  pg_dump -a -n public -t $i database >> $DEST
done
```


Avec arret du restore si il y a une erreur

```bash
psql --set ON_ERROR_STOP=on -d database1 < file1
```

Attention, si la base de données n'existe pas il faut d'abord la crée avant d'y mêtre les données du dump
```bash
createdb -T template0 database1
```





### select les shemas
psql -d database -A -t -c "select schema_name from information_schema.schemata;"


<!-- ----------------------------- Monitoring ------------------------------- -->

## Monitoring

### Uptime
```SQL
SELECT now() - pg_postmaster_start_time();
```

### Nombre de connexion courante
```SQL
SELECT COUNT(*) FROM pg_stat_activity;
```
Avec plus de détails :  
```SQL
SELECT pid, backend_start, datname, usename, client_addr, state FROM pg_stat_activity ORDER BY backend_start;
```

### List des query de plus de 1 min
```SQL
SELECT
  procpid,
  now() - pg_stat_activity.query_start AS duration,
  current_query,
  waiting
FROM pg_stat_activity
WHERE  now() - pg_stat_activity.query_start > interval '1 minutes';
```
pg94:
```
SELECT  pid,  now() - pg_stat_activity.query_start AS duration,  query,  waiting FROM pg_stat_activity WHERE  now() - pg_stat_activity.query_start > interval '1 minutes';
```

### Debug/Logging all queries for a database:
```
ALTER DATABASE database SET log_statement = 'all';
```
return in normal state:
```
ALTER DATABASE database SET log_statement = 'none';
```

### Logging slow queries:
en ms:
log_min_duration_statement = 10000
log_line_prefix = '%t %p %r %u %d '

### Affichage des connexions & Kill
Identifié les connexin courante
```SQL
SELECT * FROM pg_stat_activity ORDER BY procpid;
SELECT datid,datname,pid,usesysid,usename,client_addr,query_start FROM pg_stat_activity ORDER BY pid;
SELECT * FROM pg_stat_activity WHERE datname='mydatabase';
```

Kill d'une connexion
```SQL
SELECT pg_terminate_backend(mypid1);
```

Kill des connexion sur une base de données >= 9.4
```SQL
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='mydatabase1';
```
Kill des connexion sur une base de données < 9.4
```SQL
SELECT pg_terminate_backend(procpid) FROM pg_stat_activity WHERE datname='mydatabase1';
```

Kill des connexions supérieures à 3 jours sur pg >= 9.4
```
SELECT pg_terminate_backend(pid) FROM pg_stat_activity
WHERE datname = 'PRODIGE' AND now() - pg_stat_activity.query_start > interval '3 days';
```

Kill les connexions d'un utilisateur
```
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE usename = 'user_bipel_bpioc';
```

### Taille d'une base de données
```SQL
SELECT pg_database.datname,
  pg_database_size(pg_database.datname),
  pg_size_pretty(pg_database_size(pg_database.datname))
  FROM pg_database
  ORDER BY pg_database_size DESC;
```

Gagner de la place avec un vacuum (attention lock la bdd):
```bash
vacuumdb -a -f -F -z
```

### Taille d'un schéma
```SQL
SELECT schema_name,
    pg_size_pretty(sum(table_size)::bigint) as "disk space",
    (sum(table_size) / pg_database_size(current_database())) * 100
        as "percent"
FROM (
     SELECT pg_catalog.pg_namespace.nspname as schema_name,
         pg_relation_size(pg_catalog.pg_class.oid) as table_size
     FROM   pg_catalog.pg_class
         JOIN pg_catalog.pg_namespace
             ON relnamespace = pg_catalog.pg_namespace.oid
) t
GROUP BY schema_name
ORDER BY schema_name;
```

### Taille d'une table
```SQL
SELECT nspname || '.' || relname AS "relation",
    pg_size_pretty(pg_relation_size(C.oid)) AS "size"
  FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  WHERE nspname NOT IN ('pg_catalog', 'information_schema')
  ORDER BY pg_relation_size(C.oid) DESC
  LIMIT 20;
```
```
psql  -P pager=off -d database -c "SELECT relname as \"Table\",pg_size_pretty(pg_total_relation_size(relid)) As \"Size\",pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) as \"External Size\" FROM pg_catalog.pg_statio_user_tables ORDER BY pg_total_relation_size(relid) DESC;"  > /tmp/table.txt
```

Liste des tables par taille
```sql
WITH RECURSIVE pg_inherit(inhrelid, inhparent) AS
    (select inhrelid, inhparent
    FROM pg_inherits
    UNION
    SELECT child.inhrelid, parent.inhparent
    FROM pg_inherit child, pg_inherits parent
    WHERE child.inhparent = parent.inhrelid),
pg_inherit_short AS (SELECT * FROM pg_inherit WHERE inhparent NOT IN (SELECT inhrelid FROM pg_inherit))
SELECT table_schema
    , TABLE_NAME
    , row_estimate
    , pg_size_pretty(total_bytes) AS total
    , pg_size_pretty(index_bytes) AS INDEX
    , pg_size_pretty(toast_bytes) AS toast
    , pg_size_pretty(table_bytes) AS TABLE
  FROM (
    SELECT *, total_bytes-index_bytes-COALESCE(toast_bytes,0) AS table_bytes
    FROM (
         SELECT c.oid
              , nspname AS table_schema
              , relname AS TABLE_NAME
              , SUM(c.reltuples) OVER (partition BY parent) AS row_estimate
              , SUM(pg_total_relation_size(c.oid)) OVER (partition BY parent) AS total_bytes
              , SUM(pg_indexes_size(c.oid)) OVER (partition BY parent) AS index_bytes
              , SUM(pg_total_relation_size(reltoastrelid)) OVER (partition BY parent) AS toast_bytes
              , parent
          FROM (
                SELECT pg_class.oid
                    , reltuples
                    , relname
                    , relnamespace
                    , pg_class.reltoastrelid
                    , COALESCE(inhparent, pg_class.oid) parent
                FROM pg_class
                    LEFT JOIN pg_inherit_short ON inhrelid = oid
                WHERE relkind IN ('r', 'p')
             ) c
             LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
  ) a
  WHERE oid = parent
) a
ORDER BY total_bytes DESC;
```

### Affichage des OID

```SQL
SELECT oid,datname FROM pg_database;
```
```sql
SELECT pg_relation_filepath('rails_europe');
 pg_tblspc/17530/PG_9.1_201105231/24657/845800

select * from pg_type where typnamespace = 26942;
select * from pg_class where relnamespace = 26942;
select * from pg_operator where oprnamespace = 26942;
select * from pg_conversion where connamespace = 26942;
select * from pg_opclass where opcnamespace = 26942;
select * from pg_aggregate where aggnamespace = 26942;
select * from pg_proc where pronamespace = 26942;
```

### Number of commits and rollbacks pout une base de données:
```SQL
SELECT datname, xact_commit, xact_rollback FROM pg_stat_database where datname='mytable' ;
```

### Summaries of number of inserts/updates/deletes
```SQL
SELECT SUM(n_tup_ins) AS inserts, SUM(n_tup_upd) AS updates, SUM(n_tup_del) AS deletes FROM pg_stat_all_tables;
```

### Liste query plans
```SQL
SELECT SUM(seq_scan), SUM(seq_tup_read), SUM(idx_scan),SUM(idx_tup_fetch) FROM pg_stat_all_tables;
```

### Liste des locks held

```SQL
SELECT mode, COUNT(mode) FROM pg_locks GROUP BY mode ORDER BY mode;
```




<!-- ----------------------------- Tunning for performance ------------------------------- -->


## Tunning for performance
Utilisation de pgtune, outil en ligne : https://pgtune.leopard.in.ua/

Projet git : https://github.com/le0pard/pgtune

### shm kernel
Lire le shmmax
```bash
cat /proc/sys/kernel/shmmax
```
Fixer à 2 G le shmmax dans le kernel
```bash
echo $((2 * 1024 * 1024 * 1024)) > /proc/sys/kernel/shmmax
echo kernel.shmmax = 2147483648 >> /etc/sysctl.conf
```
Mettre 1.5G dans postgres.conf (les buffers font 8K)
```bash
1024*1024*(1024+512)/8192 = 196608
```

effective_cache_size = free + cached + shared_buffers

```text
#VACUUM VERBOSE;
max_fsm_relations = 2000
max_fsm_pages = 384000 (= max_fsm_relations*2*6*16)
```
