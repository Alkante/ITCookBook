# SSH
## Génération clef ssh
```bash
ssh-keygen -t ed25519 -b 384 -C "p.nom@exemple.com"  
ssh-keygen -t rsa -b 4096 -f id_rsa_LAN -C "p.nom@exemple.com"
```

- **-t**: [ed25519,rsa1,rsa,dsa] # ed25519 est à privilégier. rsa1 correspond à la version 1 de ssh (à éviter utiliser), rsa et dsa correspondent à la version 2 (OK)
- **-b N**: # Longueur de la clef. 256, 384 ou 521 bits pour ed25519. Pour RSA, 2^n (4096 ou 8192). Les clés inférieures à 4096 sont à bannir.
- **-f nom_fichier**: Fichier de sortie (par défaut id_ed25519, id_ed25519.pub, id_rsa, id-rsa.pub et id_sda,id_dsa.pub)
- **-C commentaire**: Commentaire pour identifier le propriétaire de la clef. Il est recomendé de prendre nom_utilisateur@nom_machine_avec_domain.

## Afficher la fingerprint d'une clef publique

```bash
ssh-keygen -lf ~/.ssh/id_rsa.pub
ssh-keygen -l -E sha256 -f ~/.ssh/id_rsa.pub
ssh-keygen -l -E sha1 -f ~/.ssh/id_rsa.pub
ssh-keygen -l -E md5 -f ~/.ssh/id_rsa.pub
```

Générer un mot de passe sécure (aléatoire) de 6 caractères
```bash
pwgen -s
```
ou de 16 caractères
```bash
pwgen -s 16
```

| Description | commandes|
|-- |-- |
| Connection ssh en ignorant les erreurs du au knows_host (IP differente) | ```ssh -o StrictHostKeyChecking=no username@hostname.com``` |
| Lancer une commande avec ssh | ```ssh user@www.exemple.com 'ls -al'``` |
| Lancer une commande avec ssh et avec intéraction | ```ssh -t user@www.exemple.com 'top'``` |
| Changer le passphrase de la clef | ```ssh-keygen -p -f id_rsa``` |



## Autoriser une clef utilisateur
```bash
mkdir -p ~/.ssh  
chmod go-rwx ~/.ssh  
touch ~/.ssh/authorized_keys  
chmod go-rwx ~/.ssh/authorized_keys  
echo "publickeys_______" > ~/.shh/authorized_keys  

ssh-keygen -t ed25519 -b 384 -C nagios@exemple.com  
ssh-keygen -t ed25519 -N "" -b 384 -f /root/.ssh/id_ed25519 -C  root@exemple.com  
```

## copie vers le serveur d'id_ed25519.pub
```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub nagios@vm1.exemple.com
```

## sur le serveur
```bash
chmod go-w ~/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

/usr/bin/ssh-keygen -t ed25519 -N "" -f ${HOME}/.ssh/temporary_id_ed25519
/usr/bin/ssh-copy-id -i ${HOME}/.ssh/temporary_id_ed25519 root@${TARGET_SERVER}

#convert ppk to openssh
puttygen ccvol.ppk -O private-openssh -o ccvol
#convert openssh to putty
puttygen id_ed25519 -O private -o id_ed25519.ppk
puttygen id_rsa -o id_rsa.ppk
#convert putty public to openssh public
ssh-keygen -i -f ssh2.pub > openssh.pub
```

## générer des paires de clés pour un user
```bash
user="pnom"
ssh-keygen -t ed25519 -N "" -b 384 -f ${user} -C "${user}@${user}.exemple.com"
puttygen "${user}" -o "${user}.ppk"
puttygen -L "${user}.ppk" > "${user}.ppk.pub"
tar -czvf "sshkeys_${user}.tgz" ${user}*
rm ${user}*
```
ssh fingerprint
```bash
ssh-keygen -lf /etc/ssh/ssh_host_rsa_key.pub
```

test ssh
```bash
test_ssh()
{
cmdlog "ssh ${SSH_OPT} ${SRV_DST} \"echo -n > /dev/null 2>&1\""
}
```

## envoyer un bash à executer sur plein de serveurs
```bash
ssh root@vm1.exemple.com 'bash -s' < get_dom0_usage.sh
for i in vm2.exemple.com vm3.exemple.com vm4.exemple.com vm5.exemple.com vm6.exemple.com; do echo $i; ssh root@${i} 'bash -s' < get_dom0_usage.sh;done
```

## tunnel SSH (port 9101 du srv distant redirigé vers 19101 local via un tunnel ssh)
```bash
ssh -N -f user@vm1.exemple.com -L19101:vm2.exemple.com:9101 sleep 60
```
## tunnel SSH (port 127.0.0.1:8080 du srv distant(vm1.exemple.com) redirigé vers 19101 local via un tunnel ssh)
```bash
ssh -N -f user@vm1.exemple.com -L19101:127.0.0.1:8080
```

## mode full non-interactive (ignore errors & fingerprints changes, etc...)
```bash
SSH_OPT="-o BatchMode=yes -o PasswordAuthentication=no -o StrictHostKeyChecking=no -o CheckHostIP=no -o ConnectTimeout=30 -i ${SSH_KEY}"
```

## Tunnel

Le Tunnel SSH permet de faire passé un flux réseau de n'importe quel nature.

```bash
ssh -L 1234:localhost:22 remotehost
```

```ascii
+--------------+   +--------------+
|     You      |   |  remotehost  |
|              |   | +----------+ |
|              |   | |localhost | |
|         1234 O===O->22        | |
|              |   | +----------+ |
+--------------+   +--------------+
```

```bash
ssh -L 1234:endhost:22 remotehost
```
```ascii
+--------------+   +--------------+   +--------------+
|     You      |   |  remotehost  |   |   endhost    |
|              |   |              |   |              |
|              |   |              |   |              |
|         1234 O==================O--->22            |
|              |   |              |   |              |
+--------------+   +--------------+   +--------------+
```

```bash
ssh -R 1234:localhost:22 remotehost
```
```ascii
+--------------+   +--------------+
|    You       |   |  remotehost  |
| +----------+ |   |              |
| |localhost | |   |              |
| |       22 <-O===O 1234         |
| +----------+ |   |              |
+--------------+   +--------------+
```

```bash
ssh -R 1234:endhost:22 remotehost
```
```ascii
+--------------+   +--------------+   +--------------+
|     endhost  |   |  You         |   |  remotehost  |
|              |   |              |   |              |
|              |   |              |   |              |
|         22   <---O==================O 1234         |
|              |   |              |   |              |
+--------------+   +--------------+   +--------------+
```

Pour des raisons de sécurité, utilisé cette commande avec un autre compte si l'accès est public.
