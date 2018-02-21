#=
Para graficar los puntos de evocacion y asi de experimentos
evocados
=#

using JLD, PyPlot

nombre=ARGS[1]
datos=load(nombre)


lfp=datos["LFPSaturados"]
saturados=datos["CanalesSaturados"]
respuestas=datos["Canalesrespuesta"]
retrazo=datos["retrazo"]
frecuencia=datos["freq"]

tantossaturados=length(saturados)
tantosrespuesta=length(respuestas);

## Esta es la latencia que recomendo Gis.
latencia=round(Int, ceil(1.5*frecuencia))
tejemplo=136
ejemplo=lfp[:,:,tejemplo];

xxsresp=zeros(tantosrespuesta)
yysresp=zeros(tantosrespuesta)
j=1
for q in respuestas
    xxsresp[j]=q[2]
    yysresp[j]=q[1]
    j+=1
end
xxssatu=zeros(tantossaturados)
yyssatu=zeros(tantossaturados)
j=1
for q in saturados
    xxssatu[j]=q[2]
    yyssatu[j]=q[1]
    j+=1
end




figure(figsize=(4.25,4))
xlim(0,64)
ylim(0,64)
grid()
limites=200
imagen=imshow(ejemplo, interpolation="nearest", cmap="Spectral_r", 
vmin=-limites,vmax=limites, extent=[0.5,64.5,0.5,64.5])
cb=colorbar(imagen, fraction=0.046)
scatter(xxsresp,yysresp, alpha=0.9, c="red", s=2, edgecolor="none", label="Respuestas")   
scatter(xxssatu,yyssatu, alpha=0.9, c="black",s=2,  edgecolor="none", marker="x", label="Saturados") 
legend()
tight_layout()
savefig("MapaSaturados.png",dpi=90)
#scatter(46,31)
