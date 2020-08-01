include("tools.jl")
export sv, findend

include("format.jl")
export formatFrac

function mid(muffins, students)
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
        newdown1=1-(muffins//students)+(W-1)
        for i =0:n
            for j=i:n
                alpha1=((i)*(1//2)+(j-i)*(1-muffins//students+(W-1))+(n-j)-muffins//students)//((n-j)+(j-i)*(W-1))
                alpha2=(muffins//students-(j-i)*(1-muffins//students)-(n-j)*1//2)//(i+(j-i)*(V-1))
                check1=checkmid(muffins,students,alpha1)
                check2=checkmid(muffins, students, alpha2)
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
        newdown1=1-(muffins//students)+(W-1)
        for i =0:n
            for j=i:n
                alpha1=(i*(1-muffins//students+(W-1))+(j-i)*1//2+(n-j-1)*muffins//students)//(i*(W-1)+(n-j)*(V-1))
                alpha2=(muffins//students-(j-i)*(1-muffins//students)-(n-j)*1//2)//(i+(j-i)*(V-1))
                #alpha2=(muffins//students-i*(muffins//students-(W-1))+(j-i)*(1//2)-(n-j)*(1-muffins//students))//(i*(W-1)+(n-j)*(V-1))
                check1=checkmid(muffins, students, alpha1)
                check2=checkmid(muffins, students, alpha2)
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



function checkmid(muffins, students, alpha)
    V = Int64(ceil((2 * muffins)/students))
    W = V-1
    lowerproof= 1-(muffins//students)*(1//(V-2))
    upperproof=(muffins//students)*(1//(V+1))
    q = Int64(2*muffins - W*students)
    r = Int64(V*students - 2*muffins)
    Wshares=W*r
    Vshares=V*q

    if Wshares > Vshares
        key = W
        x=(muffins//students)-((V-1)*alpha)
        y=(muffins//students)-((W-1)*(1-alpha))
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
                    if check1>muffins//students&&check2<muffins//students
                        if check2!=muffins//students
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
        y=1-((muffins//students)-((V-1)*alpha))
        x=1-((muffins//students)-((W-1)*(1-alpha)))

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
                        if check1>muffins//students&&check2<muffins//students
                            if check2!=muffins//students
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
#no natural solutions at all
