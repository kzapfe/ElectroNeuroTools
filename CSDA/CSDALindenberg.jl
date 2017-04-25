using JLD
#=
Este programita obtiene el CSD usando operadores diferenciales.
Usa el operador convexo de Lindenberg como Laplaciano.
Para usarse requiere un archivo *jld que contenga el LFP
como fue registrado en el experimento (o promediado sobre eventos evocados),
y, optativamente, una lista de electrodos inusables ("saturados").
=#


#Los operadores Diferenciales Numericos estan definidos en otro archivo.
include("LindenbergOperadores.jl")
importall LindenbergOperadores



if length(ARGS)==0
    error("Dar el nombre de un archivo *.jld para analizar")
else
    archivo=ARGS[1]
    println("Voy a trabajar con el archivo ", archivo)
end




#Los datos para trabajar
arx=load(archivo)
if haskey(arx, "LFPSaturados")
    LFP=arx["LFPSaturados"]
else
    LFP=arx["LFPTotal"]
end
saturados=arx["CanalesSaturados"]
respuestas=arx["Canalesrespuesta"];
frecuencia=arx["freq"]
#retrazo=load(archivo)["retrazo"]

#quitemos la terminacion de los nombres de archivo
palabra=replace(archivo,".jld", "")
println(palabra)
#palabrita=replace(palabra,"otroIntento", "")


#Una copia del LFP para trabajar sobre ella
lfpParchado=copy(LFP)


#Poner en cero los canales inservbles
for m in saturados
    q=m[1]
    p=m[2]
    lfpParchado[q,p,:]=0
end


#Si lo haces asi vas a tener manchas en las orillas.
#okey, esto se puede mejorar... pero son las orillas de todas formas.
listaredux=TiraOrillas(saturados)


#Creamos una mancha suave sobre el canal saturado.
for m in listaredux
        q=m[1]
        p=m[2]
        vecinos=vecindad8(m)
        lfpParchado[q,p,:]=promediasobreconjunto(vecinos,lfpParchado)
end


#en realidad nunca haces referencia al tercer numero como tiempo
(mu,nu,lu)=size(lfpParchado)
#Aplicamos un suavizado Gaussiano Temporal (esto afecta mucho las animaciones)
lfpplanchado=zeros(mu,nu,lu)
for j=1:mu,l=1:nu
    porromponpon=vec(lfpParchado[j,l,:])
    lfpplanchado[j,l,:]=GaussSuavizarTemporal(porromponpon)
end


aux1=zeros(mu,nu,lu)
aux2=zeros(mu,nu,lu)
#Suavizamos espacialmente con un filtro Gaussiano bidimensional el LFP.
#Posteriormente sacamos el dCSD.
for t=1:lu
    aux1[:,:,t]=GaussianSmooth(lfpplanchado[:,:,t])
    aux2[:,:,t]=DiscreteLaplacian(aux1[:,:,t])
end
CSD=-aux2

#Descartamos variables auxiliares
lfpParchado=0
aux1=0
aux2=0

#Observa que vas a guardar en el mismo archivo todo. 
paguardar=load(archivo)
paguardar["CSDLindenberg"]=CSD
save(archivo,paguardar)

