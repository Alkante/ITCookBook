# BIOS
## ASR Status (Automatic Server Recovery)

What is ASR's function?
ASR is an HP-provided capability enabling system reboots if the hardware determines that the operating system has become unresponsive. This can reduce downtime to business-facing applications.

How does it work?
ASR is comprised of two components on an ESX host: A hardware heartbeat timer and a Health Monitor running in the operating system. The heartbeat timer, by default, is set to 10 minutes and begins countdown from there. The Health Monitor is responsible for frequently reloading the timer. On ESX hosts, this agent runs in the Service Console and is usually installed as part of HP Insight Manager.

If the timer reaches zero, ASR assumes that the operating system has become unresponsive and reboots the server.

## ASR Timeout
Cf. ASR : Permet de régler le temps de l'ASR (10 par defaut)



## Thermal Shutdown
Eteint le serveur si il dépasse un certaine temperature


## Wake-On LAN
Permet d'allumer le PC via le réseau (à distance)


## POST F1 Prompt
Make delay before boot

## Power Button
Activate/disable Power Button function


## Automatique Power-On



## Power-On Delay
No Delay/Random Delay

## Set Power-On Password

## Set Admin Password

## Bios Serial Console & EMS
