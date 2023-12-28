# Tmux

<!-- TOC -->

- [Tmux](#tmux)
    - [Commandes uselles](#commandes-uselles)
    - [Help](#help)
    - [Tricks](#tricks)
        - [Lancer un terminal à distance partagé avec une boucle retour](#lancer-un-terminal-à-distance-partagé-avec-une-boucle-retour)

<!-- /TOC -->

## Commandes uselles

| Commandes | Description |
|---------- |------------ |
| ```tmux -e```            | Lancer tmux avec le support 256bit couleur |
| ```tmux list-sessions``` | lister les sesions tmux |
| ```tmux attach -d```     |attacher un terminal |
| ```tmux list-clients```     |attacher un terminal |


## Help

```
# Commandes de bases (CTRL-B Before)
# Tabs: c, n,p
#
# c : Créer un nouveau terminal dans la session tmux active
# n : Switcher entre les différents terminaux de la session
# X : Choisir un terminal spécifique (ou X est le numéro du terminal)
# d : Se détacher de la session tmux
# , : Permet de renommer un terminal
# w : Affiche la liste des terminaux disponibles
# t : Afficher l’heure dans un terminal

# Commandes dans un Split (tapez CTRL + b avant)
# Windows: ",% ,o
#
# «  : Split vertical du terminal courant en deux + ouverture d’un terminal dans le nouveau panel
# % : Split horizontal du terminal courant en deux + ouverture d’un terminal dans le nouveau panel
# o : Switcher entre les terminaux splittés
# espace : Changer l’organisation visuelle des terminaux splittés
# Alt + (flèches directionnelles) : Reduire, agrandir fenêtre du split
# ! : Convertir un split en terminal seul
# q : Afficher les numéros des terminaux splittés
# :join : permet de joindre un terminal seul sans un split
# Exemple pour rajouter le terminal numéro 3 verticalement et pour qu’il prenne 50% de l’espace total:
# :joinp -v -s 3.0 -p 50
# -h ou -v : horizontalement ou verticalement
# -s 0.0 : terminal 0 et volet 0 (volet si écran splitté)
# -p 50 : occupation à 50% de la fenêtre

# Commandes à taper dans un terminal classique

# tmux : Créer une session
# tmux attach : Se rattacher à la dernière session utilisé
# tmux ls : Voir la liste des sessions tmux active
# tmux attach -t X : S’attacher à une sessions tmux ou X est le numéro de la session
```
