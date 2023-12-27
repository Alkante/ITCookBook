# traceroute

Traceroute permet de connaître le chemin d'un parquet IP.

## Usage
Tracer un paquet réseau vers une url
```bash
traceroute www.exemple.com
```

## Fonctionnement
L'astuce est d'envoyer des paquets UDP (sur le port 33434 par défaut) avec des TTL différents entre 1 et 64.
Quand un paquet arrive chaque serveur intermédiaire décrémente le TTL de 1.
Quand il arrive au destinataire, il ne le décrémente pas.

Exemple d'un ping envoyer à soit même avec un TTL par défaut de 64 :
```bash
ping localhost
```

Quand un paquet a un TTL de 1 et est décrémenté, le serveur renvoie par défaut une requête ICMP (type : 8, code : 0 , message : Temps dépassé)
Il en va de même pour le serveur destinataire final et qui n'accepte généralement pas les requête UPD sur le port 33434, qui renvoie une requete ICMP (Type : 3, Code : 3, message :ICMP port unreachable).


Ainsi, le traceroute peut déterminer le nombre de serveurs intermédaires (64-TTL de réception).
De plus, en envoyant des TTL de 1 à 64, le traceroute identifiront tout les serveurs intermédiaires répondant par défaut via icmp.

```bash
traceroute www.exemple.com
```

Pour pinger les serveurs intermédiaire manuellement, il suffit d'utiliser le ping en modifiant le TTL.

```bash
ping -t 1 www.exemple.com
```

## Exemple

### Route du dns (defaut par UDP
```bash
traceroute www.exemple.com
```
- *** Indique qu'il n'y a pas eu de reponse (essayer avec l'option -I)
- <Num> <url/ip> (<ip>) temp1 ms temp2 ms temps3 ms

### Route du dns via ICMP (Plus souvent accepté)
```bash
traceroute -I www.exemple.com
```

### Traces avancées (Defaut ICMP)
```bash
mtr www.exemple.com
```

### Traces avvancées en terminal
```bash
mtr -t www.exemple.com
```
```
 h : help
 d : Changer l'affichage
 u : Switch entre ICMP et UDP
 q : quit
```

### Trace route en TCP
```bash
tcptraceroute www.exemple.com http
```

### check public IP address
```bash
wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'
```

### Identifier l'IP DNS (Ubuntu + NetworkManager)
```bash
nmcli dev list |egrep '^IP4.DNS' |awk '{ print $2}'
```
