function VHalf(muffins, students, alpha)
    V = Int64(ceil((2 * muffins)/students))
    W = V-1
    lowerproof= 1-(muffins//students)*(1//(V-2))
    upperproof=(muffins//students)*(1//(V+1))

    x = Int64(2*muffins - W*students)
    y = Int64(V*students - 2*muffins)
    println("Claim: there is a (", muffins, ",", students, ") procedure where the smallest piece is >=", alpha)
    println("")
    println("FC(", muffins, ",", students, ") = ", FC(muffins, students), " which is >=", alpha, ", so FC does not work")
    println("If there is a student with <=", V-2," shares, a share's buddy is >= than ", lowerproof, " which is < ", alpha)
    println("and if a student has >=", V+1, " shares, a share is >= than ", upperproof, " which is < ", alpha)
    println("Thus, the student has >= ", V, " pieces or <= ", W, "pieces")
    println("")
    println("While s_", V," is the number of ", V, "-shares and s_", W, " is the number of ", W, "-shares, we can set up the equations: ")
    println("The total number of shares: ", V, "s_",V," + ", W, "s_", W, " = ", 2*muffins)
    println("And the total number of students: s_",V," + s_", W, " = ", students)
    println("")
    println("Once we solve, we get ", x, " students get ", V, " pieces and ", y, " students get ", W, " pieces")

    Wshares = W*y
    Vshares = V*x
    if Wshares > muffins
        greaterhalf=Wshares
        key = W
        other=V
    elseif Vshares>muffins
        greaterhalf=Vshares
        key = V
        other=W
    end

    halfsum=muffins//students-1//2
    firstbound=halfsum//(key-1)
    upperbound=max(firstbound, 1-firstbound)
    lowerbound=min(firstbound, 1-firstbound)

    if lowerbound!= alpha
        println("Error, lowerbound does not equal alpha")
    end

    println("Contradiction: we have ", greaterhalf," ", key, "-shares. Since there are only, ", muffins," muffins, not all shares can be < 1/2")
    println("So, some shares will have ot be >= 1/2")
    println("")
    println("The sum of all ", key, "-shares is ", muffins//students, ". If one share is 1/2, then the sum of the remaining shares is ", halfsum)

    println("There are ", key-1, " remaining shares. We divide ", halfsum, " by ", key-1, " to get the upper bound, which is ", upperbound)
    println("The buddy of ", upperbound, " is ", lowerbound, "!")

    if alpha<=1//3&&V==3
        println("However, since the buddy is <= than 1//3, the answer is 1//3")
        println("(    ", Vshares, " " , V, "-shares   )-(0)-(   ", Wshares, " ", W, "-shares   )")
        println(1//3, "               ", 1//2, "                 ", 2//3)
    else
        if Wshares>muffins
            missingbound=(muffins//students)-(V-1)*lowerbound
            if missingbound>1//2 || missingbound<alpha
                println("Error, the bounds overlap") #bound error
            else
                println("(    ", Vshares, " " , V, "-shares   )-(0)-(   ", Wshares, " ", W, "-shares   )")
                println(lowerbound, "          ", missingbound, "  ", 1//2, "            ", upperbound)
            end

        elseif  Vshares>muffins
            missingbound=(muffins//students)-(W-1)*upperbound
            if missingbound<1//2 || missingbound>upperbound
                println("Error: the bounds overlap so it requires two diagrams") #bound error
            else
            println("(    ", Vshares, " " , V, "-shares   )-(0)-(   ", Wshares, " ", W, "-shares   )")
            println(lowerbound, "          ", 1//2, "  ", missingbound, "            ", upperbound)
            end
        end
    end
end

function FC(muffins, students)
    V = (2 * muffins) / students
    minceil=muffins//(Int64(students * ceil(V)))
    minfloor=1-muffins//(Int64(students * floor(V)))

    if muffins<students return("Moron! We only deal with muffins >= students.")
    elseif muffins%students==0 return(1)
    else return max(1//3, min(minceil, minfloor))
    end
end
