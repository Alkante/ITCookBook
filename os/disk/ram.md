# RAM
## Liste de l'utilisation mémoire des processus
```
ps -axo pmem,pid,user,command | sort -n
```
Pourcentage de la mémoire : pid : utilisateur : command  (le dernier est le plus gourmant)
