using JLD

include("LindenbergOperadores.jl")
importall LindenbergOperadores



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


palabra=replace(archivo,".jld", "")
println(palabra)
#palabrita=replace(palabra,"otroIntento", "")



tmax=size(LFP,3)

lfpParchado=copy(LFP)

listaredux=TiraOrillas(saturados)
    
for m in listaredux
        q=m[1]
        p=m[2]
        vecinos=vecindad8(m)
        lfpParchado[q,p,:]=promediasobreconjunto(vecinos,lfpParchado)
end


(mu,nu,lu)=size(lfpParchado)
lfpplanchado=zeros(mu,nu,lu)
for j=1:mu,l=1:nu
    porromponpon=vec(lfpParchado[j,l,:])
    lfpplanchado[j,l,:]=GaussSuavizarTemporal(porromponpon)
end


aux1=zeros(mu,nu,lu)
aux2=zeros(mu,nu,lu)
for t=1:lu
aux1[:,:,t]=GaussianSmooth(lfpplanchado[:,:,t])
aux2[:,:,t]=DiscreteLaplacian(aux1[:,:,t])
end
CSD=-aux2

lfpParchado=0
aux1=0
aux2=0

paguardar=load(archivo)
paguardar["CSDLindenberg"]=CSD
save(archivo,paguardar)

