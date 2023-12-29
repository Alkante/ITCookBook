# Install xenserver
## CD Boot xenserver 7
```
boot normal : no key ou F1
azerty fr
welcome : OK (no F9 / no F10)
EULA: Accept EULA
Warning : preceding install : OK
Select primary disk : /dev/sda
Virtual Machine Storage : decocher tout
Warning : no media for virtual machine : OK
Select Installation Source : local media
Supplemental Packs : No
Verify Installation Source : skip
Root Password
Networking: IP / hostname / DNS
TimeZone: Europe / Paris
System Time : Using NTP
NTP Configuration : ntp.exemple.com
Install xenserver
```


## post install
Empêcher le renommage des interfaces réseau (https://www.certdepot.net/rhel7-restore-old-network-interface-name/)
```
sed -i '/plymouth.ignore-serial-consoles/ s/$/ net.ifnames=0 biosdevname=0/' /boot/grub/grub.cfg
reboot
```

## patches xs7.0
```
cd /usr/local/src
wget "https://support.citrix.com/supportkc/filedownload?uri=/filedownload/CTX214305/XS70E004.zip" -O XS70E004.zip
unzip -q XS70E004.zip
xe patch-upload file-name=XS70E004.xsupdate
xe patch-pool-apply uuid=561b0a27-f37e-4a91-9823-56c8597f8161
wget "https://support.citrix.com/supportkc/filedownload?uri=/filedownload/CTX213770/XS70E002.zip" -O XS70E002.zip
unzip -q XS70E002.zip
xe patch-upload file-name=XS70E002.xsupdate
xe patch-pool-apply uuid=fea1e02a-8b66-4fd9-885b-065b9762acf4
wget "https://support.citrix.com/supportkc/filedownload?uri=/filedownload/CTX213769/XS70E003.zip" -O XS70E003.zip
unzip -q XS70E003.zip
xe patch-upload file-name=XS70E003.xsupdate
xe patch-pool-apply uuid=81ae90d4-9258-47d4-9c66-2d22a162f15d
wget "https://support.citrix.com/supportkc/filedownload?uri=/filedownload/CTX215416/XS70E005.zip" -O XS70E005.zip
unzip -q XS70E005.zip
xe patch-upload file-name=XS70E005.xsupdate
xe patch-pool-apply uuid=6de9dcfd-6c34-415e-a765-4f79689a74ef
wget "https://support.citrix.com/supportkc/filedownload?uri=/filedownload/CTX215899/XS70E010.zip" -O XS70E010.zip
unzip -q XS70E010.zip
xe patch-upload file-name=XS70E010.xsupdate
xe patch-pool-apply uuid=ea9df922-bcae-4562-85d8-a60a8eac2c55
wget "https://support.citrix.com/supportkc/filedownload?uri=/filedownload/CTX216113/XS70E009.zip" -O XS70E009.zip
unzip -q XS70E009.zip
xe patch-upload file-name=XS70E009.xsupdate
xe patch-pool-apply uuid=490e4de3-58e7-49fc-ac87-ae4919b54a6b
wget "https://support.citrix.com/supportkc/filedownload?uri=/filedownload/CTX219284/XS70E013.zip" -O XS70E013.zip
unzip -q XS70E013.zip
xe patch-upload file-name=XS70E013.xsupdate
xe patch-pool-apply uuid=a830eb90-25df-46bd-89ce-88caf47637f4
wget "https://support.citrix.com/supportkc/filedownload?uri=/filedownload/CTX218332/XS70E016.zip" -O XS70E016.zip
unzip -q XS70E016.zip
xe patch-upload file-name=XS70E016.xsupdate
xe patch-pool-apply uuid=fef46734-9f68-458c-8fd6-0f6f3b53d7e4
wget "https://support.citrix.com/supportkc/filedownload?uri=/filedownload/CTX218899/XS70E019.zip" -O XS70E019.zip
unzip -q XS70E019.zip
xe patch-upload file-name=XS70E019.xsupdate
xe patch-pool-apply uuid=eb384407-58cf-4993-950c-b6f23f083c2e
wget "https://support.citrix.com/supportkc/filedownload?uri=/filedownload/CTX218902/XS70E021.zip" -O XS70E021.zip
unzip -q XS70E021.zip
xe patch-upload file-name=XS70E021.xsupdate
xe patch-pool-apply uuid=59e838ef-edb4-40e2-8835-d2c5e0de9c67
wget "https://support.citrix.com/supportkc/filedownload?uri=/filedownload/CTX219203/XS70E022.zip" -O XS70E022.zip
unzip -q XS70E022.zip
xe patch-upload file-name=XS70E022.xsupdate
xe patch-pool-apply uuid=cedec355-3a8c-4286-aedc-fa49bd03225d
```
