# Send msg users
## Envoyer un message aux autres utilisateurs:
```bash
wall "Coupure de la vm dans 5 minutes"
```

## Ouverture d'une boîte de message à distance
Lancer les commandes suivantes via un accès ssh pour ouvrir une boîte de dialogue

```bash
export DISPLAY=:0

wish << EOT
wm title . "Question de l'administrateur"
    button .hello -text "Besoin d aide ?" -command exit
    button .reponse1 -text "Pas maintenant" -command exit
    pack .hello .reponse1
EOT
```
