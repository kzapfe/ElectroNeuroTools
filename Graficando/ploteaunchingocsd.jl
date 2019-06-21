using HDF5
using PyPlot


nombre=ARGS[1]

arxivo=h5open(nombre)
elementos=names(arxivo)

csdlind=read(arxivo["CSDALindenberg"])
(alto,ancho,nmax)=size(csdlind)
#(xmin, xmax)=read(arxivo["cols"])
#(ymin, ymax)=read(arxivo["rengs"])
freq=read(arxivo["freq"])

(mincsd, maxcsd)=extrema(csdlind)
limites=min(abs(mincsd),abs(maxcsd))/1.5

#for interpol in lista


for n =1:nmax

    xlim(0,ancho+1)
    ylim(0, alto+1)
    
    fafa=figure(figsize=(4,4))
    ejemplo=csdlind[:,:,n]
    tiempo=round(Int,n/freq)

    title("t = $tiempo ms")
    
   
    imshow(ejemplo, origin="lower",
           cmap="coolwarm", interpolation="nearest",
           vmin=-limites, vmax=limites,extent=[0.5,ancho+0.5,0.5,alto+0.5])

    nstring=lpad(n, 8, "0")
    
    nomine="csd_eduardo_193005_control_01_$nstring.png"

    savefig(nomine, dpi=92)
    close(fafa)
    if mod(n,10)==0
        print(" n = ", n, "; ")
    end
end
    
