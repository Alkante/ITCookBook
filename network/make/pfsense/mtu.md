# set MTU on the fly on interface
## linux
```bash
ip link set "$INTERFACE" mtu 1300
```
ou
```bash
ifconfig eth0 mtu 1500
```

## windows
Via GUI :  change TAP-Windows MTU in the adapter advanced properties

Via command : get interface index
```bash
netsh interface ipv4 show interfaces
netsh interface ipv6 show interfaces
```

En ligne de commande mode administrateur, si l'index trouvé est 10:
```bash
netsh interface ipv4 set interface 10 mtu=1400
```

# set MTU on openvpn link
## client specific override
```bash
push "mssfix 1340"
```
## client config
```bash
mssfix 1340
```
