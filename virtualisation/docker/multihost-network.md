# Mutli-host network docker
Différentes solutions :
* overlay
* weave
* calico

Selon "https://www.percona.com/blog/2016/08/03/testing-docker-multi-host-network-performance/"
* weave < overlay < calico

## Weave
Il est pour moi le plus simple à mettre en oeuvre.
### Install
```
curl -L git.io/weave -o /usr/local/bin/weave
chmod a+x /usr/local/bin/weave
```

### Run
- Premier machine
```
weave launch
```
- Autre machine
```
weave launch $IP_PREMIER_MACHINE
```

Avant de lancer un docker vous devez faire :
```
eval $(weave env)
```
weave posséde un dns, vous pouvez donc ping simplement le nom du docker distant


## Overlay
### Install
node 1 :
```
ETCD_VER=v3.1.0
DOWNLOAD_URL=https://github.com/coreos/etcd/releases/download
curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xvf etcd-v3.1.0-linux-amd64.tar.gz
cd etcd-v3.1.0-linux-amd64/
vim run.sh
```
```
nohup ./etcd -name lns-kerlink -initial-advertise-peer-urls http://192.168.32.64:2380 \
  -listen-peer-urls http://0.0.0.0:2380 \
  -listen-client-urls http://192.168.32.64:2379,http://127.0.0.1:2379 \
  -advertise-client-urls http://0.0.0.0:2379 \
  -initial-cluster-token etcd-cluster \
  -initial-cluster lns-kerlink=http://192.168.32.64:2380,vm2-kerlink=http://192.168.32.76:2380 \
  -initial-cluster-state new &
```
```
chmod a+x run.sh
./run.sh
vim /etc/default/docker
```
```
DOCKER_OPTS="--bip=192.168.254.1/24 -H tcp://0.0.0.0:2375 --cluster-store=etcd://192.168.32.64:2379 --cluster-advertise=192.168.32.64:2375"
```
```
service docker restart
```

node 2 :
```
ETCD_VER=v3.1.0
DOWNLOAD_URL=https://github.com/coreos/etcd/releases/download
curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xvf etcd-v3.1.0-linux-amd64.tar.gz
cd etcd-v3.1.0-linux-amd64/
vim run.sh
```
```
nohup ./etcd -name vm2-kerlink -initial-advertise-peer-urls http://192.168.32.76:2380 \
  -listen-peer-urls http://0.0.0.0:2380 \
  -listen-client-urls http://192.168.32.76:2379,http://127.0.0.1:2379 \
  -advertise-client-urls http://0.0.0.0:2379 \
  -initial-cluster-token etcd-cluster \
  -initial-cluster lns-kerlink=http://192.168.32.64:2380,vm2-kerlink=http://192.168.32.76:2380 \
  -initial-cluster-state new &
```
```
chmod a+x run.sh
./run.sh
vim /etc/default/docker
```
```
DOCKER_OPTS="--bip=192.168.254.1/24 -H tcp://0.0.0.0:2375 --cluster-store=etcd://192.168.32.76:2379 --cluster-advertise=192.168.32.76:2375"
```
```
service docker restart
```


#### Test etcd nodes
```
./etcdctl cluster-health
```

### Use :
Sur un des nodes :
```
docker network create -d overlay testoverlay
```
Le réseau devrait automatiquement s'ajouter sur l'autre node

node 1:
```
docker run -d --name debian1 --net=testoverlay debian sleep infinity
```

node 2 :
```
docker run -d --name debian2 --net=testoverlay debian sleep infinity
```

## Calico
