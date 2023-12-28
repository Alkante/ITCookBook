# Espace disque
ls, du, df, sparse, deleted files

## missing space
where is my space?
- df reports 18Go occupied for a 20Go total
- du -hs / reports 8Go occupied for a 20Go total

## deleted files
reboot or restart service to fix:
```
lsof -s | grep deleted
dnsmasq   20355          nobody    8w      REG              202,1 9742328374    1191298 /var/log/dnsmasq/dnsmasq.log-20180803 (deleted)
service dnsmasq restart
```

## sparse file
a sparse file is a type of computer file that attempts to use file system space more efficiently when blocks allocated to the file are mostly empty
### create a sparse file
```
truncate -s 512M file.img
```
or
```
dd if=/dev/zero of=file.img bs=1 count=0 seek=512M
```

## apparent size
Full size occupied on filesystem (as report by df)
```
du -h --apparent-size file.img
512M    file.img
```
## actual size
Size occupied by data:
```
du -h file.img
0       file.img
```

## all sizes:
size reported by du:
```
root@vm1:~# du -h /opt/zimbra/data/ldap/mdb/db/data.mdb
25M     /opt/zimbra/data/ldap/mdb/db/data.mdb
root@vm1:~# du -h --apparent-size /opt/zimbra/data/ldap/mdb/db/data.mdb
80G     /opt/zimbra/data/ldap/mdb/db/data.mdb
```
size reported by stat (= apparent)
```
stat /opt/zimbra/data/ldap/mdb/db/data.mdb
Size: 85899345920     Blocks: 51136      IO Block: 4096   regular file
```
size reported by find:
```
find /opt/zimbra/data/ldap/mdb/db/data.mdb -printf "Sparse:%S\nBytes:%s\n512blocks:%b\n1Kblocks:%k\n"
Sparse:0,000304794
Bytes:85899345920
512blocks:51136
1Kblocks:25568
```
## play with sparse files:
### copy
cp copies and detect sparse file by default
to copy force with sparse:
```
cp --sparse=always  file.img  file.img.force
du -h --apparent-size file.img.force
512M    file.img.force
du -h file.img.force
0       file.img.force
```
to copy without sparse (will copy as big file with zero, without sparse allocation):
```
cp --sparse=never file.img  file.img.nospare
du -h  file.img.nospare
512M    file.img.nospare
du -h --apparent-size  file.img.nospare
512M    file.img.force
```

### compress
by default tar does not see many zero as a sparse space:
```
tar -cvf file.img.tgz file.img
du -h file.img.tgz
513M    file.img.tgz
```
to save space when archiving:
```
tar -Scvf file.img.tgz.small file.img
du -h file.img.tgz.small
12K     file.img.tgz.small
```
