# Convert xmdomU to xedomU
Ajout d'un second disque à la VM qui sera un disque "normal" : partition, mbr (nécessaire dans xencenter)

Il contiendra une petite parition dans laquelle on installera grub et /boot

Modification dans un second temps après la migration pour supporter le PVHVM et non plus le PV

## Avant migration
#### Dans le dom0
```
DOMU="vm1.exemple.com"
VGDISK="VG0019"
#creation du LVM supplémentaire
lvcreate -n "${DOMU}-boot" -L500M "${VGDISK}"
echo "2048,,83" | sfdisk --force -u S -q "/dev/${VGDISK}/${DOMU}-boot"
partprobe
kpartx -av "/dev/${VGDISK}/${DOMU}-boot"
mkfs.ext3 "/dev/mapper/${VGDISK}-${DOMU}--boot1"
kpartx -dv "/dev/${VGDISK}/${DOMU}-boot"
#ajout à la volée du disque dans le domU:
xm block-attach "${DOMU}" "phy:/dev/${VGDISK}/${DOMU}-boot" xvdb w
#ajout du disque dans la conf du domU:
sed -i "/-swap,xvda1,w',/ a\                  'phy:/dev/${VGDISK}/${DOMU}-boot,xvdb,w',"  "/etc/xen/${DOMU}.cfg"
xl reboot ${DOMU}
```

#### Dans le domU
###### install xenserver tools
```
cd /usr/local/src
wget  http://launchpadlibrarian.net/365794438/xe-guest-utilities_7.10.0-0ubuntu1_amd64.deb
dpkg -i xe-guest-utilities_7.10.0-0ubuntu1_amd64.deb
```

###### Install grub dans le nouveau disque
```
[ -d /boot ] && mv /boot /boot.bak && mkdir /boot
echo /dev/xvdb1       /boot           ext3    defaults        0       2
mount /boot
mkdir /boot/grub
apt-get -y install grub-legacy
apt-get -y install linux-image-amd64
update-grub
cp /etc/fstab /etc/fstab.xm
sed -i 's/xvda1/xvdc/
s/xvda2/xvdb/
s/xvdb1/xvda1/' /etc/fstab
```
vérifier les lignes "root" dans /boot/grub/menu.lst , elles doivent être sous la forme (hdX,Y)


#### Dans le dom0
```
sed -i "/-boot/d"  "/etc/xen/${DOMU}.cfg"
sed -i "/disk        = \[/ a\                  'phy:/dev/${VGDISK}/${DOMU}-boot,xvdb,w',"  "/etc/xen/${DOMU}.cfg"
sed -i '/ramdisk/ s/^/#/
/kernel/ s/^/#/
/root/ s/^/#/
/ramdisk/ a\bootloader = "/usr/lib/xen-4.4/bin/pygrub"'  "/etc/xen/${DOMU}.cfg"
sed -i 's/xvda1/xvdc/
s/xvda2/xvdb/
s/xvdb1/xvda1/' /etc/xen/${DOMU}.cfg
xm shutdown ${DOMU}
xm create /etc/xen/${DOMU}.cfg
```
Vérifier que le domU est OK

#### Migration à partir du dom0
Sur le dom0 source
```
xm shutdown ${DOMU}
cd /usr/local/src
wget http://www-archive.xenproject.org/files/xva/xva.py -O xva.py
chmod +x xva.py
./xva.py -c "/etc/xen/${DOMU}.cfg" -n "${DOMU}" -s vm2.exemple.com --username=root --password="XXXXX" --no-ssl
```

## Après migration
#### dans le dom0
```
DOMU="vm1.exemple.com"
xe vm-start vm=${DOMU}
```
#### dans le domU
```
apt-get install grub-pc
sed -i '/GRUB_TERMINAL/d ; /GRUB_SERIAL_COMMAND/d ; /GRUB_CMDLINE_LINUX_DEFAULT/d' /etc/default/grub
echo "GRUB_TERMINAL=serial
GRUB_SERIAL_COMMAND=\"serial --speed=38400 --unit=0 --word=8 --parity=no --stop=1\"
GRUB_CMDLINE_LINUX_DEFAULT=\"console=tty1 console=ttyS0,38400n8\"" >> /etc/default/grub
update-grub
shutdown -h now
```

#### dom0 destination
```
UUID=`xe vm-list |sed -n '/'${DOMU}'/{G;1!p;};h'|grep uuid |sed 's/^uuid ( RO)[ ]*: \(.*\)/\1/'`
UUIDETH1=`xe pif-list |grep -A 3 eth1 |grep network-uuid |sed 's/^[ ]*network-uuid ( RO): \(.*\)/\1/'`
xe vm-param-set uuid=${UUID}  HVM-boot-policy="BIOS order" PV-args="console=ttyS0 text utf8" PV-bootloader="platform:hvm_serial=pty other-config:hvm_serial=pty"  other-config:auto_poweron=true
xe vif-create vm-uuid=${UUID}  network-uuid=${UUIDETH1}  mac=random device=1
```
