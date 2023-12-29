# RabbitMQ
<!-- TOC -->

- [RabbitMQ](#rabbitmq)
    - [Installation](#installation)
    - [Configuration](#configuration)
    - [Vhost](#vhost)
    - [Utilisateur](#utilisateur)
        - [Gérer les utilisateurs](#gérer-les-utilisateurs)
        - [Droits utilisateurs](#droits-utilisateurs)
    - [Queues](#queues)
    - [Monitoring](#monitoring)
    - [Plugins](#plugins)
        - [Lister les plugins disponibles ou installées](#lister-les-plugins-disponibles-ou-installées)
        - [Activer un plugins](#activer-un-plugins)
        - [Ajouter un utilisatuer avec un tag administrateur](#ajouter-un-utilisatuer-avec-un-tag-administrateur)

<!-- /TOC -->

## Installation
```bash
apt-get update
apt-get install rabbitmq-server
```

## Configuration
Mettre en place un fichier de configuration par défaut (non nécessaire)
```bash
cd /etc/rabbitmq
cp /usr/share/doc/rabbitmq-server/rabbitmq.config.example.gz .
gunzip rabbitmq.config.example.gz
mv rabbitmq.config.example rabbitmq.config
```

puis redémarrer
```bash
service rabbitmq-server restart
service rabbitmq-server status
```

Par défaut :
- Port de connexion : amqp : 5672
- Port clustering connexion : clustering : 25672




## Vhost
Commande : ```rabbitmqctl```

| options | Description |
|---- |------------- |
|```list_vhosts```                 | Lister les vhosts|
|```add_vhost myvhosts ```         | Ajouter un vhost|
|```delete_vhost delete_vhost```   | Supprimer un vhost|




## Utilisateur
Par défaut, un utilisateur **guest**  et mot de pass **guest** avec tout les droits d'administation est créé.
Cette utilisateur n'a accès que via la boucle locale.

### Gérer les utilisateurs
Commande : ```rabbitmqctl```

| options d'utilisateur | Description |
|---------------------- |------------- |
|```list_users```                              | Lister les utilisateurs|
|```add_user myuser MyPassword1234```          | Ajouter un utilisateur|
|```delete_user myuser MyPassword1234```       | Supprimer un utilisateur|
|```change_password myuser MyPassword1234```   | Changer password un utilisateur|




### Droits utilisateurs

Commande : ```rabbitmqctl```

| options de permission | Descritption |
|------------------------ |------------- |
|```list_permissions```                                | Lister les permissions|
|```list_permissions -p myvhost```                     | Lister les permissions pour un vhost|
|```list_user_permissions myuser```                    | Lister les permissions d'un utilisateur|
|```set_permissions myuser ".*" ".*" ".*"```           | Activé tout les droits (conf,read,write)|
|```set_permissions -p myvhost myuser ".*" ".*" ".*"```| Activé tout les droits (conf,read,write) pour un vhost|
|```clear_permissions myuser"```            | Supprimer les permissions d'un utilisateur|
|```clear_permissions -p myvhost myuser"```            | Supprimer les permissions d'un utilisateur pour un vhost|



## Queues
Commande : ```rabbitmqctl```
| Options               | Description |
|---------------------- |------------ |
|```list_queues```    | Listes toutes les queues|
|```-p dataportal list_queues```    | Listes des queues d'un vhost|
|```purge_queue -p myvhost myqueue```   | Listes des exchange X|




## Monitoring
```bash
rabbitmqctl help
```

| Options               | Description |
|---------------------- |------------ |
|```list_channels```    | Listes des channels (namespace like)|
|```list_exchanges```   | Listes des exchange X|
|```list_queues```      | Listes des queues|
|```list_bindings```    | Listes des bindings (liens entre exchange et queue)|
|```list_connections``` | Listes des connexions (producteur et consommateur)|
|```list_consumers```   | Listes des consommateurs seuelement|
|```status```           | Listes des exchange X|





| Options utile      | Description |
|------------------- |------------ |
|```disk_free_limit```| RAM utilisé par les queues|


## Plugins

### Lister les plugins disponibles ou installées
```bash
rabbitmq-plugins list
```

| Plugins utiles         | Description |
|---------------------- |------------ |
| ```rabbitmq_top```    | a top to monitor ressource|
| ```rabbitmq_mqtt```   | active l'api MQTT permetant de parametrer les queues directement pas un programme|
| ```rabbitmq_shovel``` | permet la connection de message entre broker (entre serveur Rabbitmq) |

Les plugins manuellement activés sont notés ```[E*]```, les dépendances activées sont notés ```[e*]``` et les non actives ```[ ]```.

### Activer un plugins
```bash
rabbitmq-plugins enable rabbitmq_top
rabbitmq-plugins enable rabbitmq_management
```



### Ajouter un utilisatuer avec un tag administrateur
```bash
pwgen -sn
```

```bash
rabbitmqctl add_user admin XXXXx
rabbitmqctl set_user_tags admin administrator
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
rabbitmqctl set_permissions -p rm admin ".*" ".*" ".*"
```



Connexion sur [http://localhost:15672](http://localhost:15672)

Remarque : le fichier ```/etc/rabbitmq/enabled_plugins``` a été créé

### Tester en ligne de commande l'Authentification

```bash
rabbitmqctl authenticate_user guest guest
```
