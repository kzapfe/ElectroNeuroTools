module PreprocTools

using Statistics
using HDF5
using JLD

export AbreyCheca, EncuentraTrancazosRaw,ActivAlrededorTrancazo, ActividadFueraTrancazo, FormaMatrizDatosCentrados, BuscaSaturados, BuscaSaturadosStd, BuscaRuidosos, BuscaCanalRespActPot, desviacionventanas

#= Muchas funciones aqui presentes son para limpiar,
manipular, cortar y suavizar datos. Ellas dependen
del parametero de la frecuencia de muestreo de
un experimento. Damos el valor por omision
de 17.8555 kHz, que es el del modelo del BrainWave BioCam 2017.
Hay que tener esto presente.

Las funciones afectadas son:

desviacionventanas
tari

=#

 # no exportar esto, es para uso interno
deffreq=17.8555 # freq por omision para BrainWave BioCam 2017.

function AbreyCheca(x::String)
    #Abre el archivo de brw (acepta el nombre tal cual)
    archivo=h5open(x)
    #sacatito todas las variables que te interesan
    numcuadros=archivo["/3BRecInfo/3BRecVars/NRecFrames"][1][1]
    frecuencia=archivo["/3BRecInfo/3BRecVars/SamplingRate"][1][1]
    maxvolt=archivo["/3BRecInfo/3BRecVars/MaxVolt"][1][1]
    minvolt=archivo["/3BRecInfo/3BRecVars/MinVolt"][1][1]
    bitdepth=archivo["/3BRecInfo/3BRecVars/BitDepth"][1][1]
    duracionexperimento=numcuadros/frecuencia
    factordeescala=(maxvolt-minvolt)/2^bitdepth
    DatosCrudos=read(archivo["/3BData/Raw"])
    result=Dict("numcuadros" => numcuadros,
                "frecuencia"=> frecuencia,
                "maxvolt" => maxvolt,
                "minvolt" => minvolt,
                "bitdepth" => bitdepth,
                "duracion" => duracionexperimento,
                "factor" => factordeescala,
                "DatosCrudos"=>DatosCrudos )
    return result
                    
end

function EncuentraTrancazosRaw(datos::Array, tolerancia=1400)
    result=Int[]
    longitud=length(datos)
    jcomp=0
    media=mean(datos)
    for j=1:longitud
        if abs(datos[j]-media)>tolerancia
            if j-jcomp>1
                push!(result,j)
            end
            jcomp=j
        end
    end
    return result
end

function ActivAlrededorTrancazo(Lista::Array, xxs::Array, freq=deffreq)
    #Aqui no se le ha hecho reshape a las matrices todavia
    result=Dict{AbstractString, Array}()
    q=1
    desde=round(Int, ceil(5*freq))
    hasta=round(Int, ceil(60*freq))
    for j in Lista
        nomineclave="Trancazo_$q"
        result[nomineclave]=xxs[:,j-desde:j+hasta]
        #println(nomineclave)
        q+=1
    end
    return result
end

function ActividadFueraTrancazo(Lista::Array, xxs::Array, freq=deffreq)
    q=1
    desde=round(Int, ceil(5*freq))
    hasta=round(Int, ceil(30*freq))
    aux=trues(xxs)
    for j in Lista
        aux[j-desde:j+hasta]=false
    end
    result=zeros(1)
    aux2=find(aux)
    for j in aux2
        result=vcat(result,xxs[j])
    end
    return result
end

function FormaMatrizDatosCentrados(xxs::Array, factor::Number)
    #El array tiene que ser de 4096 por algo mas
    irrrelevante,largo=size(xxs)
    aux=Array{Int32}(undef, 64,64, largo);
    for j=1:64,k=1:64
        aux[k,j,:]=xxs[j+(k-1)*64,:]
    end
    result=(aux.-2048).*factor;
    aux=0
    return result
end

function BuscaSaturados(datos::Array, freq=deffreq, saturavalue=1900,
                        desde=0.5, hasta=10)
    #busca saturados por promedio sobre umbral
    # cambios para guardar en HDF5 y mandar jld a freir esparragos.
    # no more Sets, only Arrays
    (alto,ancho,largo)=size(datos)
    cini=round(Int, ceil(desde*freq))
    cfin=round(Int, ceil(hasta*freq))
    #result=Set{Array{Int,1}}()
    result=[0::Int64 0::Int64 ]
    for j=1:ancho, k=1:alto 
        prom=mean(datos[k,j,cini:cfin])  
        if abs(prom)>saturavalue
            bla=[k j]
            result=vcat(result, bla)
        #    println(prom," ",[k,j]," ",saturavalue," ", desde, " ",hasta)
        end
    end
    #result=permutedims(hcat(result[2:end,:]...), [2,1])
    return result[2:end, :]
end

function BuscaSaturadosStd(datos::Array, ini, fin,
                           freq=deffreq, umbral=30)
    #ventms es la ventana en milisegundos
    #busca saturardos por desviación por ventana por umbral
    (alto,ancho,largo)=size(datos)
    cini=round(Int, ceil(freq*ini))
    cfin=round(Int, ceil(freq*fin))
    result=[0::Int64 0::Int64 ]
    for j=1:ancho, k=1:alto        
        sigma=std(datos[k,j,cini:cfin])    
        if sigma>umbral
            bla=[k j]
            result=vcat(result, bla)
        end
        
    end
    
    return result[2:end, :]
end


function BuscaRuidosos(datos::Array, ini, fin,
                           freq=deffreq, umbral=120, tantos=3)
    #ventms es la ventana en milisegundos
    #busca saturardos por desviación por ventana por umbral
    (alto,ancho,largo)=size(datos)
    cini=round(Int, ceil(freq*ini))
    cfin=round(Int, ceil(freq*fin))
    result=[0::Int64 0::Int64 ]
    for j=1:ancho, k=1:alto        
        pasados=findall(x-> x>umbral, datos[j,k,cini:cfin])
        if length(pasados)>tantos
            bla=[k j]
            result=vcat(result, bla)
        end
        
    end
    
    return result[2:end, :]
end



function BuscaCanalRespActPot(datos::Array,freq=deffreq, tini=0.5,
                              tfin=8,
                              maxvolt=-100, minvolt=-1500, 
                              minstd=10, maxstd=35)
    #Busquemos los canales con probable respuesta de potencial de accion
    (ancho,alto,largo)=size(datos)
    taux1=round(Int, ceil(tini*freq))
    taux2=round(Int,ceil(tfin*freq))
    
    println("Estoy buscando del cuadro " , taux1, " al , ", taux2)
    
    result=[0::Int64 0::Int64 ]
    for j=1:ancho, k=1:alto
        fondo=minimum(vec(datos[k,j,taux1:taux2]))
        dpgs=std(datos[k,j,taux1:taux2])
       
        if  (maxvolt >fondo>minvolt) && ( maxstd > dpgs > minstd)
           #  print(dpgs, " ")
            bla=[k j]
            result=vcat(result,bla)
        end
    end

    #= Esta rutina no es muy confiable. Solo da buenos resultados
    con actividad evocada. Necesitamos algo mas estricto =#
   
    return result[2:end, :]
end


function quitasatura(buenos::Array, malos::Array)
    # quitemos del array de pares bueno los malos #
    return 0
end


function desviacionventanas(data, ventmiliseg=100, freq=deffreq)
    ventana=round(Int, ventmiliseg*freq)
    longi=length(data)
    longicorrected=div(longi,ventana)
    result=zeros(longicorrected)
    for k=1:longicorrected
        result[k]=std(data[(k-1)*ventana+1:k*ventana])
    end
    return result
end                                                          


function tari(it,ft, freq=17.8555)
    # funtion que pasa de tiempo en ms a intervalos enteros de indices
    auxi=round(Int, it*freq)
    auxf=round(Int, ft*freq)
    result=auxi:auxf
end


function mediamov(trazo::Array, ms=0.5, freq=deffreq)
#Media Movil es el termino en español para moving Average.    
# funcion que promedia cada punto sobre sus vecinos, avanzando
    
    l=length(trazo)
    nv=round(Int,ms*freq)
    cabeza=repeat([trazo[1]],nv)ege
    cola=repeat([trazo[end]],nv)
    aux=vcat(cabeza,trazo,cola)
    result=zeros(l)
    for j=1:l
        result[j]=mean(aux[j:j+nv*2])
    end
    return result 
end


gauss(x, sigma)=exp(-(x/sigma)^2/2) #gaussiana en cuadros enteros
    

function pesosgauss(desv::Real,n::Int)
    # arreglo de pesos gaussianos
    g=zeros(2*n+1)
    for j=-n:n
        g[j+n+1]=gauss(j,desv)
    end
    return g
end
        
function suavegauss(trazo::Array, ms=0.5, freq=deffreq)
    # funcion que promedia cada punto sobre sus vecinos,
    # pero con peso gaussiano
    #ms es la desviacion o medio ancho en ms

    #= una desviacion en  x ms equivale a un filtro guassiano con
    # medio corte (es decir desviacion en kHz) de  1/(2 pi  x)
    e.g. 1ms va dar un filtro de 159.16 Hz de medio corte.
    e.g. 0.05 ms nos va dar practicamente un muestro igual al original (17kHz)
    =#
    
    # la sigma NO tiene porque ser entera, pero los cuadros si
    sigma=ms*freq
    cuatronv=round(Int, ceil(4*sigma)) # ¿que tan precisa la cola?
    pesos=pesosgauss(sigma, cuatronv)
    pesoT=sum(pesos)
    l=length(trazo)
    cabeza=repeat([trazo[1]],cuatronv)
    cola=repeat([trazo[end]],cuatronv)
    aux=vcat(cabeza,trazo,cola)
    result=zeros(l)
    for j=1:l
        for k=0:cuatronv
        result[j]+=aux[j+k]*pesos[k+1]
        end
    end
    result=result./pesoT
    return result 

    
end


end #module
