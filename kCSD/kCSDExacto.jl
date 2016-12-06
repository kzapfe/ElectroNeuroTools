using JLD

numarg=length(ARGS)
if numarg<1
    error("Dame un nombre de archivo JLD que tenga LFP y KTT_KInv guardados")
else
    nombre=ARGS[1] 
end

println("cargando lfp")
lfp=load(nombre)["LFPSaturados"]
KTT=load(nombre)["KTT_KInv"]
tmax=size(lfp,3)

todaslasX=Array[]

for j=1:64,k=1:64
    push!(todaslasX,[j,k])
end

xpurgadas=filter(q->!(q in saturados), todaslasX)
nbuenas=length(xpurgadas)

CSDtentativa=zeros(4096)
CSD=zeros(lfp)

lfpenvectores=zeros(nbuenas,tmax)

println("Acomodando los LFP correctos")

for j=1:nbuenas
    renglon=xpurgadas[j][1]
    columna=xpurgadas[j][2]
    lfpenvectores[j,:]=lfp[renglon,columna,:]
end

CSDTentativa=zeros(lfpenvectores)

println("Empezando calculo")
for t=1:tmax
    CSDTentativa[:,t]=KTT*flpenvectores[:,t] 
end

for j=1:nbuenas
    renglon=xpurgadas[j][1]
    columna=xpurgadas[j][2]
    CSD[renglon,columna,:]=CSDTentativa[j,:]
end


println("terminando calculo")

paguardar=load(nombre)
paguardar["kCSDCorrecta"]=CSD
save(nombre,paguardar)

println("Tu archivo jld ha sido modificado, checa una entrada kCSD")




