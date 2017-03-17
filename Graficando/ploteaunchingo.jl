
using JLD,PyPlot

nombre="../JLDFiles/LFPOriginales/Deshinibido/evento_desinhibido_3.jld"
#nombre=ARGS[1]
arx=load(nombre)
lfp=arx["LFPSaturados"]
(alto,ancho,tmax)=size(lfp)

maxabs=zeros(alto,ancho)

for j=1:64,k=1:64
   maxabs[j,k]=maximum(abs(lfp[j,k,:]))
end

maxmax=maximum(maxabs)

maxabs/=maxmax

xxs1=[600,1600]
yys1=[-100,-100]
xxs2=[601,601]
yys2=[-100,400]


ion()
imagen=figure(figsize=(16,16))
axis("off")
xlim(100,1600+16000)
ylim(-620,9000)
plot(xxs1,yys1, lw=2,c="black")
plot(xxs2,yys2, lw=2,c="black")
text(650,-70,"142ms")
text(650,100, "0.5mV")
for j=1:4:64 ,k=1:4:64
    plot((600:1600)+(k-1)*265,lfp[j,k,600:1600]+(j-1)*125,
         c="black",lw=0.1)
        # edgecolors=float(j),cmap="jet")
end
for j=1:4:64
    text((j+1)*265,-300, "$j")
    text(200,(j-1)*125, "$j")
end
#savefig("MapaTrazosCSDDeshinibida03.svg",dpi=90)
#savefig("MapaTrazosCSDDeshinibida03.png",dpi=90)


close()
close()
