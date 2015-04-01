#!/bin/bash

##ploteando un chingo con varios archivos

datosfondobasename="LaplacianFilteredSpaceTime-"
datosCMbasename="CMNegLapla-"
numero=$1
dataname=$datosfondobasename$numero".dat"
datosCMNeg=$datosCMbasename$numero".dat"
#usandonegativo='(-$2/4.):(-$1/4):($3/500.)'
#usandopositivo='($2/4.):($1/4):($3/500.)'
#usandomatrix='($1/4.):($2/4):($3)'

usandonegativo='($1):($2):(abs($3*0.01))'
usandopositivo='($1):($2):($3*0.01)'
usandomatrix='($1):($2):($3)'

outname=`basename $dataname .dat`.png


#segundos=`echo "scale=10; $numero)/7022.0" | bc`
#titulo="Repolarizacion, Centro de Masa, $segundos"
#croac='$titulo'

echo $outname

gnuplot <<EOF

set xr[-0.50:63.5]
set yr[-0.5:63.5]
set cbr[-10:10]
set size ratio -1
set pointsize 0.35
unset key
set term pngcairo size 600,600 fontscale 0.75
segundos=$numero
titulo=sprintf("Centre of Mass,  frame: g%d ", segundos)
set title titulo
set palette defined (0 "#000077", 1 "#0000FF", 2 "white", 3 "#FF0000", 4 "#990000")
unset cbtics
set label "Source" at graph 1.1, 0.98
set label "Sink" at graph 1.1, 0.02
set style fill solid noborder
#set palette defined (0 "white", 1 "#0000FF", 2 "black")
set out "$outname"
plot "$dataname" using $usandomatrix matrix  w image, "$datosCMNeg" usi $usandonegativo  w circles 
set out

EOF
