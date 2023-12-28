# Chiffrement disque sur windows : bitlocker
Par défaut il stock le clé de déchiffrement dans le materiel appelé TPM. Il se peut qu'il soit désactiver dans le BIOS

## Mot de passe au lieu de clé
Modifier la stratégie de groupe :
- Configuration ordinateur
- Modèles d'administration
- Composants Windows
- Chiffrement de lecteur BitLocker
- Lecteurs du système d'exploitation
- Exiger une authentification supplémentaire au démarrage : Activé
- Autoriser les codes confidentiels améliorés au démarrage
- Configurer l'utilisation des mots de passe pour les lecteurs du système d'exploitation
Passage du clavier en qwerty puis en powershell :
```
PS C:\Windows\system32> .\manage-bde.exe -protectors -get c:
PS C:\Windows\system32> .\manage-bde.exe -protectors -delete c: -type password
PS C:\Windows\system32> .\manage-bde.exe -protectors -add c: -password
````
