# jmeter

## Installation de jmeter sur une station de travail

https://jmeter.apache.org/usermanual/get-started.html
https://www.guru99.com/guide-to-install-jmeter.html

Vérifier que java est installé.

sudo apt install jmeter



## Présentation d'un exemple
### Objectif
On veut interroger une base de données de 4 méthodes différentes.
* requête sql
* requête http, réponse en GeoJSON
* requête http, réponse en CSV
* requête http, réponse en GML
(Un script php a été développer pour avoir le service web avec l'utilitaire ogr2ogr)

L'objection est de comparer les temps de réponse de ces 4 méthodes avec 3 requêtes.

### Construction du test
* La racine du projet "Plan de test" va contenir les variables
  - Le numéro de la requête sur les 3
  - la machine de la base postgres
  - la machine web (script php)
* On crée d'abord un "Groupe d'unités", ici on paramètre :
  - le nombre d'utilisateur
  - la durée de montée en charge
  - le nombre d'itérations
* A l'intérieur du "Groupe d'unités" on peut créé un "Tableau de résultats", on peut le voir comme la sortie standard de notre test. Il peut être intéressant de spécifier un fichier csv de sortie pour l’interpréter plus tard.

* A la suite on indique les paramètre de connexion a la base postgres avec template "Configuration de connexion JDBC"
  - Nom de liaison va permettre de l'utiliser dans les prochaines étape
  - Url de la base de données avec utilisation de la variable indiqué dans le "Plan de test", exemple jdbc:postgresql://${postgres}:5432/db_sigone
  - Port, user, password...
* On passe maintenant à la requête sql avec le module "Requête JDBC"
  - Indiqué le nom de la liaison spécifier précédemment
  - Votre requête SQL
* Puis la requête JSON avec le module "Requête HTTP"
  - Nom du serveur web (variable du "Plan de test")/port
  - HTTPS
  - URI de la requête http
* Puis la requête CSV avec le module "Requête HTTP"
  - Nom du serveur web (variable du "Plan de test")/port
  - HTTPS
  - URI de la requête http
* Puis la requête GML avec le module "Requête HTTP"
  - Nom du serveur web (variable du "Plan de test")/port
  - HTTPS
  - URI de la requête http
* Enfin pour comparer les résultats on va les afficher dans un graphique avec le module "Graphique évolution temps de réponses". Une fois l’exécution de votre plan de test vous pouvez "Générer le graphie" (modifier l'intervalle en fonction de vos besoin)

### Fichier exemple
Vous pouvez retrouver cet exemple dans le fichier "req_type.jmx"

## Ligne de commande
Pour des gros test, il peut être utilise de lancer jmeter sans GUI pour cela vous devez avoir au préalable créé votre fichier jmx puis :
```bash
./bin/jmeter.sh -n -t req_type.jmx
```
