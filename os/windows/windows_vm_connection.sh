#!/bin/bash

XScale=$(xrandr -q|sed -n 's/.*current[ ]\([0-9]*\) x [0-9]*,.*/\1/p')
YScale=$(( $(xrandr -q|sed -n 's/.*current[ ][0-9]* x \([0-9]*\),.*/\1/p') - 100 ))

User=$1
UrlServeur=$2

### Connection de bureau graphique à distance ###
xfreerdp +clipboard /w:$XScale /h:$YScale /u:"$1" /v:$2:3389 /cert-ignore
