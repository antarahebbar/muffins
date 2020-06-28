function VInt(muffins, students, alpha)
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

        x=(muffins//students)-((V-1)*alpha)
        y=(muffins//students)-((W-1)*(1-alpha))
        middleshares= Wshares-Vshares

        if alpha==1//3
            keylow=Int64(floor(Wshares/r))
            keyhigh= Int64(ceil(Wshares/r))
            other = W-keylow-1

            println("(",Vshares, " ", V, "-shares)(---0---)(", middleshares, " ", W, "-shares)(---0---)(", Vshares, " ", W, "-shares)")
            println(alpha, "       ", x, "    ", y, "       ", 1-y, "    ", 1-x, "       ", 1-alpha)

            check1=(keylow-1)*(1-alpha)+other*(y)
            check2=(keylow-1)*(1-alpha)+other*(x)
            check3=(keylow-1)*(1-x)+other*(1-y)
            println("Each student must have ", keylow, " largeshares. Verifying this: ")
            if check1>=muffins//students||check2<=muffins//students
                println("If a student has ", keylow, " largeshares and ", W-keylow, " smallshares they can atmost have ", muffins//students, " in total, which works!")
                if check3<=muffins//students
                    println("We can also check this in this way - if a student has ",  W-keylow, " ", 1-x, " size shares, they have <= ", muffins//students)
                    println("Therefore, ", alpha, " works as the upper bound with ", muffins, " muffins and ", students, " students")
                else
                    println("Alpha does not work, ", check3)
                end
            else
                println("Alpha does not work")
            end

        elseif alpha>=x||x>=y
            print("BOUND ERROR - the graph is incorrect")
            println("")
        else
            keylow=Int64(floor(Vshares/r))
            keyhigh= Int64(ceil(Vshares/r))
            other = W-keylow

            println("(",Vshares, " ", V, "-shares)(---0---)(", middleshares, " ", W, "-shares)(---0---)(", Vshares, " ", W, "-shares)")
            println(alpha, "        ", x, "  ", y, "       ", 1-y, " ", 1-x, "        ", 1-alpha)
            println("")
            println("We will call shares between ", 1-x, " and ", 1-alpha, " large-shares. Similarly those between ", y, " and ", 1-y, " are small shares")
            println("The bounds are derived in the graph from this logic - ")
            println("Since there are no shares between ", x, " and ", y, ", there must be no shares b/w their buddies, ", 1-y, " and ", 1-x)
            println("Also, since there are ", Vshares, " ", V, "-shares b/w ", alpha, " and ", x, " there must be the same number of ", W, "-shares with their buddies, leaving ", middleshares, " shares in between ", y, " and ", 1-y)
            println("The half method won't work here, since 1/2 of ", students, "//", students, " = ", students/2, "//", students, ", 1/2 is inside the interval with more shares, causing the half method to be innacurate")
            println("")

            if keyhigh*r>Vshares
                newdown=1-muffins//students+(W-1)
                answer= (keylow+other*newdown-muffins//students)//(keylow+other*(W-1))
                println("If each student has at least ", keyhigh, " ", "large-shares, then is a contradiction since we only have ", Vshares, " ", W, "-shares, not ", keyhigh*r)
                println("Each student must have ", keylow, " large shares. Verifying this: ")
                println("")


                check1=keylow*(1-alpha)+(W-keylow)*(y)
                check2=keylow*(1-alpha)+(W-keylow)*(1-y)
                check3=(keylow)*(1-x)+(W-keylow)*(1-y)
                if check1==muffins//students||check2==muffins//students
                    println("If a student has ", keylow, " largeshares and ", W-keylow, " smallshares they can atmost have ", muffins//students, " in total, which works!")
                    if check3<=muffins//students
                        println("We can also check this in this way - if a student has ", keylow, " ", 1-y, " largeshares and ", W-keylow, " ", 1-x, " smallshares, they have <= ", muffins//students)
                        println("Therefore, ", alpha, " works as the upper bound with ", muffins, " muffins and ", students, " students")
                    else
                        println("Alpha does not work, ", check3)
                    end
                else
                    println("Alpha does not work")
                end
            else
                println("Error, does not work")
            end
        end



    elseif Vshares>Wshares
        y=1-(muffins//students-((V-1)*alpha))
        x=1-(muffins//students-((W-1)*(1-alpha)))
        if alpha>=x||x>=y
            println("BOUND ERROR")
        else
            middleshares=Vshares-Wshares
            println("(",Wshares, " ", V, "-shares)(---0---)(", middleshares, " ", V, "-shares)(---0---)(", Wshares, " ", W, "-shares)")
            println(alpha, "      ", x, " ", y, "           ", 1-y, "  ", 1-x, "        ", 1-alpha)
            println("")
            println("Since 1/2 of ", students, "//", students, " = ", students/2, "//", students, ", 1/2 is inside the interval with more shares, causing the half method to be innacurate")
            println("The bounds are derived in the graph from this logic - since there are no shares between ", x, " and ", y, ", there must be no shares b/w their buddies")
            println("Also, since there are ", Wshares, " ", W, "-shares b/w ", 1-x, " and ", 1-alpha, " there must be an equal number of ", V, "-shares with their buddies")


            keylow=Int64(floor((Vshares-Wshares)/q))
            keyhigh=Int64(ceil((Vshares-Wshares)/q))
            other=V-keylow
            answer=(other*(1-muffins//students+(W-1))+(keylow-1)*(muffins//students))//(other+keylow*(V-1))
            println("If each student has at least ", keyhigh, " ", V, "-shares, then is a contradiction since we only have ", middleshares, " ", V, "-shares, not ", keyhigh*q)
            println("Each student has ", keylow, " large shares. Verifying this: ")
            println("")

            check1=keylow*(1-y)+(V-keylow)*x
            check2=keylow*(1-y)+(V-keylow)*alpha
            check3=keylow*(y)+(V-keylow)*x
            if check1==muffins//students||check2==muffins//students
                println("If a student has ", keylow, " largeshares and ", V-keylow, " smallshares they can atmost have ", muffins//students, " in total, which works!")
                if check3<=muffins//students
                    println("We can also check this in this way - if a student has ", keylow, " ", y, " largeshares and ", V-keylow, " ", x, " smallshares, they have <= ", muffins//students)
                    println("Therefore, ", alpha, " works as the upper bound with ", muffins, " muffins and ", students, " students")
                else
                    println("Alpha does not work because lowerbounds are greater than, ", muffins//students)
                end
            else
                println("Alpha does not work, verification failed")
                println("check 1 - ", check1, " check 2 - ", check2, " check 3  - ", check3)
            end
        end
    end
end

#at least x large shares and small shares
#denominator is denominator of answer and students
