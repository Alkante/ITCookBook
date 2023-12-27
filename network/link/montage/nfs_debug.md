# NFS debug
Le serveur NFS fonctionne mal

Confirmation dans les logs:
```
egrep "lockd|statd" /var/log/kern.log
Feb 10 15:34:52 vm1 kernel: [2004791.189689] lockd: cannot monitor pc1
Feb 10 15:47:14 vm1 kernel: [2005531.959284] statd: server rpc.statd not responding, timed out
```
## explication
- /var/lib/nfs/sm - directory containing statd monitor list
- /var/lib/nfs/sm.bak - directory containing statd notify list

## try to fix?
- Before removing these files, you should stop the rpcbind, statd, and lockd services. Below is a list of commands to run to fix this issue on a RPM based distro.
- After running these commands, it may be best to restart your NFS server.
- In Debian and derivatives, the commands would be:
```
service nfs-kernel-server stop
service rpcbind stop
service portmap stop
service nfs-common stop
rm -rf /var/lib/nfs/sm/*
rm -rf /var/lib/nfs/sm.bak/*
service rpcbind start
service portmap start
service nfs-common start
service nfs-kernel-server start
```

`service nfs-common restart` on the client just to be sure.

Debugging nfs problems can be frustrating. I found that this helps you get more info from the logs

## nfs debug

en temps normal:
```
rpcinfo -p localhost
   program no_version protocole  no_port
    100000    2   tcp    111  portmapper
    100000    2   udp    111  portmapper
    100024    1   udp  37864  status
    100024    1   tcp  55101  status
    100021    1   udp  56191  nlockmgr
    100021    3   udp  56191  nlockmgr
    100021    4   udp  56191  nlockmgr
    100021    1   tcp  52535  nlockmgr
    100021    3   tcp  52535  nlockmgr
    100021    4   tcp  52535  nlockmgr
    100003    2   tcp   2049  nfs
    100003    3   tcp   2049  nfs
    100003    4   tcp   2049  nfs
    100003    2   udp   2049  nfs
    100003    3   udp   2049  nfs
    100003    4   udp   2049  nfs
    100005    1   udp  60172  mountd
    100005    1   tcp  56059  mountd
    100005    2   udp  60172  mountd
    100005    2   tcp  56059  mountd
    100005    3   udp  60172  mountd
    100005    3   tcp  56059  mountd
```
et
```
rpcinfo -u localhost nlockmgr
Le programme 100021 de version 1 est prêt et en attente.
rpcinfo : RPC : non concordance de programme ou de version; version basse = 1, version haute = 4Le programme 100021 de version 2 n est pas disponible.
Le programme 100021 de version 3 est prêt et en attente.
Le programme 100021 de version 4 est prêt et en attente.
```

## RPC debugging:
```bash
echo 2048 > /proc/sys/sunrpc/rpc_debug
grep . /proc/net/rpc/*/content
ls -l /proc/fs/nfsd
cat /proc/fs/nfs/exports
```
fin debug
```bash
echo 0 > /proc/sys/sunrpc/rpc_debug
```

## NFS debugging:
```bash
# turn on linux nfs debug
echo 1 > /proc/sys/sunrpc/nfs_debug
# turn off linux nfs debug
echo 0 > /proc/sys/sunrpc/nfs_debug
```
