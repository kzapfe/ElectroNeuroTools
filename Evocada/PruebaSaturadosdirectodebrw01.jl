#=
Esta Rutina de Julia incorpora las definiciones y cositas hechas en los
notebooks de este directorio para rapidamente estimar cuantos canales
están inusables y como se ven
=#

namefile=ARGS[1]
println(" Abriendo $namefile")
stringgeneral=replace(namefile, ".brw", "")



using HDF5,JLD

include("SeparaActividadySaturados01.jl")
using SeparaActividadySaturados01
#ya en el modulo estan las funciones necesarias.


Datos=AbreyCheca("$namefile")
factor=Datos["factor"]
freq=Datos["frecuencia"]/1000 #cuadros por segundo
println("Esta es la frecuencia de muestreo: ",Datos["frecuencia"])
#la mayoría de los datos están en una lista monstruosa
DatosCrudosArreglados=reshape(Datos["DatosCrudos"], (4096, Datos["numcuadros"]));

LFPSaturado=FormaMatrizDatosCentrados(DatosCrudosArreglados, factor)

tmax=size(LFPSaturado,3)
ini=100
fini=400

PruebaRespuesta=BuscaCanalRespActPot(LFPSaturado,freq, 120,-120,-800)
Saturados=BuscaSaturados(LFPSaturado,1200,ini,fini)
setdiff!(PruebaRespuesta,Saturados)

tantossaturados=length(Saturados)
tantosrespuesta=length(PruebaRespuesta)

println("Me encontre ", tantossaturados, " saturados y ", tantosrespuesta, " posibles respuestas")


outname=string(stringgeneral,".jld")
save(outname,
     "LFPSaturados", LFPSaturado,
     "freq",freq,
     "Canalesrespuesta", PruebaRespuesta,
     "CanalesSaturados", Saturados)
