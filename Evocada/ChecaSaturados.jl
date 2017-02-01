using JLD,HDF5

listacompleta=readdir()

for i in listacompleta    
    if (i[end-2:end]=="jld" && i[1:3]=="LFP")
        try
            saturados=load(i)["CanalesSaturados"]
            tantos=length(saturados)
            println(i, " ", tantos)
        catch
            println(i, " esto no tiene lo que buscas")
        end
    end
end
