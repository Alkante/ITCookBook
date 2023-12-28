# Installation de windows PXE

## Overview
Installation de windows sur un ordinateur en PXE via un serveur PXELINUX sous Debian 9.

## VMs utilisées:
- Debian 9 Strech
- ordinateur sans OS

## Paquet installé:
- dnsmasq
- pxelinux
- samba
- genisoimage
- wimtools
- cabextract
- syslinux
- syslinux-*

## Prérequis
- Avoir un iso de windows sur la machine Debian (J'utilise ici win10_1809.iso)

### Création d'un serveur DHCP, TFTP et configuration PXE

Ma configuration dans /etc/dnsmasq.conf

```
port=0
interface=eth1
dhcp-range=192.168.20.110,192.168.20.120,255.255.255.0
dhcp-script=/bin/echo
pxe-service=x86PC, "PXE Boot Menu", pxelinux
dhcp-boot=pxelinux.0
enable-tftp
tftp-root=/var/lib/tftpboot
```

On crée le dossier de pxe et on redémarre le service

```bash
mkdir -p /var/lib/tftpboot/pxelinux.cfg
systemctl restart dnsmasq
```

On édite le menu PXE

```bash
nano /var/lib/tftpboot/pxelinux.cfg/default
```

Contenu de mon default

```
MENU TITLE Network Boot Menu
DEFAULT menu.c32

LABEL windows10
MENU LABEL Installation Windows 10
KERNEL /memdisk
INITRD /winpe.iso
APPEND iso raw
```

### Création de winpe.iso

Il faut crée le start.cmd qui va héberger les commandes à exécuter au lancement pour l'installation de Windows

```bash
mkdir /home/win-pxe
nano /home/win-pxe/start.cmd
```

Contenu de mon start.cmd

```
@echo off

echo :: Initializing
wpeinit

echo :: Initializing network
wpeinit InitializeNetwork

echo :: Waiting for network
wpeinit WaitForNetwork
ipconfig

echo :: Connecting network share \\192.168.20.10\windows
net use I: \\192.168.20.10\windows /user:user pass || pause

echo :: Executing \\192.168.20.10\windows\setup.exe
call "I:\setup.exe "/unattend:I:\unattend.xml""
```

On monte l'iso de windows dans un répertoire et on utilise wimtools pour crée le winpe.iso

```
 mkdir /home/win10iso
 mount /chemin/iso/win10_1809.iso /home/win10iso
 mkwinpeimg --iso --windows-dir=/home/win10iso --start-script=/home/win-pxe/start.cmd /home/winpe.iso
```

### Placer les fichiers PXE

Je crée des liens symbolique, place winpe.iso et l'iso windows

```
 ln -s /usr/lib/PXELINUX/pxelinux.0 /var/lib/tftpboot/
 ln -s /usr/lib/syslinux/modules/bios/{ldlinux,menu,libcom32,libutil}.c32 /var/lib/tftpboot/
 ln -s /usr/lib/syslinux/memdisk /var/lib/tftpboot/
 cp -r /home/win10iso /var/lib/tftpboot/windows
 cp /home/winpe.iso /var/lib/tftpboot/winpe.iso
```

### Mettre en place le partage Samba

Contenu de ma configuration samba (/etc/samba/smb.conf)

```
[global]
  workgroup = WORKGROUP
  map to guest = bad user
  usershare allow guests = yes

[windows]
  browsable = true
  read only = yes
  guest ok = yes
  path = /var/lib/tftpboot/windows
```

Ne pas oublier d'activer le samba

```
systemctl restart smbd
```

### Installation de Windows depuis PXE

Je démarre mon ordinateur en PXE, il récupére une adresse depuis le DHCP, et fini par ouvrir le menu PXE, je sélectionne Windows 10.
Après le chargement windows, notre script se lance et ouvre la fenetre d'installation Windows.
