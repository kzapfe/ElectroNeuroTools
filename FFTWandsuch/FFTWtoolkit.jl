module FFTWtoolkit

using FFTW

export filtrobanda, wfft


function indicecercano(a::Number, freqs::Array)
    #encuentra en índice que tiene el número  más cercano a "a" en el Array freqs
    # si a está más lejos de alguno de ellos que su paso
    tol=abs((max(freqs)-min(freqs))/length(freqs))
    result=findfirst(x->isapprox(a,x, atol=tol), freqs)
    return result
end

function indicecercano(a::Number, freqs::StepRangeLen)
    #encuentra en índice que tiene el número  más cercano a "a" en el Array freqs
    # si a está más lejos de alguno de ellos que su paso
    tol=step(freqs)
    result=findfirst(x->isapprox(a,x, atol=tol), freqs)
    return result
end

function filtrobanda(freqs, yys::Array, a::Real, b::Real )
    #filtro pasa banda para DFT anular con rango [0, freqmax)
    if a>b
        b,a=a,b
    end
    abajo=indicecercano(a,freqs)
    arriba=indicecercano(b, freqs)
    result=deepcopy(yys)
    l=length(yys)
    laux=l+1
    if !(iseven(l))
        #ajustar indices
        laux+=1
    end
   # println( "los indices aceptables seran: ")
   # println( "abajo = ", abajo, " arriba = ", arriba, " laux-arriba = ", laux-arriba, " laux - abajo =", laux-abajo)
    for w in 1:l
        if ! (( abajo < w < arriba ) || (laux-arriba)<w<(laux-abajo) )
        result[w]=0
        end
    end
    return result
end



function wfft(datos::Array, cuadros::Int)
#hace un fftw por ventanas, lo que hace que tengamos un array de una dimension mas.
    r=1:cuadros
    nredux=length(datos)-cuadros
    plan=plan_fft(datos[r])
    result=zeros(Complex, nredux, cuadros)
    for j=1:nredux
        raux=r.+j
        result[j,:]=plan*datos[raux]
    end
    return result
end


end #module


