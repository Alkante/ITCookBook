# Update-rc
## Supprimer l'exécution d'un programme au démarage
```bash
update-rc.d -f puppet remove
```

## update-rc : script au reboot et shutdown
```bash
update-rc.d shut_domUs.sh stop 10 0 6 .
update-rc.d portmap start 18 2 3 4 5 . stop 32 0 6 . stop 81 1 . start 43 S .
```
