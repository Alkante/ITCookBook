# Warp10
Platform is built to simplify managing and processing Time Series data

## Install with docker

```bash
docker pull -a warp10io/warp10
```


Ajouter un point de montage pour les donnée les les fichier de configuration
```bash
docker run --name=warp10 --volume=/home/user/var/docker:/data -p 8080:8080 -p 8081:8081 -d -i warp10io/warp10:1.0.15-1-ga07cb94
```

Afficher instance
```bash
docker ps
```

Lancer le terminal du docker
```bash
docker exec   -t -i warp10 worf.sh
```

Générer les token de read et write
```bash
encodeToken
write
<enter>
<enter>
<enter>
3600000000
generate
```

```bash
encodeToken
read
<enter>
<enter>
<enter>
3600000000
generate
```


Tester l'écriture dans le conteneur. Remplace ** WRITE_TOKEN par le token d'écriture
```bash
curl -v -H 'X-Warp10-Token: WRITE_TOKEN' --data-binary "1// test{} 42" 'http://127.0.0.1:8080/api/v0/update'
```

Tester la lecture dans le conteneur. Remplace ** WRITE_TOKEN par le token d'écriture
```bash
curl -v  --data-binary "'READ_TOKEN' 'test' {} NOW -1 FETCH" 'http://127.0.0.1:8080/api/v0/exec'
```


Lire les données via quantum
```bash
http://localhost:8081
```

```bash
'READ_TOKEN'

'~.*' {} NOW -1 FETCH
```

## Spécification d'envoye

### POST avec un entete

|header    |  Descrition
| ---------|  ---------|
| POST /api/v0/update HTTP/1.1    | endpoint du service |
| Host: HOST  | HOST est l'url ou l'IP du service |
| X-Warp10-Token: TOKEN_WRITE |TOKEN_WRITE est le token d'écriture (obligatoire) |
| Content-Type: FORMAT | FORMAT est soit ```text/plain``` ou ```application/gzip``` |

### Body
Le modèle est le suivant et peux etre répété dans un meme bady
```
TIMESTAMP/LAT:LON/ELEV NAME{LABELS} VALUE
```

Exemple d'un body avec 3 données d'envoyées
```
1380475081000000// foo{label0=val0,label1=val1} 123
/48.0:-4.5/ bar{label0=val0} 3.14
1380475081123456/45.0:-0.01/10000000 foobar{label1=val1} T
```




## Analyse de données
Télécharger le fichier d'exemple de donnée



```bash
wget http://www.warp10.io/assets/data/drones
curl -v -H 'Transfer-Encoding:chunked' -H 'X-Warp10-Token: TOKEN_WRITE' --data-binary @drones 'http://127.0.0.1:8080/api/v0/update'
```




## Structure hbase

```base
create 'continuum',
  {
  NAME => 'm',
  DATA_BLOCK_ENCODING => 'FAST_DIFF',
  BLOOMFILTER => 'NONE',
  REPLICATION_SCOPE => '0',
  VERSIONS => '1',
  COMPRESSION => 'NONE',
  MIN_VERSIONS => '0',
  TTL => '2147483647',
  KEEP_DELETED_CELLS => 'false',
  BLOCKSIZE => '65536',
  IN_MEMORY => 'false',
  BLOCKCACHE => 'true'
  },
  {
  NAME => 'v',
  DATA_BLOCK_ENCODING => 'FAST_DIFF',
  BLOOMFILTER => 'NONE',
  REPLICATION_SCOPE => '0',
  VERSIONS=> '1',
  COMPRESSION => 'LZ4',
  MIN_VERSIONS => '0',
  TTL => '2147483647',
  KEEP_DELETED_CELLS => 'false',
  BLOCKSIZE => '65536',
  IN_MEMORY =>'false',
  BLOCKCACHE => 'true'
  },
  {
  MAX_FILESIZE => '10737418240',
  REGION_REPLICATION => 2
  }
```

```bash
[
  {
    "20090601":{
      "DE":270,
      "US":21,
      "SE":5547
    }
  },
  {
    "20090602":{
      "DE":9020,
      "US":109,
      "SE":11497
    }
  },
  {
    "20090603":{
      "DE":10091,
      "US":186,
      "SE":8863
    }
  }
]
```

```bash
'clip-1440-country-DE-20090623' '{"unit:length": {"value": 722}}
```
