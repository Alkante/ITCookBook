# Baloo
Indexeur de KDE pour faire des recherches dans le contenu des fichiers

## Désactivation si baloo_file_extractor prend trop de CPU :

```bash
balooctl config set contentIndexing no
balooctl disable
ps aux |grep baloo
# et kill les processus 
```