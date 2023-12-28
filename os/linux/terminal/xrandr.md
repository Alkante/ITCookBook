# xrandr
## Afficher les connexions des écrans, les résolutions disponibles et la résolution courante
	xrandr

## Changer la résolution
	xrandr -s 1440x900

	xrandr --output HDMI --pos 1920x0 --mode 1440x900 --rate 60

Ainsi, nous pouvons en déduire l'effet des paramètres.

    --output détermine l'écran à configurer
    --pos positionne l'écran dans l'espace virtuel, dans cet exemple l'écran sera décalé de 1920 px vers la droite et de 0 vers le bas. Soit tout simplement à droite de l'écran principal (optionnel)
    --mode détermine le mode utilisé (optionnel)
    --rate la fréquence de l'écran, optionnel : par défaut c'est la plus grande valeur qui est appliquée.


## Rotation d'écran
	xrandr --output VGA-0 --rotate left
	xrandr --output VGA-0 --rotate right
	xrandr --output VGA-0 --rotate normal
	xrandr --output VGA-0 --rotate inverted

## Ajouter une résolution non présente
### Demander les parametre de la résolution voulu si elle est posible
	gtf 1920 1090 60
Cette command retourne
	Modeline "1920_1080_60.00" 172.80 1920 2040 2248 2576 1080 1081 1118 +HVsync +Vsync
### Ajouter le mode
	xrandr --newmode "1920_1080_60.00" 172.80 1920 2040 2248 2576 1080 1081 1118 +HVsync +Vsync



## Arandr : interface graphique xrandr
	apt-get install arandr




## Tailles d'écran et de flux video commun

### Écran 16/9
```
640  x 360
1024 x 576
1280 x 720   720p, HD 720, HD
1600 x 900   900p, HD 900, HD
1920 x 1080  1080p, HD 1080, Full HD
2560 x 1440
3840 × 2160  4K
```

### Écran 8/5
```
640  x 360
1024 x 576
1280 x 720
1600 x 900
1920 x 1080
2560 x 1440
3840 x 2160
```

### Écran 3/2
```
300  x 200
360  x 240
450  x 300
540  x 360
600  x 400
720  x 480
864  x 576
900  x 600
1080 x 720
1152 x 768
1281 x 854
1350 x 900
1440 x 960
1575 x 1050
1800 x 1200
2160 x 1440
2304 x 1536
2400 x 1600
2561 x 1707
2880 x 1920
```



### Écran 4/3
```
320  x 240 (QVGA)
320  x 480 (HVGA)
400  x 300
480  x 360
640  x 480 (VGA)
768  x 576 (PAL)
800  x 600 (SVGA)
960  x 720
1024 x 768 (XGA)
1200 x 900
1280 x 960
1400 x 1050 (SXGA)
1600 x 1200 (UXGA)
1920 x 1440
2048 x 1536 (QXGA)
2276 x 1707
2560 x 1920
```
