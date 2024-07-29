# Idrac Dell

## Changer l'alimentation active (si mode actif/backup sans partage de charge)
```bash
# serveurs Dell récents
racadm set System.ServerPwr.RapidOnPrimaryPSU PSU2
# serveurs Dell plus anciens
racadm set System.Power.Hotspare.PrimaryPSU PSU2
```

## Enlever le check du Host en HTTP si erreur 400
Utile si le nom de l'idrac ne correspond pas au nom DNS.

```bash
racadm set idrac.webserver.HostHeaderCheck 0
# redémarrer l'idrac pour la prise en compte
racadm racreset
```


## Changer le mot de passe du compte par défaut (root)

```bash
read -sp "Enter new password" ROOTPW
# entrer le nouveau mdp
racadm set iDRAC.Users.2.Password $ROOTPW
```


## Accéder à une remote console java depuis un PC linux récent avec OpenJDK

```bash
alias wget='wget --cipher "DEFAULT:!DH" --no-check-certificate'
# à adapter suivant la version de Java
nano /etc/java-11-openjdk/security/java.security
# Commenter les lignes suivantes 
#jdk.tls.disabledAlgorithms=SSLv3, TLSv1, TLSv1.1, RC4, DES, MD5withRSA, \
#    DH keySize < 1024, EC keySize < 224, 3DES_EDE_CBC, anon, NULL, \

wget https://[IP iDRAC]/software/avctKVM.jar
java -cp avctKVM.jar com.avocent.idrac.kvm.Main ip=[IP iDRAC] kmport=5900 vport=5900 user=USERNAME passwd=PASSWORD apcp=1 version=2 vmprivilege=true "helpurl=https://[IP iDRAC]/help/contents.html"
```