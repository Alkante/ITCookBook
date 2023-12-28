# Powershell

## List configuration réseau
```Powershell
ipconfig /all
```

## Exéctuter un script externe
Afficher la police d'execution
```Powershell
Get-ExecutionPolicy
```
Résultat attendu
```
Restricted
```

Changer la police de sécurité par l'une des suivantes :
- Restricted
- AllSigned
- RemoteSigned
- Unrestricted
