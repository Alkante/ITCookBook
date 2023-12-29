# solr 8.8

## Installation

```bash
cd /usr/local
wget https://miroir.univ-lorraine.fr/apache/lucene/solr/8.8.0/solr-8.8.0.tgz
# doc : https://lucene.apache.org/solr/guide/8_8/
tar -xzf solr-8.8.0.tgz
ln -s solr-8.8.0 solr
cd solr/bin
# installation de solr
./install_solr_service.sh /usr/local/solr-8.8.0.tgz
```

La console web est accessible : http://localhost:8983/solr/
Le service de démarrage : ```/etc/init.d/solr start|stop|status```
L'emplacement des data : ```/var/solr/data```



## creation d'un core

```bash
su - solr

/usr/local/solr/bin/solr create_core --help

# Pour supprimer un core
/usr/local/solr/bin/solr delete -c core-cdg35

# Pour créer un core depuis un modèle
/usr/local/solr/bin/solr create_core -c core-cdg35 -d /home/www/app1/solr/config/

# ajustement de config
# https://solr.apache.org/guide/7_0/field-types-included-with-solr.html
```


## Creation du mot de passe

```bash
cd /usr/local/src
git clone https://github.com/ansgarwiechers/solrpasswordhash
cd solrpasswordhash
ant
java -jar SolrPasswordHash.jar password
# donne le hash_password
```

## Configuration de la sécurité

Créer le fichier security.json :
```json
{
    "authentication": {
        "blockUnknown": true,
        "class": "solr.BasicAuthPlugin",
        "credentials": {
            "user_admin": "hash_password",
            "user_cdg35": "hash_password"
        }
    },
    "authorization":{
        "class": "solr.RuleBasedAuthorizationPlugin",
        "permissions":[
            {"name":"schema-read", "role":"role_user"},
            {"name":"update", "role":"role_user"},
            {"name":"read", "role":"role_user"},
            {"name":"all", "role":"role_admin"}
        ],
        "user-role": {
            "user_admin": "role_admin",
            "user_cdg35": "role_user"
        }
    }
}
```

```bash
cp /home/www/app1/solr/security.json /var/solr/data/
chown solr: /var/solr/data/security.json
service solr restart
```
