# XCP-NG

## Usuals commands

|    Command   |    description   |
| ------------ | ---------------- |
| `xe vm-list` | List all vm      |
| `xentop`     | `top` for Xcp-ng |

## Upgade disk size
On vm
```bash
shutdown -h now
```
Upgrade on xoa disk size and start VM

On vm
```bash
fdisk /dev/xvda
# remove part and recreate with same signed
pvdisplay # check size
pvresize /dev/xvda1
pvdisplay # check size
vgdisplay # check size, size good
lvdisplay # check size
lvextend -l +100%FREE /dev/VG_debian/LV_root
lvdisplay # check size
df -h /dev/VG_debian/LV_root # check size
resize2fs /dev/VG_debian/LV_root
df -h /dev/VG_debian/LV_root # check size
```
