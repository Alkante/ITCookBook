# speed
## wget
500 Ko/s
```bash
wget --limit-rate=500k http://www.exemple.com/mon_fichier.gz
```

## rsync
1Mo/s
```bash
rsync --bwlimit=1024 -av root@vm1.exemple.com:/backup/mon_fichier.tar .
```

## curl
423 Ko/s
```bash
curl --limit-rate 423K
```

## scp & sftp
500Ko/s
```bash
scp -l 4000 pnom@vm2.exemple.com:/backup/mon_fichier.tar .
```
