# Proxmox


## Contexte

Proxmox est un hyperviseur utilisant KVM.
Il est plus performance que xen pour la virutalisation de linux.
Xen reste avantageux pour les système non linux

## Command usuel

| Commande | Description |
|--------- |------------ |
| ```pveversion -v``` | Affiche la version de xen |
| ```pveperf``` | Affiche les perdormances |
| ```pvesh``` | Lance le shell promox (quiter avec ```quit```)|


## proxmox to vbox
https://xpbydoing.blogspot.com/2018/02/proxmox-backup-to-virtualbox.html
### install dep
```
apt-get install -y wget libglib2.0-0 libiscsi7 librbd1 libaio1 lzop glusterfs-common libjemalloc1
```
### build vma binary
```
git clone https://github.com/ganehag/pve-vma-docker.git
wget http://download.proxmox.com/debian/pve/dists/stretch/pvetest/binary-amd64/pve-qemu-kvm_2.9.1-9_amd64.deb
dpkg --fsys-tarfile ./pve-qemu-kvm*.deb | tar xOf - ./usr/bin/vma > ./vma
chmod u+x ./vma
```
### convert vma to raw
extract lzo archive:
```
lzop -d vzdump-qemu-110-2018_08_25-10_00_02.vma.lzo
```
extract vma with vma binary
```
vma extract ./file.vma -v ./vmaextract
./vma extract ../download/vzdump-qemu-110-2018_08_25-10_00_02.vma vmaextract/
```
### convert rawto vdi
```
qemu-img convert vmaextract/disk-drive-scsi0.raw -O vdi disk.vdi
```
