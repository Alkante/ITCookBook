# Docker
<!-- TOC -->

- [Docker](#docker)
  - [Installation](#installation)
    - [Préinstallation](#préinstallation)
    - [Installation](#installation-1)
      - [Dernière version (developpement)](#dernière-version-developpement)
      - [Version stable (production)](#version-stable-production)
        - [Debian/Ubuntu](#debianubuntu)
        - [Centos 7](#centos-7)
      - [Tester l'installation](#tester-linstallation)
      - [Docker en non root](#docker-en-non-root)
  - [Configuration](#configuration)
    - [Changement de l'adresse du bridge](#changement-de-ladresse-du-bridge)
      - [modification par script (avant stretch)](#modification-par-script-avant-stretch)
      - [modification conf (apres stretch)](#modification-conf-apres-stretch)
      - [modification manuelle](#modification-manuelle)
  - [Utilisation](#utilisation)
  - [Création d'une image](#création-dune-image)
    - [Exemple d'image avec python](#exemple-dimage-avec-python)
    - [Exemple d'image avec debian](#exemple-dimage-avec-debian)
      - [Construction d'une image:](#construction-dune-image)
      - [Création d'une image a partir du container](#création-dune-image-a-partir-du-container)
    - [Lancement du container](#lancement-du-container)
    - [Visualisation](#visualisation)
    - [Persistance des données](#persistance-des-données)
      - [Creation](#creation)
    - [Manipulation d'image](#manipulation-dimage)
    - [Manipulation de container](#manipulation-de-container)
    - [Partage de dossier](#partage-de-dossier)
  - [Déploiement a distance avec jenkins](#déploiement-a-distance-avec-jenkins)
  - [Network](#network)
  - [Options run](#options-run)
  - [Cluster avec compose](#cluster-avec-compose)
    - [Contexte](#contexte)
    - [Installation](#installation-2)
    - [Exemple](#exemple)
      - [Source code](#source-code)
    - [Dockerfile](#dockerfile)
    - [Compose file](#compose-file)
    - [Exécuter](#exécuter)
    - [Maintenance](#maintenance)
  - [Exécution](#exécution)
    - [Affichage](#affichage)
    - [Création et exécution](#création-et-exécution)
        - [Exemple](#exemple-1)
    - [Arret d'un conteneur](#arret-dun-conteneur)
    - [Kill d'un conteneur](#kill-dun-conteneur)
    - [Démarage automatique](#démarage-automatique)
      - [Afficher le **restart policy**](#afficher-le-restart-policy)
      - [Modifier le **restart policy**](#modifier-le-restart-policy)
  - [Network](#network-1)
    - [bridge](#bridge)
  - [Maintenance](#maintenance-1)
    - [Connecion via Terminal](#connecion-via-terminal)
    - [Crash d'un conteneur](#crash-dun-conteneur)
    - [Advanced](#advanced)

<!-- /TOC -->
## Installation

L'installation reprend la documentation officielle : [https://docs.docker.com/engine/installation/linux/debian/#install-using-the-repository](https://docs.docker.com/engine/installation/linux/debian/#install-using-the-repository)
Cette installation est valide pour Debian jessie et stretch

Source d'image officiel
hub.docker.com

### Préinstallation

Mettre à jour les dépendances principales
```bash
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    bridge-utils
```

Importer la clef GPG
```bash
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
```
Ajouter la clef (validation via finger print)
```bash
apt-key fingerprint 0EBFCD88
```


Ajouter le repo docker pour debian amd64
```bash
 add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
```
Ajouter le repo docker pour ubuntu amd64
```
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```
### Installation

#### Dernière version (développement)

Cette commande installe la dernière version de Docker

```bash
apt-get update
apt-get install docker-ce
service docker start
```

Remarque, si ```docker-ce``` n'existe pas utiliser ```docker```

#### Version stable (production)
##### Debian/Ubuntu
Cette commande installe la version désirée de Docker.
Remplacer ```<VERSION>``` par la version désirée.

```bash
apt-get update
apt-get install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual
apt-cache madison docker-ce
apt-get install docker-ce=<VERSION>
service docker start
```
##### Centos 7
La derniere version est la 18 mais a un problème de dépendances sur centos7 donc il faut resté en 17
```
yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo
yum install --setopt=obsoletes=0    docker-ce-17.03.2.ce-1.el7.centos.x86_64    docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch
```
Lock version docker
```
yum install yum-plugin-versionlock
yum versionlock docker-ce-17.03.2.ce-1.el7.centos.x86_64    docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch
yum versionlock list
```



#### Tester l'installation
```bash
docker run hello-world
```

Il devrait télécharger et éxécuté une image docker qui affiche simplement "hello from docker" dans le terminal.




#### Docker en non root

##### En tant que $USER (à faire par l'utilisateur lui-même)

```bash
sudo usermod -a -G docker $USER
sudo service docker restart
```

Il faut ensuite relancer la session (déconnexion / reconnexion de $USER).

NB : pour accéder à Nexus, il faut que la ligne
```
    "dns": ["192.168.0.80","192.168.0.81"],
```


##### En tant que root pour utilisateur pnom (autre commande équivalente)

```bash
gpasswd -a pnom docker
service docker restart
```

Et toujours besoin de relancer la session de l'utilisateur.


<!-- -------------------------- Configuration ---------------------------- -->



## Configuration

### Changement de l'adresse du bridge

/!\\ L'adresse du bridge est dans le meme réseau que st-malo !!
#### modification par script (avant stretch)
Pour modifier l'adresse du bridge, on peut utiliser ce script :
```
wget https://gist.githubusercontent.com/kamermans/94b1c41086de0204750b/raw/ee26855e6720fd25213e2419ac2324e7d6a87588/configure_docker0.sh -O configure_docker0.sh
```
Utilisation :
```bash
service docker stop
./configure_docker0.sh 192.168.254.1/24
```

| Host         | Bridge        | Container     |
| ------------ | ------------- | ------------- |
| eth0         | docker0       | eth0          |
| 192.168.67.24 | 192.168.254.1 | 192.168.254.2 |

#### modification conf (apres stretch)
Dans le fichier /etc/docker/daemon.json
```
{
  "bip": "192.168.254.1/24",
  "fixed-cidr": "192.168.254.1/25",
  "mtu": 1500,
  "dns": ["192.168.0.80","192.168.0.81"]
}
```

#### modification manuelle
```
service docker stop
ip addr flush docker0
ip link set docker0 down
brctl delbr docker0
```
modifier la config, soit dans /etc/default/docker:
```
DOCKER_OPTS="--bip=192.168.254.1"
```
soit dans /etc/docker/daemon.json:
```
echo '{
  "bip": "192.168.254.1/24"
}' > /etc/docker/daemon.json
service docker start
```

<!-- -------------------------- Utilisation -------------------------- -->

## Utilisation

Life flow :
- compilation ou téléchargement d'un image
- lancement d'un conteneur à partir d"une image
- stoper, démarer ou supprimer le conteneur

| Commandes usuelles | Description |
|----------------- |------------ |
| ```docker --version``` | Affiche la version de docker |
| ```docker search myimage``` | Recherche myimage sur les repos officiels |
| ```docker pull myautor/myimage``` | Télécharge l'image nommée myautor/myimage |
| ```docker build /usr/local/src/php-1dcb6d17643e48ea1329ede9cf9a08b2f697b2fd/5.4/`` | Installe l'image du Dockerfile local |
| ```docker images``` | Lister les images disponible en local |
| ```docker rmi myimage``` | Supprime l'image locale myimage |
| ```docker run RUN_OPTIONS myimage``` | Création d'un conteneur à partir d'une image|
| ```docker rm mycontainer``` | Supprime un container |
| ```docker start mycontainer``` | Start un container déja créé|
| ```docker stop mycontainer``` | Stop un container |
| ```docker kill mycontainer``` | Kill un container |





## Création d'une image

La création d'image docker se fait via un fichier de paramétrage nommée **Dockerfile**

```bash
mkdir myimage
cd myimage
vim Dockerfile
```


### Exemple d'image avec python
```bash
#Use an official Python runtime as a base image
FROM python:3-onbuild

#Set the working directory to /app
WORKDIR /app

#Copy the current directory contents into the container at /app
ADD . /app

#Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

EXPOSE 80

#Define environment variable
ENV NAME World

#Run app.py when the container launches
CMD ["python", "app.py"]
```


### Exemple d'image avec debian

```bash
FROM debian:wheezy

MAINTAINER Prenom nom <p.nom@exemple.com>

RUN apt-get update \
    && apt-get install -y \
        nginx

COPY nginx.conf /etc/nginx/nginx.conf

COPY service_start.sh /home/docker/script/service_start.sh
RUN chmod 744 /home/docker/script/service_start.sh

ENTRYPOINT /home/docker/script/service_start.sh
WORKDIR /home/docker
```

Détails :
* MAINTAINER : nom et courriel de mainteneur du conteneur 
* FROM : image de base (Ubuntu, Debian)
* VOLUME : point de montage
* RUN : commande à exécuter pour installer le conteneur
* ENTRYPOINT : commande qui s’exécute au démarrage du conteneur (une seule la dernière sera exécutée), ne sera pas ignoré
* CMD : commande qui s’exécute au démarrage du conteneur si aucune commande n'est spécifié (une seule la dernière sera exécutée). A mettre après l'ENTRYPOINT.

docker run -it <image> (CMD sera exécuté)
docker run -it <image> /bin/bash (CMD ne sera pas exécuté)


* ADD : copier un fichier du répertoire courant dans le système de fichiers du conteneur
* USER : utilisateur qui exécute les commandes dans le conteneur
* EXPOSE : port(s) à exposer à l’extérieur
* ENV NAME : définition de variable d'environnement

#### Construction d'une image:
```
docker build .
```
"." est le chemin du Dockerfile


Donner un nom a l'image :
```
docker build -t debian:testDockerImage .
```

#### Création d'une image a partir du container
Exemple avec modification du script de démarrage
```
docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
59f1bb3f0965        lns                 "wrapdocker"        11 minutes ago      Exited (0) 3 seconds ago                       test1
docker commit --change='ENTRYPOINT ["/home/docker/script/start.sh"]'  test1 lns:full
```

### Lancement du container
Un container est une instance d'une image
```
docker run debian:testDockerImage
```

Visualisation :
```
docker ps -l
```

Interaction avec le container :
```
docker run --tty --interactive debian:testDockerImage
```
### Visualisation
Liste des images :
```
docker images
```
Liste des container (X container pour 1 image)
```
docker ps -a
```
On peut ainsi voir l'état de chaque container

Configuration du container
```
docker inspect test1
```

### Persistance des données
#### Creation
```
docker create --tty --interactive --name="test1" debian:testDockerImage
```

Notre container :
```
wnom@debian:~/Documents/docker/test$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                         PORTS               NAMES
2dabd60b85ac        debian:testDockerImage   "/bin/bash"         25 seconds ago      Created                                            test1
ab682fcd3a58        debian:testDockerImage   "/bin/bash"         30 minutes ago      Exited (127) 37 seconds ago                        furious_pasteur
```
Puis
```
docker start --attach --interactive test1
```

### Manipulation d'image
Supprimer :
```
docker rmi 25c5e5339e48
```


### Manipulation de container
Terminal du container
```
docker attach test1
```
ou
```
docker exec -ti test1 bash
```

Sauvegarde :
```
# save tags and versions
docker save -o save/testdockersave.tar debian:testDockerImage
```
ou
```
# export release (no history)
docker export -o save/dockersave.tar debian:testDockerImage
```

Chargement :
```
# load tags and versions
docker load -i save/testdockersave.tar
```
ou
```
# import release (no history)
docker import  save/testdockersave.tar
```
Vous pouvez utilié directement une URL


Supprimer :
```
docker rm test1
```

### Partage de dossier
```
docker create --tty --interactive --name="test1" -v [chemin sur le host]:[chemin sur le docker] debian:testDockerImage
```



## Déploiement a distance avec jenkins
Utilisation en ssh :
```
HOST="app.exemple.com"
USER="username"

HOSTIP=`getent ahosts $HOST |egrep $HOST |awk '{ print $1 }'`
FOLDER_SRC="/var/lib/jenkins/workspace/Build_lns-rest-service-docker/target"
FOLDER_DST="/opt/loramacserver/Api-rest"


ssh $USER@$HOST 'docker stop $(docker ps -a -q)'
ssh $USER@$HOST 'docker rm $(docker ps -a -q)'
ssh $USER@$HOST 'docker rmi $(docker images -q)'

scp $FOLDER_SRC/lns-rest-service-docker.tar $USER@$HOST:$FOLDER_DST
ssh $USER@$HOST 'docker load -i '$FOLDER_DST'/lns-rest-service-docker.tar'
ssh $USER@$HOST 'docker run -d \
	--add-host=mysqlserver:'$HOSTIP' \
	--add-host=asserver:'$HOSTIP' \
	--add-host=nsserver:'$HOSTIP' \
	--add-host=ncserver:'$HOSTIP' \
	-p 9090:8080 -t \
	--name="api-rest" \
	-v /var/log/lns:/var/log/lns \
	kerlink/lns-rest-service-docker'
```



<!-- ------------------------ Network ----------------------------------- -->
## Network
Commandes usuelles
| Commande | Description |
|--------- |------------ |
| ```docker network --help``` | Affiche l'aides |
| ```docker network ls``` | Affiche les différents networks |
| ```docker network ls``` | Affiche les différents networks |


## Options run
L'option  ```docker run --network=<NETWORK>``` permte de connecter le docker à un network



<!-- ------------------------ Cluster avec compose ----------------------------------- -->

## Cluster avec compose
### Contexte

Cycle de vie :
- Définir app via le Dockerfile
- Définir les services avec le `docker-compose.yml`
- Exécuter `docker-compose up` pour lancer le tout

Le compose file version '3' permet de gérer différent cycle de vie tel que le build, deplay, depend_on, networks, et beaucoup d'autre

Le compose file est écrit en yaml (.yml) et utilise la structure <key>: <option>: <value>


### Installation
Install docker compose
```bash
apt-get update
apt-get install docker-compose
```


### Exemple

#### Source code
```bash
mkdir composetest
cd composetest
vim app.py
```

```python
from flask import Flask
from redis import Redis

app = Flask(__name__)
redis = Redis(host='redis', port=6379)

@app.route('/')
def hello():
    count = redis.incr('hits')
    return 'Hello World! I have been seen {} times.\n'.format(count)

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
```

```bash
vim requirements.txt
```

```txt
flask
redis
```

### Dockerfile

```bash
vim Dockerfile
```

```Dockerfile
FROM python:3.4-alpine
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```

### Compose file


```bash
vim docker-compose.yml
```

```yml
version: '2'
services:
  web:
    build: .
    ports:
     - "5000:5000"
    volumes:
     - .:/code
  redis:
    image: "redis:alpine"
```
Remarque : Le dossier . du docker est monter sur le dossier code. Cela permet de modifier le code sans redémarer le docker.


### Exécuter

```bash
sudo docker-composer up
```

ou pour le passer directement en back ground
```bash
sudo docker-composer up -d
```

Vous pouvez voir les deux containers (redis et l'app web python) en cours d'exécution avec ```docker ps ```

### Maintenance

Arreter compose
```bash
docker-compose stop
```

Détruire le container
```bash
docker-compoe down
```

Détruire le container et les donnée des volumes montées
```bash
docker down --volumes
```




<!-- ------------------------ Exécution ----------------------------------- -->
## Exécution

Le Docker permet de crées un container à partir d'une image puis de l'exécuter.
Les containers sont enregistré par défaut sauf `/var/lib/docker/containers/`.

### Affichage
Afficher la liste de tous les conteneurs (meme ceux qui ont crashés)
```bash
docker ps -a
```
### Création et exécution
La comande de base de création et d'exécution de container est `docker run`

| Options usuelles | Descipriton |
|------------------ |------------ |
| ```--help``` | Aides intégrale |
| | |
| ```--name=myname```  | nom de l'image créée |
| ```-d```          | Lancer en mode détaché (background)|
| ```-h myhost```    | Container host names |
| ```-v dirA:dirDockerB``` | Persistance des données via montage le volume/répertoire dirA and le conteneur au répertoire  dirDockerB|
| | |
| ```myarg```       | image cible |

##### Exemple

```bash
docker run --name=hbase-docker -h hbase-docker -d -v $PWD/data:/data dajobe/hbase
```

### Arret d'un conteneur

```bash
docker stop dajobe/hbase
```
### Kill d'un conteneur

```
docker kill test1
```



### Démarage automatique
Il est conseillé de configurer le démarrage automatique avec le **restart policy** de docker et non utiliser un script personnel de démarrage


| Options | Decription |
|-------- |----------- |
| ```restart --no``` | Pas de restart |
| ```restart --on-failure``` | Restart en cas d'erreur |
| ```restart --unless-stopped``` | Restart sauf en cas |
| ```restart --always``` | Pas de restart |

#### Afficher le **restart policy**

```bash
docker inspect -f "{{ .HostConfig.RestartPolicy }}" <container_id>
docker inspect -f "{{ .RestartCount }}" <container_id>
docker inspect -f "{{ .State.StartedAt }}" <container_id>
```

Si le conteneur existe déjà : ```docker update --restart=always```


#### Modifier le **restart policy**

Si vos images sont _stateless_ (pas de perte de donnée possible)

```bash
docker stop my-container
docker rename my-container my-old-container
docker run --volumes-from=my-old-container --restart always myimage
docker rm my-old-container
```


```bash
version: "2"
services:
  redis:
    image: redis:alpine
    restart: alaways
```





<!-- ------------------------ Network ----------------------------------- -->

## Network

### bridge

Afficher l'état du bridge
```bash
docker network inspect bridge
```

Création d'un autre brige isolé du réseau
```bash
docker network create -d bridge --subnet 172.25.0.0/16 isolated_nw
```
Afficher l'état du nouveau réseau
```bash
docker network inspect isolated_nw
```

Connecter à chaux un container à un réseau
```bash
docker network connect isolated_nw mycontainer
```

Lancer et connecter un container à un réseau
```bash
docker run --network=isolated_nw --ip=172.25.3.3 -itd --name=container3 busybox
```


<!-- ------------------------ Maintenance ----------------------------------- -->

## Maintenance

### Connection via Terminal

```bash
docker exec -t -i myname worf.sh
```
Connection avec un utilisateur spécifique

```bash
docker exec --user root -t -i myname worf.sh
```

### Crash d'un conteneur

| Commandes | Description |
|---------- |------------ |
| ```docker ps``` | Afficher les conteneurs en exécution |
| ```docker ps -a``` | Afficher les conteneurs en exécution et ceux arretés/craché |
|
| ```docker start mycontener``` | arreter le conteneur |
| ```docker stop mycontener``` | arreter le conteneur |
| ```docker kill mycontener``` | kill (arret forcé) le conteneur |
| ```docker rm mycontener``` | supprimer le conteneur |

### Advanced

```bash
# Stop all container
docker stop $(docker ps -a -q)

# Remove all container
docker rm $(docker ps -a -q)

# Delete all image with name or tag aas "<none>"
docker rmi `docker images| egrep "<none>" |awk '{print $3}'`
```

## erreur
### chmod tres long/slow
probleme de storage docker , corrigé dans le kernel 4.19

### Arrêter tous les services (_daemons_, réseau) Docker à la main

Sans avoir à le désinstaller.

[Arrêter les _daemons_](https://stackoverflow.com/questions/42365336/how-to-stop-docker-under-linux) :

```bash
sudo systemctl stop docker
sudo systemctl stop docker.socket
```

[Arrêter les réseaux](https://unix.stackexchange.com/questions/31763/bring-down-and-delete-bridge-interface-thats-up) :

```bash
sudo ip link set docker0 down
sudo ip link delete docker0
sudo ip link show | grep br- | awk -F ':' '{print $2}' | tr -d ' ' | while read b; do sudo ip link set "$b" down; sudo ip link delete "$b"; done
```
