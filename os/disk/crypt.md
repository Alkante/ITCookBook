# Chiffrement de partitions

## Afficher les partitions

```bash
lsblk
```

## Enlever un _device-mapper_ (`/dev/mapper/*`)

```bash
dmsetup remove /dev/mapper/sda8_crypt
```


## Chiffrer une partition

```bash
cryptsetup --verbose luksFormat --verify-passphrase /dev/sdc1
```

Saisir (deux fois) son mot de passe robuste.

Aussi :

```bash
cryptsetup luksFormat --hash=sha512 --key-size=512 /dev/sda6
```

## Monter la partition chiffrée sous le nom `crypt`

```bash
cryptsetup -v luksOpen /dev/sdc1 crypt
```

Saisir son mot de passe robuste.

### Afficher le point de mapping

```bash
ls /dev/mapper/crypt
```

### Utiliser le /dev/mapper/crypt comme une unique partition MBR ou GPT

Elle s'utilise comme une partition unique et non comme un nouveau disque.

Elle ne peut pas contenir plusieurs partions primaire et/ou logique, mais il est possible d'utiliser le LVM pour faire plusieur partitions logiques.

```bash
pvcreate /dev/mapper/crypt # Pour créer une lvm
```
ou
```bash
mkfs -t ext4 /dev/mapper/crypt # Pour formater en une partition ext4.
```

### Exemple

```bash
cryptsetup --cipher aes-xts-plain64 --key-size 512 --hash sha256 --iter-time 2000 --use-random --verify-passphrase luksFormat /dev/sda2
```

## Démonter la partition chiffrée sous le nom `crypt`

```bash
cryptsetup -v luksClose crypt
```

## Ajouter/Supprimer une clé d'une partition chiffrée

Voir les clés existantes :
```bash
cryptsetup luksDump /dev/sdb2
```

Ajouter la clé sur un emplacement vide :
```bash
cryptsetup luksAddKey --key-slot 1 /dev/sdb2
```

Retirer une clé :
```bash
cryptsetup luksRemoveKey /dev/sdb2
```

## Déverrouiller automatiquement un disque avec fstab

### Créer la partition chiffrée (sda1 dans l'exemple)
```bash
fdisk /dev/sda  
#(n, p, w) (new partition, type primary, default, default, default, write)
partprobe
cryptsetup luksFormat /dev/sda1
cryptsetup luksOpen /dev/sda1 data
mkfs.ext4 /dev/mapper/data
```

### Ajout dans fstab (avec montage sur /data)
```bash
echo "/dev/mapper/data /data   ext4    defaults   0    0" >> /etc/fstab
dd if=/dev/random bs=32 count=1 of=/root/lukskey
cryptsetup luksAddKey /dev/sda1 /root/lukskey
echo "data /dev/sda1 /root/lukskey" >> /etc/crypttab
```

Au prochain démarrage /data sera monté automatiquement et pas besoin de rentrer le mot de passe
