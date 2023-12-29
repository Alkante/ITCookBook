# mplayer
## Definision
MPlayer est un lecteur multimédia pour GNU/Linux. Il prend en charge la plupart des formats MPEG/VOB, AVI, ASF/WMA/WMV, RM, QT/MOV/MP4, OGG/OGM, VIVO, FLI, NuppelVideo, yuv4mpeg, FILM et RoQ, gérés par plusieurs codecs natifs et par des codecs binaires. Vous pouvez regarder des VideoCD, SVCD, DVD, 3ivx, DivX 3/4/5 et même des films WMV.


mplayer est en complément de mencoder (désigné pour l'encodage)

## Serveur
```
cat /dev/video0 | nc -l 1234
```
## client
```
nc videohost 1234 | mplayer tv://device=/dev/stdin
```

## Standar
```
mplayer tv://device=/dev/stdin
```
ou
```
mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0 -fps 15 -vf screenshot
```



## Raccourci
```
droite et gauche 	recule/avance de 10 secondes
haut et bas 	recule/avance d'une minute
pgup et pgdown 	recule/avance de 10 minutes
< et > 	recule/avance dans la liste de lecture
[ et ] 	diminue/augmente la vitesse par pas de 10%
{ et } 	divise/double la vitesse
backspace 	retour à la vitesse normale
p ou ESPACE 	met le film en pause (n'importe quelle touche pour redémarrer)
q ou ESC 	stoppe la lecture et quitte
+ et - 	ajuste le décalage audio de +/- 0.1 seconde
/ et * 	réduit / augmente le volume
m 	coupe le son (mute)
f 	plein-écran
o 	bascule entre les états d'affichage a l'écran (OSD) : aucun / durée écoulée / durée écoulée + durée totale
v 	bascule les modes d'affichage des sous-titres
j 	change la langue des sous titres (DVD ou video avec plusieurs langues)
# 	change de piste audio (DVD ou video avec plusieurs langues)
a 	bascule l'alignement des sous titres : haut/milieu/bas
r et t	modifie la position verticale des sous-titres
z et x 	ajuste le décalage des sous titres de +/- 0.1 seconde
y et g 	saute au prochain/précédent sous-titre
1,2,3 etc 	réglage de contraste, luminosité… Uniquement avec la sortie vidéo XV
```

## Utilisation simple, lancer un film
	mplayer film1.avi

## Lancer le lecteur dvd
	mplayer dvd://

## Lancer le lecteur dvd avec navigation sourie
	mplayer -mouse-movements dvdnav://

## Changer taille des sous titre
	mplayer -sub fichier.srt -subfont-text-scale 6 video.avi

## Déplacer les sous titres
	mplayer -vf expand=::0:0::4/3 mon.avi

## Afficher flux
	mplayer http://blablabla

## Sauvegarder flux
	mplayer -dumpstream rtsp://blablabla -dumpfile ton_fichier.ogg

## Enlever les bandes noire et lancer la video
	mplayer monfilm.avi -vf cropdetect
resulat [CROP] Crop area: X: 6..607 Y: 94..503 (-vf crop=592:400:12:100)
	monfilm.avi -vf crop=592:400:12:100

## Modifier volume
	mplayer monfilm.avi -softvol


## Take 1 photo
mplayer -vo png -frames 1 tv://
