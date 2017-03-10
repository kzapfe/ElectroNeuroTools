using JLD,PyPlot

nombre="evento_desinhibido_2.jld"
arx=load(nombre)

lfp=arx["LFPSaturados"]
(alto,ancho,tmax)=size(lfp)

maxabs=zeros(alto,ancho)

for j=1:64,k=1:64
   maxabs[j,k]=maximum(abs(lfp[j,k,:]))
end


xlim(600,1600+16000)
ylim(-600,3600)
for j=1:4:64 ,k=1:4:64
    scatter((600:1600)+(k-1)*265,lfp[j,k,600:1600]+(j-1)*50, c=float(j),cmap="jet")
        # edgecolors=float(j),cmap="jet")
end


