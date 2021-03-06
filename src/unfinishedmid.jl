

include("tools.jl")
using .Tools

include("format.jl")
using .Formatting


export mid, vmid, midproof
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
(ubmin, lbmin) =(Int64(floor(Vshares/Wnum)), #upper bound for # of W largeshares a student can have
Int64(floor((newgapshr)/Wnum))) #lower bound for # of W smallshares a student can have
Vkey = W
endpoints = (y, 1//2, ybuddy, xbuddy, abuddy)
splitshares = (y, 1//2, ybuddy)
 #check these

elseif Vshares>Wshares
newgapshr =Vshares-Wshares
halfshr = Int64(newgapshr/2)
(ubmin, lbmin) = (Int64(floor(newgapshr/Vnum)), #bound for number of largeshares a V-student can have
Int64(floor(Wshares/Vnum))) #bound for number of smallshares a V-student can have
Vkey = V
intervals =  [[a ybuddy]; [xbuddy 1//2]; [1//2 x]]
sizeint, rand = size(intervals)
splitshares = (xbuddy, 1//2, x)

else #if number of Vshares = number of Wshares
    return -1
end

if splitshares[3]-splitshares[2] != splitshares[2]-splitshares[1] #error if 1/2 is not in the middle of an interval
    #return -1
else

#find combinations of V/W-students- implementation of combs
studcombs = combs(Vkey, sizeint)
array_combs = Array{Array{Int64, 1}}(undef, 0)

append!(array_combs, studcombs)

#finding sums of each combination and verifying if they work w mid
ubsum = 0
lbsum = 0
possible = Array{Int64, 1}(undef, 0)
for i = 1:length(array_combs)
    possible =array_combs[i]

    for j = 1:length(possible)
        lbsum = ubsum+possible[j]*interval[j,1]
        ubsum = lbsum +possible[j]*interval[j,2]
        if lbsum>m//s || ubsum<

for i= 1:length(studcombs)
    elem = studcomb[i]
    for k = 1:length(elem)
        sum = elem[k]*endpoints[]=#




#end
end
end

end




function midproof(m, s, a, proof::Bool=true)

V, W, Vnum, Wnum = sv(m,s)

if proof

#defining variables
    total=m//s
    abuddy=1-a
    (lowerproof, upperproof)= (1-(total*(1//(V-2))),total*(1//(V+1))) #verifying v-conjecture
    lpbuddy = 1-lowerproof #verigying v-conjecture
    (Wshares, Vshares)=(W*Wnum, V*Vnum)
    den=lcm(s, denominator(a))

#formatting into fractions
    (lpS, upS, lpbuddyS)=(formatFrac(lowerproof), formatFrac(upperproof), formatFrac(lpbuddy))
    (alpha, aS, aB) = (formatFrac(a), formatFrac(a, den), formatFrac(abuddy, den))
    totalS=formatFrac(total, den)

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
mid = formatFrac(1//2, den)

#formatting
xS, yS, xB, yB = (formatFrac(x, den), formatFrac(y, den), formatFrac(xbuddy, den), formatFrac(ybuddy, den))

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

newgapshr = Wshares-Vshares


if Vshares>Wshares
    newgapshr = Vshares-Wshares
    halfshr = Int64(newgapshr/2)
    (ubmin, lbmin) = (Int64(floor(newgapshr/Vnum)), Int64(floor(Wshares/Vnum)))

    (ubcheck1, ubcheck2) = ((V-ubmin)*ybuddy + ubmin*x, (V-ubmin)*a + ubmin*xbuddy)
    (lbcheck1, lbcheck2) = ((V-lbmin)*ybuddy + lbmin*x, (V-lbmin)*a + lbmin*xbuddy)

    (ubcheck1S, ubcheck2S, lbcheck1S, lbcheck2S) = (formatFrac(ubcheck1, den), formatFrac(ubcheck2, den), formatFrac(lbcheck1, den), formatFrac(lbcheck2, den))
end

printfT("Buddying", "Since [$xS, $yS] is empty, by buddying we know that [$yB, $xB] is also empty.")
printfT("Defining terms", "We call the first interval of $W-shares smallshares and the second largeshares.")
printf("Our new diagram will look like this:")


if Wshares>Vshares
    println("\n",
            interval(["(", aS],
                    [")[", xS],
                    ["](", yS],
                    [")[", yB],
                    ["](", xB],
                    [")", aB],
                    labels=["$Vshares $V-shs", "0", "$newgapshr $W-shares", "0", "$Vshares $W-shs"]))
elseif Vshares>Wshares
    println("\n",
            interval(["(", aS],
                    [")[", yB],
                    ["](", xB],
                    [")[", xS],
                    ["](", yS],
                    [")", aB],
                    labels=["$Wshares $V-shs", "0", "$newgapshr $V-shares", "0", "$Wshares $W-shs"]))


#determining how many shares a V-student can have
printHeader("DETERMINING TYPES OF $V-STUDENTS:")
printf("Let Alice be a $V student.")
printfT("Determining type of $V-student", "If Alice gets $ubmin largeshares and $(V-ubmin) smallshares, she has < $(V-ubmin)*$yB + $ubmin*$xS = $ubcheck1S. She gets enough.", "", "Alice also gets ≥ $(V-ubmin)*$aS + $ubmin*$xB = $ubcheck2S. She doesn't get too much.", "", "This kind of student is possible.")
printfT("Determining type of $V-student", "If Alice gets $lbmin smallshares and $(V-lbmin) largeshares, she has < $(V-lbmin)*$yB + $lbmin*$xS = $lbcheck1S. She gets enough.", "", "Alice also gets ≥ $(V-lbmin)*$aS + $lbmin*$xB = $lbcheck2S. She doesn't get too much.", "", "This kind of student is possible.")
printf("Therefore, all $V-students must have at least $ubmin largeshares and $lbmin smallshares.")

#interval with mid gap
printHeader("INTERVAL DIAGRAM WITH MIDGAP: ")
printfT("Buddying", "$mid is in the middle of the interval [$xB, $xS]. The number of shares in [$xB, $mid] and [$mid, $xS] is the same.")
println("\n",
        interval(["(", aS],
                [")[", yB],
                ["](", xB],
                ["|", mid],
                [")", xS],
                labels=["$Wshares $V-shs", "0", "$halfshr $V-shares", "$halfshr $V-shs"]))

#defining interval gaps
printLine()
printfT("Defining interval gaps", "We define the following intervals: ", "", "I1 = ($aS, $yB) = $Wshares", "", "I2 = ($xB, $mid)", "", "I3 = ($mid, $xS)", "", "I2 = I3 = $(halfshr)")


#common terms used for proof
printfT("Terms", "")

else
    printf("midproof failed, both intervals have equal number of shares")
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
