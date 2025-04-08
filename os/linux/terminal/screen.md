# Screen

<!-- TOC -->

- [Screen](#screen)
  - [Commandes usuelles](#commandes-usuelles)
  - [Ouvrir une session sur un PC vers serveur](#ouvrir-une-session-sur-un-pc-vers-serveur)
  - [Tricks](#tricks)
    - [Ouvrir un terminal distant](#ouvrir-un-terminal-distant)
      - [Terminal 1](#terminal-1)
      - [Terminal 2](#terminal-2)
  - [Autres](#autres)
    - [Command mode](#command-mode)
    - [capturer dans un fichier log:](#capturer-dans-un-fichier-log)
    - [history](#history)
    - [screen avec mauvais user](#screen-avec-mauvais-user)
    - [nettoyer le log de screen](#nettoyer-le-log-de-screen)

<!-- /TOC -->

## Commandes usuelles

| Commande | Description |
|--------- |------------ |
| ```screen -list``` | Lister les sessions ouvertes |
| ```screen -ls```   | Idem |
| ```screen -S session1``` | Création d'une session nommé session1 (necessite parfois *1)| |
| ```screen -d``` | Détacher la session courante |
| ```screen -d session1``` | Détacher la session1 (affiché 54654.session1) |
| ```screen -r session1``` | S'attacher la session1 (qui est détaché) |
| ```screen -x session1``` | S'attacher une deuxième fois sur la session 1 |
| ```exit```            | Fermer la session |
| ```screnn -wipe session1```    | Kill de la session |

**1** : Sur un pc distant, il est necessaire de  lancer ```script /dev/null``` pour pouvoir démmarer **screen**

Ouvrir un kterminal avec screen attaché sur un pc distant :
```bash
export DISPLAY=:0
echo $DISPLAY
konsole -e screen -r session1
```

## Ouvrir une session sur un PC vers serveur

Ouverture d'un term chez le dev
```
ssh root@<PC-dev>
su - <user-dev>
script /dev/null
```

Creation d'une session sur le term du dev
```
screen -S <nom-server>
ssh pnom@<nom-server>
su - root
```

On relache la session
```
ctrl A +d
```

On liste les sessions du dev
```
screen -ls
```

Côté dev :  
```
screen -ls
screen -R <nom-server>
```


## Tricks

### Ouvrir un terminal distant

#### Terminal 1

Initialiser un terminal screen
```bash
ssh root@xxx.xxx.xxx.xxx
su -l user

script /dev/null
# attention, remplacer session1 par nom de la machine
screen -S session1
```
```
ctrl-a d
```

#### Terminal 2

Ouvrir un terminale dans le bureau de la personne
```bash
ssh root@xxx.xxx.xxx.xxx
su -l user

export DISPLAY=:0
echo $DISPLAY

screen -list
screen -d session1
konsole -e screen -r session1
```


## Autres
### Command mode
```
ctrl-a :
```
:hardcopy -h buff_file

[site rackaid](http://www.rackaid.com/resources/linux-screen-tutorial-and-how-to/)

### capturer dans un fichier log:

```
ctrl-a H
```

### history
```
CTRL-A [
```
```
screen -L -m -d -S mysession
screen -S mysession -p 0 -X stuff "echo hello^M"
screen -X -S "mysession" quit
```
### screen avec mauvais user
problème screen si on a fait, en root, su - user. Initialiser avant de lancer screen:
```
script /dev/null
```

### Remonter dans l'historique
```
CTRL-a échap
```

### nettoyer le log de screen
escape les retours charriots et les codes couleurs
```bash
perl -ne 's/\x1b[[()=][;?0-9]*[0-9A-Za-z]?//g;s/\r//g;s/\007//g;print' < ETAPE5_update_app1.log > log
```
