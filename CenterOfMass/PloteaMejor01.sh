#!/bin/bash

##ploteando un chingo

dataname=$1
outname=`basename $1 .dat`.png
#umbral=30
#usando='using 1:2:(criterio($3))'

echo $outname

gnuplot <<EOF

set xr[0.5:256.5]
set yr[0.5:256.5]
set cbr[-10:10]
set size ratio -1

set term pngcairo size 400,400 fontscale 0.75
unset key
#set palette rgbform 33,13,10
set palette defined (0 "#000077", 1 "#0000FF", 2 "white", 3 "#FF0000", 4 "#770000")
#set palette defined (0 "white", 1 "#0000FF", 2 "black")
set out "$outname"
criterio(x)=(abs(x)<60)?0:x
plot "$dataname" matrix  w image
set out

EOF
