# VirtualBox
<!-- TOC -->

- [VirtualBox](#virtualbox)
    - [Commandes usuelles](#commandes-usuelles)
        - [Affichage](#affichage)
        - [Snapshot](#snapshot)
        - [Restoration](#restoration)
        - [Start](#start)
        - [Stop](#stop)
        - [Export d'une VM allumée](#exporter-une-VM)
    - [Conversion](#Conversion)
        - [Exporter un raw](#exporter-un-raw)
        - [Importer un raw](#importer-un-raw)
        - [Conversion avec VBoxManage](#conversion-avec-vboxmanage)
        - [Conversion avec qemu](#Conversion-avec-qemu)

<!-- /TOC -->

## Commandes usuelles

### Affichage
```bash
VBoxManage list vms
```

### Snapshot
```bash
DESC="take \"19mars\" --description \"bgp+connexionfw1\""
VBoxManage snapshot "fw1" take "19mars" --description "bgp+connexion fw1"
for VM in Cog BGP1 BGP2 BT fw1 fw2; do VBoxManage snapshot "$VM" $DESC;done
```

### Restoration
```bash
VBoxManage snapshot squeeze32 restore "data_imported"
VBoxManage snapshot squeeze32 take "3.3.23" --description "avant integration données guyane"
```

### Start
```bash
for VM in Cog BGP1 BGP2 BT fw1 fw2; do VBoxManage startvm "$VM";sleep 5;done
```

### Stop
```bash
for VM in BGP2 BT fw2; do VBoxManage controlvm "$VM" acpipowerbutton;sleep 5;done
for VM in BGP1 Cog fw1; do VBoxManage controlvm "$VM" acpipowerbutton;sleep 5;done
```

### exporter une VM
Export d'une VM allumée, dans son état actuel, via un snapshot
```
vboxmanage snapshot base-group1-debian-stretch take --live
```
Récupérer l'UUID du snapshot
```
vboxmanage clonevm base-group1-debian-stretch --name=export --options=KeepAllMACs --options=keepdisknames --options=keephwuuids --register --snapshot=d9bb56dc-6872-4eb7-aa5b-4fd616dcdc9f
```
Copier le dossier de la nouvelle VM "export" et supprimer la VM :
`vboxmanage unregistervm --delete export`
## Montage sans conversion d'un fichier .vdi
https://askubuntu.com/questions/19430/mount-a-virtualbox-drive-image-vdi

```
mkdir /tmp/t
sudo modprobe nbd max_part=16
sudo qemu-nbd -c /dev/nbd0 drive.vdi
```
Si partition simple :
```
sudo mount /dev/nbd0p5 /tmp/t
```

Si LVM :
```
pvscan
lvs / vgs pour vérifier que les LV sont bien vus
```

```
mount /dev/mapper/VG-LV /tmp/t
```

### Démontage
```
umount /tmp/t
qemu-nbd -d /dev/nbd0
```

## Conversion

### Exporter un raw
L'obtention d'un rw d'un disk, d'une partion ou d'un fichier au sens large se fait avec la commande ```dd```.

| Options | Description |
|-------- |------------ |
| ```if``` | Fichier d'entrée au sens large |
| ```of``` | Fichier de sortie au sens large |

!!! ATTENTION : NE PAS INVERSER ```if``` et ```of``` !!!

```bash
dd if=/dev/sdb of=./sdb.raw
```

### Importer un raw
```bash
dd if=./sdb.raw of=/dev/sdb
```


### Conversion avec VBoxManage
L'outil de conversion VBoxManage est nativement présent dans virtual box

| Action | Commande |
|------- |--------- |
| raw to vdi  | ```VBoxManage convertdd sdb.raw sdb.vdi --format VDI``` |
| vdi to raw  | ```VBoxManage clonehd sdb.vdi sdb.raw --format RAW``` |
| raw to vmdk | ```VBoxManage convertdd sdb.raw sdb.vmdk --format VMDK``` |
| raw to vmdk | ```VBoxManage convertdd sdb.raw sdb.vmdk --format VMDK``` |
| vmdk to vdi | ```VBoxManage clonehd sdb.vmdk sdb.vdi --format VDI``` |


### Conversion avec qemu


| Action | Commande |
|------- |--------- |
| vmdk to raw  | ```qemu-img convert -f vmdk sdb.vmdk -O raw sdb.raw``` |
