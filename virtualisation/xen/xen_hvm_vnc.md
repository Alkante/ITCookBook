# Xen : Installation de VM full virtualization (HVM)
<!-- TOC -->

- [Xen : Installation de VM full virtualization (HVM)](#xen--installation-de-vm-full-virtualization-hvm)
    - [Vérification si le processeur support la full virtualization](#vérification-si-le-processeur-support-la-full-virtualization)
    - [Création de partition logique LVM](#création-de-partition-logique-lvm)
    - [Copier l'iso sur votre machine :](#copier-liso-sur-votre-machine-)
        - [Configuration du swap :](#configuration-du-swap-)
    - [Exemple de configuration /etc/xen/auto/debian.cfg :](#exemple-de-configuration-etcxenautodebiancfg-)
    - [Création de votre VM :](#création-de-votre-vm-)
    - [Connexion via VNC :](#connexion-via-vnc-)
    - [Monter comme une partition :](#monter-comme-une-partition-)
    - [Copie de VM :](#copie-de-vm-)

<!-- /TOC -->

## Vérification si le processeur support la full virtualization
```bash
xm dmesg | egrep -i vmx
xm info | grep hvm
```
Remarque : le ```cat /proc/cpuinfo``` dans un dom0 ne remonte pas les bonnes infos

## Création de partition logique LVM
```bash
lvcreate -L [taille] -n [nom-du-lv] [nom-du-vg]
lvcreate -L 2G -n vm???.exemple.com-swap VG0018
lvcreate -L 20G -n vm???.exemple.com-disk VG0018
```

## Copier l'iso sur votre machine :
```bash
scp debian-5010-amd64-netinst.iso root@VG0018:<chemin ou rien>
```

### Configuration du swap :
```bash
mkswap /dev/VG0018/debian-swap
```

## Exemple de configuration /etc/xen/debian.cfg :
```text
name = "debian"
memory = "1024"
device_model = '/usr/lib/xen-4.1/bin/qemu-dm'
disk = [
	'phy:/dev/VG0018/debian-disk,ioemu:xvda,w',
	'phy:/dev/VG0018/debian-swap,ioemu:xvdb,w',
    'file:/tmp/debian-5010-amd64-netinst.iso,xvdd:cdrom,r'
	]
xen_platform_pci=1
pae=1
acpi=1
apic=1
vif = [ 'ip=172.16.0.52,bridge=xenbr0','ip=172.16.32.52,bridge=xenbr1' ]
vcpus=2
vfb = [ 'type=vnc,vncpasswd=bonjour,vnclisten=0.0.0.0,keymap=fr' ]
boot="dc"
sdl=0
vnc=1
vnclisten="0.0.0.0"
vncconsole=1
vncunused=1
vncpasswd='bonjour'
stdvga=0
serial='pty'
builder = "hvm"
kernel = "/usr/lib/xen-4.1/boot/hvmloader"
on_reboot = 'restart'
on_crash = 'restart'
```

/!\\ Pour le paramètre "disk", il est très important d'utilier "ioemu:xvda" pour émuler les entrées/sorties, dans le cas contraire l'installateur debian ne détectera pas vos disque dur.

Vous pouvez retrouvé les différents types à cette adresse : [http://lists.xenproject.org/archives/html/xen-users/2006-08/msg00668.html](http://lists.xenproject.org/archives/html/xen-users/2006-08/msg00668.html)

Symlinks
```
ln -s /etc/xen/debian.cfg /etc/xen/auto/
```

## Création de votre VM :
```bash
xm create /etc/xen/auto/debian.cfg
```

## Connexion via KRDC ou autre:
```bash
# Ouvrir un tunnel ssh depuis un poste admin avec interface graphique
ssh -L 5900:127.0.0.1:5900 root@phy031.exemple.com

# Se connecter sur 127.0.0.1:5900 avec le mdp bonjour
```

# Duplication de la VM

## Monter comme une partition :
```bash
partx -av /dev/VG0018/vm3-disk
```
Dans lsblk vous devriez voir un “vm3-disk1”:

```bash
mount /dev/VG0018/vm3-disk1
```

## Copie de VM :
Supprimer le fichier avec les @MAC : /etc/udev/rules.d/70-persistent-net.rules

```bash
dd if=/dev/VG0018/vm3-disk of=/dev/VG0018/vm4-disk
```
