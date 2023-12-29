# Kibana


## Contexte




## Installation

### Paquet Debian

Installer les dépôts elk (cf. installation d'Elasticsearch)

Puis installer Kibana
```bash
apt-get install kibana
```

## Configuration
```bash
vim /etc/kibana/kibana.yml
```

Les options par défaut sont:
```conf
http.port:5601
elasticsearch.url: "http://localhost:9200"
```

Relancer le service
```bash
service kibana restart
```

## Utilisation
```bash
firefox localhost:5601
```
