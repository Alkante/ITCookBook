# ELK

## Contexte

ELK est un stack comprenant:
- Beats
- Logstash
- Elasticsearch (Indexeur)
- Kibana (HTML GUI)


Example de chaine de traitement simple:

Beats -> Logstash -> Elasticsearch <- Kibana



Example de chaine de traitement étendu (Big Data):

         Redis
Beats -> Kafka -> Logstash -> Elasticsearch <- Kibana
         RabbiMQ


## Installation

Installer les éléments de la chaine de traitement :
- Elasticsearch
- Logstash
- Kibana
- metricbeats



## Utilisation

### Exemple

Télécharger un jeu de données (c'est un fichier de log apache)
```bash
wget https://logz.io/sample-data
```


Configurer Logstash
```bash
vim /etc/logstash/conf.d/apache-01.conf
```

Change XXXXXXX par le chemin du fichier log téléhcargé
```conf
input {

file {

path => "XXXXXXX"

start_position => "beginning"

sincedb_path => "/dev/null"

}

}

filter {

grok {

match => { "message" => "%{COMBINEDAPACHELOG}" }

}

date {

match => [ "timestamp" , "dd/MMM/yyyy:HH:mm:ss Z" ]

}

geoip {

source => "clientip"

}

}

output {

elasticsearch {

hosts => ["localhost:9200"]

}

}
```
chmod o+r /etc/logstash/conf.d/apache-01.conf

```bash
service logstash start
```

CDans Kibana
Management->index patern
puis ```logstash-*``` suivant
puis ```@timestamp``` -> create index
