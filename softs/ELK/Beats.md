# Beats


## Contexte
Beats est un service permetant le relevé d'information.
Beats peux être vue copteur un capteur software et permet une indexation dans elasticsearch.

Par example, metricbeat monotor les données du serveur.
Il exite d'autre beats:
- Metricbeat
- Filebeat
* Winlogbeat
- Auditbeat

## Installation

### Paquet Debian

Installer les dépôts elk (cf. installation d'Elasticsearch)

Puis installer Beats
```bash
apt-get install metricbeat
```


## Utilisation
Lancer le service
```bash
service metricbeat start
```
