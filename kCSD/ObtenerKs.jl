
if length(ARGS)==0
    error("Dame un nombre de archivo de funciones b y btilde para trabajar")
else
    bnombre=ARGS[1] 
    btildenombre=ARGS[2]
end

println("Numero de procesos en paralelo ",nprocs())

println("Cargando las tablas de b_0 y  btilde_0...") 
b=readdlm(bnombre)
btilde=readdlm(btildenombre)

println("Iniciando las coordenadas de interes...")       
#ConjuntoDeCoordenadasTotal=Array[]
LasXNetas=Array[]
#CasiXNetas=Array[]

#=
for j=1:64,k=1:64
    push!(ConjuntoDeCoordenadasTotal,[j,k])
end
=#

for j=1:24, k=1:24
    push!(LasXNetas,[j+5,k+23])
end

LasXchiquitas=LasXNetas[1:24]

println("Definiendo las funciones necesarias...")

@everywhere function sumaalgunasB(LasB::Array, lasX::Array,rango)
    tantas=length(rango)
    tamanho=length(lasX)
    result=zeros(tamanho,tamanho)
    xconstante=[64,64]
    for j=1:tamanho
     xj=lasX[j]
         for k=1:j
            xk=lasX[k]
            aux=0
            for l in rango
                xl=lasX[l]
                aux += LasB[(xk-xl+xconstante)...]*LasB[(xj-xl+xconstante)...]
          end
            result[j,k]=aux
        end
    end
    return result
    
end

@everywhere function sumaalgunasByBtilde(LasB::Array, LasBtilde::Array, lasX::Array,rango)
    tantas=length(rango)
    tamanho=length(lasX)
    result=zeros(tamanho,tamanho)
    xconstante=[64,64]
    for j=1:tamanho
     xj=lasX[j]
        for k=1:tamanho
            xk=lasX[k]
            aux=0
            for l in rango
                xl=lasX[l]
                aux += LasBtilde[(xk-xl+xconstante)...]*LasB[(xj-xl+xconstante)...]
          end
            result[j,k]=aux
  #  println("hola loco ", KdurasParalel[j,k])
        end
    end
    return result
    
end

@everywhere function divideArray(lasX::Array)
    #el proceso myid()==nprocs() va a ser el director de orquesta
    procesos=nprocs()-1
    largo=length(lasX)
    idx=myid()
    if idx==nprocs()
        return 1:0
    else
        splits=[round(Int, s) for s in linspace(0,largo,procesos+1)]
        return splits[idx]+1:splits[idx+1]
    end
end

@everywhere function obtenKParcial(LasB,lasX)
    ranguito=divideArray(lasX)
    @show (ranguito)
    result= sumaalgunasB(LasB, lasX,ranguito)
    return result
end

@everywhere function obtenKtildeParcial(LasB,LasBTilde, lasX)
    ranguito=divideArray(lasX)
    @show (ranguito)
    result= sumaalgunasByBtilde(LasB, LasBTilde, lasX,ranguito)
    return result
end




function sacalaKenTrozos(LasB::Array, lasX::Array)
    largo=length(lasX)
    cachos=nprocs()
    aux=SharedArray(Float64,(largo,largo,cachos))
     @sync begin
        for p in procs()
            @async  aux[:,:,p]=remotecall_fetch(p, obtenKParcial, LasB, lasX)
        end
        end #cierra el syncbegin
    result=zeros(largo,largo)
    result=sum(aux,3)
    return result
    #return result
end

function KtildeenTrozos(LasB::Array, LasBtilde::Array, lasX::Array)
    largo=length(lasX)
    cachos=nprocs()
    aux=SharedArray(Float64,(largo,largo,cachos))
     @sync begin
        for p in procs()
            @async  aux[:,:,p]=remotecall_fetch(p, obtenKtildeParcial, LasB, LasBtilde, lasX)
        end
        end #cierra el syncbegin
    result=zeros(largo,largo)
    result=sum(aux,3)
    return result
    #return result
end


println("Precompilando justo a tiempo las funciones...")

laKParcial=obtenKParcial(b,LasXchiquitas)
laKParcial=obtenKtildeParcial(b, btilde,LasXchiquitas)

K=sacalaKenTrozos(b,LasXchiquitas);
KTilde=KtildeenTrozos(b, btilde, LasXchiquitas);

println("Calculando K y Ktilde...")
@time K=sacalaKenTrozos(b,LasXNetas);
@time KTilde=KtildeenTrozos(b,btilde, LasXNetas);

println("Simetrizando K y arreglando K tilde...")


longus=size(K,1)

K=reshape(K,longus,longus)
KTilde=reshape(KTilde,longus,longus)

K=K+transpose(K)
#=
for j=1:longus
    K[j,j]=K[j,j]/2
end
=#
println("Escribiendo K.dat y KTilde.dat en el disco...")

writedlm("K.dat",K)
writedlm("KTilde.dat",KTilde)
