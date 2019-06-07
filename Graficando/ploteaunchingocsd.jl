using HDF5
using Plots
gr(show=false)

nombre="/home/karel/BRWFiles/Eduardo/Control/Completo_193005_CTRL_Rtn_EMAD_01_subdatos.h5"

arxivo=h5open(nombre)
elementos=names(arxivo)

csd=read(arxivo["CSDALindenberg"])
(xmin, xmax)=read(arxivo["cols"])
(ymin, ymax)=read(arxivo["rengs"])
freq=read(arxivo["freq"])

limites=150
#for interpol in lista


for n =115000:25:2*10^5

    ejemplo=csd[:,:,n]
    tiempo=round(Int,n/freq)
    
    p=plot(figsize=(2.5,2.5), title="t= $tiempo ms", show=false)

    xxs=xmin:xmax
    yys=ymin:ymax
    heatmap!(xxs, yys, ejemplo,
                color=:bluesreds, aspectratio=1, clims=(-limites,limites)) 
    zlims!(-15,15)

    nomine="csd_eduardo_193005_control_01_$n.png"

    savefig(p, nomine)
    
    print(" n = ", n, "; ")
end
    
