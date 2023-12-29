# Docker compose
## Context
Il s'agit d'un outil qui permet de lancer plusieurs docker en même temps  via un seul fichier docker-compose.yml

## Installation :
```bash
curl -L https://github.com/docker/compose/releases/download/1.25.3/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
```

## Exemple
```yml
networks:
  net-0:
    driver: bridge
    ipam:
      config:
      - gateway: 10.172.0.254
        subnet: 10.172.0.0/24
services:
  base-group_1-centos-7.3:
    build:
      context: .
      dockerfile: dockerfile/ansible-centos-7.3.Dockerfile
    environment:
      TZ: Europe/Paris
    image: ansible-centos-7.3
    networks:
      net-0:
        ipv4_address: 10.172.0.1
  base-group_1-ubuntu-xenial:
    build:
      context: .
      dockerfile: dockerfile/ansible-ubuntu-xenial.Dockerfile
    environment:
      TZ: Europe/Paris
    image: ansible-ubuntu-xenial
    networks:
      net-0:
        ipv4_address: 10.172.0.2
  base-group_2-centos-7.3:
    build:
      context: .
      dockerfile: dockerfile/ansible-centos-7.3.Dockerfile
    environment:
      TZ: Europe/Paris
    image: ansible-centos-7.3
    networks:
      net-0:
        ipv4_address: 10.172.0.3
  base-group_2-ubuntu-xenial:
    build:
      context: .
      dockerfile: dockerfile/ansible-ubuntu-xenial.Dockerfile
    environment:
      TZ: Europe/Paris
    image: ansible-ubuntu-xenial
    networks:
      net-0:
        ipv4_address: 10.172.0.4
version: '2'
```
