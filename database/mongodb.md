# MongoDB
<!-- TOC -->

- [MongoDB](#mongodb)
  - [Installer MongoDB](#installer-mongodb)
    - [Option : install spécifique version](#option--install-spécifique-version)
    - [Option : Prévet update](#option--prévet-update)
    - [Info : Localidation des données :](#info--localidation-des-données-)
    - [Info : Port d'ecoute            :](#info--port-decoute------------)
    - [Info : Fichier de log           :](#info--fichier-de-log-----------)
    - [Lancer la base de donnée](#lancer-la-base-de-donnée)
  - [Usage](#usage)
  - [Utilisation/création d'une base de donnée](#utilisationcréation-dune-base-de-donnée)
  - [Créer une collection](#créer-une-collection)
  - [Shell commands](#shell-commands)
    - [Aide](#aide)
    - [Aide sur une collection](#aide-sur-une-collection)
    - [Afficher les bases de données](#afficher-les-bases-de-données)
    - [Utiliser une base de données](#utiliser-une-base-de-données)
    - [Afficher les collections de la base de données utilisée](#afficher-les-collections-de-la-base-de-données-utilisée)
    - [Afficher les utilisateurs](#afficher-les-utilisateurs)
    - [Affiche les roles](#affiche-les-roles)
    - [Affiche des profiles](#affiche-des-profiles)
  - [Exemple](#exemple)
    - [Entrer des données](#entrer-des-données)
    - [Comandes disponible pour cette collection](#comandes-disponible-pour-cette-collection)
    - [Query](#query)
    - [Afficher les collections](#afficher-les-collections)
    - [Utiliser une colection](#utiliser-une-colection)
  - [Créer un base de donnée](#créer-un-base-de-donnée)
    - [Utiliser la table](#utiliser-la-table)
    - [Afficher](#afficher)
    - [Ajouter un donnée](#ajouter-un-donnée)
    - [Afficher](#afficher-1)
  - [Maintenance](#maintenance)
    - [Sauvegarde la base de donnée](#sauvegarde-la-base-de-donnée)
    - [Restore la base de donnée](#restore-la-base-de-donnée)
    - [Sauvegarde d'une base de donnée et des utilisateurs](#sauvegarde-dune-base-de-donnée-et-des-utilisateurs)
    - [Restore la base de donnée](#restore-la-base-de-donnée-1)
    - [Sauvegarde de la base de données v2.4](#sauvegarde-de-la-base-de-données-v24)
    - [Sauvegarde de la base de données v2.6](#sauvegarde-de-la-base-de-données-v26)
    - [Restaurer de la base de données v2.4](#restaurer-de-la-base-de-données-v24)
    - [Restaurer de la base de données v2.6](#restaurer-de-la-base-de-données-v26)
    - [Sauvegarde en mode archive pour docker](#sauvegarde-en-mode-archive-pour-docker)
    - [Restauration à partir d'une archive](#restauration-à-partir-dune-archive)
        - [Se connecter à la base de données](#se-connecter-à-la-base-de-données)
      - [Créer sont pofil de droits administrateur sur toute les bases v2.4](#créer-sont-pofil-de-droits-administrateur-sur-toute-les-bases-v24)
    - [Créer un utilisateur administrateur sur une base de donnée v2.4](#créer-un-utilisateur-administrateur-sur-une-base-de-donnée-v24)
      - [Créer sont pofil de droits administrateur sur toute les bases v2.6](#créer-sont-pofil-de-droits-administrateur-sur-toute-les-bases-v26)
      - [Créer un utilisateur sur une base v2.6](#créer-un-utilisateur-sur-une-base-v26)
- [If you get locked out, start over](#if-you-get-locked-out-start-over)
    - [Supprimer une base de données](#supprimer-une-base-de-données)
    - [Supprimer un utilisateur v2.4](#supprimer-un-utilisateur-v24)
    - [Supprimer un utilisateur v2.6](#supprimer-un-utilisateur-v26)
    - [Afficher des tables de la base "admin" v2.6](#afficher-des-tables-de-la-base-admin-v26)

<!-- /TOC -->

## Installer MongoDB
```bash
apt-get install mongodb
```

### Option : install spécifique version ###
```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get install -y mongodb-org=3.0.4 mongodb-org-server=3.0.4 mongodb-org-shell=3.0.4 mongodb-org-mongos=3.0.4 mongodb-org-tools=3.0.4
```


### Option : Prévet update ###
```bash
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections
```


### Info : Localidation des données :
/var/lib/mongodb/           : définit dans /etc/mongod.conf

### Info : Port d'ecoute            :
27017                       : définit dans /etc/mongod.conf

### Info : Fichier de log           :
/var/log/mongodb/mongod.log : définit dans /etc/mongod.conf


### Lancer la base de donnée
```bash
service mongodb start
```
ou manuellement
```bash
mongodb -f /etc/mongodb.conf
```


## Usage

Démarrage du serveur mongo : ```mongod```
Démarrage de l'interface: ```mongo```

## Utilisation/création d'une base de donnée
```
use mybase
```

## Créer une collection
```
db.acteur.insert({nom:'toto'})
```




## Shell commands
### Aide
```
db.help()
```

### Aide sur une collection
```
db.<collection>.help()
```

### Afficher les bases de données
```
show dbs
```
ou
```
show databases
```

### Utiliser une base de données
```
use <db>
```

### Afficher les collections de la base de données utilisée
```
show collections
```

### Afficher les utilisateurs
```
show users
```

### Affiche les roles
```
show roles
```

### Affiche des profiles
```
show profile
```

## Exemple

### Entrer des données

```
db.teams.save({country:"England",GroupName:"D"})  
db.teams.save({country:"France",GroupName:"D"})
db.teams.save({country:"Sweden",GroupName:"D"})  
db.teams.save({country:"Ukraine",GroupName:"D"})  

db.cool.save({answer:"YES",mode:"Plus"})  
db.cool.save({answer:"NO",mode:"Minous"})
db.cool.save({answer:"MAYBE",GroupName:"Obvious"})  
db.cool.save({answer:"YOUKNOW",GroupName:"Dominous"})  

```
### Comandes disponible pour cette collection
```
db.teams.help()
```

### Query
```
db.teams.find()  
```


### Afficher les collections
```
db.getCollectionNames()
```
ou
```
show collections
```
ou
```
show tables
```


### Utiliser une colection
use collectionname


## Créer un base de donnée
Il faut utiliser use <ma_nouvelle_base> et au moins y insérer une clef/valeur

Elle sera ainsi créer automatiquement

### Utiliser la table
```
use table_1
```

### Afficher
```
show dbs;
```
Rien ne c'est créé pour l'instant

### Ajouter un donnée
```
db.table_1.insert({"name":"un exemple"})

```
### Afficher

```
show dbs;

```
La nouvelle base est présente


## Maintenance

### Sauvegarde la base de donnée
```bash
mongodump --db database_name --collection collection_name -o dump_dir_name
```
### Restore la base de donnée
```bash
mongorestore --db database_name path_to_bson_file
```


### Sauvegarde d'une base de donnée et des utilisateurs
```bash
mongodump --db database_name -o dump_dir_name
```

### Restore la base de donnée
```bash
mongorestore --db database_name path_to_bson_file
```

```
 --dumpDbUsersAndRoles


bi_push_dev             0.203GB
bi_push_prod           15.946GB
config                  (empty)
local                   0.078GB
mongotest_development   0.203GB
test                    (empty)
```

### Sauvegarde de la base de données v2.4
```bash
mongodump --db table_1 -o dump_2015
```
### Sauvegarde de la base de données v2.6
```bash
mongodump --dumpDbUsersAndRoles --db table_1 -o dump_2015
```


### Restaurer de la base de données v2.4
```bash
mongorestore --db table_1 dump_2015/table_1/
```
### Restaurer de la base de données v2.6
```bash
mongorestore --restoreDbUsersAndRoles  --db table_1 dump_2015/table_1/
```

### Sauvegarde en mode archive pour docker
Envoie le dump dans la sortie standard, pour éviter d'avoir besoin de monter un volume

```bash
docker exec NOM_DU_CONTENEUR_DOCKER mongodump --archive  > repertoire/mongo_db.dmp
```

### Restauration à partir d'une archive
Copier le fichier dans le docker, et exécuter la commande suivante :

```bash
mongorestore --archive=mongo_db.dmp
```

Pour filtrer les DB/collections à sauvegarder ou restaurer : ```--nsInclude=bdd.collection```


##### Se connecter à la base de données
```bash
mongo --port 27017 -u manager -p 123456 --authenticationDatabase admin
```

#### Créer sont pofil de droits administrateur sur toute les bases v2.4
```
use admin
db.addUser(
  {
    user: "user",
    pwd: "XXXX",
    roles: [ "Admin"]
  }
)

show users;
```

### Créer un utilisateur administrateur sur une base de donnée v2.4

```
use table_1
db.addUser(
  {
    user: "Bob",
    pwd: "111222333",
    roles: [ "userAdmin", "table_1" ]
  }
)

show users;
```


#### Créer sont pofil de droits administrateur sur toute les bases v2.6
```
use admin
db.createUser({user:"Leboss",pwd:"112233", roles:[{role:"root",db:"admin"}]})
```


#### Créer un utilisateur sur une base v2.6
```
use table_1
db.createUser(
    {
      user: "user_table_1",
      pwd: "332211",
      roles: ["readWrite"]
    }
)
```



# If you get locked out, start over
```
sudo service mongod stop
sudo mv /data/admin.* .  # for backup
sudo service mongod start
```


### Supprimer une base de données
```
use temp
db.dropDatabase()
```


### Supprimer un utilisateur v2.4
```
db.removeUser("user_table_1")
```

### Supprimer un utilisateur v2.6
```
db.dropUser("user_table_1")
```

### Afficher des tables de la base "admin" v2.6
```
use admin
db.system.indexes.find()
db.system.users.find()
db.system.version.find()
```
