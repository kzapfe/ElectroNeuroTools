#!/bin/bash

##ploteando un chingo

dataname=$1
outname=`basename $1 .dat`.png
#umbral=30
#usando='using 1:2:(criterio($3))'

echo $outname

gnuplot <<EOF

set xr[0:64]
set yr[0:64]
set cbr[-120:120]
set size ratio -1

set term pngcairo size 300,300 fontscale 0.5
unset key
#set palette defined (0 "#000077", 1 "#0000FF", 2 "yellow", 3 "#FF0000", 4 "#990000")
set out "$outname"
criterio(x)=(abs(x)<60)?0:x
plot "$dataname" matrix  w image
set out

EOF
