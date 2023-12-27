# Shorewall
## Contexte
Shorewall est un parfeu utilisant les règle iptebles.
Il est donc incompatible avec d'autre logiciel utilisant aussi ipbles.

## Installation
```bash
apt-get update
apt-get install shorewall
```

## configuration
Par défaut, le parfeu n'est pas activé pour évité tout bannissement non désiré.

La configuration de shorewall repose sur les fichiers de configuration présent dans le répertoire **/etc/shorewall**
```bash
ls /etc/shorewall/
```

Il faut ajouter des fichiers pour rendre la configuration fonctionnelle.
Il y a des exemples dans le répertoire :
- /usr/share/doc/shorewall/examples/one-interface/
- /usr/share/doc/shorewall/examples/two-interface/
- /usr/share/doc/shorewall/examples/three-interface/

Exemple d'ajout de fichier de configuration  minimal
```bash
cp /usr/share/doc/shorewall/examples/one-interface/zones /etc/shorewall/.
cp /usr/share/doc/shorewall/examples/one-interface/interfaces /etc/shorewall/.
cp /usr/share/doc/shorewall/examples/one-interface/policy /etc/shorewall/.
cp /usr/share/doc/shorewall/examples/one-interface/rules /etc/shorewall/.
```


| Fichier | Description |
|-------- |------------ |
| shorewall.conf | Ficher de configuration général |
| params | Ficher pour faire des alias et ainsi simplidier la configration |
| zones | Définition des zones (fw, net, loc, wan, ...)
| interfaces | Affection des interfaces au zones |
| policy | Définition des règles générale d'acception ou de refu entre zones |
| rules | Définition des règles particulière |




### Zones

Le fichier **/etc/shorewall/zones** permet de définir les zones.
```fw``` ou l'alias ```$FW``` correspond à l'host courant (celui qui à shorwall).
Les autres zones correspondent à un découpage arbitraire des connexion extérieur en ipv4 ou ipv6.
ATTENTION !!!! le nom des zones est limités à 5 charactères.

Exemple :
```txt
#ZONE   TYPE             OPTIONS
fw      firewall
net     ipv4
loc     ipv4
dmz     ipv4
```


### Interfaces

Toutes les interfaces qui doivent etre géré par shorewall doivent aparaitre dans ce fichier.
Chaque interface est arbitrairement affecté à une zones.
Exemple :
```txt
#ZONE           INTERFACE               OPTIONS
net             enp0s3                  dhcp,nosmurfs,tcpflags   
```

Les interfaces peuvent avoir les options suivantes :

| Option | Description |
|------- |------------ |
| arp_filter    | Limite les réponse arp au IP des interfaces du firewall |
| arp_ignore    | Option limitant au désactivant les requetes arp |
| blacklist     | Deprecated |
| bridge        | Désigne l'interface comme un bridge (active aussi routeback) |
| destonly      | Désactivation des "Rules" pour cette interface |
| dhcp          | Utilisé si DCHP sur le réseau, ou si ip dynamique ou si DCHP serveur sur le firewall ou si le firewall est un bridge et qu'il y a un DHCP |
| ignore        | Shorewall ignore l'interface |
| loopback      | Boucle local (automatique sir la boucle local est 'lo') (il ne peut y avoir qu'une boucle locale) |
| logmartians   | Log les adresses sources impossible (trés utilisié avec routefilter) |
| maclist       | Liste de MAC |
| mss=<number>  | Option paquet TCP SYN |
| nets          | Limation à un sous réseau |
| nosmurf       | Filtre les paquets ayant une adresse source (brodcast) |
| optional      | Shorewall silent some actions |
| physical=<name> |Add name to the interface |
| proxyarp      | Set /proc/sys/net/ipv4/conf/interface/proxy_arp  |
| required      | Shorewall stop pour un un warning (interface n'existe pas) |
| routeback     | Shorewall permet le traffic retour sur cette interface lors d'un routage |
| routefiler    | Active le filtre de routage /proc/sys/net/ipv4/conf/interface/pr_filter (anti-spoofing) |
| rpfilter      | Anti-poofing basé sur les table du kernel (plus efficace que sfilter) |
| sfilter       | Anti-spoofing pour bridge par exemple (alternative à routefilter) |
| sourcroute    | Accepter les ips non déclarer (sécurity risque). |
| tcpflags      | Refuse les combinaisons illégales de paquet TCP |
| unmanaged     | shorewal ne touche pas à ces interfaces |
| upnp          | Les paquet sont remapé via upnp |
| upnpclient    | Security hole : but usefull with upnp + torrent |
| wait=<seconds>| Délai avant usage de l'interface avant application des options |



### Policy

Les policy définissent les règle d'accès entre zones par défaut.

Exemple :
```txt
#SOURCE ZONE     DESTINATION ZONE    POLICY     LOG     LIMIT:BURST
#                                               LEVEL
fw               net                 ACCEPT
net              all                 DROP       info
all              all                 REJECT     info
```


### Rules

Les rules permetent de définir les règle particulières.

Avec Shorewall, vous:
 * Identifiez la zone source (client).
 * Identifiez la zone destination (serveur).
 * Si la politique depuis la zone du client vers la zone du serveur est ce que vous souhaitez pour cette paire client/serveur, vous n'avez rien de plus a faire.
 * Si la politique n'est pas ce que vous souhaitez, alors vous devez ajouter une règle. Cette règle est exprimée en termes de zone client et de zone serveur.

Si aucune regle n'est satisfaite
	-> la premiere politique dans "policy" lui correspondant sera appliqu�e
	-> si il y a une action par defaut pour cette politique definie dans actions ou actions.std. Alors cette dernière sera appliqué avant les regles de rules


## Démarrage


### Démarrage manuel
```bash
shorewall start
```

### Demarage du service
```bash
sed -i 's/\(^[ ]*STARTUP_ENABLED=\).*$/\1Yes/g' /etc/shorewall/shorewall.conf
sed -i 's/\(^[ ]*startup=\).*$/\11/g' /etc/default/shorewall
```

## SNAT en sortie (POSTPROUTING)

Changer l'adresse source sur les paquets en sortie

### Editer le fichier qmask
SNAT de 192.168.64.238 vers 192.168.64.243
```
#INTERFACE              SOURCE          ADDRESS
eth0                  192.168.64.238/32  192.168.64.243
```

SNAT de 192.168.64.0/19 vers 192.168.64.243
L'astuce est que c'est le réseau et non l'ip qui est utiliser pas shorewall, c-a-d que le netmask est très important ici.
```
#INTERFACE              SOURCE          ADDRESS
eth0                  192.168.64.238/19  192.168.64.243
```

### Ajouter la nouvelle IP à l'interface
Sous debian, une interface n'a qu'une ipv4

si vous voulez receptionner les paquets retour utiliser une interface virtuel
```bash
ifconfig eth0:0 192.168.64.243 netmask 255.255.224.0
```
puis afficher la avec
```bash
ifconfig
```
puis supprimer la avec
```bash
ifconfig eth0:0 down
```

## Interaction avec d'autres applis

### fail2ban

Fail2ban est aussi livré avec une action shorewall : /etc/fail2ban/shorewall.conf. Pour l utiliser, il suffit simplement de préciser banaction = shorewall dans /etc/fail2ban/jail.local

### docker
- fichier : /etc/shorewall/interfaces
```
dock    docker0         physical=docker+,routeback=1
dock    br              physical=br-+,routeback=1
```
- fichier : /etc/shorewall/policy
```
dock            all             ACCEPT
$FW             dock            ACCEPT
```
- fichier : /etc/shorewall/shorewall.conf
```
DOCKER=Yes
```
- fichier : /etc/shorewall/zones
```
dock    ipv4
```
https://gist.github.com/lukasnellen/20761a20286f32efc396e207d986295d
