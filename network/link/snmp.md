# SNMP
## parcourir
avec un oid:
```
snmpwalk -v 2c -c exemplecom switch.exemple.com .1.3.6.1.4.1
```
avec un dictionnaire (retourne une erreur si MIB not in search path)
```
snmpwalk -v 2c -c exemplecom switch.exemple.com TPLINK-MIB::tplinkMgmt.9
```

## show key value:
```
snmpget -v 2c -c exemplecom switch.exemple.com .1.3.6.1.4.1.11863.6.8.1.1.1.8.49199
```

## translate key/oid
```
snmptranslate .1.3.6.1.4.1.11863.9.1.3.2.1
```

## MIB
add definitions
```
cd /usr/share/snmp/mibs/
wget 'http://www.circitor.fr/Mibs/Mib/B/BROTHER-MIB.mib' -O BROTHER-MIB.mib
```
activate other group of mib
```
mkdir ~/.snmp
echo "mibs +ALL" >> ~/.snmp/snmp.conf
```
show conf:
```
snmpconf -G
```
