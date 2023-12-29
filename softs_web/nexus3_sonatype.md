# Nexus 3 sonartype

<!-- TOC -->

- [Nexus 3 sonartype](#nexus-3-sonartype)
  - [Links](#links)
  - [Info VM utilisé pour cette installation](#info-vm-utilisé-pour-cette-installation)
  - [Installation](#installation)
  - [Passer Nexus3 en mode service](#passer-nexus3-en-mode-service)
  - [Proxy 80 -> 8081](#proxy-80---8081)
  - [Plugin Nexus composer](#plugin-nexus-composer)
    - [Installation](#installation-1)

<!-- /TOC -->

## Links

```
Doc : https://help.sonatype.com/repomanager3
SystemRequir : https://help.sonatype.com/repomanager3/system-requirements#SystemRequirements-Java
```

## Installation
Il faut télécharger l'archive et l'extraire peux importe où l'on souhaite sauf dans le home directory.
Pour suivre les bonnes pratiques : "On a Unix machine common practice is to use /opt"

```bash
(En user root)
cd /opt
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
tar -xvzf latest-unix.tar.gz
rm latest-unix.tar.gz
chown nexus:nexus /opt/nexus-3.20.0-04 -R
chown nexus:nexus /opt/sonatype-work/ -R
```

On se retrouve donc avec deux fichiers "/opt/nexus-[version]" et "/opt/sonatype-work".
Le premier est le répertoire d'application et le deuxième le répertoire des data.

Dans /opt/nexus-3.20.0-04/bin/nexus.vmoptions on retrouve la configuration de la ram max/min,
les répertoire à utiliser et les logs.
Dans /opt/sonatype-work/nexus3/etc/nexus.properties il est possible de changer l'ip et le port par défaut qui est configuré dans /opt/nexus-3.20.0-04/etc/nexus-default.properties
(Pas possible d'utiliser 80 et 443 et tous autres ports en dessous de 1024 car se type de port est réservé par les users root et www-data)

Il n'est pas recommandé de lancer Nexus en root. Pour démarrer Nexus :

```bash
(En user nexus)
/opt/nexus-3.20.0-04/bin/nexus run
```
Si tout démarre bien alors il devrait y avoir le message Started Sonatype Nexus OSS [version],
et via un navigateur on accède à http://nexus.exemple.com:8081.
On se login avec admin et le mot de passe par défaut est dans le répertoire /opt/sonatype-work/nexus3/admin.password

A se moment un wizard setup nous fait changer le mdp, j'ai utilisé le mot de passe root de noyal.

Ctrl+c dans la console pour quitter et fermer nexus.

## Passer Nexus3 en mode service

Modifier dans /opt/nexus-3.20.0-04/bin/nexus.rc le user à utiliser (nexus ici) et utiliser systemd créer un service nexus

```bash
(En user root)
ln -l /opt/nexus-3.20.0-04 /opt/nexus_last_update
nano /etc/systemd/system/nexus.service
```

```
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus_last_update/bin/nexus start
ExecStop=/opt/nexus_last_update/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
```

Puis on active

```bash
(En user root)
systemctl daemon-reload
systemctl enable nexus.service
systemctl start nexus.service
```

## Proxy 80 -> 8081
Dans sonatype-work/nexus3/etc/nexus.properties je décommente application-host et je modifie l'adresse d'écoute.

```
application-host=127.0.0.1
```

Je restart le service nexus et grace au proxy de nginx maintenant j'accède à https://nexus.exemple.com/

## Mise à jour
Lien maj: https://help.sonatype.com/repomanager3/download

```
cd /opt/
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
tar xzvf latest-unix.tar.gz
service nexus stop
chown -R nexus: nexus-3.22.1-02
ln -s nexus-3.22.1-02 nexus_last_update
# Penser à recuperer les fichiers deploy
cp nexus-3.20.0-04/deploy/nexus-repository-composer-0.0.4-bundle.kar nexus-3.22.1-02/deploy/
service nexus start
```

## Plugin Nexus composer

### Installation
https://github.com/sonatype-nexus-community/nexus-repository-composer
Build all with docker. this command will build nexus docker images with the compiled plugin inside

```bash
# Get the source with fixed version
git clone https://github.com/sonatype-nexus-community/nexus-repository-composer.git
cd nexus-repository-composer
git checkout composer-parent-0.0.4
# Compile (take 5 minutes)
docker build -t nexus-repository-composer .
```

Extract only the compiled plugin file (*.kar)
```bash
docker run -d -p 8081:8081 --name nexus-repository-composer nexus-repository-composer
docker cp nexus-repository-composer:/opt/sonatype/nexus/deploy/nexus-repository-composer-0.0.4-bundle.kar .
docker stop nexus-repository-composer
docker rm nexus-repository-composer
```
nexus-3.22.1-02
Clean docker images image
```bash
docker rmi nexus-repository-composer
```

Put the plugin file in the **deploy** directory of the nexus.
From example on nexus.exemple.com:/opt/nexus-3.20.0-04/deploy/nexus-repository-composer-0.0.4-bundle.kar

Fix owner
```bash
chown nexus: /opt/nexus-3.20.0-04/deploy/nexus-repository-composer-0.0.4-bundle.kar
```
Restart the nexus. For example on nexus-3.22.1-02nexus.exemple.com:
```bash
service nexus restart
service nexus status
```
