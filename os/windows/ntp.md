# NTP
## par defaut
local time

pour rétablir localtime:
```
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation]
"RealTimeIsUniversal"=-
```

## dualboot ubuntu/windows
si on veut aligner les 2 os, il faut modifier l'un des 2. Si on veut modifier windows, on passe en UTC:
```
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation]
“RealTimeIsUniversal”=dword:00000001
```
