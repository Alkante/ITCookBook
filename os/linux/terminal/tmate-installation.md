

# Notes sur tmate

## Tmate slave (Tmate server)

https://tmate.io/


### Installation du serveur tmate

Installation testée sur Debian Stretch 9.1 pour le serveur tmate

- Dépendences à installer :

```
apt install git-core build-essential pkg-config libtool libevent-dev libncurses-dev zlib1g-dev automake libssh-dev cmake ruby
```


- Installer msgpack-c :

```
git clone https://github.com/msgpack/msgpack-c
cd msgpack-c
cmake .
make
make install
```

- Installer tmate-slave :

```
cd /opt
git clone https://github.com/tmate-io/tmate-slave.git
cd tmate-slave
./create_keys.sh
./autogen.sh
./configure
make
```

le script create_keys.sh génère les clés ssh, il affiche des empreintes MD5 à la sortie

copier et garder les fingerprints MD5 quelque part

exemple :

```
af:2d:81:c1:fe:49:70:2d:7f:09:a9:d7:4b:32:e3:be
c7:a1:51:36:d2:bb:35:4b:0a:1a:c0:43:97:74:ea:42
```

pour récupérer les fingerprints a posteriori :

```
ssh-keygen -E md5 -lf /opt/tmate-slave/keys/ssh_host_rsa_key.pub
ssh-keygen -E md5 -lf /opt/tmate-slave/keys/ssh_host_ecdsa_key.pub
```




### Lancer le service

exemple si tmate-slave est installé dans /opt :

```
cd /opt/tmate-slave
export LD_LIBRARY_PATH=/usr/local/lib
./tmate-slave -k /opt/tmate-slave/keys -p 1234 -b 10.10.10.102 -v
```

tmate exécute (bind) le service sur l'adresse IP 10.10.10.102 sur le port TCP 1234

```
./tmate-slave --help
usage: tmate-slave [-b ip] [-h hostname] [-k keys_dir] [-p port] [-x proxy_hostname] [-q proxy_port] [-s] [-v]
```

`-s` = quiet mode
`-v` = verbose mode



**Créer le service tmate-slave pour systemd**


créer le fichier `/etc/systemd/system/tmate-slave.service` :

```
[Unit]
Description=tmate-server

[Service]
ExecStart=/bin/bash -c "/opt/tmate-slave/tmate-slave -k /opt/tmate-slave/keys -p 1234 -b 172.16.67.45 -h 172.16.67.45 -v >/var/log/tmate-slave.log 2>&1"

[Install]
WantedBy=multi-user.target
```

puis exécuter les commandes suivantes pour activer le service :

```
systemctl daemon-reload
systemctl enable tmate-slave
systemctl start tmate-slave
```


## Tmate client

Installation sur Ubuntu 16.04 :

tmate client version : 2.2.1+201706011546+stable3~ubuntu16.04.1


```
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:tmate.io/archive
sudo apt-get update
sudo apt-get install tmate
```


Installation sur Debian 9.1 :

```
git clone https://github.com/tmate-io/tmate
./autogen.sh
./configure
make
make install
```




Créer le fichier `/home/<user>/.tmate.conf` et adapter le contenu suivant :

```
set -g tmate-server-host "tmate.exemple.com" # or 10.10.10.102
set -g tmate-server-port 1234
set -g tmate-server-rsa-fingerprint   "af:2d:81:c1:fe:49:70:2d:7f:09:df:ce:e3:27:d9:a9"
set -g tmate-server-ecdsa-fingerprint "c7:a1:51:36:d2:bb:35:4b:0a:1a:6c:3c:a9:28:2b:ed"
#set -g tmate-identity ""              # Can be specified to use a different SSH key.
```

les fingerprints sont celles sauvegardées précédemment (du serveur aussi appelé slave)
