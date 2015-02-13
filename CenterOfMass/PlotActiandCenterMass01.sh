#!/bin/bash

##ploteando un chingo con varios archivos

datosfondobasename="MediasFiltradaLocal350-"
numero=$1
dataname=$datosfondobasename$numero".dat"


outname=`basename $dataname .dat`.png
index="::::$numero"

echo $outname

gnuplot <<EOF

set xr[-0.50:63.5]
set yr[-0.5:63.5]
set cbr[-12:12]
set size ratio -1
set pointsize 0.5
unset key
set term pngcairo size 400,400 fontscale 0.75

set palette defined (0 "#000077", 1 "#0000FF", 2 "white", 3 "#FF0000", 4 "#990000")
#set palette defined (0 "white", 1 "#0000FF", 2 "black")
set out "$outname"
plot "$dataname" matrix  w image, "DatosCMNegativo01.dat" usi 2:1 every $index w lp ls 7 lc rgb "blue", "DatosCMPositivo01.dat" usi 2:1 every $index w lp ls 7 lc rgb "red"
 
set out

EOF
