#!/bin/bash

argumento=$1
uncero='0'
dosceros='00'
tresceros='000'

paraencoder=$argumento\*".png"

paraencoderbien="mf://$paraencoder"
outputbien=$argumento"01.avi"

unnum=\?
dosnum=\?\?
tresnum=\?\?\?

#echo $argumento$uncero
#echo $argumento$tresnum".png"

rename $argumento $argumento$uncero $argumento$tresnum".png"
rename $argumento $argumento$dosceros $argumento$dosnum".png"
rename $argumento $argumento$tresceros $argumento$unnum".png"

echo $paraencoderbien

##Consejos de Mario Valle para mejor imagenes cientificas hard-edges
opt="vbitrate=2160000:mbd=2:keyint=132:v4mv:vqmin=3:lumi_mask=0.07:dark_mask=0.2:mpeg_quant:scplx_mask=0.1:tcplx_mask=0.1:naq"

mencoder "$paraencoderbien"  -o $outputbien -ovc lavc -mf fps=12 -lavcopts $opt



