# ls système
## lsblk
```bash
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0  59,6G  0 disk 
└─sda1   8:1    0  59,6G  0 part 
sdb      8:16   0 931,5G  0 disk 
├─sdb1   8:17   0 390,6G  0 part 
├─sdb2   8:18   0 443,2G  0 part 
├─sdb3   8:19   0  37,3G  0 part /
├─sdb4   8:20   0     1K  0 part 
├─sdb5   8:21   0     2G  0 part [SWAP]
└─sdb6   8:22   0  58,4G  0 part /home
sr0     11:0    1  1024M  0 rom 
```

## lspci
```bash
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5)
00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b5)
00:1c.4 PCI bridge: Intel Corporation 82801 PCI Bridge (rev b5)
00:1c.5 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 6 (rev b5)
00:1c.6 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 7 (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation P67 Express Chipset Family LPC Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
01:00.0 VGA compatible controller: NVIDIA Corporation GF114 [GeForce GTX 560 Ti] (rev a1)
01:00.1 Audio device: NVIDIA Corporation GF114 HDMI Audio Controller (rev a1)
03:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)
04:00.0 PCI bridge: ASMedia Technology Inc. ASM1083/1085 PCIe to PCI Bridge (rev 01)
05:02.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller (rev c0)
06:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)
07:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
```


## lscpu
```bash
Architecture :        x86_64
Mode(s) opératoire(s) des processeurs : 32-bit, 64-bit
Boutisme :            Little Endian
Processeur(s) :       4
Liste de processeur(s) en ligne : 0-3
Thread(s) par cœur : 1
Cœur(s) par socket : 4
Socket(s) :           1
Nœud(s) NUMA :       1
Identifiant constructeur : GenuineIntel
Famille de processeur : 6
Modèle :             42
Révision :           7
Vitesse du processeur en MHz : 1599.984
BogoMIPS :            6585.40
Virtualisation :      VT-x
Cache L1d :           32K
Cache L1i :           32K
Cache L2 :            256K
Cache L3 :            6144K
Nœud NUMA 0 de processeur(s) : 0-3
```