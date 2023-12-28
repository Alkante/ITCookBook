# SATA et mode AHCI

Les connecteurs SATA avec le mode AHCI d'activé permettent de pluger ou de dépluger à chaud un disque
Le mode AHCI est à activer ou à désactiver dans le BIOS.

## Monter un disque SATA avec mode AHCI en hot plug

### Vérifier si le module linux AHCI est utilisé
```bash
lspci -k |egrep --color "ahci|$"
```


### Identifier quelque le port où est connecté le disque
#### Lister les disques déjà reconnu
```bash
cat /sys/class/scsi_disk/*/device/model
```
#### Rechercher à quoi correspond *
```bash
ls /sys/class/scsi_disk
```

```bash
pat-get install lsscsi
```
```bash
lsscsi -v
```

Permet de voir le point de montage utilisé et le hostX SATA utilisé

### Démander un scan sur un port non utilisé (appelé host)
```bash
echo "- - -" > /sys/class/scsi_host/host1/scan
```

### Vérifier l'apparition du point de montage
```bash
ls /dev |egrep sd[a-z]
```

### Monter le disque
```bash
mount /dev/sdX /media/temp
```


## Démonter un disque SATA avec mode AHCI en hot unplug

### Démonter le point de montage
```bash
umount /dev/sdX
```

### Enlever l'alimentation
```bash
echo 1 > /sys/block/sdX/device/delete
```

Le disque peut être enlever physiquement
