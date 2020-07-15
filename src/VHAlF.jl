function vhalf(muffins, students, alpha)
    # this program gives a proof of an f(m,s,alpha) input, using the half method

V = Int64(ceil((2 * muffins)/students))
W = V-1
lowerproof= 1-(muffins//students)*(1//(V-2))
upperproof=(muffins//students)*(1//(V+1))


    #cases and claim
println("Claim: there is a (", muffins, ",", students, ") procedure where the smallest piece is >=", alpha)
println("")
println("Case 1: Alice gets >=", V+1, " shares, then one of them is ", muffins//students, "*", 1//(V+1), "= ", upperproof, ", which is <=", alpha)
println("Case 2: Bob gets <= ", V-2, " shares, one of them is ", muffins//students, "*", lowerproof, "= ", muffins//students*(1//(V-2)), ". Its buddy is ", 1-(muffins//students*(1//(V-2))), " <=", alpha)
println("Case 3: Hence, the student has >= ", V, " pieces or <= ", W, "pieces. There are total ", Int(muffins*2), " pieces and ", students, " students.")
println("")

#solving for shares
x = Int64(2*muffins - W*students)
y = Int64(V*students - 2*muffins)

Wshares = W*y
Vshares = V*x


println(V, "s_",V," + ", W, "s_", W, " = ", 2*muffins)
println("s_", V," + s_", W, " = ", students)
println("")
println("Hence, s_", V, "=", x, " and s_", W, "=",y,". ", x, " students get ", V, " pieces and ", y, " students get ", W, " pieces.")
println("There are ", Vshares, " ", V, "-shares and ", Wshares, " ", W, "-shares.")
println("")

if Wshares > muffins
    greaterhalf=Wshares
    key = W
    other=V
elseif Vshares>muffins
    greaterhalf=Vshares
    key = V
    other=W
end


#proof
halfsum=muffins//students-1//2
firstbound=halfsum//(key-1)
upperbound=max(firstbound, 1-firstbound)
lowerbound=min(firstbound, 1-firstbound)




#proof of alpha


if lowerbound!= alpha&&lowerbound>1//3
    println("Error, alpha cannot be derived with half method.")
elseif alpha==1//3&&lowerbound<1//3
    println("Contradiction: we have ", greaterhalf," ", key, "-shares and only ", muffins," muffins. Not all shares can be <1/2, so some will have to be >=1/2.")
    println("")

    println("The sum of all ", key, "-shares is ", muffins//students)
    println("Assume there is one ", V, " share that is <= 1//2. The sum of the remaining shares is ", muffins//students, "-", 1//2, "=", halfsum)

            #solving for alpha
    println("There are ", key-1, " remaining shares. We divide ", halfsum, " by ", key-1, " to get ", upperbound)
    println("The buddy of ", upperbound, " is ", lowerbound, ". Since ", lowerbound, "< 1//3, a procedure with ", lowerbound, " will have to be cut into 3 pieces.")
    println("Thereofore, alpha is 1//3.")
    println("")
else

    println("Contradiction: we have ", greaterhalf," ", key, "-shares and only ", muffins," muffins. Not all shares can be <1/2, so some will have to be >=1/2.")
    println("")

    println("The sum of all ", key, "-shares is ", muffins//students)
    println("Assume there is one ", V, " share that is <= 1//2. The sum of the remaining shares is ", muffins//students, "-", 1//2, "=", halfsum)

            #solving for alpha
    println("There are ", key-1, " remaining shares. We divide ", halfsum, " by ", key-1, " to get ", upperbound)
    println("The buddy of ", upperbound, " is ", lowerbound, "!")
    println("")

end


    #diagram

if alpha<=1//3&&V==3
    println("(    ", Vshares, " " , V, "-shares   )-(0)-(   ", Wshares, " ", W, "-shares   )")
    println(1//3, "               ", 1//2, "                 ", 2//3)
else
    if Wshares>muffins

        missingbound=(muffins//students)-(V-1)*lowerbound
        if missingbound>1//2 || missingbound<alpha
            println("Error, cannot produce diagram as bounds overlap.") #bound error

        else
            println("(    ", Vshares, " " , V, "-shares   )-(0)-(   ", Wshares, " ", W, "-shares   )")
            println(lowerbound, "          ", missingbound, "  ", 1//2, "            ", upperbound)
        end

    elseif  Vshares>muffins
        missingbound=(muffins//students)-(W-1)*upperbound
        if missingbound<1//2 || missingbound>upperbound
            println("Error, cannot produce diagram as bounds overlap.") #bound error
        else
            println("(    ", Vshares, " " , V, "-shares   )-(0)-(   ", Wshares, " ", W, "-shares   )")
        println(lowerbound, "          ", 1//2, "  ", missingbound, "            ", upperbound)

        end
    end
end


end
