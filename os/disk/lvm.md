# lvm
<!-- TOC -->

- [lvm](#lvm)
    - [Contexte](#contexte)
    - [installation](#installation)
    - [PV](#pv)
        - [Scan des volumes physiques LVM](#scan-des-volumes-physiques-lvm)
        - [Liste des volumes physiques LVM](#liste-des-volumes-physiques-lvm)
        - [Création d'un volume physique LVM : !!! Attention, cette commande formate le disque](#création-dun-volume-physique-lvm---attention-cette-commande-formate-le-disque)
- [VG](#vg)
        - [Scan des groupes de volumes LVM](#scan-des-groupes-de-volumes-lvm)
        - [Liste des groupes de volumes LVM](#liste-des-groupes-de-volumes-lvm)
        - [Création d'un group de volume](#création-dun-group-de-volume)
- [LV](#lv)
        - [Scan des volumes logique LVM](#scan-des-volumes-logique-lvm)
        - [Liste des volumes logique LVM](#liste-des-volumes-logique-lvm)
        - [Création volume logique (utiliser les suffix standart: kmgtKMGT (Kilo, Mega, Giga et Tera))](#création-volume-logique-utiliser-les-suffix-standart-kmgtkmgt-kilo-mega-giga-et-tera)
        - [Renommer lvm](#renommer-lvm)
    - [LV resize](#lv-resize)
        - [Agrandir une partition logique LVM](#agrandir-une-partition-logique-lvm)
        - [augmentation disque](#augmentation-disque)
        - [reduce](#reduce)
    - [augmentation disque système pour VM xenserver 72]
    - [snapshot](#snapshot)
        - [Faire un snapshot de la LVM (même en fonctionnement)](#faire-un-snapshot-de-la-lvm-même-en-fonctionnement)
        - [Faire un snapshot de la LVM (même en fonctionnement)](#faire-un-snapshot-de-la-lvm-même-en-fonctionnement-1)
        - [Monter le disque et vérifier](#monter-le-disque-et-vérifier)
        - [Supprimer un volume logique VLM](#supprimer-un-volume-logique-vlm)
- [probleme suppression LV](#probleme-suppression-lv)
    - [enable LV](#enable-lv)
    - [pb remove](#pb-remove)

<!-- /TOC -->



## Contexte
Imbrication :
- Physical Volume
- Virtual Volume
- Logical Volume

PV->VG->LV

## installation
```bash
apt-get install lvm2
```


## PV
### Scan des volumes physiques LVM
liste des parties de disque estanmpillées LVM
```bash
pvscan
```

### Liste des volumes physiques LVM
liste des parties de disque estampillées LVM
```bash
pvdisplay
```

### Création d'un volume physique LVM : !!! Attention, cette commande formate le disque ###
```bash
pvcreate /dev/sdm
```


# VG

### Scan des groupes de volumes LVM
```bash
vgscan
```

### Liste des groupes de volumes LVM
```bash
vgdisplay
```

### Création d'un group de volume
```bash
vgcreate vg0 /dev/sdd
```


# LV

### Scan des volumes logique LVM
```bash
lvscan
```

### Liste des volumes logique LVM
```bash
lvdisplay
```

### Création volume logique (utiliser les suffix standart: kmgtKMGT (Kilo, Mega, Giga et Tera)) ###
```bash
lvcreate -L 5G -n lvm-01-root vg0
```
utilisation de 100% du VG
```bash
lvcreate -ll 100%FREE -n save vg0
lvcreate -n NAME -l 100%FREE vg0
```
### Renommer lvm
```bash
lvrename vg0  serv-06 serv-06-test
```

## LV resize

### Agrandir une partition logique LVM
+1 Go
```bash
lvextend -L+1g /dev/VGresol/new
```
new size : 400Go
```bash
lvextend -L 400Go /dev/VGresol/new
```

### augmentation disque ext3 (pas ext4)
Il faut eteindre la VM
```bash
LV="/dev/VGresol/new"
xm shutdown vmid
lvextend -L+16G $LV
# check disk
fsck.ext3 -C 0 -f -p $LV
# ext3 to ext2
tune2fs -O ^has_journal $LV
# resize ext2 file system
resize2fs -p $LV
# ext2 to ext3
tune2fs -j $LV
xm create /etc/xen/vmid.cfg
```

### reduce ext3 (pas ext4)
```bash
xm shutdown rainbow
LV="/dev/VGintrepid/rainbow-disk"
fsck.ext3 -C 0 -f -p $LV
tune2fs -O ^has_journal $LV
resize2fs -p $LV 100G
tune2fs -j $LV
lvreduce -fv -L 100G $LV
```

## augmentation disque système pour VM xenserver 72
La manip est plus simple, il suffit de shutdown la vm, puis augmenter le disque au niveau de l'interface web https://xen-orchestra.exemple.com/
Ont restart la vm puis dedans en root:
```bash
lsblk # Doit afficher le disque avec la nouvelle taille
fdisk /dev/xvda
p #List part
d #delete part système
n #nouvelle part
p #primaire
#taille min
#taille max
# si message "La partition #2 contient une signature ext3." répondre NON
p #List pour vérifier
w #ecrire et confirmer
```
Puis reboot à nouveau la VM
Au reboot :
```
resize2fs /dev/xvda2
lsblk
```

## snapshot

### Faire un snapshot de la LVM (même en fonctionnement) ###
```bash
lvcreate --snapshot -n lvm-01-root-snapshot /dev/vg0/lvm-01-root
```

### Faire un snapshot de la LVM (même en fonctionnement)
avec une condition (si la taille est différent e plus de 128Mo avec le snapshoot precedant, on annule)
```bash
lvcreate --snapshot -L128M -n lvm-01-root-snapshot /dev/vg0/lvm-01-root
```

### Monter le disque et vérifier
```bash
mount -o ro /dev/vg0/lvm-01-root-snapshot /mnt/vg0/lvm-01-root-snapshot
```

### Supprimer un volume logique VLM
```bash
lvremove /dev/vg0/lvm-01-root
```


# probleme suppression LV

## enable LV
```bash
lvchange -ay /dev/VGdata1/LVdata1
```
## pb remove
disable
```bash
lvchange -an /dev/VGdata1/LVdata1
dmsetup remove VGdata1-LVdata1
swapoff
dmsetup info -c /dev/mapper/VG001-vm1.exemple.com--swap
fuser -m /dev/mapper/VG001-vm1.exemple.com--swap
```

# backup / restore
## backup
les dom0 ont des backups quotidiens des metadata LVM (~ table de partition des LVM). Backup all (%s) VG in distinct files:
```
/sbin/vgcfgbackup -f ${DATABASES_TMP_DIR}/LVM_%s.dmp
```

## restore lvm
Restore a particular VG:
```
vgcfgrestore -f ${DATABASES_TMP_DIR}/LVM_VG002.dmp VG002
```

Voir si le lvm est bien dispo
```bash
lvs
```
