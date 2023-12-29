# Vmware

<!-- TOC -->

- [Vmware](#vmware)
    - [Context](#context)
    - [Convertion](#convertion)

<!-- /TOC -->

## Context

Vmware ext un logiciel de vituralisation fonctionnent exclusivement sous windwos

Vmware utilise nativement les images disques .vmdk ainsi que les descriptifs machine virtuel .ova et .ovf

Différence entre ovf et ova

ovf est un dossier contenant :
- le manifest (.mf)
- le la machine virtuel (.vhd ou n.vmdk)

ova une fichier zip du dossier ovf.
Les fichier ova on besion d'etre décompressé en ovf pour pouvoir etre utilisé.

## Convertion

Les convertions et génération d'ova te d'ovf se font avec le logiciel OVFTooL de VMware.
Cette outils est instalable sur windwos, linux et mac sous condition d'inscription.





| Actions | Commandes |
|-------- |---------- |
| .vmdk generate .vmx | Créé une machien virtuel sous VMware, puis modifier la pour charger le disque .vmdk |
| .vmx to ova | ``````& 'C:\Program Files\VMware\VMware OVF Tool\ovftool.exe' 'image.vmx' 'image.ova'`````` |
