# SVN

```
 +---------------------------------+                +----------------------+
 |                                 |                |                      |
 |  SERVEUR                        |                |  Utilisateur         |
 |     - Repo svn (gestion users)  |                |                      |
 |         - Projet_1          -------checkout-------> new_copie_Projet_1  |
 |         - new_Projet_2      <-------import---------   Projet_2          |
 |         - ...                   |                |                      |
 +---------------------------------+                +----------------------+
```



## Serveur

### Création d'un repo
```
svnadmin create myrepository
```

#### Structure
myrepository
   - conf/               # Répretoire de configuration générale du repo
      - authz            # User et droit d'acces en fonction des répertoires
      - passwd           # User/Password
      - svnserver.conf   # Configuration pour authentification : [passwd|authz|SASL]
   - db/                 # Données du repo : à regarder/modifier avec svnadmin
   - format              #
   - hooks/              # Donnée du repo : à regarder/modifier avec svnadmin
   - locks/              # Donnée du repo : à regarder/modifier avec svnadmin
   - README.txt          # README




### Aide et liste des commandes
```
svn help
```

### Aide sur une commande
```
svn help checkout
```

Sous-commandes disponibles :
```
   add                                  : Ajout d'un fichier au versioning
   blame (praise, annotate, ann)
   cat
   changelist (cl)
   checkout (co)
   cleanup
   commit (ci)                          : Envoyer la nouvelle version sur le serveur (Les confilts doivent être résolus avant)
   copy (cp)
   delete (del, remove, rm)             : Supprime le fichier/dosier et enlève son versionnement
   diff (di)
   export
   help (?, h)                          : Affiche l'aide
   import
   info                                 : Affiche les informations sur de la copie locale
   list (ls)
   lock
   log                                  : Affiche la liste des commits
   merge
   mergeinfo
   mkdir                                : Créer un dossier de travail
   move (mv, rename, ren)               : Déplacer/renomer un fichier/dosier versioné
   patch
   propdel (pdel, pd)
   propedit (pedit, pe)
   propget (pget, pg)
   proplist (plist, pl)
   propset (pset, ps)
   relocate
   resolve
   resolved
   revert
   status (stat, st)                    : Affiche les informations sur l'état des fichiers (M:Modifié, A:Ajouter, ?:Non versionner, D:Déplacer)
   switch (sw)
   unlock
   update (up)
   upgrade
```


## Utilisateur


### Création d'un projet sur le server à partir d'un repertoire standard (Vide ou non) chez un utilisateur
```
svn import mon_project svn://url_ip:/path/repo/mon_projet -m "Initialisation"
```
Tout les documments contenus dans le répertoire seront inclus (versionnée) ou en local
```
svn import mon_projet file:///Path/repo/mon_projet/ -m "initial import"
```


### Informations Générales
```
svn info
```
### Inforamtions sur l'état des versions des fichiers
```
svn status
```

```
svn import           # Permet de créer un projet sur le serveur, et de créer une copie de travail à partir d'un dossier
svn checkout         # Permet de récupérer une copie de tavail d'un projet existant sur le server (A faire qu'une fois)
```
```
svn update           # MAJ la copie de travail local (si possible, sinon il faut résoudre les diffs)
svn commit -m "Comentaire" # Envoie la nouvelle version vers le server
```


### Lister les fichiers n'étant pas sous le contrôle du svn ###
```
svn status | grep ^\? | awk '{print $2}'
```

### Création d'un branche ###
```
svn copy http://svn.example.com/svn_repos/Projets_1/trunk \
svn copy http://svn.example.com//svn_repos/Projets_1/trunk \
           http://svn.example.com/svn_repos/Projets_1/branches/ma_branche \
           -m "Creating a private branch of /calc/trunk."
```

### Resoudre les conflics
```
svn update
```
### Voir ou sont les conflicts
```
svn status
    README – the original with markers
    README.mine – Notre version
    README.r5 – La version sur laquel nous avons travaillé
    README.r6 – La version sur le serveur.
```

Si README/mine et README.r5 était identique, il n'y auttai pas eu de conflit

### 2 solutions:
Travailler avec une fenetre : -> Utiliser README

Puis

	svn resolved README

Travailler avec 2 fenettre : diff entre README.mine(A changer) et README.r6

Puis

	cp README.mine README
	svn resolved README

### Add

#### Ajouter tout les fichiers non versionné '?'

	svn status |grep '?' |sed 's/^.* /svn add /' |bash
