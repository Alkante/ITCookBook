
# Patch et Diff


## Création de patch

### Créer le patch d'un fichier
```bash
diff -u original.txt nex.txt > original.patch
```

### Créer le patch d'un dossier
```bash
cp -R original new
diff -rupN original/ new/ > original.patch
```
```
 -r, --recursive             : Explore aussi les sous dossiers
 -u, -U NUM, --unified[=NUM] : output NUM (default 3) lines of unified context
 -p, --show-c-function       : show which C function each change is in
 -N, --new-file              : treat absent files as empty
```




## Application de patch

### Appliquer un patch
```bash
patch < exemple.txt.patch
```
ou
```bash
patch exmple.txt < exemple.txt.patch
```

### Appliquer un patch avec un nom différent
```bash
patch exemple.txt < exemple.txt.v1.2.3.patch
```


### Appliquer un patch à un dossier
```bash
patch -p1 < soft.patch
-p1 est le niveau de profondeur ou commence la racine à patcher
```

## Désappliquer un patch
```bash
patch -p1 -R < soft.patch
```
