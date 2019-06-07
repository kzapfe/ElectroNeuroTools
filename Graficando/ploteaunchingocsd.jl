using HDF5
using PyPlot


nombre="/home/karel/BRWFiles/Eduardo/Control/Completo_193005_CTRL_Rtn_EMAD_01_subdatos.h5"

arxivo=h5open(nombre)
elementos=names(arxivo)

csd=read(arxivo["CSDALindenberg"])
(xmin, xmax)=read(arxivo["cols"])
(ymin, ymax)=read(arxivo["rengs"])
freq=read(arxivo["freq"])

limites=150
#for interpol in lista


for n =10^5:25:2*10^5

    figure(figsize=(2.5,2.5))
    ejemplo=csd[:,:,n]
    tiempo=round(Int,n/freq)

    title("t = $tiempo ms")
    
   
    imshow(ejemplo, origin="lower",
           cmap="coolwarm", interpolation="nearest",
           vmin=-limites, vmax=limites,
           extent=[xmin,xmax,ymin,ymax]) 
  

    nomine="csd_eduardo_193005_control_01_$n.png"

    savefig(nomine, dpi=92)
    close()
    print(" n = ", n, "; ")
end
    
