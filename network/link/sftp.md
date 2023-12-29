# SFTP

First, lets create the new group:
```bash
sudo addgroup exchangefiles
```
Then create the new directories:

## Create the chroot directory
```bash
sudo mkdir /home/exchangefiles/
sudo chmod g+rx /home/exchangefiles/
```

## Create the group-writable directory
```bash
sudo mkdir -p /home/exchangefiles/files/
sudo chmod g+rwx /home/exchangefiles/files/
```

## Give them both to the new group.
```bash
sudo chgrp -R exchangefiles /home/exchangefiles/
```

## Configurer le sshd
```bash
vim /etc/ssh/sshd_config
```
```
Match Group fmii
  # Force the connection to use SFTP and chroot to the required directory.
  ForceCommand internal-sftp
  ChrootDirectory /app/rails/production/app
  # Disable tunneling, authentication agent, TCP and X11 forwarding.
  PermitTunnel no
  AllowAgentForwarding no
  AllowTcpForwarding no
  X11Forwarding no
```

## On the server:
```
sudo adduser --ingroup exchangefiles testfiles
sudo service ssh reload
```

## test on server:
```
sftp testfiles@server.example.com
ssh testfiles@server.example.com
```


## Permission
Le dossier chrooté dit être possédé par le root ET les droit d'écriture du group et other doivent être désactivé pour le dossier et ces parents.

```bash
SFTP_SRV="192.168.1.1"
SFTP_USER="sftp_user"
SFTP_KEY="${SCRIPTDIR}/sig.private"
SFTP_PORT="22"
SFTP_OPT="-q -o BatchMode=yes -o PasswordAuthentication=no -o StrictHostKeyChecking=no -o CheckHostIP=no -o ConnectTimeout=30 -i $SFTP_KEY -P $SFTP_PORT"
```

### download
```
sftp $SFTP_OPT "$SFTP_USER@$SFTP_SRV:/chemin/exemple/exemple.csv" ${SCRIPTDIR}/dest/folder/
```
download à travers une jump box (ou wallix):
```
sftp -o User=root@vm1.exemple.com:pnom wab.exemple.fr:/remote/fichier /local/fichier
```
### upload
```
sftp $SFTP_OPT "$SFTP_USER@$SFTP_SRV:/chemin/exemple/" <<< $"put ${SCRIPTDIR}/dest/folder/exemple.csv"
```
