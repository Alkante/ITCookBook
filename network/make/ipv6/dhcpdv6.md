# DHCP en IPv6

## Installation isc-dhcp-server
```bash
apt-get install isc-dhcp-server
```

## Etape de configuration
/!\\ Cette configuration est destiné à l'utilisation d'un DHCP IPv6 en parallèle d'un DHCP IPv4

### Le fichier isc-dhcp-server
#### Copier /etc/default/isc-dhcp-server
Renommer la copie en isc-dhcp6-server

#### Modifier le fichier /etc/default/isc-dhcp6-server
```bash
DHCPD_CONF=/etc/dhcp/dhcpd6.conf
DHCPD_PID=/var/run/dhcpd6.pid
OPTIONS="-6"
INTERFACES="eth0"
```

#### Copier /var/run/dhcpd.pid
Renommer la copie en dhcpd6.pid

#### Copier /etc/init.d/isc-dhcp-server
Renommer la copie en isc-dhcp6-server

#### Modifier isc-dhcp6-server
```
#!/bin/sh
...
# Provides:          isc-dhcp6-server
...
# Short-Description: DHCPv6 server
# Description:       Dynamic Host Configuration Protocol Server IPv6
...
DHCPD_DEFAULT="${DHCPD_DEFAULT:-/etc/default/isc-dhcp6-server}"
...
if [ "$DHCPD_DEFAULT" = "/etc/default/isc-dhcp6-server" ]; then
...
DESC="ISC DHCPv6 server"
# fallback to default config file
DHCPD_CONF=${DHCPD_CONF:-/etc/dhcp/dhcpd6.conf}
# try to read pid file name from config file, with fallback to /var/run/dhcpd6.pid
if [ -z "$DHCPD_PID" ]; then
DHCPD_PID=$(sed -n -e 's/^[ \t]*pid-file-name[ \t]*"(.*)"[ \t]*;.*$/\1/p' < "$DHCPD_CONF" 2>/dev/null | head -n 1)
fi
DHCPD_PID="${DHCPD_PID:-/var/run/dhcpd6.pid}"
...
```


#### Créer votre configuration
```
default-lease-time 600;
max-lease-time 7200;

option dhcp-renewal-time 3600;
option dhcp-rebinding-time 7200;
option dhcp6.name-servers fe80::a00:27ff:fec5:8c2b;
option dhcp6.domain-search "exemple.fr";
option dhcp6.info-refresh-time 21600;

subnet6 fd00:5881:9000::0/40 {
        range6 fd00:5881:9000::1 fd00:5881:9000::100;


        host pfsense {
                hardware ethernet d8:fb:b4:5c:84:14;
                fixed-address6 fd00:5881:9000:f::1;
        }
        host IPAM {
				host-identifier option dhcp6.client-id 94:2d:f6:7b:7e:84;
                #hardware ethernet 94:2d:f6:7b:7e:84;
                fixed-address6 fd00:5881:9000::101;
        }
}
```
/!\\ Le DHCPv6 ne peut pas annoncer la passerelle c'est au routeur de l'annoncer (RA)
/!\\ Le préfix /64 est obligatoire

#### host-identifier option dhcp6.client-id / DUID
Avec dhcpv6 on n'utilise plus l'adresse MAC mais un DUID pour désigné le client (l'objectif est d'avoir un DUID unique au monde). Il existe 3 type :
* Adresse MAC + le temps
* ID unique associer au numéro de l'entreprise
* Adresse MAC
Vous pouvez recuperer ce DUID dans le fichier /var/lib/dhcp/dhclient6.eth0.leases :
option dhcp6.client-id 0:3:0:6:8:0:27:e3:fa:62;
En cas de changement d'adresse MAC, supprimer ce fichier.

### Exécution du serveur DHCPv6
Il faut d'abord une exécution manuel pour la creation du fichier isc-dhcp6-server.service
```bash
/usr/sbin/dhcpd -6 -d -cf /etc/dhcp/dhcpd6.conf eth0
```

Utilisation du service :
```bash
/etc/init.d/isc-dhcp6-server start
```

Status :
```bash
/etc/init.d/isc-dhcp6-server status
```


## Client
### Accepter les Router Advertissement
### Avec /etc/network/interface
```bash
iface eth0 inet6 dhcp
	accept_ra 1
```

### Double client-id sur le réseau
- Vérifier le fichier: /etc/machine-id
- Si c'est le même : uuidgen | sed 's/-//g' > /etc/machine-id

Source : https://wiki.gentoo.org/wiki/NetworkManager#DHCPv6_Unique_IDentifier_.28DUID.29
