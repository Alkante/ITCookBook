# Tools guest XenServer / XCP-NG

Pour lire l'UUID de la VM depuis l'OS de la VM :

```bash
xenstore-read vm
```

Voir toutes les variables récupérables (fonctionne avec les guest tools XCP-NG mais pas ceux de Citrix ?) :

```bash
xenstore-ls
```