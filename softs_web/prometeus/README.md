# Prometeus with grafana

## Context
This projet will run:
- A node_exporter in the host to monitor (locahost)
- A Prometheus server (docker)
- A Grafana server (docker)

The node_exporter is a service that will mesure many things in the host where he is installaed lie CPU load, RAM, ...
The Prometheus serveur will connect to the node_export each 15s to get mesurements.
Grafana connect to prometeus to retrive and display data.


## Configuration
Download the node_exporter

```bash
cd exporter
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar xvf node_exporter-0.18.1.linux-amd64.tar.gz
rm node_exporter-0.18.1.linux-amd64.tar.gz
cd ..
```


You only need to change the ip in ./data/prometheus/config/prometheus.yml```.

```yml
...
scrape_configs:
  ...
  - job_name: systems # Job for system monitoring (using with exporter)
    static_configs:
      - targets: ['192.168.0.48:9100'] # <- Change this ip by your host ip
  ...
```

## Run all

```bash
# Run Prometeus node_exporter on your host
./exporter/node_exporter-0.18.1.linux-amd64/node_exporter
# Run prometeus and grafana
docker-compose up -d
```

Exporter UI: http://localhost:9100
Prometheus:  http://localhost:9090
Grafana: http://localhost:3000/        # admin/admin

