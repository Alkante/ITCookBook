# hostname
## Set
```
HOST="pcname"
DOM="exemple.com"
IP1="192.168.0.1"

echo "${HOST}" > /etc/hostname
sed -i "/$IP1/d"  /etc/hosts
echo "$IP1 ${HOST}.${DOM} ${HOST}" >> /etc/hosts
```

## Prise en compte
```
hostname -F /etc/hostname
```

## Verification
```
hostname
hostname -s
hostname -f
```
