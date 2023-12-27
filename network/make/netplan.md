# NetPlan
A partir d'ubuntu 17 networking est remplacer par netplan

# Configuration
La configuration est dans ```/etc/netplan/*.yaml```

# Application configuration
```bash
netplan try
```
Cette commande fait 3 action :
- test configuration
- applique la config
- attends la confirmation de l'utilisateur, sans confirmation il revient a la config d'avant au bout de 2 minutes

## Exemple
```bash
HOST="vm1"
IP1="192.168.0.1"
IP2="192.168.1.1"
IP1v6="fd00:2800:ba20:a0:c::116"
IP2v6="fd00:2800:ba20:a5:c::116"
NET="19"
NETv6="64"
GW="192.168.0.254"
GWv6="fd00:2800:ba20:a0:ffff::1"
DNS1="192.168.0.254"
DNS2="192.168.0.253"
DNS3="fd00:2800:ba40:a0:fffc::ddd1"
DNS4="fd00:2800:ba20:a5:fffc::ddd2"
echo "
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses:
        - $IP1/$NET
        - $IP1v6/$NETv6
      gateway4: $GW
      gateway6: $GWv6
      nameservers:
          addresses:
              - $DNS1
              - $DNS2
              - $DNS3
              - $DNS4
    eth1:
      addresses:
        - $IP2/$NET
        - $IP2v6/$NETv6
      routes:
        - to: 10.502.0.0/16
          via: 192.168.0.254
        - to: fd00:2800:ba00::/40
          via: fdd00:2800:ba00:500:ffff::102:2
" > /etc/netplan/01-netcfg.yaml
```

## Exemple
https://netplan.io/examples
