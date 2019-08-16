module ArraySetTools

export rowstoset, elemtorow


## ******************************************
## funciones para manipular arrays y sets



function rowstoset(xxs::Array; enteros=true)
    # pasa los renglones de un arreglo a un conjunto como si jueran elementos
    if enteros
        result=Set{Array{Int64,2}}()
    else
        result=Set{Array{Float64,2}}()
    end
    (nrow,ncol)=size(xxs)
    for j in 1:nrow
        push!(result, reshape(xxs[j,:], 1, ncol))
    end
    return result
end

function elemtorow(xxs::Set)
    #pasa los elementos de un conjunto a rengoles de un array
    result=[0 0] 
    for k in xxs
        result=vcat(result, transpose(k))
    end
    return result[2:end,:]
end




end #module
