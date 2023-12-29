# Streamer

## Description
Utilitaire très simple de manipulation de webcam

## Installer

### Installer streamer
	apt-get update
	apt-get install streamer


### Prendre une photo jpeg
	streamer -f jpeg -o image.jpeg
	streamer /dev/video0 -b 16 -f jpeg -o image.jpeg

```
-b : Nombre de couleur, 15, 16, 24, 32
-f : type d'encodage
-o fichier de sortie
```

### Prendre une video
	streamer -q -c /dev/video0 -f rgb24 -r 3 -t 00:00:05: -o video.avi
	streamer -q -c /dev/video0 -f rgb24 -F stereo -r 3 -t 00:00:05: -o video.avi

```
-r : images/secondes
-t : nombre d'image total (120) ou temps en secondes (00:0::10) == 10 secondes
```
