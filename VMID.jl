
function VMid(muffins, students, alpha)
    V = Int64(ceil((2 * muffins)/students))
    W = V-1
    lowerproof= 1-(muffins//students)*(1//(V-2))
    upperproof=(muffins//students)*(1//(V+1))
    q = Int64(2*muffins - W*students)
    r = Int64(V*students - 2*muffins)
    Wshares=W*r
    Vshares=V*q

    println("Claim: there is a (", muffins, ",", students,") procedure where the smallest share is ", alpha)
    println("")
    println("Each student will get either ", V, " or ", W, " shares")
    println("If there is a student with <=", V-2," shares, a share's buddy is >= than ", lowerproof, " which is < ", alpha)
    println("and if a student has >=", V+1, " shares, a share is >= than ", upperproof, " which is < ", alpha)
    println("While s_", V," is the number of ", V, "-shares and s_", W, " is the number of ", W, "-shares, we can set up the equations: ")
    println("The total number of shares: ", V, "s_",V," + ", W, "s_", W, " = ", 2*muffins)
    println("And the total number of students: s_",V," + s_", W, " = ", students)
    println("Once we solve, we get ", q, " students get ", V, " pieces and ", r, " students get ", W, " pieces, so there are ", Vshares, " ", V, "-shares and ", Wshares, " ", W, "-shares")
    println("")
    println("We can set up the interval graph: ")

    if Wshares > Vshares
        key = W
        x=(muffins//students)-((V-1)*alpha)
        y=(muffins//students)-((W-1)*(1-alpha))
        middleshares=Wshares-Vshares
        if alpha>=x||x>=y
            println("BOUND ERROR. Alpha doesn't work")
            println("")
        elseif (1-y)-1//2==1//2-y
            println("(",Vshares, " ", V, "-shares)(---0---)(", middleshares, " ", W, "-shares)(---0---)(", Vshares, " ", W, "-shares)")
            println(alpha, "        ", x, "  ", y, "   ", 1//2, "    ", 1-y, " ", 1-x, "        ", 1-alpha)
            println("")
            println("We now have three intervals. I1 is b/w ", 1-alpha, " and ", 1-x, " and contains ", Vshares, " shares")
            println("I2 is bw ", 1-y, " and ", 1//2, " and contains ", middleshares/2, " shares")
            println("I3 bw ", 1//2, " and ", y, " and contains ", middleshares/2, " shares")
            println("")
            println("Here are the possibilities for student shares: ")
        else
            println("Bound error")
        end

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
                            println("The student can have ", i, " I1 shares, ", j - i, " I2 shares, and ", n - j, " I3 shares")
                            push!(I1, i)
                            push!(I2, j-i)
                            push!(I3, n-j)
                            if i!=0&&(Vshares%i!=0)
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
        println("")
        println("y1 are the students with the first combo of shares, y2 are the students with the second combo of shares")
        println("Since I2=I3, we can set up these equations:")
        I3numb=maximum(I3)
        I2numb=maximum(I2)

        println("Eq 1: ", I3numb, "y1 = ", I2numb, " y2")
        println("Eq 2: y1 + y2 = ", r)
        println(I3numb+I2numb, "y = ", r)
        println("")
        if (r%(I3numb+I2numb))!=0||divide
            println("There is a contradiction, since y isn't a natural number. The proof works.")
        else
            println("There is no contradiction. The proof does not work.")
        end

    elseif Vshares>Wshares
        y=1-((muffins//students)-((V-1)*alpha))
        x=1-((muffins//students)-((W-1)*(1-alpha)))

        middleshares=Vshares-Wshares
        if alpha>=x||x>=y
            println("BOUND ERROR. Alpha does not work")
        elseif 1//2-(1-y)==y-1//2
            println("(",Wshares, " ", V, "-shares)(---0---)(", middleshares, " ", V, "-shares)(---0---)(", Wshares, " ", W, "-shares)")
            println(alpha, "      ", x, " ", y, "   ", 1//2, "  ", 1-y, "  ", 1-x, "      ", 1-alpha)
            println("")
            println("We now have three intervals. I1 is b/w ", alpha, " and ", x, " and contains ", Vshares, " shares")
            println("I2 is bw ", y, " and ", 1//2, " and contains ", middleshares/2, " shares")
            println("I3 bw ", 1//2, " and ", y, " and contains ", middleshares/2, " shares")
            println("")
            println("Here are the possibilities for student shares: ")

            n=V
            I1=Int64[]
            I2=Int64[]
            I3=Int64[]

divide=false

                for i =0:n
                    for j=i:n
                        check1=i*x+(j-i)*1//2+(n-j)*(1-y)
                        check2=i*alpha+(j-i)*y+(n-j)*(1//2)
                        if check1>muffins//students&&check2<muffins//students
                            if check2!=muffins//students
                                println("The student can have ", i, " I1 shares, ", j - i, " I2 shares, and ", n - j, " I3 shares")
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
        println("")
        println("y1 are the students with the first combo of shares, y2 are the students with the second combo of shares")
        println("Since I2=I3, we can set up these equations:")

        I3numb=maximum(I3)
        I2numb=maximum(I2)

        println("Eq 1: ", I3numb, "y1 = ", I2numb, " y2")
        println("Eq 2: y1 + y2 = ", q)
        println(I3numb+I2numb, "y = ", q)

        println("")
        if (q%(I3numb+I2numb))!=0||divide
            println("There is a contradiction, since y isn't a natural number. The proof works.")
        else
            println("There is no contradiction. The proof does not work.")
        end
            end
        end
end
