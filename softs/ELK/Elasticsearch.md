# Elasticsearch



# Installation

## Paquet Debian

```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list

apt-get update
apt-get install elasticsearch
```


## Configuration
```bash
vim /etc/elasticsearch/elasticsearch.yml
```

Les options par défaut sont:
```
network.host: "localhost"
http.port:9200
```

Relancer le service
```bash
service elasticsearch restart
```
