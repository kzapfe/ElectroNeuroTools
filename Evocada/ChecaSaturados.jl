using JLD

listacompleta=readdir()

for i in listacompleta    
    if (i[end-2:end]=="jld")
        saturados=load(i)["CanalesSaturados"]
        tantos=length(saturados)
        println(i, " ", tantos)
    end
end
