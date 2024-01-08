# Bacula

## File, Job, Volume Retention
- _File Retention_ : Uniquement en BDD. Enregistre le détail des fichiers sauvegardés.
    Si autoprune alors suppression des données en BDD après cette date
- _Job Retention_ : Même chose que _file retention_ mais pour les jobs
- _Volume Retention_ : Sur le disque. S'il n'y a plus de place sur le disque alors bacula supprime les volumes après cette date

# query batch bconsole

## get backups job infos for vm1-fd

```bash
echo -e "query\n5\nvm1-fd" | /usr/local/bacula/bin/bconsole
```

## get list of last backed up files from jobid = 137773

```bash
echo -e "query\n12\n137773" | /usr/local/bacula/bin/bconsole
```

# get latest files in log for a client:

```bash
cd /root/tache.cron
bash get_last_backuped_files.sh vm2
```

## Console bacula

Lancement de la console bacula :

```bash
/usr/local/bacula/bin/bconsole
```

Help :

```
*help
  Command       Description
  =======       ===========
  add           Add media to a pool
  autodisplay   Autodisplay console messages
  automount     Automount after label
  cancel        Cancel a job
  create        Create DB Pool from resource
  delete        Delete volume, pool or job
  disable       Disable a job
  enable        Enable a job
  estimate      Performs FileSet estimate, listing gives full listing
  exit          Terminate Bconsole session
  gui           Non-interactive gui mode
  help          Print help on specific command
  label         Label a tape
  list          List objects from catalog
  llist         Full or long list like list command
  messages      Display pending messages
  memory        Print current memory usage
  mount         Mount storage
  prune         Prune expired records from catalog
  purge         Purge records from catalog
  python        Python control commands
  quit          Terminate Bconsole session
  query         Query catalog
  restore       Restore files
  relabel       Relabel a tape
  release       Release storage
  reload        Reload conf file
  run           Run a job
  status        Report status
  setdebug      Sets debug level
  setip         Sets new client address -- if authorized
  show          Show resource records
  sqlquery      Use SQL to query catalog
  time          Print current time
  trace         Turn on/off trace to file
  unmount       Unmount storage
  umount        Umount - for old-time Unix guys, see unmount
  update        Update volume, pool or stats
  use           Use catalog xxx
  var           Does variable expansion
  version       Print Director version
  wait          Wait until no jobs are running

```

# Restore one line :

```bash
echo -e "restore client=vm3-fd\n5\ncd /etc\nmark shadow\ndone\nyes"  | /usr/sbin/bconsole
```


# Base MySQL
## Commandes utiles

Voir l'état des volumes :

```sql
select unique(VolStatus),count(VolStatus) from Media group by VolStatus;
```

Obtenir la liste des volumes pour un client :

```sql
select VolumeName,MediaType,VolStatus,Recycle from Media where VolumeName like 'vm4-%' limit 1500;
```

Supprimer un volume qui n'existe pas sur disque :

```sql
delete from Media where VolumeName = 'vm4-Full-1288';
```

## Etat des volumes (VolStatus)
https://www.bacula.org/5.2.x-manuals/en/main/main/Automatic_Volume_Recycling.html


+-----------+--------------------------------------------------------------------------------------------------------------+
| VolStatus | Description                                                                                                  |
+-----------+--------------------------------------------------------------------------------------------------------------+
| Full      | Volume plein (plus de place sur le storage ?)                                                                |
| Append    | Volume non plein (job count non dépassé), utilisable                                                         |
| Recycle   | Volume vide, utilisable                                                                                      |
| Read-Only | Fichier introuvable ou illisible (appartient à root au lieu de bacula ?)                                     |
| Error     | Fichier introuvable sur le storage                                                                           |
| Used      | Etat normal (volume utilisé, possiblement recyclable si champ Recycle à 1 et si durée de rétention dépassée) |
+-----------+--------------------------------------------------------------------------------------------------------------+


# Nettoyage du Catalog (base MySQL)

Bacula ne fait pas de purge globale dès que les volumes dépassent la durée de rétention, le director de fait que marquer les devices comme réutilisables et les réutilise un par un : Si il y a trop de volumes pour un client il faut obligatoirement faire du ménage à la main sur le storage ET dans la base.

Dans la base :
Récupérer l'ID (133 dans notre exemple). Vérifier l'état des volumes, vérifier qu'il n'y ait pas de souci de nom de volume / de volume en erreur / de volumes sans fichier sur disque / ...

```sql
select VolumeName,VolStatus,MediaType,StorageId from Media where VolumeName like "BackupCatalog%" ;
```

Supprimer tous les volumes d'un client sauf certains (un Filexx = un client, dans l'exemple File0 = BackupCatalog) :

```sql
delete from Media where MediaType='File0' and VolumeName not in ('BackupCatalog-Full-20614','BackupCatalog-Full-20616','BackupCatalog-Full-6274','BackupCatalog-Full-6276','BackupCatalog-Full-21665');
```

Supprimer en fonction du `VolStatus` :

```sql
delete from Media where MediaType='File0' and VolStatus='Read-Only';
```

Supprimer plusieurs volumes d'un coup :

```sql
delete from Media where VolumeName in ('BackupCatalog-Full-21286','BackupCatalog-Full-21226','BackupCatalog-Full-21230','BackupCatalog-Full-21236','BackupCatalog-Full-19418','BackupCatalog-Full-6198','BackupCatalog-Full-6204','BackupCatalog-Full-6215','BackupCatalog-Full-6228','BackupCatalog-Full-6238','BackupCatalog-Full-6246','BackupCatalog-Full-6248','BackupCatalog-Full-6255','BackupCatalog-Full-6260','BackupCatalog-Full-6261','BackupCatalog-Full-6262','BackupCatalog-Full-6263','BackupCatalog-Full-6267','BackupCatalog-Full-6269','BackupCatalog-Full-6271','BackupCatalog-Full-6272','BackupCatalog-Full-6273','BackupCatalog-Full-20528');
```

# Suppression de volumes facile - commande bacularm

Cette commande est un script en deux parties (à lancer depuis le storage):
- le director supprime l'entrée dans le catalog
- le storage supprime le fichier


# Suppression de tous les _backups_ incrémentaux en attente

```bash
for id in $(echo "status dir" | bconsole | awk '/Back Incr.*waiting/ {print $1}') ; do echo "cancel jobid=$id" ; done | bconsole
```
