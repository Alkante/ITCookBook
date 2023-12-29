# Goteleport
## Objectif
Avoir une interface pour donner des consoles aux développeurs.

## Installation
Teleport fonctionne en cluster (serveur) / node (clients) avec un binaire unique pour les clients et le serveur et qui doit être installé sur les deux

Installation via dépôt:
```
curl https://deb.releases.teleport.dev/teleport-pubkey.asc | apt-key add -
add-apt-repository 'deb https://deb.releases.teleport.dev/ stable main'
apt-get update
apt-get install teleport
```

Il existe aussi une installation via docker : https://teleport.exemple.com/docs/setup/guides/docker-compose/

## Configuration
### Les commandes
Avec l'installe de teleport vient 3 commandes :
- teleport qui permet de démarrer le service en mode cluster ou node
- tctl qui permet de gérer le cluster
- tsh qui permet s'authentifier sur le cluster en mode CLI et permet d’utiliser les même fonctions que l'interface web

### Démarrage d'un cluster
Teleport peux générer une configuration de base avec la commande :
```bash
teleport configure --cluster-name=teleport.mondomaine.com -o file
```
Le fichier sera placé dans /etc/teleport.yaml et sera celui utilisé par le service par défaut.
Toute la configuration possible est expliqué ici : https://teleport.exemple.com/docs/config-reference/


Il est possible de démarrer à la main teleport pour tester la configuration
```bash
teleport --config=/etc/teleport.yaml
```

### Désactiver la double authentification
Editer /etc/teleport.yaml
```
authentication:
    type: local
    second_factor: off
```

### Gestion des rôles/utilisateurs
Il est possible d'utiliser soit l'interface web, soit la commande tctl

Création d'un utilisateurs :
- https://teleport.exemple.com/web/users
- tctl users add --roles=myrole user

Création d'un rôle :
- https://teleport.exemple.com/web/roles
- tctl create -f roles.yaml

Exemple de rôle pour autoriser des dev à se connecter sur des nodes avec comme hostname vm1 et vm2 avec user_dev :
```
kind: role
metadata:
  name: access_dev
spec:
  allow:
    app_labels:
      '*': default
    db_labels:
      '*': default
    kubernetes_labels:
      '*': default
    logins:
    - user_dev
    node_labels:
      hostname:
      - vm1
      - vm2
  deny: {}
  options:
    cert_format: standard
    enhanced_recording:
    - command
    - network
    forward_agent: false
    max_session_ttl: 30h0m0s
    port_forwarding: true
version: v3
```

## Ports
- 3022	Node	SSH port. This is Teleport's equivalent of port #22 for SSH.
- 3023	Proxy	SSH port clients connect to. A proxy will forward this connection to port #3022 on the destination node.
- 3024	Proxy	SSH port used to create "reverse SSH tunnels" from behind-firewall environments into a trusted proxy server.
- 3025	Auth	SSH port used by the Auth Service to serve its API to other nodes in a cluster.
- 3080	Proxy	HTTPS connection to authenticate tsh users and web users into the cluster. The same connection is used to serve a Web UI. (modifié avec 10443)

Fonctionnement entre le node et le cluster avec la configuration :
- Le cluster est joignable sur le port 10443 via l'interface web
- Le node se connecte sur le port 3025 du cluster pour vérifié le token, si le token est bon alors le node ouvre le port 3022
- Quand un utilisateur se connecte au node, le cluster se connecte au port 3022 du node


## Fonction de replay
Teleport permet de voir un replay complet des sessions ssh

https://teleport.exemple.com/web/cluster/teleport.exemple.com/recordings

### Activation de la fonction
Requirements : Debian 10 , Ubuntu 18.04/20.04

Installer les paquets :
```
apt -y install bpfcc-tools linux-headers-$(uname -r)
```
