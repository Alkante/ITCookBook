# GeoServer


## Context
GeoServer est un server cartographique coparable à MapServer
Il est codé en Java

## Installation

### Java

Installer JDK 8

```bash
apt-get update
apt-get install openjdk-8-jre
```

### Téléchargement

Télécharger la version stable [http://geoserver.org/release/stable/](http://geoserver.org/release/stable/)

```bash
mkdir /usr/share/geoserver/
mv geoserver*.zip /usr/share/geoserver/
cd /usr/share/geoserver/
unzip geoserver*.zip
rm geoserver*.zip
mv geoserver*/* .
rmdir geoserver*
sudo chown -R pnom /usr/share/geoserver
```

### Environement

```bash
echo "export GEOSERVER_HOME=/usr/share/geoserver" >> ~/.profile
. ~/.profile
```

### Lancement
Pour un lancement manuel, utiliser la ligne de commande suivante

```bash
su -l pnom
cd /usr/share/geoserver/bin
sh startup.sh
```

### Connexion

Utiliser l'url suivante :
[http://localhost:8080](http://localhost:8080)

Par défaut, le login/password est admin/geoserver

## Usage

Layer Preview : liste des layer publiable disponible.
Les type de layer sont :
 - vectoriel.point
 - vectoriel.ligne
 - vectoriel.surface
 - raster
 - multilayer



## Plugin

### Geomesa for HBASE

[http://www.geomesa.org/documentation/user/hbase/install.html#install-hbase-geoserver](http://www.geomesa.org/documentation/user/hbase/install.html#install-hbase-geoserver)


Télécharger  le Plugin
```bash
cd /tmp
wget https://github.com/locationtech/geomesa/archive/geomesa_2.11-1.3.1.tar.gz
tar xvf geomesa_2.11-1.3.1.tar.gz
cd geomesa-geomesa_2.11-1.3.1
cd geomesa-hbase
```

Vérifier votre version de maven >= 3.5 pour etre sur
```bash
mvn -version
```

Compiler
```bash
mvn clean install
```
15 minutes plus tard

Affichier le résultat de la compilation de la distribution

```bash
ls geomesa-hbase-dist/target
```

### Geomesa pour GeoServeur

geomesa-hbase-gs-plugin/target

Affichier le résultat de la compilation de la distribution

```bash
cd  geomesa-geomesa_2.11-1.3.1/geomesa-hbase/geomesa-hbase-gs-plugin/target
ls
```

Trouver le fichier d'install du plugin
```bash
geomesa-hbase-gs-plugin_2.11-1.3.1-install.tar.gz
cp geomesa-hbase-gs-plugin_2.11-1.3.1-install.tar.gz /usr/share/geoserver/webapps/geoserver/WEB-INF/lib
```
