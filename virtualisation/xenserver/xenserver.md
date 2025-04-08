# Xenserver

voir aussi https://xen-orchestra.exemple.com/

<!-- TOC -->

- [Xenserver](#xenserver)
  - [Comandes usuelles](#comandes-usuelles)
  - [hostname dom0](#hostname-dom0)
  - [dom0 label name](#dom0-label-name)
  - [network](#network)
    - [get interfaces](#get-interfaces)
    - [get interfaces detail](#get-interfaces-detail)
    - [bridges](#bridges)
    - [config second LAN](#config-second-lan)
    - [Créer un VLAN sur une interface existante](#créer-un-vlan-sur-une-interface-existante)
  - [add static route](#add-static-route)
  - [add custom dns](#add-custom-dns)
  - [Operations en cours](#operations-en-cours)
  - [ipv6](#ipv6)
  - [DomU](#domu)
    - [liste](#liste)
    - [start](#start)
    - [show infos](#show-infos)
    - [show vm disks](#show-vm-disks)
  - [#show vm network](#show-vm-network)
    - [shutdown](#shutdown)
    - [supprimer la VM (ne supprime pas le disque)](#supprimer-la-vm-ne-supprime-pas-le-disque)
    - [supprimer la VM avec ses disques](#supprimer-la-vm-avec-ses-disques)
    - [install](#install)
  - [SR](#sr)
    - [actualiser les VG pour identifier les LV (vdi)](#actualiser-les-vg-pour-identifier-les-lv-vdi)
    - [create sr](#create-sr)
    - [faire du sr le default sr local](#faire-du-sr-le-default-sr-local)
    - [declare storage type lvm](#declare-storage-type-lvm)
    - [liste des storages](#liste-des-storages)
    - [trouver le uuid du SR à partir du name VG0018](#trouver-le-uuid-du-sr-à-partir-du-name-vg0018)
    - [afficher les infos de VG0018 (SR uuid, /dev/sda)](#afficher-les-infos-de-vg0018-sr-uuid-devsda)
      - [LV appartenant à VG0018](#lv-appartenant-à-vg0018)
    - [recréer des SR de type "par défaut" sur un dom0](#recréer-des-sr-de-type-par-défaut-sur-un-dom0)
  - [VDI](#vdi)
    - [Create new Virtual Disk (VDI) xe vdi-create : 10GB](#create-new-virtual-disk-vdi-xe-vdi-create--10gb)
    - [dd à partir d'un autre serveur vers le nouveau LV](#dd-à-partir-dun-autre-serveur-vers-le-nouveau-lv)
    - [import d'un LV](#import-dun-lv)
    - [Redimensionner le VDI](#redimensionner-le-vdi)
      - [extend avec exemple sur vm vm5.exemple.com](#extend-avec-exemple-sur-vm-vm5exemplecom)
          - [Sur le dom0](#sur-le-dom0)
        - [Dans la VM](#dans-la-vm)
      - [extend](#extend)
      - [resize](#resize)
      - [resize non possible](#resize-non-possible)
      - [extend with mod rescue](#extend-with-mod-rescue)
      - [reduce / shrink / decrease](#reduce--shrink--decrease)
  - [VBD](#vbd)
    - [creation](#creation)
    - [suppression](#suppression)
  - [CD](#cd)
    - [montage dans domU](#montage-dans-domu)
  - [Template](#template)
    - [Liste](#liste-1)
    - [Création](#création)
    - [change parametre du template](#change-parametre-du-template)
  - [commandes pour monter le LV d'un domU dans le dom0](#commandes-pour-monter-le-lv-dun-domu-dans-le-dom0)
    - [1/ on cherche l'id du vdi de la vm](#1-on-cherche-lid-du-vdi-de-la-vm)
    - [2/ on cherche l'id du dom0](#2-on-cherche-lid-du-dom0)
    - [3/ on associe dans un vdb le vdi trouvé en 1/ à la machine trouvée en 2/ ( le dom0)](#3-on-associe-dans-un-vdb-le-vdi-trouvé-en-1-à-la-machine-trouvée-en-2--le-dom0)
    - [on "plug" sur le dom0 le vbd créé en 3/](#on-plug-sur-le-dom0-le-vbd-créé-en-3)
    - [kpartx ouvre le disque et le mappe dans /dev/mapper](#kpartx-ouvre-le-disque-et-le-mappe-dans-devmapper)
    - [montage de la partition](#montage-de-la-partition)
    - [on refait tout en sens inverse](#on-refait-tout-en-sens-inverse)
    - [recap](#recap)
  - [Réseau](#réseau)
    - [lister les cartes réseau sur le dom0](#lister-les-cartes-réseau-sur-le-dom0)
    - [forcer la découverte des cartes réeau](#forcer-la-découverte-des-cartes-réeau)
    - [configurer la nouvelle carte](#configurer-la-nouvelle-carte)
  - [patch](#patch)
    - [set default SR to upload patches to:](#set-default-sr-to-upload-patches-to)
    - [upload patch](#upload-patch)
    - [apply patch](#apply-patch)
  - [pool](#pool)
    - [join pool](#join-pool)
      - [pb join pool](#pb-join-pool)
  - [backup pool](#backup-pool)
  - [leave pool](#leave-pool)
  - [import LVM xen to LVM xenserver](#import-lvm-xen-to-lvm-xenserver)
  - [import VG xen to "SR xenserver"](#import-vg-xen-to-sr-xenserver)
  - [CPU](#cpu)
    - [show](#show)
    - [change start / max](#change-start--max)
    - [cpu hotplug](#cpu-hotplug)
  - [CD / ISO](#cd--iso)
  - [consoles](#consoles)
    - [VNC](#vnc)
  - [firewall](#firewall)
  - [Clonage](#clonage)
  - [Copy](#copy)
  - [Migration](#migration)
  - [Import/export](#importexport)
  - [HVM/PV domU](#hvmpv-domu)
    - [vieux domU qui n'ont pas de kernel xen:](#vieux-domu-qui-nont-pas-de-kernel-xen)
  - [solving errors:](#solving-errors)
    - [xenopsd](#xenopsd)
    - [The uploaded update package is invalid.](#the-uploaded-update-package-is-invalid)
<!-- /TOC -->

## Comandes usuelles


| Commande                      | Description                                   |
| ----------------------------- | --------------------------------------------- |
| `xl li`                       | Afficher les VMs                              |
| `xl info`                     | Afficher les informations du système          |
| `xe console vm=vm1.exemple.com` | Se connecte à la VM. Press Ctrl + ']' to quit |
| `xl console vm1.exemple.com`    | Se connecte à la VM. Press Ctrl + ']' to quit |


| Commande        | Description              |
| --------------- | ------------------------ |
| `xe help`       | Aide                     |
| `xe help --all` | Aide étendu              |
| `xe host-list`  | Afficher les hosts liées |



## hostname dom0

```bash
xe host-set-hostname-live host-uuid=7927bd63-626b-4d3d-8c4b-a4bc6454df34 host-name=slave
```

vérifier la config du hosts centos :
- /etc/hostname
- /etc/hosts
- hostname
- /etc/sysconfig/network

## dom0 label name

```bash
xe host-param-set name-label=slave uuid=7927bd63-626b-4d3d-8c4b-a4bc6454df34
```

## network

le management est fait par openvswitch
pas de fichier de config, tout est en database :

```bash
xe-get-network-backend
```
openvswitch
Infos sur le backend par défaut openvswitch:

```bash
ovs-vswitchd -V
ovs-vswitchd (Open vSwitch) 2.3.2
```

### get interfaces

```bash
xe pif-list
uuid ( RO)                  : c52feb00-a393-fb81-dbe1-e758fb0a76f2
                device ( RO): eth0
    currently-attached ( RO): true
                  VLAN ( RO): -1
          network-uuid ( RO): db10af45-e36c-0665-1742-dbc6fe8c557a
```
et bridges associés

```bash
xe network-list
uuid ( RO)                : db10af45-e36c-0665-1742-dbc6fe8c557a
          name-label ( RW): Pool-wide network associated with eth0
    name-description ( RW):
              bridge ( RO): xenbr0

```
détails du network:

```bash
xe network-param-list uuid=db10af45-e36c-0665-1742-dbc6fe8c557a
```

### get interfaces detail

```bash
xe pif-param-list uuid=c52feb00-a393-fb81-dbe1-e758fb0a76f2
uuid ( RO)                       : c52feb00-a393-fb81-dbe1-e758fb0a76f2
                     device ( RO): eth0
                    managed ( RO): true
                 management ( RO): true
         network-name-label ( RO): Pool-wide network associated with eth0
                         IP ( RO): 192.168.0.68
                    netmask ( RO): 255.255.224.0
                    gateway ( RO): 192.168.31.254
```

### bridges
show

```bash
ovs-vsctl show
```

plus de détails :

```bash
ovs-vsctl list bridge
```

plus de détails pour une port :

```bash
ovs-vsctl list port xenbr1
```
plus de détails pour une interface :

```bash
ovs-vsctl list interface 7ac1552c-98a4-4ab9-ac7f-c266368b71f9
```

create bridge

```bash
ovs-vsctl add-br xenbr0
```
add interface to bridge

```bash
ovs-vsctl add-port eth0 xenbr0
```
### config second LAN

```bash
xe pif-reconfigure-ip uuid=9ad28236-2c07-9c2b-1983-282506ae97f1 IP=192.168.32.67 netmask=255.255.224.0 mode=static
```
vérifier avec ifconfig xenbr1

### Créer un VLAN sur une interface existante

```bash
xe pif-plug uuid=$(xe vlan-create pif-uuid=$(xe pif-list device=eth0 --minimal) network-uuid=$(xe network-create name-label=PROD_VL111) vlan=111)
```

## add static route

```bash
NETBR1=`xe network-list bridge=xenbr1 | awk '/^uuid/ { print $NF }'`
xe network-param-set uuid=$NETBR1 other-config:static-routes=192.168.0.0/15/192.168.5.21,fd00:effe:6700::/40/fd00:effe:6600:500:ffff::102:2
xe-toolstack-restart
```

## add custom dns

```
DOM0=`hostname -s`
PIFETH1=`xe pif-list host-name-label=$DOM0 device=eth1 | awk '/^uuid/ { print $NF }'`
xe pif-param-set uuid=$PIFETH1 other-config:options=attempts:2,options=timeout:2
```

## Operations en cours

Lors de migrations, on peut visualiser l'avancement de la tâche :

```bash
xe task-list
```

## ipv6

```bash
DOM0=`hostname -s`
PIFETH0=`xe pif-list host-name-label=$DOM0 device=eth0 | awk '/^uuid/ { print $NF }'`
xe pif-reconfigure-ipv6 IPv6=fd00:effe:6720:a0:d::104/64 gateway=fd00:effe:6720:a0:ffff::1 uuid=$PIFETH0 mode=static
```

```bash
echo '
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv6.conf.eth0.disable_ipv6 = 0' >> /etc/sysctl.d/90-net.conf
sysctl -p -f /etc/sysctl.d/90-net.conf
```

## DomU
### liste

```bash
xe vm-list
xl li
```

### start

```bash
xe vm-start vm=vm1
```

set autostart

```bash
xe vm-param-set uuid=38108877-eaae-71b7-8c6a-1a00bf4ab99b other-config:auto_poweron=true
```

autostart must be enabled on pool!!

```bash
POOLUUID=`xe pool-list | awk '/^uuid/ { print $NF }'`
xe pool-param-list uuid=$POOLUUID  | grep other-config | grep power
xe pool-param-set uuid=$POOLUUID other-config:auto_poweron=true
xe pool-param-list uuid=$POOLUUID  | grep other-config | grep power
```

### show infos

```bash
xe vm-list params=name-label,networks
xe vm-list params=uuid name-label=vm4
```
get stats

```bash
xe vm-data-source-list vm=vm3
```

### show vm disks

```bash
xe vm-disk-list vm="vm1"
```

## #show vm network

```bash
xe vm-vif-list
```

### shutdown

```bash
xe vm-shutdown uuid=4b9e1d49-9beb-09a9-7f03-ff279d3da6d0
```

### supprimer la VM (ne supprime pas le disque)

Destroy a VM. This leaves the storage associated with the VM intact. To delete storage too, use vm-uninstall.

```bash
xe vm-destroy uuid=d19814b9-c038-e11c-6a42-9926144dc5ef
```

### supprimer la VM avec ses disques

supprime la vm et ses vdi associés et attachés

```bash
xe vm-uninstall vm=vm1
```

### install

```bash
xe vm-install new-name-label=vm3.exemple.com template="Debian Wheezy 7.0 (64-bit)"
```

## SR

```
                                -----SR-----
                             |               |
--------         -----       |     ----      |         ----         --------
| dom0 |  -----  (PBD) -----       {VDI}        -----  (VBD)  ----  | domU |
--------         -----       |     ----      |         ----         --------
                             |               |
--------         -----       |     ----      |         ----         --------
| dom0 |  -----  (PBD) -----       {VDI}        -----  (VBD)  ----  | domU |
--------         -----       |     ----      |         ----         --------
                             |               |
                                -----SR-----
```

### actualiser les VG pour identifier les LV (vdi)

Force an SR scan, syncing database with VDIs present in underlying storage substrate.

```bash
xe sr-scan
```

### create sr

```bash
xe sr-create content-type=user device-config:device=/dev/sda3 host-uuid=24432523-b3cc-47b6-807c-23c91ada27ad name-label=LocalStorage shared=false type=lvm
pvdisplay -C
/dev/sda3  VG_XenStorage-423b716a-2ca0-7c91-4bf0-d682ee1464d5 lvm2 a--  128,11g 128,11g
```

```bash
vgdisplay -C
VG_XenStorage-423b716a-2ca0-7c91-4bf0-d682ee1464d5   1   1   0 wz--n- 128,11g 128,11g
```

### faire du sr le default sr local

```bash
xe pool-param-set default-SR=423b716a-2ca0-7c91-4bf0-d682ee1464d5 uuid=4b43d4d9-bed3-f372-94df-a2eabccb3a48
```

### declare storage type lvm

```bash
xe sr-create host-uuid=7927bd63-626b-4d3d-8c4b-a4bc6454df34 name-label="sr-data1" type=lvm device-config:device="/dev/drbd11"
```

### liste des storages

```bash
xe sr-list
```

### trouver le uuid du SR à partir du name VG0018

```bash
xe pbd-list sr-name-label=VG0018 | awk '/sr-uuid/ { print $NF }'
SRUUID=`xe pbd-list sr-name-label=VG0018 | awk '/sr-uuid/ { print $NF }'`
xe sr-list | awk  'BEGIN {FS="\n" ; RS="\n\n"}  /VG0018/ { print }' | awk '/^uuid/ { print $NF }'
```

### afficher les infos de VG0018 (SR uuid, /dev/sda)

```bash
xe pbd-list sr-name-label=VG0018
uuid ( RO)                  : e3a549cf-046b-a227-aef2-279b20d5d1f4
host-uuid ( RO): 24432523-b3cc-47b6-807c-23c91ada27ad
sr-uuid ( RO): 830f2626-7ca6-4008-7d99-2a017e4e6498
device-config (MRO): device: /dev/sdb1
currently-attached ( RO): true
```

infos LVM

```bash
vgdisplay -C
VG                                                 #PV #LV #SN Attr   VSize   VFree  
VG_XenStorage-423b716a-2ca0-7c91-4bf0-d682ee1464d5   1   5   0 wz--n- 128,11g  67,91g
VG_XenStorage-830f2626-7ca6-4008-7d99-2a017e4e6498   1   2   0 wz--n-   1,82t 836,48g
```
ou en filtrant sur le sr_uuid

```bash
vgdisplay "VG_XenStorage-${SRUUID}"
  --- Volume group ---
  VG Name               VG_XenStorage-830f2626-7ca6-4008-7d99-2a017e4e6498
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               1,82 TiB
  PE Size               4,00 MiB
  Total PE              476797
  Alloc PE / Size       262659 / 1,00 TiB
  Free  PE / Size       214138 / 836,48 GiB
  VG UUID               QbjUD2-2DNJ-TMhH-0Kp3-pJGx-mhPy-g0A5ws
```

#### LV appartenant à VG0018

```bash
lvdisplay -C  "VG_XenStorage-${SRUUID}"

 LV                                       VG                                                 Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
 MGT                                      VG_XenStorage-830f2626-7ca6-4008-7d99-2a017e4e6498 -wi-a----- 4,00m                                                    
 VHD-9961944c-b8be-4843-a26d-c3bacf30cdae VG_XenStorage-830f2626-7ca6-4008-7d99-2a017e4e6498 -wi-ao---- 1,00t                                                    
```

Le vdi-uuid est 9961944c-b8be-4843-a26d-c3bacf30cdae

```bash
VDIUUID="9961944c-b8be-4843-a26d-c3bacf30cdae"
```

Infos sur le VDI :

```bash
xe vdi-param-list uuid=$VDIUUID
uuid ( RO)                    : 9961944c-b8be-4843-a26d-c3bacf30cdae
              name-label ( RW): vm3.exemple.com-data
        name-description ( RW):
           is-a-snapshot ( RO): false
             snapshot-of ( RO): <not in database>
               snapshots ( RO):
           snapshot-time ( RO): 19700101T00:00:00Z
      allowed-operations (SRO): clone; snapshot
      current-operations (SRO):
                 sr-uuid ( RO): 830f2626-7ca6-4008-7d99-2a017e4e6498
           sr-name-label ( RO): VG0018
               vbd-uuids (SRO): 108aaf60-d9e4-0746-e227-a674795e96e3
         crashdump-uuids (SRO):
            virtual-size ( RO): 1099511627776
    physical-utilisation ( RO): 1101667500032
                location ( RO): 9961944c-b8be-4843-a26d-c3bacf30cdae
                    type ( RO): User
                sharable ( RO): false
               read-only ( RO): false
            storage-lock ( RO): false
                 managed ( RO): true
                  parent ( RO): <not in database>
                 missing ( RO): false
            is-tools-iso ( RO): false
            other-config (MRW):
           xenstore-data (MRO):
               sm-config (MRO): host_OpaqueRef:8b8aff77-b04a-3d1f-e209-77857dc85c7a: RW; read-caching-reason-24432523-b3cc-47b6-807c-23c91ada27ad: LICENSE_RESTRICTION; read-caching-enabled-on-24432523-b3cc-47b6-807c-23c91ada27ad: false; vdi_type: vhd; vmhint: 38108877-eaae-71b7-8c6a-1a00bf4ab99b
                 on-boot ( RW): persist
           allow-caching ( RW): false
         metadata-latest ( RO): false
        metadata-of-pool ( RO): <not in database>
                    tags (SRW):
```

ou affichage du VBDUUID

```bash
xe vdi-param-get  uuid=9961944c-b8be-4843-a26d-c3bacf30cdae param-name=vbd-uuids
108aaf60-d9e4-0746-e227-a674795e96e3
```

Infos sur le vbd:

```bash
VBDUUID=108aaf60-d9e4-0746-e227-a674795e96e3
xe vbd-param-list uuid=$VBDUUID
uuid ( RO)                        : 108aaf60-d9e4-0746-e227-a674795e96e3
                     vm-uuid ( RO): 38108877-eaae-71b7-8c6a-1a00bf4ab99b
               vm-name-label ( RO): vm3.exemple.com
                    vdi-uuid ( RO): 9961944c-b8be-4843-a26d-c3bacf30cdae
              vdi-name-label ( RO): vm3.exemple.com-data
          allowed-operations (SRO): attach; unpause; unplug; unplug_force; pause
          current-operations (SRO):
                       empty ( RO): false
                      device ( RO): xvdc
                  userdevice ( RW): 2
                    bootable ( RW): false
                        mode ( RW): RW
                        type ( RW): Disk
                 unpluggable ( RW): true
          currently-attached ( RO): true
                  attachable ( RO): true
                storage-lock ( RO): false
                 status-code ( RO): 0
               status-detail ( RO):
          qos_algorithm_type ( RW):
        qos_algorithm_params (MRW):
    qos_supported_algorithms (SRO):
                other-config (MRW): owner: true
                 io_read_kbs ( RO): 0.000
                io_write_kbs ( RO): 0.000
```

### recréer des SR de type "par défaut" sur un dom0

DVD, usb...
removable storage

```
xe sr-create content-type=disk type=udev host-uuid=aacb2879-cadc-41ac-b79a-0eac35c5f289  shared=false name-label='Removable storage' device-config:location=/dev/xapi/block
```

DVD:
```
xe sr-create content-type=iso type=udev host-uuid=aacb2879-cadc-41ac-b79a-0eac35c5f289 device-config:location=/dev/xapi/cd name-label='DVD drives'
```

## VDI
### Create new Virtual Disk (VDI) xe vdi-create : 10GB

```bash
xe vdi-create sr-uuid=423b716a-2ca0-7c91-4bf0-d682ee1464d5 name-label=vm4-disk type=user virtual-size=10737418240
```
e907e553-0ef5-47ed-a149-4a40bd4e37da

```bash
lvdisplay -C | grep e907e553-0ef5-47ed-a149-4a40bd4e37da
```

add big disk (impossible via xencenter: 2To max)

```bash
lvcreate -L25T -n"LV-"$(uuidgen) VG_XenStorage-5addc83d-d336-fc82-9a46-d6a39e950a8c --config global{metadata_read_only=0}
xe sr-scan uuid=5addc83d-d336-fc82-9a46-d6a39e950a8c
```

### dd à partir d'un autre serveur vers le nouveau LV

```bash
dd if=vm4-disk_07102016.dd bs=4M | ssh -c arcfour root@linux18.exemple.com dd of=/dev/VG_XenStorage-423b716a-2ca0-7c91-4bf0-d682ee1464d5/VHD-e907e553-0ef5-47ed-a149-4a40bd4e37da bs=4M
```

### import d'un LV

```bash
xe vdi-introduce sr-uuid=423b716a-2ca0-7c91-4bf0-d682ee1464d5 type=user location=/dev/VG_XenStorage-423b716a-2ca0-7c91-4bf0-d682ee1464d5/VHD-3f82be9e-b133-4212-a40b-41a869e93030 uuid=3f82be9e-b133-4212-a40b
```

### Redimensionner le VDI

#### extend avec exemple sur vm vm5.exemple.com

###### Sur le dom0
État de la VM

```bash
# xe vm-list
<domU>
uuid ( RO)           : 9614c11b-8702-ff35-f449-3cc82c900639
     name-label ( RW): vm5.exemple.com
    power-state ( RO): running

<dom0>
uuid ( RO)           : 10922e31-20d2-4784-a064-f2af9e584f2a
     name-label ( RW): Control domain on host: linux19.exemple.com
    power-state ( RO): running

```
VMUUID=9614c11b-8702-ff35-f449-3cc82c900639
DOM0UUID=10922e31-20d2-4784-a064-f2af9e584f2a
```bash
# xe vm-disk-list vm="vm5.exemple.com"
Disk 0 VBD:
uuid ( RO)             : 6fcaddd6-ae0a-d980-846f-81c70c1e90d9
    vm-name-label ( RO): vm5.exemple.com
       userdevice ( RW): 0
Disk 0 VDI:
uuid ( RO)             : b16f0ac6-3ca7-4158-86f1-d0689bba5d2e
       name-label ( RW): vm5.exemple.com-disk
    sr-name-label ( RO): VGlinux19
     virtual-size ( RO): 107374182400
```

On note les ID

```bash
VDIUUID=b16f0ac6-3ca7-4158-86f1-d0689bba5d2e
```

```bash
# fdisk -l /dev/VG_XenStorage-20eeb323-e69d-82ea-8a49-2fc1401fac50/VHD-b16f0ac6-3ca7-4158-86f1-d0689bba5d2e
Disque /dev/VG_XenStorage-20eeb323-e69d-82ea-8a49-2fc1401fac50/VHD-b16f0ac6-3ca7-4158-86f1-d0689bba5d2e : 107.6 Go, 107592286208 octets, 210141184 secteurs
```

On stop la VM.
```bash
xe vm-shutdown uuid=$VMUUID force=true
```

On agrandit le VDI
```bash
xe vdi-resize uuid=$VDIUUID disk-size=200GiB
```

On trouve le point de montage et on lance fdisk
```bash
# VBDUUID=`xe vbd-create vm-uuid=$DOM0UUID  vdi-uuid=$VDIUUID device=autodetect`
# echo $VBDUUID
37554900-81df-466f-3c91-e4e0185a3f74
# xe vbd-plug uuid=$VBDUUID
# DEVICE=`xe vbd-param-get uuid=$VBDUUID param-name=device`
# echo $DEVICE
sm/backend/20eeb323-e69d-82ea-8a49-2fc1401fac50/b16f0ac6-3ca7-4158-86f1-d0689bba5d2e
# kpartx -av "/dev/$DEVICE"
# lsblk
NAME                                    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
...
tdb                                     254:1    0   200G  0 disk
├─b16f0ac6-3ca7-4158-86f1-d0689bba5d2e1 253:4    0   1,9G  0 part
└─b16f0ac6-3ca7-4158-86f1-d0689bba5d2e2 253:5    0  98,1G  0 part
```

```bash
# fdisk -l /dev/tdb
# fdisk /dev/tdb
d -Delete Partition
2
n -New create new partition
p -Primary
1- Partition number
Default values for size
w -Write changes
# fdisk -l /dev/tdb
```

```bash
kpartx -dv "/dev/$DEVICE"
xe vbd-unplug uuid=$VBDUUID
xe vbd-destroy uuid=$VBDUUID
```

On lance la VM
```bash
xe vm-start vm="vm5.exemple.com"
```

##### Dans la VM

```bash
# ssh ansible@vm5.exemple.com
# sudo -s
# df -h
Sys. de fichiers                         Taille Utilisé Dispo Uti% Monté sur
/dev/xvda2                                  97G     75G   17G  82% /
```

```bash
resize2fs /dev/xvda2
```

```bash
# df -h
Sys. de fichiers                         Taille Utilisé Dispo Uti% Monté sur
/dev/xvda2                                 195G     75G  111G  41% /
```

#### extend

```bash
xe vdi-resize uuid=$VDIUUID disk-size=80GiB
```

Puis redimmensionner le filesystem:

```bash
xe vm-param-set uuid=6f04... PV-args=single
```

Boot VM and show disk list make partition table changes in the Linux VM.

```bash
fdisk -l
fdisk /dev/xvda
d -Delete Partition
n -New create new partition
p -Primary
1- Partition number
Default values for size
w -Write changes
```

#### resize

monter le vdi dans le dom0 (cf commandes pour monter le LV d'un domU dans le dom0)
et fcsk resi2fs

#### resize non possible

avec un VM centos7, le mode rescue et emergency ne permet pas de faire des opérations sur le disque, car il est monté ????
marche pas !
reboot vm and resize:

Resize the filesystem:
```bash
resize2fs /dev/xvda1
```

On XenServer host: remove the single-user boot mode setting:

```bash
xe vm-param-set uuid=6f04... PV-args=
```

#### extend with mod rescue

Sur le DomU modifier le fichier /boot/grub/grub.cfg pour ajouter ```systemd.unit=rescue.target```
```
...
    linux   /boot/vmlinuz-4.9.0-8-amd64 root=UUID=c7ade669-aaea-477e-929a-5373c0de6028 ro  console=tty1 console=ttyS0,38400n8 systemd.unit=rescue.target
...
```

Reboot puis :

```bash
resize2fs /dev/xvda2
```

#### reduce / shrink / decrease

pas possible, il faut créer un second disque et copier les données dessus
monter les 2 vdi dans le dom0 (cf commandes pour monter le LV d'un domU dans le dom0)

copie avec dd

```bash
dd if=/dev/tda of=/dev/tdb status=progress
```

## VBD
### creation

association vdi <-> vm

```bash
xe vbd-create vm-uuid=87600288-ce00-c981-3972-223f15822c04 vdi-uuid=f027f337-a5ce-46c7-a7e1-147195c97d54 bootable=true mode=RW type=Disk device=autodetect
xe vbd-create vm-uuid=87600288-ce00-c981-3972-223f15822c04 vdi-uuid=f027f337-a5ce-46c7-a7e1-147195c97d54 bootable=true mode=RW type=Disk device=5
xe vbd-create vm-uuid=87600288-ce00-c981-3972-223f15822c04 vdi-uuid=f027f337-a5ce-46c7-a7e1-147195c97d54 bootable=true mode=RW type=Disk device=xvde
```
### suppression

détacher au préalable :

```bash
xe vbd-unplug uuid=bc22ad4c-0be1-d0ba-d71a-43b3f032afb6
```

supprime l'association uniquement, pas le le vdi

```bash
xe vbd-destroy uuid=82f86b67-a20a-d621-71f5-a4463c2d43b6
```

## CD

### montage dans domU

```bash
xe vbd-create vm-uuid=01b4c038-9bb0-1b4d-f97b-cea3c4c8d490 type=CD device=254 vdi-uuid=9bbe1f7d-b4fa-4339-9397-6c9b54a2cfa2 mode=ro
```

## Template

### Liste
Lister les templates disponibles

```bash
xe template-list
```

### Création

```bash
UUID=`xe template-list name-label="Ubuntu Precise Pangolin 12.04 (64-bit)" params=uuid --minimal`
NEW_UUID=`xe vm-clone uuid=$UUID new-name-label="Ubuntu Xenial 16.04 (64-bit)"`
xe template-param-set other-config:default_template=true other-config:debian-release=xenial uuid=$NEW_UUID
```

### change parametre du template

```bash
xe template-param-set other-config:'mac_seed: fa063d6d-f004-300f-1cec-a58b67c93ff1; default_template: true; linux_template: true; install-methods: cdrom,http,ftp; install-arch: amd64; debian-release: squeeze; disks: <provision><disk device="0" size="5368709120"  sr="" bootable="true" type="system"/></provision>; install-distro: debianlike' uuid=fe573ebb-e035-b7b8-1723-8fae5ff611f9
```

```bash
xe vm-install template="Debian Squeeze 6.0 (64-bit)" new-name-label=squeeze64 sr-name-label=sr-data1
```


## commandes pour monter le LV d'un domU dans le dom0

suppose que le LV représente un disque avec des partitions à l'intérieur
éteindre la VM.

### 1/ on cherche l'id du vdi de la vm

```bash
VMNAME="vm1.exemple.com"
VDIUUID=`xe vbd-list vm-name-label=$VMNAME| awk '/vdi-uuid/ { print $NF }'`
```
8e869860-bf1f-4333-b620-13c2551e98f5

### 2/ on cherche l'id du dom0

```bash
DOM0=`hostname -s`
DOM0UUID=`xe vm-list name-label="Control domain on host: $DOM0" | awk '/uuid/ { print $NF }'`
```

ac25597b-7720-4910-ab7b-df7d5ebda1ef

### 3/ on associe dans un vdb le vdi trouvé en 1/ à la machine trouvée en 2/ ( le dom0)

```bash
VBDUUID=`xe vbd-create vm-uuid=$DOM0UUID  vdi-uuid=$VDIUUID device=autodetect`
```
bc22ad4c-0be1-d0ba-d71a-43b3f032afb6

### on "plug" sur le dom0 le vbd créé en 3/

```bash
xe vbd-plug uuid=$VBDUUID
```

### kpartx ouvre le disque et le mappe dans /dev/mapper

```bash
DEVICE=`xe vbd-param-get uuid=$VBDUUID param-name=device`
kpartx -l "/dev/$DEVICE"
kpartx -av "/dev/$DEVICE"
```

Sortie du type (autre exemple) :
```
add map 29a49afb-82c2-46dd-a28c-96b3ef987309p1 (253:9): 0 3997696 linear /dev/sm/backend/b0335f20-0c77-c220-1fe8-ebfd4bc491c1/29a49afb-82c2-46dd-a28c-96b3ef987309 2048
add map 29a49afb-82c2-46dd-a28c-96b3ef987309p2 (253:10): 0 130215936 linear /dev/sm/backend/b0335f20-0c77-c220-1fe8-ebfd4bc491c1/29a49afb-82c2-46dd-a28c-96b3ef987309 3999744
```

verif dans /dev/mapper
```bash
ls -l /dev/mapper/
ls -l /dev/mapper/ | grep $VDIUUID
```

```
lrwxrwxrwx 1 root root        7 21 juin  16:55 29a49afb-82c2-46dd-a28c-96b3ef987309p1 -> ../dm-9
lrwxrwxrwx 1 root root        8 21 juin  16:55 29a49afb-82c2-46dd-a28c-96b3ef987309p2 -> ../dm-10
```

```bash
PART="/dev/mapper/${VDIUUID}p2"
```

### montage de la partition

```bash
mkdir -p /tmp/t
mount $PART /tmp/t/
```

### on refait tout en sens inverse

```bash
umount /tmp/t
kpartx -dv "/dev/$DEVICE"
xe vbd-unplug uuid=${VBDUUID}
xe vbd-destroy uuid=${VBDUUID}
```

### recap

montage :

```bash
DOM0=`hostname -s`
VMNAME="vm1.exemple.com"
VMUUID=`xe vm-list name-label=$VMNAME | awk '/^uuid/ { print $NF }'`
VDIUUID=`xe vbd-list vm-name-label=$VMNAME| awk '/vdi-uuid/ { print $NF }'`
DOM0UUID=`xe vm-list name-label="Control domain on host: $DOM0" | awk '/uuid/ { print $NF }'`
VBDUUID=`xe vbd-create vm-uuid=$DOM0UUID  vdi-uuid=$VDIUUID device=autodetect`
xe vbd-plug uuid=$VBDUUID
DEVICE=`xe vbd-param-get uuid=$VBDUUID param-name=device`
kpartx -l "/dev/$DEVICE"
kpartx -av "/dev/$DEVICE"
PART="/dev/mapper/${VDIUUID}p2"
mkdir -p /tmp/t
mount $PART /tmp/t/
```
demontage:
```
umount /tmp/t
kpartx -dv "/dev/$DEVICE"
xe vbd-unplug uuid=$VBDUUID
xe vbd-destroy uuid=$VBDUUID
```


## Réseau

### lister les cartes réseau sur le dom0

```bash
xe pif-list
```

### forcer la découverte des cartes réeau

```bash
xe pif-scan host-uuid=[uuid of the XenServer host]
```

### configurer la nouvelle carte

```bash
xe pif-reconfigure-ip mode=static uuid=afc01480-ca70-ee45-5de0-09602f2ba52c IP=192.168.56.2 netmask=255.255.255.0
xe pif-param-set disallow-unplug=true other-config:management_purpose="DRBD Replication" uuid=afc01480-ca70-ee45-5de0-09602f2ba52c
xe pif-plug uuid=2b840145-adaa-c323-3305-02de841b283f
```

## patch

### set default SR to upload patches to:

A default SR must exists to receive uploads

```bash
SR1=`xe sr-list name-label=VG${DOM0}a | awk '/^uuid/ { print $NF }'`
POOLUUID=`xe pool-list | awk '/^uuid/ { print $NF }'`
xe pool-param-set default-SR=$SR1 uuid=$POOLUUID
```

### upload patch

```bash
UUIDPATCH=`xe patch-upload file-name=$i`
```

### apply patch

```bash
xe patch-pool-apply uuid=$UUIDPATCH
```

## pool
### join pool

sur le dom0 local, taper la commande pour rejoindre le pool de phy0048
le dom0 doivent avoir le même niveau de patch citrix xen

```bash
xe pool-join master-address=phy0048.exemple.com master-username=root master-password=XXXX
```

#### pb join pool

"The master says the host is not known to it. Perhaps the Host was deleted from the master's database? Perhaps the slave is pointing to the wrong master?"
il faut reconfigurer le host pour joindre à nouveau le pool:

```bash
/etc/init.d/xapi stop
echo master > /etc/xensource/pool.conf
rm -f /var/xapi/state.db*
rm -f /var/xapi/local.db
/etc/init.d/firstboot activate
reboot
```

Puis join pool à nouveau

## backup pool

backup des metadata du pool (uuid, relations, etc...)

```bash
xe pool-dump-database file-name=/root/pool-dump-database.dmp
```

## leave pool

on ejecte le dom0 (host-uuid=14f0e505-dac3-41a1-9a4f-d78fbcc75049) du pool

Attention, tous les SR de ce dom0 seront détruits!!!

```
xe pool-eject host-uuid=14f0e505-dac3-41a1-9a4f-d78fbcc75049
WARNING: Ejecting a host from the pool will reinitialise that host's local SRs.
WARNING: Any data contained with the local SRs will be lost.
The following VDI objects will be destroyed:
VDI: e4886e37-a292-4423-befc-230cf4789f98 (SCSI 1:0:0:0)
VDI: a25e0610-aa00-4617-b9a5-11f8fe46c376 (vm1old.exemple.com-disk)
VDI: 05ce334e-889f-42e2-b297-cd50a0dddb9e (Update: XS72E001)
VDI: b4adec1b-ba9c-4d5a-80c0-535a1e285643 (Update: XS72E009)
VDI: a3a57345-d778-4a87-b0fc-099c4db26d14 (Update: XS72E006)
VDI: 65acc3f7-4249-47a5-b33b-f7cbbc94137c (Update: XS72E004)
VDI: dfcbfe7b-85df-4545-97ae-7505c48efdb7 (Update: XS72E002)
VDI: e0613a18-40d8-409b-8840-daa47718f589 (Update: XS72E005)
VDI: ea02bee4-7415-4ce1-8335-338191590b6f (Update: XS72E008)
VDI: b26c2e69-35ed-4f05-8bbb-06c9e6f0cecb (x115old.exemple.com-disk)
Type 'yes' to continue
yes
Specified host will attempt to restart as a master of a new pool in 10.000 seconds...
```

le dom0 reboote !


## import LVM xen to LVM xenserver

http://discussions.citrix.com/topic/244316-migrating-existing-xen-machines-from-centosrheletc-to-xenserver/
https://support.citrix.com/article/CTX136342

```bash
dd if=/dev/zero of=/dev/sdb bs=1M count=1024
echo "2048,,8e" | sfdisk -u S -q /dev/sdb
#pvcreate /dev/sdb1 --config global{metadata_read_only=0}
#vgcreate VGdata2 /dev/sdb1 --config global{metadata_read_only=0}
uuidgen
a99a7434-bea8-4d96-9b95-30e6311007b1
vgrename VGdata2 VG_XenStorage-a99a7434-bea8-4d96-9b95-30e6311007b1 --config global{metadata_read_only=0}
uuidgen
3f6afbe4-c9c7-470b-8f0a-0e7d1ab539a8
#lvcreate -n LV-3f6afbe4-c9c7-470b-8f0a-0e7d1ab539a8 -L1G VG_XenStorage-a99a7434-bea8-4d96-9b95-30e6311007b1 --config global{metadata_read_only=0}
```

## import VG xen to "SR xenserver"

```bash
xe sr-introduce uuid=a99a7434-bea8-4d96-9b95-30e6311007b1 type=lvm name-label="vgdata2" shared=false
```
a99a7434-bea8-4d96-9b95-30e6311007b1

```bash
xe pbd-create host-uuid=fc13ea06-1900-4700-a7c5-d75d1b961f9c sr-uuid=a99a7434-bea8-4d96-9b95-30e6311007b1 device-config:device=/dev/sdb1
```
e7235fa6-b7cd-c5f8-7113-a2f327867945

```bash
xe pbd-plug uuid=e7235fa6-b7cd-c5f8-7113-a2f327867945
```

Probe the existing SR to determine its UUID:

```bash
xe sr-introduce device-config:<device>=</dev/sdb1>
xe sr-create host-uuid=fc13ea06-1900-4700-a7c5-d75d1b961f9c content-type=user shared=false device-config:device=/dev/sdb1 type=ext
xe sr-probe type=lvmoiscsi device-config:target=<192.168.1.10> \
device-config:targetIQN=<192.168.1.10:filer1> \
device-config:SCSIid=<149455400000000000000000002000000b70200000f000000>
```

Introduce the existing SR UUID returned from the sr-probe command. The UUID of the new SR is returned:

```bash
xe sr-introduce content-type=user name-label=<"Example Shared LVM over iSCSI SR">
shared=true uuid=<valid_sr_uuid> type=lvmoiscsi
```

Create a PBD to accompany the SR. The UUID of the new PBD is returned:

```bash
xe pbd-create type=lvmoiscsi host-uuid=<valid_uuid> sr-uuid=<valid_sr_uuid> \
device-config:target=<192.168.0.1> \
device-config:targetIQN=<192.168.1.10:filer1> \
device-config:SCSIid=<149455400000000000000000002000000b70200000f000000>
```

Plug the PBD to attach the SR:

```bash
xe pbd-plug uuid=<pbd_uuid>
```

Verify the status of the PBD plug. If successful the currently-attached property will be true:

```bash
xe pbd-list sr-uuid=<sr_uuid>
```

## CPU
### show

```bash
xe vm-param-list uuid=8bab4396-7866-60da-46f7-6256e9776d47 | egrep -i "^[[:blank:]]*VCPUs-"
```

### change start / max
field: VCPU values must satisfy: 0 < VCPUs_at_startup ≤ VCPUs_max
```bash
xe vm-param-set VCPUs-max=8 uuid=8bab4396-7866-60da-46f7-6256e9776d47
xe vm-param-set VCPUs-at-startup=4 uuid=8bab4396-7866-60da-46f7-6256e9776d47
```

### cpu hotplug

si start < max, alors on peut ajouter des cpu à la volée. Ici: start=4 max=8, on ajoute 2 cpu en fixant 6 new-vcpus :

```bash
xe vm-vcpu-hotplug vm=vm1.exemple.com new-vcpus=6
```


## CD / ISO

creation dossier local qui va contenir les iso

```bash
mkdir -p /opt/ISO_Store
```

création du sr correspondant:

Pour un host seul dans son pool :

```bash
SRUUID=`xe sr-create name-label=LocalISO type=iso device-config:location=/opt/ISO_Store device-config:legacy_mode=true content-type=iso`
xe sr-scan uuid=$SRUUID
```

Pour un cluster (en supposant que le hostname "linux" du dom0 soit identique au "name-label" XCP-NG/XenServer).
```bash
SRUUID=$(xe sr-create name-label=LocalISO type=iso device-config:location=/opt/ISO_Store device-config:legacy_mode=true content-type=iso host-uuid=$(xe host-list name-label=$(hostname) --minimal))
```


verifier que l'iso fait partie des CD reconnus:

```bash
xe cd-list
```

trouver le premier n° de device dispo sur la vm :

```bash
xe vm-param-list uuid=d99479bb-f541-31c9-666f-d3d300d8d090 | grep allowed-VBD-devices
```

attacher le cd à la VM sur le premier device dispo

```bash
xe vm-cd-add cd-name=debian-stretch-DI-rc2-amd64-netinst.iso vm=puritan.exemple.com device=1
```

vérifier que l'iso est attachée à la VM:

```bash
xe vm-cd-list
```

faire booter la VM sur le cd

```bash
xe vm-param-set uuid=$VMUUID HVM-boot-params:order="d" HVM-boot-policy="BIOS order"
```

## consoles
### VNC

```
DOMID=`list_domains | grep $UUID | awk '{ print $1 }'`

 # xenstore-read /local/domain/$DOMID/console/vnc-port
5901
Last two digits of the above command output will provide you with the VNC port number. In this case it's 1. Use vnc client to connect remotely:
$ vncviewer -via root@XENSERVER_IP localhost:1
```

## firewall

sur xenserver 7.2 : system-config-firewall-tui permet d'activer / désactiver iptables



## Clonage

Dispo uniquement pour les VM basées sur un stockage fichier (raw, pas LVM) et ext. Permet de dupliquer vers une nouvelle instance sur le même SR en écrivant uniquement les diff sur le nouveau disque virtuel.

## Copy

- Opération de copie complète vers nouvelle instance
On peut spécifier le SR de destination

```bash
xe vm-copy vm=vm1.exemple.com new-name-label=vm2.exemple.com sr-uuid=cd424d67-31dc-41d5-7c81-22591a28fef2
```

- Déplacer une VM sur un autre disque à froid
Renommer la vm avec "_orig" à la fin
```bash
xe vm-copy vm=vm3.exemple.com_orig new-name-label=vm3.exemple.com sr-uuid=c6033e83-a175-7858-7080-79934b683947 # sr du nouveau disque
```

- Copie à froid, avec le mapping des storages et network:

```bash
xe vm-migrate live=false remote-master=phy003.exemple.com remote-username=root remote-password=xxxxxx copy=true vm=1f9e4fd5-afd8-04e2-9592-37e7611480ef vif:305ade8c-25e4-5c6f-4e5e-895efefbf9b5=8f6784a6-64d6-cf58-8832-f19f124fefa2 vdi:6802dcfe-1dc3-41a6-ba8e-ff8a4cc7dba5=f5e494e5-cef3-f3b7-d653-bc2ffbcb52c0
```

## Migration

Migration d'une VM à chaud avec xen-orchestra.

Prérequis : avoir un peu plus du triple d'espace disque pour la VM.
Exemple pour une VM de 30Go de disque, il faut au moins 90Go.

Sur https://xen-orchestra.exemple.com/, l'on recherche la VM.
Exemple : https://xen-orchestra.exemple.com/#/vms/e378a0af-90e3-2959-3b67-c1ca3232758c/general

Cliquer sur le bouton migrate. Dans la barre en haut à droite, c'est la 3ème icone avec une flèche.
Sélectionner la machine hôte, le disque et le SR.
Suivre la migration sur https://xen-orchestra.exemple.com/#/tasks

## Import/export

Permet de migrer une VM en CLI sans avoir besoin de 3x l'espace disque (mais nécessite d'éteindre la VM).

https://techblog.jeppson.org/2016/06/quickly-transfer-vms-xenserver-pools/

```bash
xe vm-export uuid=$(xe vm-list name-label=vm1.exemple.com --minimal) filename= | ssh root@phy0047.exemple.com xe vm-import filename=/dev/stdin vm-name=vm1.exemple.com_COPY sr-uuid=1e3b2da0-e270-515a-92e9-b6460a2addd0
```
Il est possible de suivre l'import/l'export avec `xe task-list` ou via Xen Orchestra

## HVM/PV domU
### vieux domU qui n'ont pas de kernel xen:

HVM impossible -> PV boot. Mais pygrub impossible également, il faut passer un kernel présent sur le dom0, et qui a le support xen:

```bash
xe vm-param-set uuid=4e672b85-9c8b-6690-d045-25c00461af91 HVM-boot-policy=""
xe vm-param-set uuid=4e672b85-9c8b-6690-d045-25c00461af91 PV-bootloader=""
xe vm-param-set uuid=4e672b85-9c8b-6690-d045-25c00461af91 PV-kernel="/boot/guest/vmlinuz-2.6.26-2-xen-amd64"
xe vm-param-set uuid=4e672b85-9c8b-6690-d045-25c00461af91 PV-ramdisk="/boot/guest/initrd.img-2.6.26-2-xen-amd64"
xe vm-param-set uuid=4e672b85-9c8b-6690-d045-25c00461af91 PV-args="console=ttyS0 text utf8 root=/dev/xvda2"
```

## solving errors:

### xenopsd

```
message: xenopsd internal error: Memory_interface.Internal_error("(Sys_error \"Broken pipe\")")
```
message observé au démarrage impossible d'une VM. La commande suivante:

```bash
xe-toolstack-restart
```

permet à l'api de re-fonctionner

### The uploaded update package is invalid.

```
info: Invalid signature
```

The above error received due to the files pubring.gpg and secring.gpg were empty  under /opt/xensource/gpg/   directory

You need to Synchronize the ntp time by running the command ntpdate -u "SERVER IP" and restarted the             service 60-import-keys from /etc/firstboot.d/.

For example:

```bash
ntpdate -u "SERVER IP"
/etc/firstboot.d/60-import-keys start
```
