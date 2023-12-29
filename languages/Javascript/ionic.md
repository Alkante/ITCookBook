# Ionic

<!-- TOC -->

- [Ionic](#ionic)
    - [Installation](#installation)
    - [Initialisation d'un projet](#initialisation-dun-projet)
    - [Develloper](#develloper)

<!-- /TOC -->

## Installation
Mettre à jour npm
```bash
npm install -g npm
```
En tant que root
```bash
npm install -g cordova
npm install -g ionic
```

## Initialisation d'un projet
```bash
ionic start ionic2-tutorial-github blank --v2
ionic start MyIonic2Project --v2
```

cordova telemetry on


Installer la dernière version
```bash
sudo npm cache clean -f
sudo npm install -g n
sudo n stable

sudo ln -sf /usr/local/n/versions/node/<VERSION>/bin/node /usr/bin/node
```
To undo
```bash

sudo apt-get install --reinstall nodejs-legacy     # fix /usr/bin/node
sudo n rm 6.0.0     # replace number with version of Node that was installed
sudo npm uninstall -g n
```


## Develloper
```
ionic serve
```
http://localhost:8100/
