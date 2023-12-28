# GPT

## Lister les partitions gpt/mbr
```bash
parted -l
```
Liste toutes les partitions gpt et mbr

## GPT UEFI
Le système de démarage est UEFI/EFI sur gpt.
Il est possible de créer un partion crypter puis de faire du LVM dedans

## si > 2To:
```bash
apt-get install gdisk
```
## clear mbr with gpt type:
```bash
sgdisk -og /dev/sdg
```

## get total sectors number:
```bash
ENDSECTOR=`sgdisk -E /dev/sdg`
```

## create 1st partition, filling all disk, and with name "disk2":
```bash
sgdisk -n 1:2048:$ENDSECTOR -c 1:"disk2" -t 1:8300 /dev/sdg
```

## on affiche la table:
```bash
sgdisk -p /dev/sdg
```

## create 4ème partition xen on sda
```bash
ENDSECTOR=`sgdisk -E /dev/sda`
sgdisk -n 4:87033856:$ENDSECTOR -c 4:"VG006a" -t 1:8e00 /dev/sda
```

## backup
```bash
sgdisk --backup={/path/to/file} {/dev/device/here}
```

## restore
```bash
sgdisk --load-backup={/path/to/file} {/dev/device/here}
```
