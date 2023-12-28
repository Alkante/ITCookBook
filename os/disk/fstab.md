# fstab


## Commandes outils
Afficher les montages effectué au démarage
```bash
cat /etc/fstab
```


```bash
# Nom du périphérique  point de montage du fs  type      options         dump-freq pass-num            
LABEL=/                /                       ext3      defaults        1 1
none                   /dev/pts                devpts    gid=5,mode=620  0 0
none                   /proc                   proc      defaults        0 0
none                   /dev/shm                tmpfs     defaults        0 0

# Le swap de linux
/dev/sda1              swap                    swap      defaults        0 0

```


dump-freq permet d'ajuster la programmation d'archivage de la partition (utilisé par dump)
pass-num est utilisée par l’utilitaire fsck pour déterminer dans quel ordre vérifier les partitions.


Afficher les UUID des disques
```bash
blkid
```