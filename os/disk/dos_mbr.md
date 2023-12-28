# mdr

<!-- TOC -->

- [mdr](#mdr)
        - [Afficher toutes les partitions (part, lvm, ...)](#afficher-toutes-les-partitions-part-lvm-)
        - [Afficher le type des partions /dev/sd*](#afficher-le-type-des-partions-devsd)
        - [Afficher le type des partions avec parted](#afficher-le-type-des-partions-avec-parted)
        - [Afficher la mémoire disponible de manière efficace](#afficher-la-mémoire-disponible-de-manière-efficace)
- [creation fichier avec taille de 20M](#creation-fichier-avec-taille-de-20m)
- [big file](#big-file)
- [montage d'une iso](#montage-dune-iso)
- [montage des cdrom](#montage-des-cdrom)
- [enlever journalisation](#enlever-journalisation)
- [resize avec fdisk](#resize-avec-fdisk)
- [remettre journalisation](#remettre-journalisation)
                    - [](#)
- [backup mbr et table partition](#backup-mbr-et-table-partition)
                    - [](#-1)
- [restore](#restore)
- [dd show progress](#dd-show-progress)
- [check fs avec progression avancement](#check-fs-avec-progression-avancement)
- [lire info partition dont inodes](#lire-info-partition-dont-inodes)
- [sfdisk](#sfdisk)
    - [on repartitionne](#on-repartitionne)
    - [partitionner le disque en LVM avec une seule partition sur tout le disque](#partitionner-le-disque-en-lvm-avec-une-seule-partition-sur-tout-le-disque)

<!-- /TOC -->







## Afficher toutes les partitions (part, lvm, ...)
```bash
lsblk
```

## Afficher le type des partions /dev/sd*
```bash
file -sL /dev/sd*
```


## Afficher le type des partions avec parted
```bash
parted print
```


## Afficher la mémoire disponible de manière efficace
```bash
df -h | grep -E 'Dispo|/$|/home$'
```


## creation fichier avec taille de 20M
```bash
dd if=/dev/urandom of=iso.iso bs=1k count=20000 &
```


## big file
```bash
dd if=/dev/zero of=test.img bs=1024 count=0 seek=$[1024*100]
```



## montage d'une iso
```bash
mount -o loop -t iso9660 fichier.iso /mnt/iso
```

## montage des cdrom
```bash
eject /media/cdromX
mount -t iso9660 -o ro,noexec,nosuid,nodev /dev/hda /media/cdrom0
mount -t iso9660 -o ro,noexec,nosuid,nodev /dev/hdc /media/cdrom1
```



## enlever journalisation
```bash
umount /dev/sda1
fsck -n /dev/sda1
tune2fs -O ^has_journal /dev/sda1
```

## resize avec fdisk
```bash
fdisk -l
e2fsck -f /dev/sda1
resize2fs /dev/sda1
```


## remettre journalisation
```bash
tune2fs -j /dev/sda1
```


# backup mbr et table partition
```bash
dd if=/dev/sda of=/home/user/mbr bs=512 count=1  
sfdisk -d /dev/sda > /home/user/part_table
```
## restore
```bash
dd if=/home/user/mbr of=/dev/sda
sfdisk /dev/hda < part_table
```

## dd show progress
```bash
kill -USR1 $(pgrep ^dd)
watch -n60 'kill -USR1 $(pgrep ^dd)'
```


## check fs avec progression avancement
```bash
fsck.ext3 -C 0 -f -p /dev/sdb6
```


## lire info partition dont inodes
```bash
tune2fs -l /dev/sda2
```


# sfdisk
## on repartitionne
6 partitions:
```bash
echo "/dev/sda1 : start= 2048, size=974848, Id= 83
/dev/sda2 : start= 976896, size=3905536, Id= 82
/dev/sda3 : start= 4882432, size=15624192, Id= 83
/dev/sda4 : start= 20506624, size=1933018544, Id= 5
/dev/sda5 : start= 20508672, size=629145600, Id=8e
/dev/sda6 : start=649656320, size=1303868848, Id=8e" | sfdisk -u S --force -q /dev/sda
```
## partitionner le disque en LVM avec une seule partition sur tout le disque
```bash
echo "2048,,8e" | sfdisk -u S -q /dev/sdc
```
en ext3
```bash
echo "2048,,83" | sfdisk -u S -q /dev/xvdf
```
