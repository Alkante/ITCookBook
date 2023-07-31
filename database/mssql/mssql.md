# Mssql
## Explication :
- https://www.sqlshack.com/understanding-sql-server-backup-types/
- https://www.brentozar.com/archive/2012/12/backups-gone-bad-the-danger-of-differentials/

If you need to do a one-time full backup without affecting your differentials, check out copy-only backups.
Ideally you schedule the index maintenance to happen right before the full backup.

## Dump/restore
Exemple d'un dump de la prod vers la recette
### Dump:
Dans : SQL Server Management Studio
1- clic droit sur la bdd : Task-> Back up
2- Backup FULL
3- Selection du fichier de destination
4- Ok

### Restore:
1- Sur la prod activer la régle de firewall du partage samba "Partage de fichier et d'imprimantes (SMB-Entrée)"
2- Sur la recette récupération du dump : \\recette.exemple.com\PROD_SQL_BACKUP
3- Copier le votre dump dans le dosser C:\backup
Dans : SQL Server Management Studio
4- clic droit sur la bdd : Task-> Restore -> Database
5- Selction de votre fichier : Device
6- Options:
  - Overwrite the existing database (WITH REPLACE)
  - Recovery state : RESTORE WITH NORECOVERY
7- ok
8- Exécuter une commande sql : 'RESTORE DATABASE database WITH RECOVERY'
9- Sur la prod désactiver la régle de firewall du partage samba "Partage de fichier et d'imprimantes (SMB-Entrée)"
