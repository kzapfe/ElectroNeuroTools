function Gradiente2D(z::Array)
    (alto,ancho)=size(z)
    result=Array(Any, (alto,ancho))
    aux=copy(z)
    aux=vcat(aux[1,:],aux,aux[end,:])
    aux=hcat(aux[:,1],aux,aux[:,end])
    for j=2:alto+1, k=2:ancho+1
        dfdx=aux[j,k+1]-aux[j,k-1]
        #los arreys tienen un eje y invertido. Su y es la -y cartesiana
        dfdy=-(aux[j+1,k]-aux[j-1,k]) 
        result[j-1,k-1]=(dfdx. dfdy)
    end
    return result
end

        
