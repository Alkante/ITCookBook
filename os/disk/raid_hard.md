# Megacli

## Cas CentOS: Megacli not found
Megacli n'a pas de lien symbolique vers Megacli par défaut.
Utiliser:
```
/opt/MegaRAID/MegaCli/MegaCli64
```

## Infos générales
```
megaraidsas-status
```
détail (la commande faire crash les serveurs en XCP_ng, il faudrait test de mettre à jour le paquet megacli)
```
megacli -adpallinfo -aALL
```
ecrire journal des évènements dans evenements.log:
```
megacli -AdpEventLog -GetEvents -critical -fatal -f evenements.log -aALL
```
lister les disques:
```
megacli -pdlist -a0
```
lister les volumes raid:
```
megacli -LDGetNum -a0
```
infos disques logiques:
```
megacli -LDInfo -Lall -a0
```
afficher membres d'un volume:
```
megacli -ldpdinfo -a0
```
etat d'un volume:
```
megacli -CfgDsply -a0
```
infos batterie:
```
megacli adpbbucmd GetBbuCapacityInfo a0
megacli -AdpBbuCmd -GetBbuStatus -a0
omreport storage battery controller=0 battery=0
```

## Voir l'état SMART des disques physiques d'un RAID hard
```
smartctl -x -d megaraid,3 /dev/sdb
```
Avec :
- 3 : l'ID du disque visible avec la commande ```megacli -PDInfo -PhysDrv[32:3] -aAll |grep Device\ Id``` (en remplaçant 32:3 par le bon ID d'enclosure / de slot)
- /dev/sdb : device correspondant au disque logique qui contient le disque physique

## ajouter 2 ssd
convertir en disque "non foreign" les disques qui viennent d'être inserés:
```
megacli -CfgForeign -Clear -aALL
```
les disques sont alors reconnus comme utilisables, mais seuls (jbod):
changer "JBOD" to "non configuré":
```
megacli -PDMakeGood -PhysDrv [32:4] -Force -a0
megacli -PDMakeGood -PhysDrv [32:5] -Force -a0
```
créer volume raid1:
```
megacli -CfgLdAdd -r1 [32:4,32:5] -a0
```
afficher nb volumes
```
megacli -LDGetNum -a0
```
afficher infos volume 1
```
megacli -LDInfo -L1 -a0
```

## replace bad disk
### reconnaitre le disque
led blink:
```
megacli -PdLocate -start physdrv[32:3] -a0
```
unblink:
```
megacli -PdLocate -stop -physdrv[32:3] -a0
```

### mettre offline
le message syslog ou dmesg peut indiquer que le disque a été expulsé (offline):
```
/dev/sdb offline
```
si besoin mettre offline:
```
megacli -PDOffline -PhysDrv [32:3] -a0
megacli -PDInfo -PhysDrv [32:3] -aALL
```

### insérer nouveau disque
Normalement, la reconstruction du raid1 démarre toute seule sans action.

```
megacli -PDInfo -PhysDrv [32:3] -aALL
```

si pas détecté, rescanner le bus SCSI:
```
echo "- - -" > /sys/class/scsi_host/host0/scan
echo "- - -" > /sys/class/scsi_host/host#/scan
```
si besoin, le mettre online:
```
megacli -PDOnline -PhysDrv [32:3] -a0
```
si besoin, mettre le nouveau disque comme étant utilisable:
```
megacli -PDMakeGood -PhysDrv [32:3] -aALL
```
si besoin, convertir en JBOD:
```
megacli -PDMakeJBOD -PhysDrv [32:3] -Force -a0
```

### start rebuild
si besoin:
```
megacli -PDRbld -Start -PhysDrv [32:3] -a0
```
show progression:
```
megacli -pdrbld -showprog -physdrv[32:3] -a0
megacli -pdrbld -progdsply -physdrv[32:3] -a0
```

### remove raid1
remove L1 raid group (=id 1 = a0d1)
```
megacli -CfgLdDel -L1 -a0
```
### erreur battery
Désactivation du cache sur défaillance batterie
```bash
megacli -LDSetProp NoCachedBadBBU -L1 -a0
```

Vérification :
```bash
megacli -LDGetProp -Cache -L1 -a0
```

### Etendre un disque virtuel après avoir changé les disques par des plus grands :
```bash
megacli -LdExpansion -p100 -Lall -aAll
```
Si besoin de rescanner le périphérique côté OS :

```bash
echo 1 > /sys/block/sdb/device/rescan
```

# OMSA
Utilitaires dell

## references
http://cavepopo.hd.free.fr/wordpress/linux/how-to-create-a-raid-array-using-omconfig-omreport-cli/
http://www.dell.com/support/manuals/us/en/04/Topic/dell-opnmang-srvr-admin-v8.1/OMSA_CLI-v5/en-us/GUID-8157BF14-6C52-4693-8355-CB9DA7F2D7BE

## install
```
echo "deb ftp://ftp.sara.nl/pub/sara-omsa dell sara
deb http://linux.dell.com/repo etch dell-software" >> /etc/apt/sources.list
gpg --keyserver pgpkeys.mit.edu --recv-key E74433E25E3D7775
gpg -a --export E74433E25E3D7775| apt-key add -
apt-get update
apt-get -y install dellomsa
update-rc.d -f dataeng remove
update-rc.d -f mpt-statusd remove
```

## Commandes
cf http://support.dell.com/support/edocs/software/svradmin/5.2/en/cli/html/storage.htm

## omconfig
Omconfig chassis commands to default or to set values for current, fan, voltage, and temperature probes, to configure BIOS
### blink
```bash
omconfig storage pdisk action=blink controller=0 pdisk=0:0:3
```

### info disques physiques
```bash
omreport storage pdisk controller=0
```

### import foreign virtual disk
```bash
omconfig storage controller action=importrecoverforeignconfig controller=0
```

### control du nouveau status
```bash
omreport storage vdisk controller=0
```
