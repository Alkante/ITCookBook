# RSAT
Console d'administration des services Microsoft (Active Directory, DNS, ...)


## Installation
https://mikefrobbins.com/2018/10/03/use-powershell-to-install-the-remote-server-administration-tools-rsat-on-windows-10-version-1809/

Lancer un powershell en tant qu'admin
```powershell
Get-WindowsCapability -Name RSAT* -Online | Add-WindowsCapability -Online
```

## Consoles utiles :
https://www.windows8facile.fr/tous-les-raccourcis-console-windows-server/

Accès : windows + R (démarrer => exécuter) puis entrer le nom de la console et appuyer sur Entrée

| Console           | Description                                                          |
| ----------------- | -------------------------------------------------------------------- |
| adsiedit.msc      | Browsing LDAP dans un AD, modification d'attributs en mode LDAP      |
| gpmc.msc          | Gestion des GPO / liens GPO <=> OU                                   |
| dnsmgmt.msc       | Gestion DNS                                                          |
| dsa.msc           | Gestion utilisateurs et ordinateurs Active Directory                 |
| dssite.msc        | Gestion des sites Active Directory                                   |
