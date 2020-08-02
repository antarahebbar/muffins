include("tools.jl")
export sv, findend, combs

include("format.jl")
export formatFrac


function mid(m, s)
V, W, Vnum, Wnum = sv(m,s)

total = m//s
Wshares= W*Wnum
Vshares= V*Vnum

if m<=0||s<=0
    return "inputs must be >0"
elseif m%s==0
    return "s divides into m, so a=1"
elseif m<s
    return "input m>s"
else


    if Wshares>Vshares
        alphalist=[]
        n=W
        newdown1=1-(m//s)+(W-1)
        for i =0:n
            for j=i:n
                alpha1=((i)*(1//2)+(j-i)*(1-m//s+(W-1))+(n-j)-m//s)//((n-j)+(j-i)*(W-1))
                alpha2=(m//s-(j-i)*(1-m//s)-(n-j)*1//2)//(i+(j-i)*(V-1))
                check1=checkmid(m,s,alpha1)
                check2=checkmid(m, s, alpha2)
                if check1==true
                    push!(alphalist, alpha1)
                    if check2==true
                        push!(alphalist, alpha2)
                    else
                        continue
                    end
                elseif check2==true
                    push!(alphalist, alpha2)
                else
                    continue
                end
          end
      end
println(alphalist)
println(maximum(alphalist))
println(minimum(alphalist))


    elseif Vshares>Wshares
        alphalist=[]
        n=V
        newdown1=1-(m//s)+(W-1)
        for i =0:n
            for j=i:n
                alpha1=(i*(1-m//s+(W-1))+(j-i)*1//2+(n-j-1)*m//s)//(i*(W-1)+(n-j)*(V-1))
                alpha2=(m//s-(j-i)*(1-m//s)-(n-j)*1//2)//(i+(j-i)*(V-1))
                #alpha2=(m//s-i*(m//s-(W-1))+(j-i)*(1//2)-(n-j)*(1-m//s))//(i*(W-1)+(n-j)*(V-1))
                check1=checkmid(m, s, alpha1)
                check2=checkmid(m, s, alpha2)
                if check1==true
                    push!(alphalist, alpha1)
                elseif check2==true
                    push!(alphalist, alpha2)
                else
                    continue
                end
            end
        end
        println(alphalist)
        println(maximum(alphalist))
        println(minimum(alphalist))

    end
end

end

    #=if Wshares > Vshares
        key = W
        x=(m//s)-((V-1)*alpha)
        y=(m//s)-((W-1)*(1-alpha))
        middleshares=Wshares-Vshares
        if alpha>=x||x>=y
            return false
        elseif (1-y)-1//2==1//2-y

        n=W
        I1=Int64[]
        I2=Int64[]
        I3=Int64[]
divide=false

            for i =0:n
                for j=i:n
                    check1=i*(1-alpha)+(j-i)*(1-y)+(n-j)*(1//2)
                    check2=i*(1-x)+(j-i)*(1//2)+(n-j)*(y)
                    if check1>m//s&&check2<m//s
                        if check2!=m//s
                            push!(I1, i)
                            push!(I2, j-i)
                            push!(I3, n-j)
                            if i!=0&&(Wshares%i!=0)
                                divide=true
                            end
                        else
                            continue
                        end
                    else
                        continue
                    end
                end
            end
        end

        I2numb=maximum(I2)
        I3numb=maximum(I3)
        if (r%(I2numb+I3numb)!=0)||divide
                return true
        else
                return false
        end

    elseif Vshares>Wshares
        y=1-((m//s)-((V-1)*alpha))
        x=1-((m//s)-((W-1)*(1-alpha)))

        middleshares=Vshares-Wshares
        if alpha>=x||x>=y
            return false
        elseif 1//2-(1-y)==y-1//2

            n=V
            I1=Int64[]
            I2=Int64[]
            I3=Int64[]

divide=false
m=0
                for i =0:n
                    for j=i:n
                        check1=i*x+(j-i)*1//2+(n-j)*(1-y)
                        check2=i*alpha+(j-i)*y+(n-j)*(1//2)
                        if check1>m//s&&check2<m//s
                            if check2!=m//s
                                push!(I1, i)
                                push!(I2, j-i)
                                push!(I3, n-j)
                                if i!=0&&(Wshares%i!=0)
                                    divide=true
                                end
                            else
                                continue
                            end
                        else
                            continue
                        end
                    end
                end
            I2numb=maximum(I2)
            I3numb=maximum(I3)
            if (q%(I2numb+I3numb)!=0)||divide
                    return true
            else
                    return false
            end
        end
end
end
end
#no natural solutions at all=#





#Helper function vmid, verifies whether mid can be used to solve m(m,s)
function vmid(m,s,a)
V, W, Vnum, Wnum = sv(m,s)

total = m//s
Wshares, Vshares= W*Wnum, V*Vnum
lowerproof, upperproof= 1-(total*(1//(V-2))), (total)*(1//(V+1))

((_, x), (y,_)) = findend(m,s,a,V)
xbuddy = 1-x
ybuddy = 1-y
abuddy = 1-a

if m<s||m<=0||s<=0||m%s==0
    return -1
elseif a<1//3||a>1//2
    return -1
elseif x>y
    return -1 #intervals are disjoint, mid does not work
elseif lowerproof>a||upperproof>a
    return -1 #v-conjecture failed
else

if Wshares>Vshares
newgapshr = Wshares-Vshares
halfshr = Int64(Vshares/2) #check this
(ubmin, lbmin) =(Int64(floor(Vshares/Wnum)), #upper bound for # of W largeshares
Int64(floor((newgapshr)/Wnum))) #lower bound for # of W smallshares
VV = W
endpoints = (y, 1//2, ybuddy, xbuddy, abuddy)
splitshares = (y, 1//2, ybuddy)
 #check these

elseif Vshares>Wshares
newgapshr =Vshares-Wshares
halfshr = Int64(newgapshr/2)
(ubmin, lbmin) = (Int64(floor(newgapshr/Vnum)), #bound for number of largeshares a V-student can have
Int64(floor(Wshares/Vnum))) #bound for number of smallshares a V-student can have
VV = V
endpoints = (a, ybuddy, xbuddy, 1//2, x)
splitshares = (xbuddy, 1//2, x)

else #if number of Vshares = number of Wshares
    return -1
end

if splitshares[3]-splitshares[2] != splitshares[2]-splitshares[1] #error if 1/2 is not in the middle of an interval
    return -1
else

#find combinations of V/W-students- implementation of combs function
studcombs = combs(VV, 3)
workingcomb = Array{Array{{Int64}}}(undef, 0)
print(studcombs)

sum = 0
#=for i= 1:length(studcombs)
    elem = studcomb[i]
    for k = 1:length(elem)
        sum = elem[k]*endpoints[]=#




end
end
end
