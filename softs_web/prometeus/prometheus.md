# Prometeus


## Contexte

Time series multi dimentional real time database

Each timeseries as
- a metri name (ASCII adn digit)
- labels as key-value. Each label and combinaison of label is a dimention

Notation is same as OpenTSDB and like:  ```metric name>{<label name>=<label value>, ...}```
Exemple: ```api_http_requests_total{method="POST", handler="/messages"}```


CAUTION: Remember that every unique combination of key-value label pairs represents a new time series, which can dramatically increase the amount of data stored. Do not use labels to store dimensions with high cardinality (many different label values), such as user IDs, email addresses, or other unbounded sets of values.

### metric type
- Counter
- Gauge (simple value)
- Historgram
- Summary

## Links

- Doc install with docher: https://prometheus.io/docs/prometheus/latest/installation/
- First tutorial : https://prometheus.io/docs/introduction/first_steps/
- List of exporter: https://prometheus.io/docs/instrumenting/exporters/

## Install

```bash
docker-compose up
```

docker exec -it prometheus /bin/sh

For debug in one shot ```docker-compose run  --entrypoint /bin/sh prometheus```

Connect ```docker exec --user 0 -w / -it prometheus /bin/sh```

## Configuration

The configuration can reload conf at runtime


```bash
sudo chown -R nobody:nogroup config
sudo chmod 755 config
sudo chmod -R 644 config/prometheus.yml
```

Go on http://localhost:9090

Cofiguration explication:
- global:
- rule_files:
   - Rule are file used to generate new timeseries. These rule are checked periodicaly (global.evaluation_interval)

- scrape_configs: Describe ressource (Ex: exapmle.com/api) to monitor





## UI

Ui description:
- Menu -> Alerts:
  - Display list on Inactive, Pending and Firing alerts
- Menu -> Graph
  - Interface of query with graph or console result
- Menu -> Status -> Runtime & Build Information:
  - Many generale info
- Menu -> Status -> Comand-Line Flags
  - Command line variable info
- Menu -> Status -> Configuration
  - Actual yml conf
- Menu -> Status -> Rules
  - Lists of server to monitor
- Menu -> Status -> Targets
  - Lists of endpoint provide by Prometheus
- Menu -> Status -> Service Discovery


## Exporter

### Node exporter
- src: https://github.com/prometheus/node_exporter

```
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar xvf node_exporter-0.18.1.linux-amd64.tar.gz
rm node_exporter-0.18.1.linux-amd64.tar.gz
cd node_exporter-0.18.1.linux-amd64
./node_exporter
```
###In UI
Query `node_cpu_core_throttles_total{instance="192.168.0.48:9100"}`

http://localhost:9100/metrics

ou

curl -s "localhost:9100/metrics"

## API

Reload configuration (Ex: after adding exporter): ```curl -X POST http://localhost:9090/-/reload```


node_cpu_seconds_total{instance="localhost:9100″}
