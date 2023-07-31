# Sqlite

Sqlite est un système de base de données très léger.
Contrairement à MySQL ou PostgreSQL, Sqlite utilise un fichier pour stocker une ou plusieurs base de données.
Les accès sont ceux du système de fichier.
<!-- TOC -->

- [Sqlite](#sqlite)
    - [Installation](#installation)
    - [Connexion](#connexion)
        - [Vérifier le type de fichier](#vérifier-le-type-de-fichier)
        - [Connexion à sqlite pour les versions 3.x](#connexion-à-sqlite-pour-les-versions-3x)
        - [Connexion à sqlite pour les versions 1.x et 2.x](#connexion-à-sqlite-pour-les-versions-1x-et-2x)
        - [Exécution d'une commande via bash](#exécution-dune-commande-via-bash)
        - [Problème d'ouverture de la base de données](#problème-douverture-de-la-base-de-données)
    - [Commandes usuelles](#commandes-usuelles)
    - [Options](#options)
    - [Exemple de commandes SQL](#exemple-de-commandes-sql)

<!-- /TOC -->

<!-- ----------------------------- Installation ------------------------------- -->

## Installation
```bash
apt-get update
apt-get install sqlite
```


<!-- ----------------------------- Connexion ------------------------------- -->

## Connexion

### Vérifier le type de fichier
```bash
file mydatabase1.sqlite
```

### Connexion à sqlite pour les versions 3.x
```bash
sqlite3 mydatabase1.sqlite
```

### Connexion à sqlite pour les versions 1.x et 2.x
```bash
sqlite mydatabase1.sqlite
```

### Exécution d'une commande via bash
```bash
sqlite3 mydatabase.sqlite "SELECT * FROM mytable;"
```

### Problème d'ouverture de la base de données
Unable to popen database "mydatabase": file is encrypted or is not a database

Ce message ne veux rien et tout dire, il faut donc :

- Vérifier les doits d'acces et le propriétaire
- Utiliser sqlite3 au lieu de sqlite (problème de versino entre 1x,2.x et 3.x)


<!-- ----------------------------- Commandes usuelles ------------------------------- -->

## Commandes usuelles

| Commande              | Descrition |
|---------------------- |--------------------------------------------------- |
| ```.help```           | Affiche l'aide |
| ```.quit```           | Quiter |
|||
| ```.databases```      | Liste les base de données |
| ```.tables```         | Liste la/les tables |
| ```PRAGMA table_info(mytable);``` | Afficher la description de la table |




## Options

| Commande              | Descrition |
|---------------------- |--------------------------------------------------- |
| ```.log myfile```     | Activation les logs et les mettre dans un ficher |
| ```.log stdout```     | Activation les logs et les mettre sur la sortie standard  |
| ```.log stderr```     | Activation les logs et les mettre sur la sortie d'erreur  |
| ```.log off```        | Désactiver les logs|
| ```.headers on```     | Afficher les entêtes (nom des colonnes)|
| ```.headers off```    | Cacher les entêtes (nom des colonnes)|



## Exemple de commandes SQL
Check and add ftp users in **ftp_users** tables
```
SELECT * FROM ftp_users;

INSERT INTO ftp_users (userid, passwd, uid, gid, home, shell)
VALUES
 ('ftp_user','xxxx',33,33,'/home/path/ftp','/bin/false');
```
