#!/bin/bash

directoriolugar="/media/discogrande/estimulacion_control2/"

for i in $(ls $directoriolugar/*.brw);
do
    j=$(basename $i .brw)
    julia SeparaActividadyPromedia.jl $j
    echo "Uno mas listo"
    echo "\n"
 
done
	 
