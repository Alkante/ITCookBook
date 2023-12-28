# cut

## Usage

| Option       | Description |
|------------- |------------ |
| -c1-5        | Permet de sélectionner les colonnes 1 à 5             |
| -c14-        | Permet de sélectionner de la colonne 14 à la dernière |
| -c1-3,14-18  | Permet de spécifier plusieurs plages de colonnes      |


## Afficher le champ 6 avec ':' comme séparateur
```bash
cut -d: -f6 /etc/passwd
```
