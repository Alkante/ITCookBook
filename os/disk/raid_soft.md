# Raids
soft raid = soft logiciel = mdadm
<!-- TOC -->

- [Raids](#raids)
- [Description](#description)
    - [Usage](#usage)
        - [Création d'un raid](#création-dun-raid)
        - [Création d'un raid](#création-dun-raid-1)
        - [Création du raid 1](#création-du-raid-1)
        - [Chargement au démarrage](#chargement-au-démarrage)
        - [info](#info)
        - [Formatage de patition](#formatage-de-patition)
    - [Fstab](#fstab)
    - [Reconstruire un raid en live](#reconstruire-un-raid-en-live)
        - [voir le raid sans le réassembler](#voir-le-raid-sans-le-réassembler)
        - [Assembler le raid](#assembler-le-raid)
    - [Resize raid](#resize raid)

<!-- /TOC -->

# Description
Différents type de Raid:
| Type | Description |
|----- |------ |
| Raid 0 | Entrelacement |
| Raid 1 | Sauvegarde par copie |


## Usage

### Création d'un raid
Install
```
apt-get install mdadm
```
Afficher les raid existant, si il y en a.
```bash
cat /proc/mdstat
```

### Création d'un raid
Duplication du disque a froid
```bash
sudo sfdisk -d /dev/sda | sudo sfdisk /dev/sdb
```

### Création du raid 1
```bash
mdadm --create /dev/md1 --level=1 --assume-clean --raid-devices=2 /dev/sdc1 /dev/sdd1
```

### Chargement au démarrage
```bash
mdadm --daemonise /dev/md1
```
Si la commande ci-dessus renvoie un message du type :

mdadm: --daemonise does not set the mode, and so cannot be the first option.

essayez la commande suivante :

```bash
mdadm --monitor --daemonise /dev/md1
```

### info
```bash
	fdisk -l
	mdadm --detail /dev/md1
```

### Formatage de patition
```bash
	mkfs.ext4 /dev/md1
```
### suppression
```
umount /dev/md1
mdadm --stop /dev/md1
mdadm --remove /dev/md1
```
## Fstab

```bash
vim /etc/fstab
```

```text conf
/dev/md0 /mnt/md1 ext4 defaults  0 1
```

| Commandes | Description |
|---- |----- |
| ```mdadm --stop /dev/md0``` | Stop |
| ```mdadm --manage /dev/md1 --add /dev/sda2``` | Ajout membre |
| ```mdadm --assemble /dev/md0 --name=phy039:0 --update=name /dev/dm-2``` | rename metadata hostname |
| ```mdadm --examine --scan | grep "md/0"``` | ajout/verif dans conf /etc/mdadm/mdadm.conf |



## Reconstruire un raid en live

NB : lorsque qu'il n'y a pas de ficher /etc/mdadm.conf (qui est optionnel), les disques RAID logiciels autodétectés sont numérotés depuis md127 en descendant (/dev/md127, /dev/md126, etc.).

Il semble que l'absence de /etc/mdadm.conf soit une spécificité CentOS/XCP-ng.

### voir le raid sans le réassembler
```bash
mdadm -E scan
```

### Assembler le raid
```bash
mdadm --assemble --scan
```


## Changement de disque
### Status
```bash
lsblk
mdadm --detail /dev/md127
```
ou
```
cat /proc/mdstat
```

### Désactiver un disque

NB : ici nous sommes dans le cas du disque complet et non des RAID sur des partitions.

```
mdadm --manage /dev/md127 --fail /dev/sdb --remove /dev/sdb
```

### Insertion physique du nouveau disque (probablement nommé sdb)

Il est souhaitable si le disque n'est pas vierge d'avoir au préalable effacé la table de partition (disque sdX) :

DANGER : ne pas se tromper de disque.

```bash
dd if=/dev/zero of=/dev/sdX bs=512 count=1
```

### Recopie de la table de partition du disque valide (sda) vers le disque de remplacement du disque défectueux neuf (sdb)

DANGER : ne pas se tromper de disque.

```bash
sfdisk -d /dev/sda | sfdisk /dev/sdb
```

### Ajout du nouveau disque sdb au RAID /dev/md127

```bash
mdadm --manage /dev/md127 --add /dev/sdb
```

NB : lors de la synchronisation de disques GPT, le MBR est aussi synchronisé.

### Resize raid
Pour l'exemple j'ai /dev/md1 avec 2 partitions :
- sda4
- sdb4

Vérifier que le raid est en bon état :
```
cat /proc/mdstat
```

Retirer un des disques du raid et le resize :
```
mdadm /dev/md1 --fail /dev/sda4 --remove /dev/sda4
# Affiche normalement :
#mdadm: set /dev/sda4 faulty in /dev/md1
#mdadm: hot removed /dev/sda4 from /dev/md1

fdisk
d
4
n
4
#min
#max
p
w
```

Remettre le disque dans le raid et attendre que le raid soit reconstruit :
```
mdadm -a /dev/md1 /dev/sda4
```

Une fois le raid reconstruit refaire la manipulation avec sdb4, vous devriez avoir l'équivalent de ça :
```
root@backup02:~# lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
...
└─sda4    8:4    0  3,7T  0 part  
  └─md1   9:1    0   20G  0 raid1 /
sdb       8:16   0  3,7T  0 disk
...
└─sdb4    8:20   0  3,7T  0 part  
  └─md1   9:1    0   20G  0 raid1 /
```

/!\ Reboot la machine si le kernel dit ne pas pouvoir lire la table de partition, attention vous pouvez "perdre" la main sur la machine si la machine bloque au démarrage sur une question

Vérifier la taille connu :
```
mdadm -D /dev/md2 | grep -e "Array Size" -e "Dev Size"
```

Augmenter au max ou alors une taille précise (en KB):
```
mdadm --grow /dev/md2 -z max
#mdadm --grow /dev/md2 -z SIZE
```

Revérifier la taille, tout devrait être bon
