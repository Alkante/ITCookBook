
# Git

## Overview

```raw
SERVEUR                   
+-----------------------+     +-----------------------+         +-----------------+     +---------------+
|                       | IP  |                       |         |                 |     | Répertoire de |
| repo distant          |     |  Repo local           |         | Zone de transit |     | travail       |
| - myprojet            --pull->  new_copie_myproject --checkout(fetch)----------------->               |
|   (.git --bare)       <-push--       (.git)         <-commit---      (.git)     <-add--      (./*)    |
|                       |     |                       |         |                 |     |               |
+-----------------------+     +-----------------------+         +-----------------+     +---------------+
```


## Configuration
Configuration gobal du client git
```bash
git config --global user.name "myuser"
git config --global user.email "myuser@exemple.com"
git config --global core.editor "vim"
```

## Création d'un projet en local puis sur le serveur
Initialisation en local

```bash
mkdir myproject
cd automation-scripts-software
git init
```
Faire un premier commit

```bash
touch README
git add README
git commit -m 'first commit'
```

Initialisation du projet sur le serveur et premier push
```bash
git remote add origin git@gitlab.exemple.com:root/automation-scripts-software.git
git push -u origin master
```

## Création d'un projet sur le serveur puis en local

Création du projet sur le serveur

cd existing_git_repo
git remote add origin git@gitlab.exemple.com:root/swordarmor.fr.git
git push -u origin master



## Cloner
Clonnage d'un projet existant
```bash
git clone ssh://git@git.mydomain.com/user/myproject.git
```

## diff
### show diff entre la branche locale(master) et le remote(origin/master)
```bash
git diff master origin/master
```


### Les branches


### Lister des tags disponible sur cette branch
```bash
git tag
```

### Liste les tags disponibles avec filtre
```bash
git tag -l "4.*"
```

### Jumper sur un tag
Il n'est pas vraiement possible d'aller sur un tag puis commit pas dessus.
```bash
git checkout tags/oneBranch -b
```

Pour pouvoir commiter, il vous faudra créer une branch
```bash
git checkout -b newBranch
```

La bonne pratique est de jumper sur un tag en créant une branch en même temps
```bash
git checkout tags/oneBranch -b newBranch
```

### Liste les logs du plus dernière vers l'ancien par rapport à la possition courante
```bash
git log
```
ou seulement le dernier log
```bash
git log -n 1
```

### Affiche le dernier log par rapport à la position courante
Cette commande donne le dernier log avec des info sur les modification
```bash
git show
```

### Affiche le log d'un tag
```bash
git rev-list -n 1 myTag
```

### Voir information sur un tag
```bash
git show myTag
```

### Voir les commit attaché à chaque tag
```bash
git --show-ref --tags
```


### Afficher les branch et identifier dans laquelle on est
```bash
git branch
```

### Voir toutes les branches en locales et sur le serveur (remotes)
```bash
git branch -a
```

### Voir toutes les branches sur le serveur (remotes)
```bash
git branch -r
```

### copier une branche branchX d'un repoA vers un repoB:
ajout du nouveau repo distant:
```
git remote add origin2 git@git.exemple.com:app/repoB.git
```
on se place sur la branche à copier:
```
git checkout branchX
```
on pousse vers le nouveau repo:
```
git commit -m "commit to copy branch"
git push origin2 branchX
```

### Master IT: Liste des logs
```bash
git log --graph --oneline --decorate --all
```

## export
### archive
copie du repo distant et extraction dans le dossier courant
```bash
git archive --format tar --remote=git@git.exemple.com:entreprise/AdminCmd.git master | tar -xv
```

## purge
si des gros fichiers ont été poussés par erreur sur le repo, ménage!
### sur le client
http://dalibornasevic.com/posts/2-permanently-remove-files-and-folders-from-a-git-repository
```bash
git filter-branch -f --tree-filter 'git rm --ignore-unmatch ./soft/puppet/exemples.tar.gz' HEAD
git push origin master --force
rm -rf .git/refs/original/
git for-each-ref --format='delete %(refname)' refs/original
```
To dereference, expire reflog (which by default is 90 days) and force garbage collect, you can do:
```bash
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now
```
You'll need to make sure all branches and tags are pushed to remote (unless you're pushing to a new repo).
```bash
git push origin --force --all
git push origin --force --tags
```
### sur le serveur
```bash
cd /var/opt/gitlab/git-data/repositories/entreprise/ITCookBook.git
git reflog expire --expire=now --all
git gc --prune=now
git gc --aggressive --prune=now
```

# push without clone
uploader un fichier sur gitlab via git, car http limite la taille de l'upload:
```
git init
git checkout -b localpatch
git remote add patch https://gitlab.app1.com/cpentreprise/app.git
git add .
git commit -m "commit message"
git push patch localpatch
```
merger via http gitlab

## Fichier binaire/large -> git lfs
Git lfs (Large File Storage) permet de stocker des fichiers sans diff
### Installation
```bash
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
apt install git-lfs
```
#### Debian stretch
```bash
curl -L "https://packagecloud.io/github/git-lfs/gpgkey" 2> /dev/null | apt-key add -
echo "deb https://packagecloud.io/github/git-lfs/debian/ stretch main" > /etc/apt/sources.list.d/git-lfs.list
apt update
apt install git-lfs
```
#### Ubuntu xenial
```bash
curl -L "https://packagecloud.io/github/git-lfs/gpgkey" 2> /dev/null | apt-key add -
echo "deb https://packagecloud.io/github/git-lfs/ubuntu/ xenial main" > /etc/apt/sources.list.d/git-lfs.list
apt update
apt install git-lfs
```
#### Ubuntu bionic
```bash
curl -L "https://packagecloud.io/github/git-lfs/gpgkey" 2> /dev/null | apt-key add -
echo "deb https://packagecloud.io/github/git-lfs/ubuntu/ bionic main" > /etc/apt/sources.list.d/git-lfs.list
apt update
apt install git-lfs
```
### Utilisation
Dans le projet :
```bash
cd projet1
git lfs install
```

Lister les fichiers :
```bash
git lfs track *.tar.gz
git lfs track *.db
git lfs track *.png
```
Ajouter le fichier gitattributes (liste des fichiers lfs)
```bash
git add .gitattributes
```

Visualisation :
```bash
git lfs status
git lfs ls-files
```
Après vous pouvez utiliser normalement git.

### Mirror
Le mirror gitlab ne fonctionne pas avec lfs, il faut repush sur le mirror:
```bash
git clone http://git.exemple.com/admin/projet1.git
cd  projet1
git checkout develop
git remote set-url origin https://git.exemple.com/admin/projet1.git
git lfs fetch --all http://git.exemple.com/admin/projet1.git
git lfs push --all origin develop
```

## Erreur
### Corompt remote
Impossible de git clone le projet app4 (push/pull fonctionne)
#### Résolution
Récupération d'un projet existant (pnom2), résoudre les refs (impossible de le faire coté serveur) puis push les nouvelles refs
```
cp -r /mnt/share1/pnom2/app4-git/ /home/pnom/git/
cd /home/pnom/git/app4-git
git status
git reset --hard HEAD
git clean -fd
git checkout origin/master
git pull
git clean -fd
git log --all --graph --decorate --oneline
git remote -v
git remote set-url origin git@git.exemple.com:pnom/app4_test.git
git remote -v
git gc --aggressive
git repack -a -d --window-memory 10m --max-pack-size 20m
git push --mirror
cd ../
git clone git@git.exemple.com:pnom/app4_test.git
```
Dans gitlab
- renommer le projet app4/app4 en app4/app4_bad
- renommer le projet pnom/app4_test en app4/app4
- remettre les membres du app4/app4_bad dans app4/app4
-

Récupération du wiki:
```
git clone git@git.exemple.com:app4/app4_bad.wiki.git
git remote set-url origin git@git.exemple.com:app4/app4.wiki.git
git push --mirror
```
```
cd app4-git
git remote set-url origin git@git.exemple.com:app/app4.git
git push --force --all
```

### FSCK
Erreur style : failed to parse commit 50ae43a9f78e19a931e0e8b9aff60fdf1d0319d5 from object database for commit-graph

Récupérer le gitaly relative path sur la page admin du projet : https://git.exemple.com/admin/projects/entreprise/ngpr_app2
Exemple : Gitaly relative path: @hashed/30/88/308831041ea4863c3f87d222c31f759411898c874a9006b4bd6c745858b8f3bd.git

Lancer le build du "commit-graph" à la main
```
/opt/gitlab/embedded/bin/git -C /var/opt/gitlab/git-data/repositories/@hashed/30/88/308831041ea4863c3f87d222c31f759411898c874a9006b4bd6c745858b8f3bd.git commit-graph write
```

Ensuite le git fsck est passé à nouveau.
