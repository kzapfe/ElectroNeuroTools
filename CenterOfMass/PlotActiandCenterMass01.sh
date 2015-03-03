#!/bin/bash

##ploteando un chingo con varios archivos

datosfondobasename="GaussSmoothSpaceandTime01-"
numero=$1
dataname=$datosfondobasename$numero".dat"


outname=`basename $dataname .dat`.png
index="::::$numero"

#segundos=`echo "scale=10; $numero)/7022.0" | bc`
#titulo="Repolarizacion, Centro de Masa, $segundos"
#croac='$titulo'

echo $outname

gnuplot <<EOF

set xr[-0.50:63.5]
set yr[-0.5:63.5]
set cbr[-70:70]
set size ratio -1
set pointsize 1.0
unset key
set term pngcairo size 400,400 fontscale 0.75
segundos=$numero/7022.0
titulo=sprintf("Centro de Masa %f seg.", segundos)
set title titulo
set palette defined (0 "#000077", 1 "#0000FF", 2 "white", 3 "#FF0000", 4 "#990000")
#set palette defined (0 "white", 1 "#0000FF", 2 "black")
set out "$outname"
plot "$dataname" matrix  w image, "DatosCMPositivo.dat" usi 2:1:3 every $index w lp ls 7 palette 
 
set out

EOF
