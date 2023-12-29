# Install XenServer

## Hardware

Minimum 45Gb

### Virtualbox
dique minimi 45 Gb sinon il crash

- F1-Standard
  - Enter: Install/upgrade
- F2-Advancer
  - Enter: Install/upgrade
  - no-serial Enter: Install/upgrade without serial
  - safe Enter: Install/upgrade in safe mode
  - multipath Enter: Install/upgrade in mutiparted root disk
  - shell Enter: boot in shell
  - memtest Enter: Start memtest


- Select Keymap : Sélectionner le clavier


## Processus d'installation

- Select keymap:
  - **fr**
- Welcome to XenServerSetup
  - load device [F9]
  - advanced [F10]
  - **OK**
  - Reboot
- End User Licence Agreement
  - **Accept EULA**
  - Back
- (flag issue) System Hardware
  - **OK**
  - Back
- Virtual Machine Storage
  - [*] sda - 60Gb Data
  - [ ] Enable provisionning .. Xen Desktop
  - **OK**
  - Back
- Select installation Source
  - **Local Media**
  - HTTP or FTP
  - NFS
  - **OK**
  - Back
- Verify installation Source
  - **Skip...**
  - Verify
  - **OK**
  - Back
- Set Password
  - Password : **MyPassword**
  - Confirm : **MyPassword**
  - **OK*
  - Back
- Net Working
  - (*) automatic configuration (DHCP)
  - ( ) Static
    - IP Adress : ...
    - Subnet mask : ...
    - Getwat : ...
  - **OK**
  - Back
- Host Name ans DNS Configuration
  - ( ) Automatically set via DHCP
  - (*) Mannualy specified: **MyHostname**
  - (*) Automatically set via DHCP
  - ( ) Mannualy specified:
    DNS1: ...
    DNS2: ...
    DNS3: ...
- Select Time Zone
  - **Europe -> Paris**
- System Time
  - **Using NTP**
  - Manual time Entry
- NTP Configuration
  - (*) NTP is configured by my DHP
  - Manual:
    NTP1: ...
    NTP2: ...
    NTP3: ...
- Confirm Installation
  - **Install XenServer**
  - Back



## Network timeout
### dell r440/430
pxe xenserver 7.2
probleme de dhcp avec la carte réseau broadcom 5720:
- plugger l adaptateur usb/rj45
- on boote en pxe avec eth0, on choisit OS/xenserver7.2
- la machine télécharge les noyaux et les monte en ram
- pendant "configuring network", switcher sur tty2 (ctrl + alt + F2) et prendre une IP en dhcp sur l adapatateur usb/rj45:
- chercher l'interface de l'usb
```
ip a
```
- relancer du dhclient
```
dhclient eth2
ip a
pkill -9 -f dhclient
```
- sur tty1 l'install se poursuit (ctrl + alt + F1)
