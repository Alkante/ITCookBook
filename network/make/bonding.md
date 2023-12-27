# bonding
Agrégation de plusieurs Interfaces réseaux en une Interface logique

## Mise en place
```bash
apt-get install ifenslave
```
si les fichiers /etc/network/if-pre-up.d/ifenslave existent pas besoin de jouer avec /etc/modules ni /etc/modprobe.d/*.conf

sinon
```bash
modprobe bonding
modprobe mii
```
monitor
```bash
cat /proc/net/bonding/bond0
```
```
auto eth0
iface eth0 inet manual
auto eth1
iface eth1 inet manual
auto bond0
iface bond0 inet static
        slaves eth0 eth1
        bond-mode 802.3ad
        bond-miimon 100
        bond-downdelay 200
        bond-updelay 200
        address....
```

## phy>bond>vlan>bridge
```
auto eth0
iface eth0 inet manual
auto eth1
iface eth1 inet manual
auto bond0
iface bond0 inet manual
        slaves eth0 eth1
        bond-mode 802.3ad
        bond-miimon 100
        bond-downdelay 200
        bond-updelay 200
iface bond0.1 inet manual
auto xenbr01
iface xenbr01 inet static
        bridge_ports bond0.1
        address 192.168.0.102
        netmask 255.255.255.0
        network 192.168.0.0
        broadcast 192.168.0.255
        gateway 192.168.0.254
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0
```
