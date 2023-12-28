# SSD
## alignement
http://tytso.livejournal.com/2009/02/20/

## Optimisation SSD
https://wiki.debian.org/SSDOptimization#Low-Latency_IO-Scheduler

## Raid 1
Le noyau ne va pas détecter de SSD (lenteur d'écriture)
```
cat /sys/block/sda/queue/rotational
```
1 pour HDD et 0 pour SSD
Pour changer cela :
```
vim /etc/rc.local
echo deadline > /sys/block/sda/queue/scheduler
echo 0 > /sys/block/sda/queue/add_random
echo 0 > /sys/block/sda/queue/rotational
exit 0
```
Dans /etc/fstab, ajouter "noatime" pour le SSD


# Test de performance :
http://wiki.linux-france.org/wiki/performance_du_stockage

```
alias flbf='sync ; sh -c "echo 3 > /proc/sys/vm/drop_caches"'
flbf ; time dd if=/dev/zero of=dd.tmp bs=1M count=1000 conv=fsync
```
40m/s HHD , 300m/s SSD
