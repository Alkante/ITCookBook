# Xen

lister
```
xm list
```

créer
```
xm create /etc/xen/vm1.exemple.com.cfg
```
console (exit : CTRL+5(NUM) ou CTRL+])
```
xm console vm1.exemple.com
```
reboot
```
xm destroy vm1.exemple.com
xm create /etc/xen/vm1.exemple.com.cfg
```

# xm console

pour sortir d'une console virtuelle et retourner sur le host physique:
```
CTRL+5(NUM)
```
ou
```
CTRL+]
```
## lister les options de configuration possibles pour un DomU
```
xm create --help_config
```

## lister les machines démarrées
```
xm list
```

## démarrer automatiquement un domU lors du démarrage du domO
```
cd /etc/xen/auto && ln -s ../vm1.cfg
```

# Memory
## hotplug : changer les paramètres mémoire à la volée
start with 4Go at boot and eventually 12Go:
```
memory = '4096'
maxmem = '16384'
```

```bash
xm mem-set vm3.exemple.com 1536
```

# CPU
## association des cpu
```
xm vcpu-list
```
## config domU
nb cpu pour domU = vcpu
```
vcpus = 2
```
cpu pin avec cpus
```
cpus = "2,3"
```

laisser le dom0 avec tous les CPU physiques (dom0-cpu 0 dans  xend-config.sxp)
sinon bug (lié à lenny-xen?) les domU ne redémarrent pas correctement)

donner 2 virtual cpu à rainbow
```bash
xm vcpu-set rainbow 2
```

## hotplug cpu:
start with 4 cpu and keep 2 other cpu available:
```
vcpus       = '4'
maxcpus  = '6'
```
add the 2 available cpus:
```
xm vcpu-set vm4.exemple.com 6
```


# réseau
## ajout d'une seconde carte réseau

### conf dom0
dans /etc/xen/xend-config.sxp, remplacer
(network-script network-bridge) par (network-script network-multi-bridge)
et créer /etc/xen/scripts/network-multi-bridge (chmod +x)
```bash
#!/bin/sh
dir=$(dirname "$0")
"$dir/network-bridge" "$@" netdev=eth0
"$dir/network-bridge" "$@" netdev=eth1
```
```
/etc/init.d/xend restart
```

un second bridge est alors créé
```bash
brctl show
```
bridge name     bridge id               STP enabled     interfaces
eth0            8000.0013723f0868       no              peth0
                                                        vif1.0
                                                        vif3.0
eth1            8000.0013723f0869       no              peth1
                                                        vif3.1
### conf du client (config du DomU)
```bash
vif         = [
'ip=192.168.0.18,mac=00:16:3E:D5:C9:7E,bridge=eth0',
'ip=192.168.4.18,mac=00:16:3E:38:2F:09,bridge=eth1',
]
```
redémarrer le DomU pour que la seconde interface y soit détectée

###  à la volée
ajouter
```bash
xm network-attach 3 script=vif-bridge ip=192.168.4.18 mac=00:16:3E:38:2F:09 bridge=eth1
```
enlever la carte
```bash
xm network-detach 3 0
```
## enlever une carte réseau au dom0
suppression interface eth0 sur le dom0 (securité et gain IP)
```bash
ifconfig eth0
ip addr show dev eth0
ip addr flush eth0
ip addr show dev eth0
ifconfig eth0
vi /etc/network/interfaces
```

# Disk
## Augmenter l'espace disque
Sur le domU
```bash
shutdown -h now
```
Sur le dom0 (ajout de 30 go en plus)
```bash
lvextend -L +30G -n /dev/vg0/vm5.exemple.com-disk
lsblk
xl create /etc/xen/conf.d/vm5.exemple.com.cfg
```
Sur le domU
```bash
resize2fs /dev/xvda2
```

NB : l'arrêt/redémarrage du domU ne sont pas nécessaires.

## ajout à chaud second disque dur
sur le domO creation du volume
```bash
lvcreate -n vm6.exemple.com-temp -L 20,00G VG0013
```
ajout au domU vm6.exemple.com-temp
```bash
xm block-attach vm6.exemple.com phy:/dev/VG0013/vm6.exemple.com-temp xvda3 w
```

## detachement du disque
```bash
xm block-detach vm6.exemple.com xvda3
```

## extraire une des partitions d'un disque img
```bash
losetup /dev/loop0 centos.img
fdisk -u -l /dev/loop0
kpartx -av /dev/loop0
mount /dev/mapper/loop0p1 /tmp/t
```

# Pygrub

Pygrub, pour configurer un noyau domU different du dom0 (mais xenifié obligatoirement)
http://wiki.xensource.com/xenwiki/PyGrub
http://wiki.debian.org/PyGrub

## dans le domU
```bash
mkdir /boot/grub
apt-get install grub-legacy
apt-get install linux-image-amd64
update-grub
echo 'default         0
timeout         2
title           Debian GNU/Linux, kernel 3.16.0-8-amd64
root            (hd0,0)
kernel          /boot/vmlinuz-4.9.0-6-amd64 root=/dev/xvda2 ro
initrd          /boot/initrd.img-4.9.0-6-amd64'  > /boot/grub/menu.lst
shutdown -h now
```

## dans le dom0
```bash
sed -i '
/ramdisk/ s/^/#/
/kernel/ s/^/#/
/root/ s/^/#/
/ramdisk/ a\bootloader = "/usr/lib/xen-4.1/bin/pygrub"
' vm.exemple.com.cfg
```

## debug
Error: Boot loader didn't return any data!
possibles problèmes:
- https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=745419#5
  résolu en appliquant https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=745419#40 :
  cp /usr/lib/xen-4.1/bin/pygrub /usr/lib/xen-4.1/bin/pygrub.orig
  wget http://ftp.exemple.com/install/xen/pygrub.4.1.6_wheezy_mod.txt -O  /usr/lib/xen-4.1/bin/pygrub
- caractère spéciaux dans menu.lst
- hd0 ou hd0,0 non trouvé
- https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=603391
  résolu en passant de 4.1.4-3 vers 4.1.6.lts1 par apt update
- maj grub qui cassent la syntaxe:
  remplacer
  root          (hostdisk//dev/xvda2)
  par
  root          (hd0,1)
  fix : cf AdminCookBook/virtualisation/xen/script/zz-update-grub-xen


En général, les soucis viennent du fait qu'on utilise un block LVM non partitionné (/dev/xvda2 par ex), ce qui augmente le risque de bugs.
tester pygrub avec le menu.lst monté

```bash
python /usr/lib/xen-4.1/lib/python/grub/GrubConf.py grub /mnt/t/boot/grub/menu.lst
```

Ou non monté (le menu grub apparait si c'est OK):

```bash
/usr/lib/xen-4.1/bin/pygrub -i /dev/mapper/VG0012-vm3.exemple.com--disk
```

## OLD method
on boote le domU
```bash
xm create /etc/xen/vm10.exemple.com.cfg
xm console vm10.exemple.com
uname -a
```

```
Linux vm10.exemple.com 2.6.26-2-xen-amd64 #1 SMP Thu Sep 16 16:32:15 UTC 2010 x86_64 GNU/Linux

```
on verifie que les points de montage dans le domU correspondent (cat /etc/fstab) aux declarations dans la configuration du domU dans le dom0 (/etc/xen/vm10.exemple.com.cfg)
toujours dans le domU, on install le noyau etch classique

```
mkdir /boot/grub
echo '(hd0) /dev/xvda' > /boot/grub/device.map && cd /dev && mknod xvda b 202 0
echo '(hd0) /dev/sda' > /boot/grub/device.map && cd /dev && mknod sda b 202 0
echo '(hd0) /dev/sda' > /boot/grub/device.map && cd /dev && mknod sda b 8 0
grub-probe -t abstraction --device /dev/sda2 -v
update-grub
dpkg --configure -a
apt-get install grub

```
si pb install grub

```
default         0
timeout         2
title           Debian GNU/Linux 6.0
root            (hd0,0)
kernel          /boot/vmlinuz-2.6.32-5-xen-amd64 root=/dev/xvda2 ro
initrd          /boot/initrd.img-2.6.32-5-xen-amd64
title           Debian GNU/Linux 6.0 (Single-User)
root            (hd0,0)
kernel          /boot/vmlinuz-2.6.32-5-xen-amd64 root=/dev/xvda2 ro single
initrd          /boot/initrd.img-2.6.32-5-xen-amd64
apt-get install linux-image-2.6.18-6-xen-686
update-grub

```
on contrôle /boot/grub/menu.lst

à partir du dom0 on eteint le domU

```
xm shutdown vm10.exemple.com

```
on edite la config du domU (on commente l'ancien type de boot kernel et ramdisk, pour ajouter pygrub

```bash
#kernel      = '/boot/vmlinuz-2.6.26-2-xen-amd64'
#ramdisk     = '/boot/initrd.img-2.6.26-2-xen-amd64'
bootloader   = '/usr/lib/xen-3.2-1/bin/pygrub'

tjs dans la config du domU (xend-config.sxp), placer la partition de boot en premier dans la liste des devices:
                  #'phy:/dev/VGlinux19/vm11.exemple.com-swap,xvda1,w',
                  #'phy:/dev/VGlinux19/vm11.exemple.com-disk,xvda2,w',
                  'phy:/dev/VGlinux19/vm11.exemple.com-disk,xvda2,w',
                  'phy:/dev/VGlinux19/vm11.exemple.com-swap,xvda1,w',
```                  


# Miscellaneous
## Erreur après un reboot
Après un reboot de la vm impossible de xm create, erreur :
```bash
xm create /etc/xen/auto/vm13.exemple.com.cfg
Using config file "/etc/xen/auto/vm13.exemple.com.cfg".
Error: cannot release un-acquired lock
```
Solution (pas de reboot de vm):
```bash
/etc/init.d/xen restart
```

## Erreur lier à la mise à jour du kernel dans le domU
```bash
ssh root@<dom0>
ls /media/usb
# si pas vide, alors utiliser un autre dossier
mount /dev/VG0039/<domU>-disk /media/usb

chroot /media/usb
mount none -t proc /proc
mount none -t sysfs /sys
mount none -t devpts /dev/pts
export HOME=/root
export LC_ALL=C
export PS1="\e[01;31m(inChroot):\W \$ \e[00m"

ls -l /boot/
# noter les kernels

less /boot//menu.lst
# vérifier les kernels
# si «hostdisk//dev/xvda2» est présent alors :
sed -i "s|hostdisk//dev/xvda2|hd0,0|" boot/grub/menu.lst

update-grub

exit
umount /media/usb/proc /media/usb/sys/ /media/usb/dev/pts
# fin du chroot

xm create -c /etc/xen/<domU>.cfg

```

## Erreur unknon gpg key :
Installation xen failed :

```bash
I: Retrieving Release
I: Retrieving Release.gpg
I: Checking Release signature
E: Release signed by unknown key (key id EF0F382A1A7B6500)
```

solution :

```bash
xen-create-image --debootstrap-cmd="\"/usr/sbin/debootstrap --no-check-gpg\"" --verbose --config=stretch-64.conf --hostname=${domU_prod} --lvm=${LVM} --ip=${VMIP2} --netmask=${VMNET2} --swap=${SWAP} --size=${DISK} --memory=${RAM}M --pygrub
```

## Erreur pygrub [Errno 28] No space left on device
Redémarrer xend :

```bash
/etc/init.d/xen restart
```

Vider le dossier /run/xend/boot :

```bash
rm /run/xend/boot/boot*
```
