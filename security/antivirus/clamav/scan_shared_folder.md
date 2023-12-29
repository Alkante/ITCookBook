# Exemple de scan clamav
On mount les partages réseau concerné sur une machine avec du CPU (ici docker-dev)

## Sur nfs serveur
```bash
echo '
# check malware
/home/share1 vm1.exemple.com(rw,async,no_root_squash,no_subtree_check)
/home/share2 vm1.exemple.com(rw,async,no_root_squash,no_subtree_check)
/home/share3 vm1.exemple.com(rw,async,no_root_squash,no_subtree_check)
/home/share4 vm1.exemple.com(rw,async,no_root_squash,no_subtree_check)
/home/share5 vm1.exemple.com(rw,async,no_root_squash,no_subtree_check)
' >> /etc/exports
/etc/init.d/nfs-kernel-server restart
```


## Sur nfs client
```bash
mount -t nfs -o vers=3 vm12.exemple.com:/home/share1 /mnt/share1
mount -t nfs -o vers=3 vm12.exemple.com:/home/share2 /mnt/share2
mount -t nfs -o vers=3 vm12.exemple.com:/home/share3 /mnt/share3
mount -t nfs -o vers=3 vm12.exemple.com:/home/share4 /mnt/share4
mount -t nfs -o vers=3 vm12.exemple.com:/home/share5 /mnt/share5
```

## Lancement des scans
```bash
screen -R share1
clamscan -i -o -z --stdout -r /mnt/share1 > /mnt/share1.log 2>&1
screen -R share2
clamscan -i -o -z --stdout -r /mnt/share2 > /mnt/share2.log 2>&1
screen -R share3
clamscan -i -o -z --stdout -r /mnt/share3 > /mnt/share3.log 2>&1
screen -R share4
clamscan -i -o -z --stdout -r /mnt/share4 > /mnt/share4.log 2>&1
screen -R share5
clamscan -i -o -z --stdout -r /mnt/share5 > /mnt/share5.log 2>&1
```
