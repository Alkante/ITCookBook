# Module et noyau
## Menu des options noyaux et des modules noyaux
```bash
cd /usr/src/linux-headers-`uname -r` && make menuconfig
```

## decompression initrd
```bash
gunzip < /boot/initrd.img | cpio -i --make-directories
```

## compression initrd
```bash
find ./ | cpio -H newc -o > initrd.cpio
gzip initrd.cpio
mv initrd.cpio.gz initrd.img
```
