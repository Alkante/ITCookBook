# sshd Windows

## Client et serveur SSH

### Installation
- Menu -> Paramètres
  - Applications
    - Gérer les fonctionnalités facultatives
      - OpenSSH Client (Beta)
      - OpenSSH Server (Beta)

### SSH client
Utlisable avec l'invite de command (cmd) mias pas sous PowerShell

```cmd
ssh root@192.168.0.1
```

### SSH Server
Ouvrir l'interface des services
- Rechecher -> "services"

Deux nouveaux services sont disponibles:
- ssh-agent
- sshd

```cmd
cd C:\WINDOWS\system32\OpenSSH
```

Si vous lancer le service **sshd**, vous obtiendrez un erreur 1297.
Vous devez avant créer le compte **NT Service\sshd**
- Rechercher "secpol" ou Local Security Policy (seulement sous windows 10 professionnel)

Pour les windows familial




Via Power shell
```powershell
Start-Service ssh-agent
cd C:\WINDOWS\system32\OpenSSH
.\ssh-keygen -A
.\ssh-add ssh-host_ed25519_key
```

Toujour répondre Oui aux questions

Pour des raison de porblème de droit du sshd, installer le module suivant
```powershell
Install-Module -Force OpenSSHUtils
Repair-SshdHostKeyPermission -FilePath C:\Windows\System32\OpenSSH\ssh_host_ed25519_key
```
Toujour répondre Oui aux questions

```powershell
Start-Service sshd
Get-Service sshd
```


Normalement, le compte networks doit être utilisé (si vous êtes admin, utiliser votre password)


Authoriser le port 22 du firewall
```powershell
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Service sshd -Enable True -Direction Inbound -Protocol TCP -Action Allow -Profile Private
```
Private peut aussi est Domain, Public, Privé, ou Tout
