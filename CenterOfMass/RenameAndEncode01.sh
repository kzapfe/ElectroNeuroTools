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

mencoder "$paraencoderbien"  -o $outputbien -ovc lavc -mf fps=12


