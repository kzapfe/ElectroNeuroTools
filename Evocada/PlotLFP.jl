using JLD, PyPlot


if length(ARGS)==0
    error("Dar el nombre de un archivo LFP_*.jld para graficar")
else
    archivo=ARGS[1]
    println("Voy a trabajar con el archivo ", archivo)
end
    

#Los datos para fraficar
LFP=load(archivo)["LFPSaturados"]
saturados=load(archivo)["CanalesSaturados"]
respuestas=load(archivo)["Canalesrespuesta"];
frecuencia=load(archivo)["freq"]
retrazo=load(archivo)["retrazo"]

tantossaturados=length(saturados)
tantosrespuesta=length(respuestas);
limites=200

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


ioff()
tmax=size(LFP,3)

for t=1:tmax
   
figure(figsize=(6,6))
xlim(0,65)
ylim(0,65)
    ejemplo=LFP[:,:,t]
    tiempo=round((t-retrazo)/frecuencia,1)
    title("t= $tiempo")
imagen=imshow(ejemplo, origin="lower", interpolation="nearest", cmap="winter", 
vmin=-limites,vmax=limites, extent=[0.5,64.5,0.5,64.5])
    cb=colorbar(imagen, fraction=0.046)
    if t>(tmax-140)

        scatter(xxsresp,yysresp, alpha=0.9, c="red", edgecolor="none")
        scatter(xxssatu,yyssatu, alpha=0.9, c="white", edgecolor="none", marker="s") 
    end
    savefig("LFP_Try_$t.png",dpi=90)
    close()
    PyPlot.close_figs()
end
