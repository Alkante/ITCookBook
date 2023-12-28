# align RTC with:
## local:
local time
pratique dans un dualboot avec windows:
```
timedatectl set-local-rtc 1
```
déconseillé par ubuntu : The system is configured to read the RTC time in the local time zone. This mode can not be fully supported.
```
timedatectl | grep TZ
 RTC in local TZ: yes
```
## utc

```
timedatectl set-local-rtc 0
```

# hardware clock

## show
```
hwclock --show
```

## set hardware clock from system clock

The following sets the hardware clock from the system clock. Additionally it updates /etc/adjtime or creates it if not present. See hwclock(8) section "The Adjtime File" for more information on this file as well as the #Time skew section.
```
hwclock --systohc
```
