# VLC
## affichage video webcam simple
	vlc v4l2:///dev/video0

### Avec options
```
vlc v4l2:// :v4l-vdev="/dev/video0" :v4l-adev="/dev/audio2" :v4l-norm=3 :v4l-frequency=-1 :v4l-caching=300 :v4l-chroma="" :v4l-fps=-1.000000 :v4l-samplerate=44100 :v4l-channel=0 :v4l-tuner=-1 :v4l-audio=-1 :v4l-stereo :v4l-width=640 :v4l-height=480 :v4l-brightness=-1 :v4l-colour=-1 :v4l-hue=-1 :v4l-contrast=-1 :no-v4l-mjpeg :v4l-decimation=1 :v4l-quality=100
```

```
cvlc v4l2:///dev/video0 :v4l2-standard= :input-slave=alsa://hw:0,0 :live-caching=300 :sout="#transcode{vcodec=WMV2,vb=800,scale=1,acodec=wma2,ab=128,channels=2,samplerate=44100}:http{dst=:8080/stream.wmv}"
```

```
vlc http://<ip_address_of_webcam_host>:8080/stream.wmv
mplayer http://<ip_address_of_webcam_host>:8080/stream.wmv
```

```
vlc --reset-config
vlc --list
```


## streaming server vlc
```
vlc -vvv v4l2:///dev/video0 --sout '#standard{access=http,mux=ogg,dst=192.168.0.18:8080}'
```


```
vlc -vvv v4l2:// :v4l2-dev=/dev/video0 :v4l2-width=640 :v4l2-height=480 --sout="#transcode{vcodec=h264,vb=800,scale=1,acodec=mp4a,ab=128,channels=2,samplerate=44100}:rtp{sdp=rtsp://:8080/live.ts}" -I dummy
```


```
vlc v4l2:// :v4l2-dev=/dev/video0 :v4l2-width=640 :v4l2-height=480 --sout "#transcode{vcodec=mpeg4,acodec=mpga,vb=800,ab=128}:udp{dst=127.0.0.1,port=8080,mux=ts}"
```

```
vlc "v4l2://" --v4l-vdev="/dev/video0" --v4l-adev="/dev/null" --sout #transcode{vcodec=theo,vb=256}:standard{access=http,mux=ogg,dst=:1234}" -I dummy
```


```
vlc v4l2:// :v4l2-vdev="/dev/video0" --sout '#transcode{vcodec=x264{keyint=60,idrint=2},vcodec=h264,vb=400,width=368,heigh=208,acodec=mp4a,ab=32,channels=2,samplerate=22100}:duplicate{dst=std{access=http{mime=video/x-ms-wmv},mux=asf,dst=:8082/stream.wmv}}' --no-sout-audio &
```



```
cvlc v4l2:// :v4l2-vdev="/dev/video0" --sout '#transcode{vcodec=h264,vb=400,acodec=mp4a,ab=32,channels=2,samplerate=22100}:duplicate{dst=std{access=http{mime=video/x-ms-wmv},mux=asf,dst=:8082/stream.wmv}}' --no-sout-audio
```

```
vlc v4l2:// --v4l-vdev="/dev/video0" --sout #transcode{vcodec=h264,vb=256}:standard{access=http,mux=ogg,dst=:1234}" -I dummy
```



## SERVEUR OK
```
cvlc v4l2:// :v4l2-vdev="/dev/video0" --sout '#transcode{vcodec=h264,vb=256}:standard{access=http,mux=ts,dst=:1234}' -I dummy
```
## CLIENT OK
```
vlc http://127.0.0.1:1234

```

## Chaine d'encodage
```
#transcode{<chaine>}
vcodec : Video Codec : [h264,mpeg4,x264]
vb : Video Bit Rate :[800,400]
acodec : Audio Code : [mp4a,mpga]
ab : Audio Bit Rate : [32,1208]
channels : Nombre de cannaux audio : [2]
samplerate : Drequence audio : [22100]
scale : Taille Video : [1]
width : largeur : [368]
heigh : hauteur : [208]



RTSP/RTP
RTSP/SRTP


RTSP  : (eal Time Streaming Protocol) permet la lecture et la pause et à besoin d'un tranport tel que  RTP ou RDT
RTP   : (Real-Time Transport Protocol)  possède un canal retour pour avoir des information sur l'état du service et à supporte le multicast (pas de chiffrement en natif)
      RTP est la version normalisée internationale de  l'ancien protocole propriétaire RDP (initialement créé pour Real Player)
SRTP  : (acronyme de Secure Real-time Transport Protocol) est le pendant sécurisé (chiffré) de RTP.

RTMP: the 'original' protocol uses TCP port 1935
RTMPS: the RTMP protocol over a secure SSL connection using HTTPS
RTMPE: an encrypted version of RTMP developed by Adobe
RTMPT: the RTMP protocol encapsulated within HTTP requests to traverse firewalls. It is a cleartext protocol using TCP ports 80 and 443 to bypass corporated firewalls. The encapsulated session may carry plain RTMP, RTMPS, or RTMPE packets within.

```




# Direct video
```
vlc -I dummy v4l2:///dev/video0 --video-filter scene --no-audio --scene-path /home/stoppal/test --scene-prefix image_prefix --scene-format png vlc://quit --run-time=1
```
