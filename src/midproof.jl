include("tools.jl")
export findend, sv

include("format.jl")
export printf, printfT, printHeader, findlast, formatFrac


function midproof(m, s, a, proof::Bool=true)

V, W, Vnum, Wnum = sv(m,s)

if proof

#defining variables
    total=m//s
    abuddy=1-a
    lowerproof= 1-(total*(1//(V-2))) #verifying v-conjecture
    lpbuddy = 1-lowerproof
    upperproof=(total)*(1//(V+1)) #verigying v-conjecture
    Wshares=W*Wnum
    Vshares=V*Vnum
    den=lcm(s, denominator(a))

#formatting into fractions
    lpS=formatFrac(lowerproof, denominator(lowerproof))
    upS=formatFrac(upperproof, denominator(upperproof))
    aS=formatFrac(a, den)
    alpha = formatFrac(a, denominator(a))
    totalS=formatFrac(total, den)
    aB=formatFrac(abuddy, den)
    lpbuddyS = formatFrac(lpbuddy, denominator(lpbuddy))

if lowerproof>a ||upperproof >a
    printf("Alpha does not comply with v-conjecture, V-Int failed")
    printEnd()
elseif a<1//3||a>1//2
    printf("Alpha must be >1//3 and <1//2")
    printEnd()
elseif m%s==0
    printf("Int method does not apply to input, alpha is 1 since s divides into m")
    printEnd()
elseif m<s
    printf("Int method does not apply, m must be > than s")
    printEnd()
else

#claim
    printHeader("CLAIM:")
    printf("There is a ($m, $s) procedure where the smallest piece is ≥ $alpha.")
    printfT("Note", "Let the common denominator $den. Therefore, alpha will be referred to as $aS.")

#assumptions
    printHeader("ASSUMPTIONS:")
    printfT("Determining muffin pieces", "If there is an ($m, $s) procedure with smallest piece α > 1/3, there is an ($m, $s) procedure where every muffin is cut into 2 pieces. Hence, there are $(2*m) shares.")
    printfT("Buddies", "If there exists share size α, there also must exist a share size 1-α. All possible shares sizes exist between [$aS, $aB].")


#findend
((_, x), (y,_)) = findend(m,s,a,V)
xbuddy = 1-x
ybuddy = 1-y

#formatting
xS = formatFrac(x, den)
yS=formatFrac(y, den)
xB = formatFrac(xbuddy, den)
yB= formatFrac(ybuddy, den)

#solving for shares
printHeader("SOLVING FOR # OF SHARES:")
printf("Each student will get either $V or $W shares.")
printLine()

#number of shares
printfT("Determining sharesizes", "While s_$V is the number of $V-shares and s_$W is the number of $W-shares: ","", "($V)s_$V + ($W)s_$W = $(2*m)  (total shares) ", "s_$V + s_$W = $s  (total students)", "", "$Vnum students get $V pieces and $Wnum students get $W pieces. There are $Vshares $V-shares and $Wshares $W-shares.")
println("")

#interval diagram without gaps
printHeader("INTERVAL DIAGRAM:")
printf("The following captures what we know:")
println("\n",
        interval(["(", aS],
                [")[", xS],
                ["](", yS],
                [")", aB],
                labels=["$Vshares $V-shs", "0", "$Wshares $W-shs"]))

if Wshares>Vshares
    newgapshr = Wshares-Vshares
    printfT("Buddying", "Since [$xS, $yS] is empty, by buddying we know that [$yB, $xB] is also empty.")
    printf("Our new diagram will look like this:")
    println("\n",
            interval(["(", aS],
                    [")[", xS],
                    ["](", yS],
                    [")[", yB],
                    ["](", xB],
                    [")", aB],
                    labels=["$Vshares $V-shs", "0", "$newgapshr $W-shares", "0", "$Vshares $W-shs"]))
    printfT("Defining terms", "We call the first interval of $W-shares smallshares and the second largeshares.", "", "Let Alice be a $W student.")
elseif Vshares>Wshares
    newgapshr = Vshares-Wshares
    printfT("Buddying", "Since [$xS, $yS] is empty, by buddying we know that [$yB, $xB] is also empty.")
    printf("Our new diagram will look like this:")
    println("\n",
            interval(["(", aS],
                    [")[", yB],
                    ["](", xB],
                    [")[", xS],
                    ["](", yS],
                    [")", aB],
                    labels=["$Wshares $V-shs", "0", "$newgapshr $V-shares", "0", "$Wshares $W-shs"]))
    printfT("Defining terms", "We call the first interval of $W-shares smallshares and the second largeshares.")

    ubmin = Int64(floor(newgapshr/Vnum))
    lbmin = Int64(floor(Wshares/Vnum))

    ubcheck1 = (V-ubmin)*ybuddy + ubmin*x
    ubcheck2 = (V-ubmin)*a + ubmin*xbuddy
    lbcheck1 = (V-lbmin)*ybuddy + lbmin*x
    lbcheck2 = (V-lbmin)*a + lbmin*xbuddy

    ubcheck1S = formatFrac(ubcheck1, den)
    ubcheck2S=formatFrac(ubcheck2, den)
    lbcheck1S = formatFrac(lbcheck1, den)
    lbcheck2S=formatFrac(lbcheck2, den)

#determining how many shares a V-student can have
printHeader("DETERMINING TYPES OF $V-STUDENTS:")
printf("Let Alice be a $V student.")
printfT("Determining type of $V-student", "If Alice gets $ubmin largeshares and $(V-ubmin) smallshares, she has < $(V-ubmin)*$yB + $ubmin*$xS = $ubcheck1S. She gets enough.", "", "Alice also gets ≥ $(V-ubmin)*$aS + $ubmin*$xB = $ubcheck2S. She doesn't get too much.", "", "This kind of student is possible.")
printfT("Determining type of $V-student", "If Alice gets $lbmin smallshares and $(V-lbmin) largeshares, she has < $(V-lbmin)*$yB + $lbmin*$xS = $lbcheck1S. She gets enough.", "", "Alice also gets ≥ $(V-lbmin)*$aS + $lbmin*$xB = $lbcheck2S. She doesn't get too much.", "", "This kind of student is possible.")
printf("Therefore, all $V-students must have at least $ubmin largeshares and $lbmin smallshares.")

else
    printf("midproof failed, both intervals have equal shares")
end

    #=if Wshares > Vshares
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
        end=#
end
end
end
