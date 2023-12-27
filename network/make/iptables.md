# Iptables
<!-- TOC -->

- [Iptables](#iptables)
    - [Schema](#schema)
        - [Informatino schéma](#informatino-schéma)
    - [Vocabulaire](#vocabulaire)
    - [Type de connexion](#type-de-connexion)
        - [Manipuler les "chaines" (tables)](#manipuler-les-chaines-tables)
        - [Manipuler les règles dans une chaine](#manipuler-les-règles-dans-une-chaine)
        - [Constrution des regles](#constrution-des-regles)
        - [Les modules iptables](#les-modules-iptables)
            - [Les modules sont automatiquement utilisé avec -p,-m,-j](#les-modules-sont-automatiquement-utilisé-avec--p-m-j)
        - [Extentions tcp et udp](#extentions-tcp-et-udp)
        - [Extentions icmp](#extentions-icmp)
        - [Autres extentions](#autres-extentions)
    - [](#)
        - [Ubuntu](#ubuntu)
    - [](#-1)
        - [Installer iptables (ipv4) et ip6tables pour (ipv6)](#installer-iptables-ipv4-et-ip6tables-pour-ipv6)
        - [Snipet](#snipet)
            - [Toutes les sessions TCP doivent commencer par un SYN](#toutes-les-sessions-tcp-doivent-commencer-par-un-syn)
            - [Toutes les connections etablies peuvent entrer](#toutes-les-connections-etablies-peuvent-entrer)
            - [Toutes les connections etablies peuvent sortir](#toutes-les-connections-etablies-peuvent-sortir)
            - [Authoriser SSH](#authoriser-ssh)
            - [Authoriser HTTP](#authoriser-http)
            - [Authoriser HTTPS (HTTP+SSL)](#authoriser-https-httpssl)
            - [Authoriser DNS](#authoriser-dns)
            - [Authoriser NTP](#authoriser-ntp)
        - [Syn-flood protection:](#syn-flood-protection)
        - [Furtive port scanner:](#furtive-port-scanner)
        - [Ping of death:](#ping-of-death)
        - [Protection : Nombre (10) de paquet par secondes (1) (limite)](#protection--nombre-10-de-paquet-par-secondes-1-limite)
    - [Log](#log)
        - [Loguer tout les packets droper sur OUTPUT (ssi la regle est en fin de table et policy == DROP)](#loguer-tout-les-packets-droper-sur-output-ssi-la-regle-est-en-fin-de-table-et-policy--drop)
                    - [](#-2)
    - [Extentions iptables](#extentions-iptables)
        - [state vs conntrack](#state-vs-conntrack)
        - [Les helper](#les-helper)
        - [IP masquerade](#ip-masquerade)
        - [bloquer IP](#bloquer-ip)
        - [empecher notre serveur d'envoyer des mails](#empecher-notre-serveur-denvoyer-des-mails)
        - [Ajout if virtuelle](#ajout-if-virtuelle)
        - [Ajout alias](#ajout-alias)
        - [partage de connexion (ex: dom0 xen sans ip publique)](#partage-de-connexion-ex-dom0-xen-sans-ip-publique)
        - [modifier default IP source par 192.168.0.1](#modifier-default-ip-source-par-21283129104)
        - [SYN flood](#syn-flood)
        - [Protection SYN flood](#protection-syn-flood)

<!-- /TOC -->


## Schema

```
========================================================================================================================
#   BROUTING    I       PREROUTING      I   INPUT   I           FORWARD           I   OUTPUT   I      POSTROUTING
========================================================================================================================
                I                       I           I                             I            I
                I                       I (FILTER)------->[LOCAL PROCESS][Routing ]->(RAW)     I
                I                       I    ^      I     [ LINUX HOST  ]         I    |       I
                I                       I    |      I                             I    |       I
                I                       I    |      I                             I (MANGLE)   I
                I                       I    |      I                             I    |       I
                I                       I    |      I                             I    !       I
                I                       I (MANGLE)  I                             I  (NAT)     I
                I                       I    ^      I                             I    |       I
                I                       I    |      I                             I    !       I
                I                       I    |      I                             I[CHECK FOR] I
                I                       I    |      I                             I[NAT REMOTE]I
                I                       I    |      I                             I |     !    I
                I                       I    |      I                             I | (FILTER)-----------\
                I                       I    |      I                             I |          I         !
  [Routing]-------(RAW)->(MANGLE)->(NAT)->[Routing ]----------->(MANGLE)->(FILTER)-- ----------------->(MANGLE)->(NAT)
  [Process]     I                       I [Decision]--\                           I |          I                   |
      ^ ^_____  I   *****************   I    ^      I |                           I |          I                   |
      |       \ I   * NETWORK LAYER *   I    |      I |                           I |          I                   !
->[Processing] \I***********************I****|******I*|***************************I*!**********I*****************[OUT]->
  [ Decision ] |I   *  LINK LAYER   *   I    |      I |                           I (FILTER)   I                   ^
      |        |I   *****************   I    |      I |                           I     !      I                   |
      !        |I                       I {FILTER}  I \-------->(MANGLE)->(FILTER)--->{NAT}    I                   |
  [Bridging]   /I                       I    ^      I                             I     |      I                   |
/-[Process ]  / I                       I    |      I                             I     !      I                   |
|      ______/  I                       I    |      I                             I {FILTER}-----\                 |
|     /         I                       I    |      I                             I            I !                 |
\>{BROUTE}------->{NAT}->(MANGLE)->(NAT)->[Bridging]->{FILTER}->(MANGLE)->(FILTER)------------->{NAT}->(MANGLE)->(NAT)
                I                       I [Decision]I                             I            I
                I                       I           I                             I            I
========================================================================================================================
Legende : [Infos]    {EBTables}     (iptables)
```



### Information schéma

Par défaut la commandes ```iptables``` selectionne la chaine "FILTER"
La chaine "NAT" n'est pas installé par défaut
La chaine est lancé avant conntrack (traking) pour marquer les paquets.
Conntrack est utilisé juste après "RAW" (En début de PREROUTING et en début d'OUTPUT)

## Vocabulaire

| Action            | Table impacté  |
|------------------ |--------------- |
| DNAT               | => PREROUTING:NAT  |
| SNAT && MASQUERADE | => POSTROUTING:NAT |
| MARK && TOS && TTL | => ALL:MANGLE      |


## Type de connexion

| Type                                | Couche  | Techniquement       |     Description  |
|------------------------------------ |-------- |-------------------- |----------------- |
| Standard                              | Normal  | | |
| Router                                | 2        |Change MAC et IP       | Activer le router (natif dans le noyaux linux)
| Router + NAT static                   | 3        |                      | Association d'un IP publique à chaque IP local (rarement utilisé)|
| Router + NAT dym (ou port forwarding) | 4        |Change MAC, IP et PORT | Association d'une IP publique unique + Num port à chaque IP local (Nat le plus courant), Active le NAT Masquerade (natif dans le noyaux linux)|
| Bridge                                | 2        |Ne change rien         | Réoriente le trafic en fonction de l'address mac/IP, brodcast sur les interface dans un premier temps|



### Manipuler les "chaines" (tables)        
- Lister               LIST   : iptables -L [<options>] <nom_chaine>
- Créer                NEW    : iptables -N <options> <nom_chaine>
- Renommer             RENAMME: iptables -E <nom_chaine> <nouveau_nom_chaine>
- Effacer              DEL    : iptables -X <options> <nom_chaine>
- Changer la politique POLICY : iptables -P <options> <nom_chaine> <cible>
- Vider (les règles)   FLUSH  : iptables -F <options> <nom_chaine>
- Compteur a zero      ZERO   : iptables -Z <options> <nom_chaine>


Options : -t [raw|mangle|nat|filter|security]
          -d {icmp|udp|tcp|...}   # List in /etc/protocols
          -j {ACCEPT|DROP|QUEUE|RETURN|REJECT|LOG|DNAT|SNAT}
          -i {INPUT|FORWARD|PREROUTING}
          -o {FORWARD|OUTPUT|POSTROUTING}


<nom_chaine>   =   [PREROUTING|INPUT|FORWARD|OUTPUT|POSTROUTING]
<cible>        =   [ACCEPT|DROP|QUEUE|RETURN|REJECT|LOG|DNAT|SNAT]


### Manipuler les règles dans une chaine
- Ajouter                ADD      : iptables -A <nom-chaine> <regle>
- Inserer à une position INSERT   : iptables -I <nom-chaine> <n> <regle>
- Remplacer              REMPLACE : iptables -R <nom_chaine> <n> <regle>
- Supprimer              DEL      : iptables -D <nom_chaine> <n>
- Supprimer la 1ere regles
  correspondante         DEL      : iptables -D <nom_chaine> <regle>


### Constrution des regles
- Source           : [-s| --src| --source] <ip>
                   : ! [-s| --src| --source] <ip>
- Destination      : [-d| --dst| --destination] <ip>
                   : ! [-d| --dst| --destination] <ip>
- Protocol         : [-p| --protocol] <protocol>
- Interface input  : [-i| --in-interface] <iface>
- Interface output : [-o| -out-interface] <iface>
- Fragement        : -f ???

### Les modules iptables
#### Les modules sont automatiquement utilisé avec -p,-m,-j
- Protocol (-p) : udp, tcp, icmp, ...

### Extentions tcp et udp
- Les drapeaux      : --tcp-flags <masque> <test>
                    :  SYN,ACK,FIN, RST,RST,URG et ALL
- Group de drapeaux : --syn
                    : (Equivalent a --tcp-flags SYN,RST,ACK,SYN
- Port source       : [--sport| --source-port] <port>
- Port destination  : [--sport| --destination-port]
- Option tcp        : --tcp-options

### Extentions icmp
- --icmp-type <ype>

### Autres extentions
-m <extention>
--mac-source
--limit
--limit-burst



## Ubuntu
### Installer iptables (ipv4) et ip6tables pour (ipv6)

apt-get update
apt-get install iptables
apt-get install ip6tables


### Snipet

#### Toutes les sessions TCP doivent commencer par un SYN
```bash
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
```

#### Toutes les connections etablies peuvent entrer
```bash
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

#### Toutes les connections etablies peuvent sortir
```bash
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```


#### Authoriser SSH
```bash
iptables -A INPUT -p tcp --dport 22  -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22  -m state --state NEW -j ACCEPT
```

#### Authoriser HTTP
```bash
iptables -A INPUT -p tcp --dport 80  -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80  -m state --state NEW -j ACCEPT
```

#### Authoriser HTTPS (HTTP+SSL)
```bash
iptables -A INPUT -p tcp --dport 443  -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443  -m state --state NEW -j ACCEPT
```

#### Authoriser DNS
```bash
iptables -A INPUT -p tcp --dport 22  -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22  -m state --state NEW -j ACCEPT
```

#### Authoriser NTP
```bash
iptables -A INPUT -p udp --dport 123  -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p udp --dport 123  -m state --state NEW -j ACCEPT
```




### Syn-flood protection:
```bash
iptables -A FORWARD -p tcp --syn -m limit --limit 1/s -j ACCEPT
```

### Furtive port scanner:
```bash
iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
```

### Ping of death:
```bash
iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
```

### Protection : Nombre (10) de paquet par secondes (1) (limite)
```bash
iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --set
iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --update --seconds 1 --hitcount 10 -j DROP
```

## Log

### Loguer tout les packets droper sur OUTPUT (ssi la regle est en fin de table et policy == DROP)
```bash
iptables -N LOGGING
iptables -A OUTPUT -j LOGGING
iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
iptables -A LOGGING -j DROP
```


## Extentions iptables

### state vs conntrack
L'utilisation de conntrack est recommandé car state commence à être antidaté



### Les helper
Les helpers permettent permettent d'ouvrir certain port pour les connexions de nature complexe necessitant des ports suplémentatires
Les paquets serotn marqué par la table raw (PREROUTING,OUTPUT) qui est la seul lancé avant conntrack.
Ainsi, les paquets marqué seront tracqué par conntrack dans un seconde list leur étant dédié.
Les helpers sont par défaut sécurisé, mais il est possible pour des raisons réseaux de dévérouiller certain comporenement en utilisant les options non (défault) à vos risque et péril puisque ce sont souvent de gros trou de sécurité connu dans le firewall

```bash
--------------------------------------------------------------------------------------------------------------
Module         Source address   Source Port     Destination address     Destination port  Protocol   Option
--------------------------------------------------------------------------------------------------------------
amanda         Fixed            0-65535         Fixed                   In CMD            TCP
ftp            Fixed            0-65535         In CMD                  In CMD            TCP        loose = 0 (default)
ftp            Full             0-65535         In CMD                  In CMD            TCP        loose = 1
h323           Fixed            0-65535         Fixed                   In CMD            UDP
h323 q931      Fixed            0-65535         In CMD                  In CMD            UDP
irc            Full             0-65535         Fixed                   In CMD            TCP
netbios_ns     Iface Network    Fixed           Fixed                   Fixed             UDP
pptp           Fixed            In CMD          Fixed                   In CMD            GRE
sane           Fixed            0-65535         Fixed                   In CMD            TCP
sip rtp_rtcp   Fixed            0-65535         Fixed                   In CMD            UDP         sip_direct_media = 1 (default)
sip rtp_rtcp   Full             0-65535         In CMD                  In CMD            UDP         sip_direct_media = 0
sip signalling Fixed            0-65535         Fixed                   In CMD            In CMD      sip_direct_signalling = 1 (default)
sip signalling Full             0-65535         In CMD                  In CMD            In CMD      sip_direct_signalling = 0
tftp           Fixed            0-65535         Fixed                   In Packet         UDP
--------------------------------------------------------------------------------------------------------------
Legend :
  - Fixed: Value of a connection tracking attribute is used. This is not a candidate for forgery.
  - In CMD: Value is fetched from the payload. This is a candidate for forgery.
```

proxy TCP le client 192.168.0.216 accède à 192.168.2.254:80 via le proxytcp 192.168.0.16:5000
```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
YourIP=192.168.0.16
YourPort=15080
TargetIP=192.168.2.254
TargetPort=80
iptables -t nat -A PREROUTING --dst $YourIP -p tcp --dport $YourPort -j DNAT --to-destination $TargetIP:$TargetPort
iptables -t nat -A POSTROUTING -p tcp --dst $TargetIP --dport $TargetPort -j SNAT --to-source $YourIP
iptables -t nat -A OUTPUT --dst $YourIP -p tcp --dport $YourPort -j DNAT --to-destination $TargetIP:$TargetPort
```

### IP masquerade
```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
```


### bloquer IP
```bash
iptables -A INPUT -s 192.168.0.188 -j DROP
```

### empecher notre serveur d'envoyer des mails
```bash
iptables -A OUTPUT -o eth0 -p tcp --dport 25 -j DROP
```

### Ajout if virtuelle
```bash
ifconfig lo add 192.168.0.1 netmask 255.255.255.0
```

### Ajout alias
```bash
ifconfig eth0:0 1.2.3.4 netmask 255.255.255.255

iptables -A OUTPUT -p tcp --dst vm1.exemple.com --dport 25 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 25 -j DROP
```
ACCEPT     tcp  --  anywhere             vm1.exemple.com tcp dpt:smtp
DROP       tcp  --  anywhere             anywhere            tcp dpt:smtp


### partage de connexion (ex: dom0 xen sans ip publique)
sur linux17:
```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

### modifier default IP source par 192.168.0.1
```bash
iptables -t nat -A POSTROUTING -o eno1 -j SNAT --to-source 192.168.0.1
```

### SYN flood
```bash
cat /proc/sys/net/ipv4/tcp_syncookies
cat /proc/sys/net/ipv4/tcp_max_syn_backlog
cat /proc/sys/net/ipv4/conf/all/rp_filter

echo "1" > /proc/sys/net/ipv4/tcp_syncookies
echo "1024" > /proc/sys/net/ipv4/tcp_max_syn_backlog
echo "1" > /proc/sys/net/ipv4/conf/all/rp_filter
```

Quelques explications :

La première ligne fait en sorte que la machine ne garde pas en mémoire les demandes de connexion semi-ouverte tant qu’elle n’a pas reçu la confirmation ACK
La deuxième commande positionne à 1024 le nombre maximum de SYN_WAIT
Enfin, la variable rp_filter permet de vérifier qu’un paquet arrive bien par l’interface sur laquelle il devrait arriver

Il est possible de paramétrer ses valeurs de façon permanente en modifiant le fichier /etc/sysctl.conf :

### Protection SYN flood
```
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.tcp_max_syn_backlog = 1024
```

On pourra ensuite recharger la configuration avec la commande :

```bash
sysctl -p /etc/sysctl.conf
```

### Redirect traffic to another machine
web traffic redirected to 192.168.1.1, excepted for 192.168.1.2 client:
```
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A PREROUTING -p tcp --dport 80 ! -s 192.168.1.2 -j DNAT --to 192.168.1.1:80
iptables -t nat -A POSTROUTING -j MASQUERADE
```
multiple source cannot be negated (! -s ip1,ip2). So, in prerouting ACCEPT ip1 ip2, then DNAT the others:
```
iptables -t nat -A PREROUTING -p tcp --dport 80 -s 192.168.0.1,127.0.0.1,10.10.0.1 -j RETURN
iptables -t nat -A PREROUTING -p tcp --dport 80  -j DNAT --to 10.10.0.1:80
iptables -t nat -A POSTROUTING -p tcp --dport 80 -j MASQUERADE
```
