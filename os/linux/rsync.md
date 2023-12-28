# rsync


## Commande usuelle
### Standard
les trailings slash '/' sont très important
```bash
rsync source/ destination/
```

### Copie archive
copie la plus conforme en terme de droit d'utilisateur ...
```bash
rsync -az test/ save/
```

### Avec ssh
```bash
rsync -e ssh -avz root@toto.com:/ save/
```


## Options
| Options         | Description |
|---------------- |--------------- |
| -v, --verbose   | Mode verbeux |
| -a, --archive   | Équivalent à -rlptgoD |
| -z, --compress  | Compression des données lors du tranferts (puis décompressées automatiquement à l'arriver) |
| -r, --recursive | Copie récursive des dossiers |
| -l, --links     | Copie les liens symbolique comme des liens symboliques |
| -p, --perms     | Préserver les permissions |
| -g, --group     | Préserver les groupes |
| -o, --owner     | Préserver le propriétaire (Root seulemment) |
| -D,             | Équivalent à --devices --specials |
| --devices       | Préserver les fichiers appareils (Root seulemment) |
| --specials      | Préserver les fichiers spéciaux |


## Commandes avancées

### Synchro HOMEWWW_DIR vers $FILES_DEST/backup.0 avec création dans backup.O de hards links si le fichier n'a pas change dans backup.1

```bash
RSYNC_OPT="-a --links --exclude-from=${EXCLUDE}"
rsync ${RSYNC_OPT} --link-dest=${FILES_DEST}/backup.1/ ${HOMEWWW_DIR}/ ${FILES_DEST_0}
```

### Copie source vers destination avec liste de masque de fichiers et no empty dir

```bash
SSH_OPT=" -o BatchMode=yes -o ConnectTimeout=30 -i ${HOME}/.ssh/id_dsa"
RSYNC_OPT="-rcv"
RSYNC_OPTSSH="-z -e 'ssh ${SSH_OPT}'"
rsync ${RSYNC_OPT} -m --include-from=${GRH_PREFIX_FILES} "${SRC}/chemin/folder/" "${DST}/exemple/folder/"
```


### Regex masque de fichiers
```bash
rsync -av --prune-empty-dirs --include "*/"  --include="*.map" --include="*.ows" --exclude="*" /home/app1/ root@www.exemple.com:/home/app1/
```
### Include/exclude
```bash
rsync -rcvn -f'+ /*' -f'- /WEB-INF/data/data/*' -f'- /WEB-INF/data/index/index/*' app1/ root@vm1.exemple.com:/home/sites/app1/
```

### ne copier que les fichiers manquants vers la destination:
```bash
rsync --ignore-existing -av /usr/local/nagios/libexec/* /usr/lib64/nagios/plugins/
```

### gestion des doublons: ajout extension date
```bash
rsync -irc -b --suffix=".${DATE}" "${SRC}/" "${DST}/"
```

### A partir d'une liste de fichiers
```bash
rsync ${RSYNC_OPT} --files-from="rsyncPRS.log" ${RSYNC_OPTSSH} "${SRC}/" "${USER}@${SRV_DST}:${DIR_DST}/"
```

### vm1 client
```bash
rsync -avz --delete root@vm1.exemple.com::adeupa /home/vm1_backup/site/adeupa/ --password-file=/home/vm1_backup/.passwd_rsync
rsync -avz --delete root@vm1.exemple.com::crbn /home/vm1_backup/site/crbn/ --password-file=/home/vm1_backup/.passwd_rsync
rsync -avz --delete root@vm1.exemple.com::unedic /home/vm1_backup/site/unedic/ --password-file=/home/vm1_backup/.passwd_rsync
```

### Client vm1
```bash
rsync -avz --delete root@vm1.exemple.com::dde29 /home/vm1_backup/dd29/ --password-file=/home/vm1_backup/.passwd_rsync
```

### Client vm2
```bash
rsync -avz --delete root@vm2.exemple.com::gip /home/vm2_backup/gip_loire/ --password-file=/home/vm2_backup/.passwd_rsync
rsync -avz --delete root@vm2.exemple.com::tomcat /home/vm2_backup/tomcat5.5_loire/ --password-file=/home/vm2_backup/.passwd_rsync
rsync -avz --delete root@vm2.exemple.com::mdweb /home/vm2_backup/mdweb_loire/ --password-file=/home/vm2_backup/.passwd_rsync
```
