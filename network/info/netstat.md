# Netstat

## Voir tout
```bash
netstat -taupeW
```

## Voir tout sans résolution des noms (plus rapide)
```bash
netstat -taupenW
```

## Nombre de conexion par IP
```bash
netstat -Wpan |egrep 'tcp|udp' |awk '{print $5}' |awk -F: '{OFS=":"}(NF=NF-1) 1' |grep -v '^::$' |sort |uniq -c
```
