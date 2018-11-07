module SeparaActividadySaturados01

using HDF5
using JLD

export AbreyCheca, EncuentraTrancazosRaw,ActivAlrededorTrancazo, ActividadFueraTrancazo, FormaMatrizDatosCentrados, BuscaSaturados, BuscaSaturadosStd, BuscaCanalRespActPot


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

function ActivAlrededorTrancazo(Lista::Array, xxs::Array, freq::Number)
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

function ActividadFueraTrancazo(Lista::Array, xxs::Array, freq::Number)
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
    aux=Array{Int32}(64,64, largo);
    for j=1:64,k=1:64
        aux[k,j,:]=xxs[j+(k-1)*64,:]
    end
    result=(aux*(-1)+2048)*factor;
    aux=0
    return result
end

function BuscaSaturados(datos::Array, saturavalue=1900, desde=retrazo, hasta=final)
     #busca saturados por promedio sobre umbral
    (alto,ancho,largo)=size(datos)
    result=Set{Array{Int,1}}()
    for j=1:ancho, k=1:alto
        prom=mean(datos[k,j,desde:hasta])
        
        if abs(prom)>saturavalue
            push!(result, [k,j])
        #    println(prom," ",[k,j]," ",saturavalue," ", desde, " ",hasta)
        end
    end
    return result
end

function BuscaSaturadosStd(datos::Array, ventana=50, umbral=20)
    #busca saturardos por desviación por ventana por umbral
    (alto,ancho,largo)=size(datos)
    mediaventana=div(ventana,2)
    largoventanasmedias=div(largo-ventana,mediaventana)
    result=Set{Array{Int,1}}()
    for j=1:ancho, k=1:alto
        for l=1:largoventanasmedias-1
            sigma=std(datos[k,j,l*mediaventana:l*mediaventana+ventana])    
            if sigma<umbral
                push!(result, [k,j])
                break
            end
        end
    end
    return result
end



function BuscaCanalRespActPot(datos::Array,freq::Number, tini=tiempopostgolpe, umbral=-100, umbralsaturacion=-1500)
    #Busquemos los canales con probable respuesta de potencial de accion
    (ancho,alto,largo)=size(datos)
    datosaux=datos[:,:,tini:largo] #fuera de la accion maxima del potencial de accion.
    #tiempos post golpe para ver si el canal esta pegado en un valor
    taux1=round(Int, ceil(0.5*freq))
    taux2=round(Int,ceil(8*freq))
    desviacionpostgolpe=std(datosaux[taux1:taux2])
    result=Set{Array{Int,1}}()
    for j=1:ancho, k=1:alto
        fondo=minimum(vec(datosaux[k,j,:]))
        if fondo<umbral && fondo>umbralsaturacion &&desviacionpostgolpe>10
            push!(result,[k,j])
        end
    end
    return result
end


end
