# DomU xm centos6.5
Préparation d'un domU centos dans un xen 4 (avec backend classique xm)

Principe:

Boot avec noyau (kernel,ramdisk) centos, ip statique, qui va chercher sur le r�seau (ligne extra) l'install centos:

Le kickstart indique le depot centos et les preferences d'installation

## sur le dom0:
### Création du disque
```bash
lvcreate -n vm1-disk -L 100GB VG0020
```

### Récupération des noyaux pour booter une première fois:
```bash
wget http://mirror.centos.org/centos/6.5/os/x86_64/isolinux/vmlinuz -O /boot/vmlinuz-centos6.5amd64
wget http://mirror.centos.org/centos/6.5/os/x86_64/isolinux/initrd.img -O /boot/initrd-centos6.5amd64
```
### config domU initiale
Dans /etc/xen/xen-centos6.5-amd64-install:
```bash
kernel = "/boot/vmlinuz-centos6.5amd64"
ramdisk = "/boot/initrd-centos6.5amd64"
name = "centos"
memory = "1024"
disk = [ 'phy:/dev/VG0020/vm1-disk,xvda,w' ]
vif = [ 'ip=192.168.65.2,mac=00:16:3E:3F:72:E3,vifname=vm1.0,bridge=xenbr0' ]
bootloader="/usr/bin/pygrub"
extra = "text ip=192.168.65.2 netmask=255.255.224.0 gateway=192.168.95.254 dns=192.168.0.5  ks=http://mirror.exemple.com/kickstart"
vcpus=1
on_reboot = 'destroy'
on_crash = 'destroy'
```

### fichier de réponses kickstart
A déposer sur http://mirror.exemple.com/kickstart
```bash
install
url --url http://mirror.centos.org/centos/6.5/os/x86_64
lang fr_FR.UTF-8
network --bootproto=static --ip=192.168.65.2 --netmask=255.255.224.0 --gateway=192.168.95.254 --nameserver=192.168.0.5
rootpw YYYYYY
firewall --disabled
selinux --disabled
keyboard fr-latin1
authconfig --enableshadow --enablemd5
timezone --utc Europe/Paris
bootloader --location=partition --driveorder=xvda --append="console=hvc0"
shutdown
zerombr
clearpart --all --initlabel
partition / --fstype=ext3 --size=1 --grow --asprimary --ondisk=xvda
partition swap --size=1 --maxsize=2000 --asprimary --ondisk=xvda
%packages
@core
%end
%post
%end
```


# Install
## sur le dom0
```
xm create -c /etc/xen/xen-centos6.5-amd64-install
```

## config domU
Après l'install, commenter les lignes kernel, ramdisk et extra
Ajouter la ligne pygrub
```
bootloader="/usr/bin/pygrub"
```
