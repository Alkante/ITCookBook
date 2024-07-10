# ZFS

## Intro
Ne pas utiliser de raid materiel avec (inutile)

un zpool contient 1 ou plusieurs vdev ( ~ raid de un ou plusieurs vdev)
un vdev contient plusieurs disques organisé en:
- mirror ( ~ raid1 )
- RAIDZ  ( ~ raid5 )
- RAIDZ2  ( ~ raid6 avec parité 2 disques )
- RAIDZ3  ( ~ raid avec parité 3 disques )

## références
http://bernaerts.dyndns.org/linux/75-debian/279-debian-wheezy-zfs-raidz-pool
http://www.durindel.fr/informatique/tuto-freenas-9-3-creation-du-pool
https://icesquare.com/wordpress/how-to-improve-zfs-performance
http://blog.zorinaq.com/from-32-to-2-ports-ideal-satasas-controllers-for-zfs-linux-md-ra/

## Avantages

- 128bit
- snapshot
- intégrité
- quota
- resize

## install sur Debian

Pré-requis:
```
apt-get install build-essential autoconf libtool gawk alien fakeroot gdebi linux-headers-$(uname -r)
apt-get install zlib1g-dev uuid-dev libattr1-dev libblkid-dev libselinux-dev libudev-dev libssl-dev parted lsscsi wget ksh gdebi
```
Récupération des sources:
```
cd /usr/local/src
wget https://github.com/zfsonlinux/zfs/releases/download/zfs-0.6.5.11/spl-0.6.5.11.tar.gz
wget https://github.com/zfsonlinux/zfs/releases/download/zfs-0.6.5.11/zfs-0.6.5.11.tar.gz
tar -xzf zfs-0.6.5.11.tar.gz
tar -xzf spl-0.6.5.11.tar.gz
```
Compil / install:
```
cd spl-0.6.5.11
./configure
make deb
dpkg -i *.deb

cd /usr/local/src/zfs-0.6.5.11
./configure --with-spl=/usr/src/spl-0.6.5.11
make deb
dpkg -i *.deb
cd /lib64
mv libnvpair.so* libuutil.so* libzfs_core.so* libzfs.so* libzpool.so* /lib/x86_64-linux-gnu/
modprobe zfs
```
Vérification:
```
dmesg -T | egrep 'SPL:|ZFS:'
zfs list
```

## Desinstall
```
apt-get remove --purge kmod-zfs-3.2.0-4-amd64 kmod-zfs-devel kmod-zfs-devel-3.2.0-4-amd64 zfs_0.6.5.11 libnvpair1 libuutil1 libzfs2 libzpool2 libzfs2-devel zfs-test zfs-dracut zfs-initramfs
apt-get remove --purge kmod-spl-3.2.0-4-amd64 kmod-spl-devel kmod-spl-devel-3.2.0-4-amd64 spl
cd /lib/x86_64-linux-gnu/
rm libnvpair.so* libuutil.so* libzfs_core.so* libzfs.so* libzpool.so*
rmmod zavl
rmmod zunicode
rmmod zfs
rmmod zcommon
rmmod znvpair
rmmod spl
```

## Utilisation
### pool
#### create pool
avec creation d'un premier vdev de type "mirrror" dans le pool "pool01"
```
zpool create -f pool01 mirror /dev/sdc1 /dev/sdd1
zpool status
  pool: pool01
 state: ONLINE
  scan: none requested
config:

        NAME        STATE     READ WRITE CKSUM
        pool01      ONLINE       0     0     0
          mirror-0  ONLINE       0     0     0
            sdc1    ONLINE       0     0     0
            sdd1    ONLINE       0     0     0
```
### add vdev to pool
```
zpool add pool01 mirror /dev/sdc2 /dev/sdd2
  pool: pool01
 state: ONLINE
  scan: none requested
config:

        NAME        STATE     READ WRITE CKSUM
        pool01      ONLINE       0     0     0
          mirror-0  ONLINE       0     0     0
            sdc1    ONLINE       0     0     0
            sdd1    ONLINE       0     0     0
          mirror-1  ONLINE       0     0     0
            sdc2    ONLINE       0     0     0
            sdd2    ONLINE       0     0     0
```
### delete pool
avec option force:
```bash
zpool destroy -f pool01
```

## dataset
### create
on segmente le pool en différents dataset pour leur appliquer différents réglages (notamment quota)
```bash
zfs create pool01/client01
```
### change properties
play with quota:
```bash
zfs set quota=5T pool01/client01
zfs set quota=none pool01/client01
zfs get quota pool01/client01
```
### destroy
```bash
zfs destroy pool01/client01
```

## réglages
### show pool properties
```bash
zfs get all pool01
```
### change pool properties
disable deduplication ( sinon 5Go RAM par To de stockage! )
disabled par défaut
```bash
zfs set dedup=off pool01
```
disable access time ( pas besoin pour le stockage d'un backup par exemple)
enabled par défaut
```bash
zfs set atime=off pool01
```
### autostart at boot
sur debian wheezy:
```bash
echo 'zfs' >> /etc/modules
```

### share with NFS
```bash
zfs set sharenfs=on pool01/client02
zfs set sharenfs="rw=@192.168.20.0/29,rw=@10.504.0.0/16" pool01/client02
#zfs set share="name=my-share,path=/path/on/server,prot=nfs,sec=sys,rw=*,public"pool01/client02
```
check:
```bash
zfs get sharenfs pool01/client02
NAME             PROPERTY  VALUE                                  SOURCE
pool01/client02  sharenfs  rw=@192.168.20.0/29,rw=@10.504.0.0/16  local
```

## Replace
Création de la partition (exmple ici avec sdb)
```bash
gdisk /dev/sdb
```
Statut avant :
```bash
zpool status
```
```
NAME                                         STATE     READ WRITE CKSUM
pool01                                       DEGRADED     0     0     0
  mirror-0                                   ONLINE       0     0     0
    ata-XXXXXXXXXXXXXXXX-part1               ONLINE       0     0     0
    ata-YYYYYYYYYYYYYYYY-part1               ONLINE       0     0     0
  mirror-1                                   DEGRADED     0     0     0
    ata-ZZZZZZZZZZZZZZZZ-part1               ONLINE       0     0     0
    1111111111111111111                      UNAVAIL      0     0     0  was /dev/disk/by-id/ata-WWWWWWWWWWWWWWWW-part1
```
Remplacer le disque zfs :
```bash
ls -al /dev/disk/by-id |grep sdb # get ata-VVVVVVVVVVVVVVVV-part1
zpool replace -f pool01 1111111111111111111 /dev/disk/by-id/ata-VVVVVVVVVVVVVVVV-part1
zpool status
```
```
NAME                                           STATE     READ WRITE CKSUM
pool01                                         DEGRADED     0     0     0
  mirror-0                                     ONLINE       0     0     0
    ata-XXXXXXXXXXXXXXXX-part1                 ONLINE       0     0     0
    ata-YYYYYYYYYYYYYYYY-part1                 ONLINE       0     0     0
  mirror-1                                     DEGRADED     0     0     0
    ata-ZZZZZZZZZZZZZZZZ-part1                 ONLINE       0     0     0
    replacing-1                                DEGRADED     0     0     0
      1111111111111111111                      UNAVAIL      0     0     0  was /dev/disk/by-id/ata-WWWWWWWWWWWWWWWW-part1
      ata-VVVVVVVVVVVVVVVV-part1               ONLINE       0     0     0  (resilvering)
```
