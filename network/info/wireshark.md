# Wireshark
```bash
apt-get install wireshark
```

## Configurer wireshark pour une utilisation non root

```bash
dpkg-reconfigure wireshark-common
```
Select OUI

## S'ajouter en temps que membre de wireshark
```bash
adduser $USER wireshark
```

## Connexion distante
```bash
mkfifo capture.fifo
ssh root@formation.exemple.com "tcpdump -s 0 -U -n -w - -i enp2s0" >  capture.fifo
wireshark -i <(ssh root@formation.exemple.com "tcpdump -s 0 -U -n -w - -i enp2s0")
ssh root@formation.exemple.com "tcpdump -s 0 -U -n -w - -i enp2s0 not port 22" > /tmp/remote
```
