# Grafana

<!-- TOC -->

- [Grafana](#grafana)
  - [Context](#context)
  - [Links](#links)
  - [Install](#install)

<!-- /TOC -->

## Context

## Links
Docker doc : https://grafana.com/docs/grafana/latest/installation/configure-docker/
## Install

```bash
docker-compose up -d
```
http://localhost:3000  admin/admin


For debug
```bash
docker exec -it grafana /bin/sh
docker exec -it -u 0 -w / grafana /bin/sh
```


```
Menu -> Explore -> Add data source

  -> Prometeus
    - URL : http://prometheus:9090
    - Save and test
Menu -> Create -> Dashboard
  - Add panel/ new panel
    - Add Query
      - metric: node_load1
        legende CPU load 1   
```
