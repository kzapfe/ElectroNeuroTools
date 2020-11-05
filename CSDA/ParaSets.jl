module ParaSets

#=
Funciones que ayudan a lidar con el problema de hacer sets en arrays y vicesversa
=#

export arraytoset, vecindad8, promediasobreconjunto, TiraOrillas


function arraytoset(xin::Array)
    renglones=size(xin, 1)
    result=Set()
    for j=1:renglones
    push!(result, xin[j,:])
    end
    return result
end



function TiraOrillas(Puntos::Set)
    #Descarta lo que se sale de la malla de electrodos
    result=Set([])
    for p in Puntos
        if !(p[1]==0 || p[2]==0 || p[1]==65 ||  p[2]==65)
            push!(result,p)
           # println("Añadiendo ", p, " al result") 
        end
    end
    return result
end


function vecindad8(punto::Array)
    # La ocho-vecindad de un punto en una malla cuadrada.
    j=punto[1]
    k=punto[2]
    result=Set{Array{Int64,1}}()
    push!(result, [j-1,k-1])
    push!(result, [j-1,k])
    push!(result, [j-1,k+1])
    push!(result, [j,k-1])
    push!(result, [j,k+1])
    push!(result, [j+1,k-1])
    push!(result, [j+1,k])
    push!(result, [j+1,k+1])
    result=TiraOrillas(result)
    return result
end

function promediasobreconjunto(puntos::Set, datos::Array)
    #Promedia sobre un conjunto un valor.
    n=0

    tmax=size(datos)[3]
    result=zeros(tmax)
    
    for q in puntos
        result=result.+datos[q[1],q[2],:]
        n+=1
    end
    result=result./n
    return result
end




end
