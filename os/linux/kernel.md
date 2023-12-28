# Kernel

## Affichage information noyaux

### Affichage des modules noyaux associés aux matérielles
```bash
lsmod
```
ou affichage en mode graphique
```bash
apt-get install hwloc
lstopo
```

### Affichage des périférique
liste des périphériques pci
```bash
lspci
```
liste des périphériques usb
```bash
lsusb
```

liste des périphériques hal (couche d'abstration matérielles)
```bash
lshal
```

eviter bloquage "ping sendmsg operation not permitted"
la table conntrack est pleine
```
echo 'net.ipv4.netfilter.ip_conntrack_max=131072' >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
```