push!(LOAD_PATH, ".")
using PreprocTools
using HDF5


abrestring="/home/karel/BRWFiles/Eduardo/Control/193005_CTRL_Rtn_EMAD_01.brw"
stringgeneral=replace(abrestring, ".brw"=>"")

Datos=AbreyCheca(abrestring)

### parametetros globales.
freq=Datos["frecuencia"]/1000 #cuadros por milisegundo.
factor=Datos["factor"] #Factor de conversion de numeros enteros a microVolts



autorebana=false
if autorebana
    tamax=400*1024*1024  #maximo tamaño tolerable de archivo en tu lap
    tam=filesize(abrestring)
    cachos=div(tam,tamax)+1
else
    #tiempos interesantes es una lista de intervalos en segundos. 
tstr="00:01.1-00:02.3
00:04.5-00:05.7
00:08.9-0:11.0
00:15.7-00:16.7
00:18.7-00:20.1
00:23.0-00:24.6
00:33.9-00:34.8
00:38.0-00:39.0
00:42.0-00:43.0
00:47.1-00:48.5
00:51.3-00:52.5
00:54.2-00:55.7
00:58.0-00:59.0"
    tinteres=parseatiempos(tstr, freq)
    cachos=length(tinteres)
end


cuadrosmax=Datos["numcuadros"]
tiempototalms=round(cuadrosmax/freq; digits=1) 
println("Tienes ", cuadrosmax, " cuadros de muestreo a ", round(freq; digits=4), " cuadros por milisegundo")
println( "Esto corresponde a  ", tiempototalms, "ms." )


fmemlibre=Sys.free_memory()/Sys.total_memory()
println("Te queda libre, " fmemlibre, " del total del RAM")


# Si los datos andan en un arreglo de lista en lugar de cuadrado, los ponemos cuadrados
if size(Datos["DatosCrudos"])[1] != 4096
DatosCrudosArreglados=reshape(Datos["DatosCrudos"], (4096, Datos["numcuadros"]))
else
DatosCrudosArreglados=Datos["DatosCrudos"]
end;



dirgen=dirname(stringgeneral)
basegen=basename(stringgeneral)
indicadorespecifico=".h5"

if cachos > 1
    for cacho in 1:cachos
        if autorebana
    ## escoga el usuario un cacho para trabajar entre 1 y cachos
            pedazo=round(Int, Datos["numcuadros"]/cachos)
            nini=1+(cacho-1)*pedazo
            
            if cacho < cachos # si no es el ultimo cacho
                nfin=cacho*pedazo
            else
                nfin=cuadrosmax
            end
            
        else # si no autorebana   
            q=tinteres[cacho]
            nini=q[1]
            nfin=q[end]
        end 
            
        datosaux=DatosCrudosArreglados[:,nini:nfin]
        palabritaespecial="/Cacho_$(cacho)_"
        DatosCentrados=FormaMatrizDatosCentrados(datosaux, factor);
        intervalo=[nini/freq, nfin/freq]
    
        listaaguardar=Dict(
        "lfp" => DatosCentrados,
         "freq" =>freq,
        "intervalo"=>intervalo)
        
  
        outname=string(dirgen,palabritaespecial, basegen, indicadorespecifico)

        h5open(outname, "w")  do file
            for k in keys(listaaguardar)
                datos=listaaguardar[k]
                println("abriendo los datos ", k)
                println
                write(file, "$k", datos)
            end
        end 

        println("hemos guardado este cacho en el archivo ", outname)

        end #CIERRA SOBRE CACHOS
      
    else
       
    palabritaespecial="/Completo_"
    DatosCentrados=FormaMatrizDatosCentrados(DatosCrudosArreglados, factor);
    intervalo=[1/freq, cuadrosmax/freq]
    
      listaaguardar=Dict(
    "lfp" => DatosCentrados,
     "freq" =>freq,
    "intervalo"=>intervalo)
        
  
    outname=string(dirgen,palabritaespecial, basegen, indicadorespecifico)

    h5open(outname, "w")  do file
        for k in keys(listaaguardar)
            datos=listaaguardar[k]
            println("abriendo los datos ", k)
            println
            write(file, "$k", datos)
        end
    end 

       println("hemos guardado este cacho en el archivo ", outname)
    
 end        
            

#    end;
# Liberar memoria
Datos["DatosCrudos"]=0
