# VM centos
## dom0
### Création du disque
```bash
lvcreate -n vm1.exemple.com -L 50GB VG0035
```

### Récupération des noyaux pour booter une premiére fois:
```bash
wget http://mirror.centos.org/centos/7/os/x86_64/isolinux/vmlinuz -O /boot/vmlinuz-centos7amd64
wget http://mirror.centos.org/centos/7/os/x86_64/isolinux/initrd.img -O /boot/initrd-centos7amd64
```
### config domU initiale
Dans /etc/xen/vm1.exemple.com:
```bash
kernel = "/boot/vmlinuz-centos7amd64"
ramdisk = "/boot/initrd-centos7amd64"
name = "vm1.exemple.com"
memory = "2048"
disk = [ 'phy:/dev/VG0035/vm1.exemple.com-disk,xvda,w' ]
vif = [ 'ip=192.168.0.55,mac=00:16:3E:D2:32:42' ]
#bootloader="/usr/lib/xen-4.4/bin/pygrub"
extra = "text ip=192.168.0.55 netmask=255.255.224.0 gateway=192.168.31.254 dns=192.168.0.5  ks=http://mirror.exemple.com/centos/7/domU.cfg"
vcpus=2
on_reboot = 'destroy'
on_crash = 'destroy'
```

### install domU
```
xl create -c /etc/xen/vm1.exemple.com.cfg
```

### pygrub domU
Après l'install, commenter les lignes kernel, ramdisk et extra
Ajouter la ligne pygrub
```
bootloader="/usr/lib/xen-4.4/bin/pygrub"
```
### run
```
xl create /etc/xen/vm1.exemple.com.cfg
```
