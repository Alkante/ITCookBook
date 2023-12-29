# DomU xe jessie8
Préparation d'un domU jessie avec xenserver 7 (backend xe)

## Creation à partir du template
```bash
xe vm-install template=Other\ install\ media sr-uuid=0aca1060-d96c-bca4-50da-df869e4fc1ec new-name-label=HDP1
VMNAME="vm1.exemple.com"
VMUUID=`xe vm-install template=Debian\ Wheezy\ 7.0\ \(64-bit\) sr-uuid=0aca1060-d96c-bca4-50da-df869e4fc1ec new-name-label=$VMNAME`
```
#### Modification du disque
get VM vdi:
```bash
VDIUUID=`xe vm-disk-list vm=$VMNAME --minimal | awk -F "," '{ print $1 }'`
```
On redimensionne le VDI:
```bash
xe vdi-resize uuid=$VDIUUID disk-size=80GiB
```
On change le label du VDI:
```bash
xe vdi-param-set uuid=$VDIUUID name-description=$VMNAME-disk
```
#### Ajout du réseau:
Identification du network correspondant au bridge0
```bash
NETUUID=`xe network-list bridge=xenbr0 params=uuid --minimal`
```
Ajout de l'interface réseau
```bash
xe vif-create vm-uuid=$VMUUID network-uuid=$NETUUID mac=random device=0
```

#### modif des propriétés de la VM
on indique le repo local:
```bash
xe vm-param-set uuid=$VMUUID other-config:install-repository=http://mirror.exemple.com/ftp.fr.debian.org/debian/dists/jessie other-config:debian-release=jessie
xe vm-param-set uuid=$VMUUID memory-static-max=1024MiB memory-dynamic-max=1024MiB  memory-dynamic-min=256MiB
xe vm-param-set uuid=$VMUUID PV-args="console=hvc0 auto=true url=http://mirror.exemple.com/preseed-jessie.cfg interface=eth0 netcfg/get_hostname=vm1 netcfg/get_domain=exemple.com netcfg/disable_dhcp=true netcfg/get_ipaddress=192.168.0.94 netcfg/get_netmask=255.255.224.0 netcfg/get_gateway=192.168.31.254 netcfg/get_nameservers=192.168.0.5 debian-installer/locale=en_US console-setup/layoutcode=en console-setup/ask_detect=false"
```
on indique un boot en HVM
xe vm-param-set uuid=$VMUUID HVM-boot-policy=BIOS\ order PV-args="" PV-bootloader="" HVM-boot-params="ndc"
```bash
xe vm-param-set uuid=$VMUUID PV-args="console=ttyS0 text utf8 ip=192.168.0.75::192.168.31.254:255.255.224.0:centos7:eth0:none nameserver=192.168.0.5  modprobe.blacklist=dm_multipath,iscsi_boot_sysfs,iscsi_tcp nompath rd.multipath=0 ks=http://mirror.exemple.com/centos/7/ks.cfg rootfstype=ramfs"
```
xe vm-param-set uuid=$VMUUID HVM-boot-policy="" PV-bootloader="eliloader"

#### Préparation du kickstart:
Sur le http distant déposer le fichier suivant ks.cfg:
```bash
auth --enableshadow --passalgo=sha512
url --url="http://mirror.exemple.com/centos/7/os/x86_64"
lang fr_FR.UTF-8
network --bootproto=static --device=eth0 --ip=192.168.0.75 --netmask=255.255.224.0 --gateway=192.168.31.254 --nameserver=192.168.0.5
rootpw YYYYYY
firewall --disabled
selinux --disabled
keyboard fr-latin1
timezone --utc Europe/Paris
shutdown
#Partitioning
ignoredisk --only-use=xvda
bootloader --location=mbr --boot-drive=xvda
zerombr
clearpart --none --initlabel --drives=xvda
#autopart
partition / --fstype=ext3 --size=1 --grow --asprimary --ondisk=xvda
partition swap --size=1 --maxsize=2000 --asprimary --ondisk=xvda
#Packages
%packages
@core
%end
%post
%end
```

#### lancement de l'install
L'install est non-interactive et la VM s'éteint en fin de process
```bash
xe vm-start vm=$VMNAME &
xe console vm=$VMNAME
```

si l'install échoue, la vm repasse en mode boot pygrub au lieu du mode install. Pour pouvoir relancer l'install:
```bash
xe vm-param-set uuid=$VMUUID other-config:install-round=1
xe vm-start vm=$VMNAME
```
#### après l'install:
on repasse en boot normal pygrub
```bash
xe vm-param-set uuid=$VMUUID PV-args="console=ttyS0 text utf8"
```
