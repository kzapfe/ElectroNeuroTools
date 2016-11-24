using JLD

listacompleta=readdir()

for i in listacompleta    
    if (i[end-2:end]=="jld" && i[1:6]=="LFP_Pr")
        saturados=load(i)["CanalesSaturados"]
        tantos=length(saturados)
        println(i, " ", tantos)
    end
end
