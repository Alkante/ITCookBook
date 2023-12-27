# Network info

## ping
1 seul ping / timeout 2s
```bash
ping -n -q -c 1 -W 2 8.8.8.8
```

## TCPDump
### Option
```
option 	Détail 	Exemple
-i 	Affiche les packets pour une interface spécifique. Utiliser 'any' pour tracer toutes les interfaces 	tcpdump -i eth-s1p1
tcpdump -i any
-s0 	Affiche les packets sans les tronquer 	tcpdump -i eth-s1p1 -s0
-x 	Mode "Verbose Hexa" : contenu des packets en Hexadecimal 	tcpdump -i eth-s1p1 -x
-X 	Mode "Verbose Hexa" : contenu des packets en Hexadecimal et ASCII 	tcpdump -i eth-s1p1 -X
-v 	Mode "Verbose light" 	tcpdump -i eth-s1p1 -v
-vv 	Mode "Verbose medium" 	tcpdump -i eth-s1p1 -vv
-vvv 	Mode "Verbose Full" 	tcpdump -i eth-s1p1 -vvv
-w 	Enregistre la sortie de TCPDUMP dans le fichier passé en paramètre 	tcpdump -i eth-s1p1 -w trc20040427.dump
-r 	Affiche le contenu d'un fichier créé avec tcpdump -w 	tcpdump -r trc20040427.dump
```

```
Condition 	Détail 	Exemple
host 	Affiche les trames pour le host défini en paramètre (peut en général être omis) 	tcpdump -i eth-s1p1 host 10.10.10.5
tcpdump -i eth-s1p1 10.10.10.5
src 	Affiche les trames ayant pour origine le host défini en paramètre 	tcpdump -i eth-s1p1 src host 10.10.10.5
dst 	Affiche les trames ayant pour destination le host défini en paramètre 	tcpdump -i eth-s1p1 dst host 10.10.10.5
port 	Affiche les packets du port précisé 	tcpdump -i eth-s1p1 port 21
tcpdump -i eth-s1p1 port ftp
icmp, ip, arp, rarp, udp, tcp 	Affiche les packets du protocole précisé 	tcpdump -i eth-s1p1 icmp
less 	Affiche les packets d'une taille inférieure à celle précisée en paramètre 	tcpdump -i eth-s1p1 less 60
great 	Affiche les packets d'une taille supérieure à celle précisée en paramètre 	tcpdump -i eth-s1p1 greater 96
```

#### Afficher tout par defaut
```bash
tcpdump
```

#### Afficher verbeux
```bash
tcpdump -v
```

#### Afficher très verbeux
```bash
tcpdump -vv
```

#### Afficher les interfaces réseaux disponible
```bash
tcpdump -D
```

#### Afficher sans les résolution DNS
```bash
tcpdump -n
```

#### Affichage rapide
```bash
tcpdump -q
```

#### Afficher le traffic d'une interface
```bash
tcpdump -i eth0
```

#### Arrêter le capture après X paquets
```bash
tcpdump -c 100
```

#### Création d'un fichier de log de capture (peut-être utiliser avec wireshark)
```bash
tcpdump -w fichier.log
```

#### Lire un ficher de capture
```bash
tcpdump -r fichier.log
```

#### Affichage concernant un host particulier
```bash
tcpdump host www.exemple.com
```

#### Affichage concernant une source
```bash
tcpdump src www.exemple.com
```

#### Affichage concernant une destination
```bash
tcpdump dst www.exemple.com
```

#### Affichage concernant un port
```bash
tcpdump port ftp
```

#### Affichage multi contrainte (and et not and)
```bash
tcpdump src 192.168.0.1 and dst 192.168.0.2 and port ssh
```

#### Afficher le contenu des paquets
```bash
tcpdump -A
```
```
 -p       Don't  put  the  interface into promiscuous mode
 -s SIZE  Troncation des paquet après une certaine taille SIZE en octet (par defaut 65535)
 -G TIME  Rotate de fichier toutes les TIME secondes
 -C SIZE  Coupe de fichier si il dépasse SIZE*1 000 000 octets
```

### Exemple
#### Regarder tout le trafic sur une interface sauf ssh(22) vennat d'une ip et sans resolution de nom
```bash
tcpdump -n -i eth0 -vv host 192.168.0.1 and not port 22
```

#### Capture pour wireshark
```bash
tcpdump -i eth0 -w my.tcpdump -s 0 tcp port 1723 or proto 47
```

#### Capture ftp
```bash
sudo tcpdump -nnvvv -i eth0 dst 192.168.0.1 and dst port ftp
sudo tcpdump -nnvvvSXs 1514 -i eth0 dst 192.168.0.1 and dst port ftp
```

#### Lecture pcap
```bash
tcpdump -ttttnnr trace.pcap
```

#### Statistique
```bash
tcpstat -f "port 45672" -o "Time:%S\tn=%n\tbps=%b\ttot=%N\n" 60 > tcpstat.log 2>&1 &
```

### Lancer capture sans danger pour l'espace disque
```bash
tcpdump -pni eth0 -s 65535 -G 10 -w capture.log -w 'capture_%Y-%m-%d_%h:%M:%S.cap'
```

### Fusionner des ficher de capture
```bash
mergecap -w fiche_out capt_1 capt_2 capt_3
```

### Traquer les paquets SYN et ACK sur le port 80
```bash
tcpdump -n tcp and port 80 and 'tcp[tcpflags] & tcp-syn == tcp-syn'
```


# Pkstat
## traffic report
Analyse sur 59 secondes des 5 plus gros flux en octets
```bash
pktstat -i eth0 -1 -w 59 -n -B 2>&1 | sort -nr | head -n 5
```


## Netstat
### Vérification DDOS
Pour savoir combien de SYNC_REC actifs se produisent sur le serveur. Le nombre doit être assez faible, de préférence inférieur à 5. Lors d’incidents d’attaque DoS ou de courriers piégés, le nombre peut devenir assez élevé. Cependant, la valeur dépend toujours du système, donc une valeur élevée peut être moyenne sur un autre serveur.
```bash
netstat -n -p|grep SYN_REC | wc -l
```
#### List IP
```bash
netstat -n -p | grep SYN_REC | sort -u
```

#### Répertoriez toutes les adresses IP uniques des nœuds qui envoient l'état de connexion SYN_REC
```bash
netstat -n -p | grep SYN_REC | awk '{print $5}' | awk -F: '{print $1}'
```

#### Utilisez la commande netstat pour calculer et compter le nombre de connexions que chaque adresse IP établit avec le serveur.
```bash
netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
```

#### Répertoriez le nombre de connexions que les adresses IP établissent au serveur à l'aide du protocole TCP ou UDP.
```bash
netstat -anp |grep 'tcp\|udp' | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
```

#### Vérifiez les connexions ESTABLISHED au lieu de toutes les connexions et affichez le nombre de connexions pour chaque IP.
```bash
netstat -ntu | grep ESTAB | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr
```

#### Afficher une liste des adresses IP et son nombre de connexions qui se connectent au port 80 sur le serveur. Le port 80 est principalement utilisé par le protocole HTTP.
```bash
netstat -plan|grep :80|awk {'print $5'}|cut -d: -f 1|sort|uniq -c|sort -nk 1
```

source : https://linuxaria.com/howto/how-to-verify-ddos-attack-with-netstat-command-on-linux-terminal

## Conntrack
Paramètre système max
```bash
sysctl -a | grep nf_conntrack_max
>net.netfilter.nf_conntrack_max = 10240
>net.nf_conntrack_max = 10240
```
connexions actuelles
```bash
cat /proc/net/ip_conntrack
> tcp      6 113 TIME_WAIT src=192.168.0.219 dst=192.168.0.9 sport=46481 dport=22014 packets=38 bytes=9966 src=192.168.0.9 dst=192.168.0.219 sport=22014 dport=46481 packets=31 bytes=30666 [ASSURED] mark=0 secmark=0 use=1
> tcp      6 21 TIME_WAIT src=192.168.0.213 dst=192.168.0.9 sport=38717 dport=31000 packets=7 bytes=1254 src=192.168.0.9 dst=192.168.0.213 sport=31000 dport=38717 packets=6 bytes=1869 [ASSURED] mark=0 secmark=0 use=1
> unknown  2 40 src=192.168.0.222 dst=224.0.0.2 packets=1 bytes=32 [UNREPLIED] src=224.0.0.2 dst=192.168.0.222 packets=0 bytes=0 mark=0 secmark=0 use=1
> tcp      6 432000 ESTABLISHED src=192.168.0.216 dst=192.168.0.17 sport=39788 dport=22 packets=7913 bytes=469635 src=192.168.0.17 dst=192.168.0.216 sport=22 dport=39788 packets=15862 bytes=4386132 [ASSURED] mark=0 secmark=0 use=1
```

reduire timeout de 5 jours à 5 heures
```bash
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_established=14400
sysctl -w net.ipv4.netfilter.ip_conntrack_tcp_timeout_established=14400
echo "
net.netfilter.nf_conntrack_tcp_timeout_established = 14400
net.ipv4.netfilter.ip_conntrack_tcp_timeout_established = 14400
" >> /etc/sysctl.conf
```
connections keepalive
```bash
sysctl -w net.ipv4.tcp_keepalive_time=60
netstat -to
```
