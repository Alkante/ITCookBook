# fdisk
<!-- TOC -->

- [fdisk](#fdisk)
  - [Commande de préutilisation de fdisk](#commande-de-préutilisation-de-fdisk)
  - [Delete /dev/sde1](#delete-devsde1)
  - [Afficher les partions](#afficher-les-partions)
          - [######### ATTENTION NOTER les numéros de block ('Start' et 'End')](#-attention-noter-les-numéros-de-block-start-et-end)
  - [Supprimer la partition (mais les données sont toujours là)](#supprimer-la-partition-mais-les-données-sont-toujours-là)
  - [Nouvelle partition primaire](#nouvelle-partition-primaire)
    - [Vérifier que c'est bon](#vérifier-que-cest-bon)
    - [Démonter tout histoire de faire quelque chose de propre](#démonter-tout-histoire-de-faire-quelque-chose-de-propre)

<!-- /TOC -->

## Commande de préutilisation de fdisk

| Commandes | Description |
|---------- |------------ |
| ```lsblk``` | Trouver le bon point de montage |
| ```umount /dev/sda2```  | Démonter la partion si besoin |
| ```e2fsck -f /dev/sda2``` |  Check la taille, les erreur et si les fichier sont contigus |
| ```resize2fs /dev/sda2 8G``` | Reduire la taille |

## Delete /dev/sde1
```bash
fdisk /dev/sde
```


## Afficher les partions

```text
# p
#Device Boot         Start         End      Blocks   Id  System
#/dev/sde1   *           1          63      506016   83  Linux
#Warning: Partition 1 does not end on cylinder boundary.                   
#/dev/sde2              63       62063   498015000   83  Linux
#Warning: Partition 2 does not end on cylinder boundary.                   
#/dev/sde3           62063       62187      996030   82  Linux swap
#Warning: Partition 3 does not end on cylinder boundary.  
```


/!\\ ATTENTION NOTER les numéros de block ('Start' et 'End')

## Supprimer la partition (mais les données sont toujours là)
```
# d
# 2              # sda2
## Afficher les partions
# p
## Appliquer les changements
# w
```



```bash
fdisk /dev/sda
```

## Nouvelle partition primaire
```
# n              # Create
# p              # Primary
# 2              # sda2
# $Start      # First cylinder (default = 1) : Des fois c'est $Start -1 (Je sais, c'est crade :/ regarder avec p si le $Start est bon sinon, quiter 'q' et relancer fdisk :| )
# +8G            # Last cylinder (partion de taille 8G en tout)
## Afficher les partions
# p
## Appliquer les changements
# w

### Forcer le redimentionnement sinon il vous dit de faire 'e2fsck -f /dev/sda2' avant qui
## lui même envera un warning car la taille théorique et physique sont différente ET C'EST NORMAL
## !!! Vérifier que le Start et End sont bon sinon ca va faire mal !!!
```

```bash
resize2fs -f /dev/sda2
```


### Vérifier que c'est bon ###
```
cd /mnt
mkdir /mnt/root
mount /dev/sda2 /mnt/root
```

### Démonter tout histoire de faire quelque chose de propre ###
```
cd /mnt
umount /mnt/root
```
