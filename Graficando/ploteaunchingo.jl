

using JLD,PyPlot

nombre="/home/karel/RGutWork/JLDFiles/evento_desinhibido_1.jld"
#nombre=ARGS[1]
arx=load(nombre)
lfp=arx["LFPSaturados"]
csd=arx["kCSDCorrecta"]
(alto,ancho,tmax)=size(lfp)

maxabs=zeros(alto,ancho)

for j=1:64,k=1:64
   maxabs[j,k]=maximum(abs(lfp[j,k,:]))
end

maxmax=maximum(maxabs)

maxabs/=maxmax

xxs1=[600,1600]
yys1=[400,400]
xxs2=[601,601]
yys2=[-100,400]


ion()
imagen=figure(figsize=(15,16))
axis("off")
xlim(100,1600+16000)
ylim(9000,-620)
plot(xxs1,yys1, lw=2,c="black")
#plot(xxs2,yys2, lw=2,c="black")
text(650,270,"142ms")
#text(650,20, "0.5mV")
for j=1:4:64 ,k=1:4:64
    plot((600:1600)+(k-1)*265,-vec(csd[j,k,600:1600])+(j-1)*125,
         c="black",lw=0.1)
        # edgecolors=float(j),cmap="jet")
end
for j=1:4:64
    text((j+1)*265,-300, "$j")
    text(200,(j-1)*125, "$j")
end
savefig("MapaTrazosCSDDeshinibida01.svg",dpi=90)
savefig("MapaTrazosCSDDeshinibida01.png",dpi=90)
close()
close()
