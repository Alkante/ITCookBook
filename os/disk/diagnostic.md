# Diagnostic

* lsof: Show files and network connections in use.
* tcpdump: Sniff network traffic.
* iostat: Monitor IO statistics. -x option is particularly useful.
* vmstat: Monitor CPU/memory use.
* pstack: Get stack trace from a running process (for a Java process a JVM generated thread dump is usually more interesting.)
* strace: Trace systems calls.
# strace
```bash
strace -t -p `pgrep mapserv` > logstrace2 2>&1
```
# cpu
```bash
apt-get install sysstat
```
## cpu use per core
```bash
mpstat -P ALL
mpstat -P ALL 5
```
## cpu use by time
```bash
sar -u 2 5
```
## top process
```bash
ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10
```
## cpu by process
```bash
top -p `ps -C filezilla -o "pid="`
```
# disk
## pb perfs IO disques:
```bash
apt-get install atop
atop -c -d 5
pidstat -d -l 5
apt-get install blktrace
```

## fichiers ouverts par process
```bash
lsof -n | awk '{print $1}' | sort |  uniq -c | sort -rn | head
```

## bench dd
```bash
dd if=/dev/zero of=/tmp/output.img bs=8k count=128k
```
  x002 : 100Mo
  geopalqualif : 130Mo
  geopal : 200Mo
  si17 : 140Mo
  nfs cesson : 40Mo
  poste sata : 75Mo
  gigabit : 100Mo

## hdparm (test trop synthetique..)
```bash
sudo hdparm -t /dev/sda for timed buffered disk reads
sudo hdparm -T /dev/sda for timed cache reads
```

## stats disque
```bash
iostat -xtc 5 3
```

## test perf avec vidage cache
```bash
dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc
cat /proc/sys/vm/drop_caches
echo 3 > /proc/sys/vm/drop_caches
dd if=tempfile of=/dev/null bs=1M count=1024
dd if=tempfile of=/dev/null bs=1M count=1024
rm tempfile
echo 0 > /proc/sys/vm/drop_caches
```

## creation fichier avec taille de 20M
```bash
dd if=/dev/urandom of=iso.iso bs=1k count=20000 &
dd if=/dev/zero of=test.iso bs=1 count=0 seek=200M
dd if=/dev/zero of=test.img bs=1024 count=0 seek=$[1024*100]
```

## iozone
```bash
iozone -a -i 0 -i 1 -i 2  -s 200M -r 4 /dev/sdb1 |grep 204800
```

## bonnie
```bash
bonnie++ -d /home/postgres/ -r 2048 -u root
```

## seeker
```bash
wget http://www.linuxinsight.com/files/seeker.c
gcc -O2 seeker.c -o seeker
./seeker /dev/sda
```

## ioping
```bash
wget https://ioping.googlecode.com/files/ioping-0.8.tar.gz ; tar xf ioping*;cd ioping-0.8;make
./ioping -c 10 /dev/sda
```
