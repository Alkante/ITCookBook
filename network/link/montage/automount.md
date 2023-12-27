# Automount (autofs)
## fast install
```bash
apt-get install autofs
```

## example with NFS and IP security:
```bash
echo '/mnt     /etc/auto.mnt   --ghost,--timeout=30' >> /etc/auto.master
echo 'share1        -fstype=nfs,exec,dev,suid,share3,rsize=8192,wsize=8192,timeo=14   share1.exemple.com:/home/share1
share2            -fstype=nfs,exec,dev,suid,share3,rsize=8192,wsize=8192,timeo=14   share2.exemple.com:/home/share2
share3            -fstype=nfs,exec,dev,suid,share3,rsize=8192,wsize=8192,timeo=14   share3.exemple.com:/home/share3' >> /etc/auto.mnt
service autofs restart
```

## additionnal autofs to sssd mounts
add personal map to main map:
```
cat /etc/auto.master
+auto.master
/mnt2     /etc/auto.perso   --ghost,--timeout=90
```

configure personnal map, (IP or kerberos mix):
```
sudo cat /etc/auto.perso
share4       -fstype=nfs4,proto=tcp,sec=krb5 mayflower.exemple.com:/home/share4
backup   -fstype=nfs,vers=3,exec,dev,suid,share3,rsize=8192,wsize=8192,timeo=14   backup.exemple.com:/backup
```
```bash
sudo service autofs restart
```
