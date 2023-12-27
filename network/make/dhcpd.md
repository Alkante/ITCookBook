# DHCP
## installer isc-dhcp-server
```bash
apt-get install isc-dhcp-server
```
En cas de probleme
```bash
systemctl status isc-dhcp-server.service
```

### Backup du fichier original
```bash
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.back
```

### Editer /etc/dhcp/dhcpd.conf
```bash
vim /etc/dhcp/dhcpd.conf
```

```
option domain-name "mylan.org";
option domain-name-servers 208.67.222.222, 208.67.220.220;
```

### Définir le réseau de 192.168.1.1/24 à 192.168.1.10
#### Option : le server est server1.megalan.org
```
subnet 192.168.1.0 netmask 255.255.255.0 {
  range 192.168.1.1 192.168.1.10;
  option routers server1.megalan.org;
}

# Attribuer un adress fixe avec un nom arbitraire ne servant à rien nom "pc_personnal"
host pc_personnal {
  hardware ethernet 00:0D:87:B3:AE:A6;
  fixed-address 192.168.1.5;
}
```

## Redémarer le dhcp
```bash
service isc-dhcp-server restart
```
ou :
```bash
/etc/init.d/isc-dhcp-server restart
```

## Voir les log en cas de probleme
```bash
tail /var/log/messages
```
