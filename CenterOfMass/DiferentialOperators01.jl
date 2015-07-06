function Gradiente2D(z::Array)
    #por cuestiones de ploteo, mejor dar dos matrices como resultado
    (alto,ancho)=size(z)
    vx=Array(Real, (alto,ancho))
    vy=Array(Real, (alto,ancho))
    aux=copy(z)
    aux=vcat(aux[1,:],aux,aux[end,:])
    aux=hcat(aux[:,1],aux,aux[:,end])
    for j=2:alto+1, k=2:ancho+1
        #Derivada de la secante
        dfdx=aux[j,k+1]-aux[j,k-1]
        #los arreys tienen un eje y invertido. Su y es la -y cartesiana
        dfdy=(aux[j+1,k]-aux[j-1,k]) 
        (vx[j-1,k-1], vy[j-1,k-1])=(dfdx, dfdy)
    end
    return (vx, vy)
end

        
function Divergencia2D(z::Array)
    (alto,ancho)=size(z)
    result=Array(Real, (alto,ancho))
    aux=copy(z)
    aux=vcat(aux[1,:],aux,aux[end,:])
    aux=hcat(aux[:,1],aux,aux[:,end])
    for j=2:alto+1, k=2:ancho+1
        #Derivada de la secante
        vx2=aux[j,k+1][1]
        vx1=aux[j,k-1][1]
        vy2=aux[j+1,k][2]
        vy1=aux[j-1,k][2] 
        dvxdx=vx2-vx1
        #los arreys tienen un eje y invertido. Su y es la -y cartesiana
        dvydy=-(vy2-vy1)
        result[j-1,k-1]=dvxdx+dvydy
    end
    return result
end

        
function Divergencia2D(Ex::Array, Ey::Array)
    (alto,ancho)=size(z)
    result=Array(Real, (alto,ancho))
    aux=copy(z)
    aux=vcat(aux[1,:],aux,aux[end,:])
    aux=hcat(aux[:,1],aux,aux[:,end])
    for j=2:alto+1, k=2:ancho+1
        #Derivada de la secante
        vx2=Ex[j,k+1]
        vx1=Ex[j,k-1][1]
        vy2=Ey[j+1,k][2]
        vy1=Ey[j-1,k][2] 
        dvxdx=vx2-vx1
        #los arreys tienen un eje y invertido. Su y es la -y cartesiana
        dvydy=(vy2-vy1)
        result[j-1,k-1]=dvxdx+dvydy
    end
    return result
end
