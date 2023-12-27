# Quagga
## Installation
```bash
apt-get install quagga
```

## Activer les démons Quagga
```bash
vim /etc/quagga/daemons
```

Puis modifier les démons que vous voulez utiliser, dans notre cette exemple nous utiliserons les démons zebra (interface et routage statique) et bgpd
```
zebra=yes
bgpd=yes
ospfd=no
ospf6d=no
ripd=no
ripngd=no
```
Relancer le service :
```bash
service quagga restart
```

## Configuration
Pour chaque démon Quagga actif vous devez avoir un fichier de configuration dans /etc/quagga/

- zebra.conf 	
- bgpd.conf
- ospfd.conf
- ospf6d.conf
- ripd.conf
- ripngd.conf

Pour vos fichiers de configuration vous pouvez vous baser sur les exemples de configurations :
```bash
cp /usr/share/doc/quagga/examples/zebra.conf.sample /etc/quagga/zebra.conf
cp /usr/share/doc/quagga/examples/bgpd.conf.sample /etc/quagga/bgpd.conf
```

Modifier les droits des fichiers :
```bash
chown quagga.quaggavty /etc/quagga/*.conf
chmod 640 /etc/quagga/*.conf
```

Redémarrer le service Quagga:
```bash
service quagga restart
```

## Accès telnet
Par défaut vous pouvez vous connecter sur l'interface loopback
Pour l'accès a distance vous devez spécifier les adresses dans le fichier /etc/quagga/debian.conf
Exemple :
```
zebra_options=" --daemon -A 127.0.0.1 192.168.0.1"
bgpd_options=" --daemon -A 127.0.0.1 192.168.0.1"
```
Redémarrer le service Quagga:
```bash
service quagga restart
```

### Connection
Port telnet :

- zebra: 2601
- ripd: 2602
- ripng: 2603
- ospfd: 2604
- bgpd: 2605
- ospf6d: 2606		

Exemple
```
telnet localhost 2605
```

## VTYSH
VTYSH permet d'avoir qu'un seul accès pour chaque demon Quagga

### Configuration
Copier l'exemple :
```bash
cp /usr/share/doc/quagga/examples/vtysh.conf.sample /etc/quagga/vtysh.conf
```

Changer le hostname
Modifier les droits du fichier :
```bash
chown quagga.quaggavty /etc/quagga/*.conf
chmod 640 /etc/quagga/*.conf
```

Redémarrer le service Quagga:
```bash
service quagga restart
```

Pour le confort, modifier le fichier /etc/environement
```
VTYSH_PAGER=more
```
Cela enlevera le END a chaque application d'une commande

### Utilisation
Lancement :
```bash
vtysh
```

Sauvegarder la configuration
```
router# write
```

## Routage linux
Pour router sur une machine linux, vous devez décommenter dans le fichier /etc/sysctl.conf les lignes :
```
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding=1
```

Puis recharger la configuration
```bash
sysctl -p /etc/sysctl.conf
```

# FRR fork maintenu
globalement la même chose
