module ParaSets

#=
Funciones que ayudan a lidar con el problema de hacer sets en arrays y vicesversa
=#

export arraytoset


function arraytoset(xin::Array)
    renglones=size(xin, 1)
    result=Set()
    for j=1:renglones
    push!(result, xin[j,:])
    end
    return result
end


end
