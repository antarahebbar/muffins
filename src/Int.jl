module INTMETHOD

include("tools.jl")
using .TOOLS

include("format.jl")
using .FORMAT

export int, vint1, intproof, vint2

#Function takes (m,s) and outputs alpha if vint verifies it, can also output optional proof
#will output 1 if vint does not verify int, 1 is the largest upperbound for alpha
function int(m,s, proof::Bool=false)
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
        newgap = Wshares-Vshares
        newdown1=1-total+(W-1)
        newdown2=1-total
        ubmin=Int64(floor(Vshares/Wnum)) #upper bound for # of W largeshares
        lbmin = Int64(floor((newgap)/Wnum)) #lower bound for # of W smallshares
        f=W-ubmin
        a = min(((f)W - (f+1)m//s + ubmin)//((f-1)W + 2ubmin),
                            ((lbmin-1)W + (W -2lbmin+1)m//s)//(W^2 - lbmin)) 

        if a<=1//3
            if vint1(m,s,1//3)==0
                ans=1//3
                return ans
                if proof
                    return intproof(m,s,1//3, true)
                end
            else
                return 1 #vint failed, upperbound of alpha is 1
            end
        else
            den=lcm(s, denominator(a))

            if vint1(m,s,a)==0 #vint worked
                if proof
                    return intproof(m,s,a,true)
                end

                ans= a
                return ans
            else
                if proof
                    return intproof(m,s,a,true)
                end
                return 1 #vint failed, upperbound of alpha is 1
        end
        end

    elseif Vshares>Wshares

        j = Int64(floor((Vshares-Wshares)/Vnum))
        k=Int64(floor((Wshares/Vnum)))
        a = min(((V-j)W + (2j -V-1)m//s)//((V-j)W + (j-1)V),
                    ((V-k+1)m//s + k - V)//((V-k-1)V + 2k))
        print(a)
        f=V-k
        den=lcm(s, denominator(a))
        if a<=1//3
            if vint1(m,s,1//3)
                ans= 1//3
                if proof
                    return intproof(m,s,1//3,true)
                end
            else
                return 1 #vint failed, upperbound of alpha is 1
            end
            return ans
        else
            if vint1(m,s,a)==0
                if proof
                    return intproof(m,s,a,true)
                end
            ans = a
            return ans

            else
                if proof
                    return intproof(m,s,a,true)
                end
            return 1 #vint failed, upperbound of alpha is 1

            end
        end
    else
        return 1 #vint failed, upperbound of alpha is 1
    end

end
end

#Helper function for int, inputs (m,s,a) and verifies if alpha works- outputs 0 if true, -1 if false
function vint1(m, s, a)
V, W, Vnum, Wnum = sv(m,s)

total=m//s
lowerproof= 1-(total*(1//(V-2)))
upperproof=(total)*(1//(V+1))

Wshares=W*Wnum
Vshares=V*Vnum
if lowerproof>a ||upperproof >a #checking to see if v-conjecture works
    return -1
elseif a<1//3||a>1//2  #checks to see if a bounds are correct
    return -1
elseif m%s==0||m<s #checks to see if m&s are incompatible with int
    return -1
else

#cases

((_, x), (y,_)) = findend(m,s,a,V)
abuddy = 1-a
xbuddy = 1-x
ybuddy = 1-y

#=alpha1 = (total-x)*(1//(V-1))
alpha2= 1-(total-y)*(1//(W-1))

if alpha1!=a ||alpha2!=a
    return false=#
if x>y||x<a||y>1-a
    return -1
elseif x==a || y==(1-a)
    return -1
else


if Wshares > Vshares #according to VV conjecture the gap will exist in the Wshares
    newgapshr= Wshares-Vshares

#checking if shares add up to m/s

#defining variables
ubmin=Int64(floor(Vshares/Wnum)) #upper bound for # of W largeshares
lbmin = Int64(floor((newgapshr)/Wnum)) #lower bound for # of W smallshares

#checking for a contradiction
check1 =(W-ubmin)*(ybuddy)+(ubmin)*abuddy #looking for a contradiction in largeshaes
check2 = (W-lbmin)*xbuddy+(lbmin)*y #looking for a contradiction in smallshares


    if check1<=total
        return 0
    elseif check2>=total
        return 0
    else
        return -1
    end


elseif Wshares<Vshares

    newgapshr=Vshares-Wshares

    #defining variables
    ubmin = Int64(floor(newgapshr/Vnum))
    lbmin = Int64(floor(Wshares/Vnum))

    #case 3: do shares total up to m/s?
    check1 = (V-ubmin)*ybuddy+(ubmin)*x
    check2=(V-lbmin)*xbuddy+(lbmin)*a


    if check1<=total
        return 0
    elseif check2>=total
        return 0
    else
        return -1
    end

    else
        return -1

    end
    end
    end
end



#given m,s,a program will output a proof that f(m,s) <= alpha using int method
function intproof(m, s, a, proof::Bool=true)

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

#verifying v-conjecture applies to f(m,s) and if findend produced conclusive intervals
printHeader("CASEWORK:")

if x!=a
    printfT("Case 1", "If Alice has ≤ $(V-2) shares, a share is ≥ $(totalS) * $(1//(V-2)), which = $lpbuddyS. Its buddy is $lpS < $aS")
else
    printf("Findend did not produce a conclusive interval, int failed.")
    printEnd()
end

if y!=(1-a)
    printfT("Case 2", "If Bob has ≥ $(V+1) shares, a share is ≥ than $(total) * $(1//(V+1)), which = $upS. $upS < $aS")
else
    printf("Findend did not produce a conclusive interval, int failed.")
    printEnd()
end

#solving for shares
printHeader("SOLVING FOR # OF SHARES:")
printf("Each student will get either $V or $W shares.")
printLine()

#number of shares
printfT("Determining sharesizes", "While s_$V is the number of $V-shares and s_$W is the number of $W-shares: ","", "($V)s_$V + ($W)s_$W = $(2*m)  (total shares) ", "s_$V + s_$W = $s  (total students)", "", "$Vnum students get $V pieces and $Wnum students get $W pieces. There are $Vshares $V-shares and $Wshares $W-shares.")
println("")

#format
xS=formatFrac(x, den)
yS=formatFrac(y, den)
xB=formatFrac(xbuddy, den)
yB=formatFrac(ybuddy, den)

if x>y
    printf("Intervals are not disjoint, half/fc may be better methods to solve for alpha")
    printEnd()
elseif x==a || y==(1-a)
    printf("Findend failed - there are no sharesizes other than alpha and 1-alpha. Intproof failed")
    printEnd()

else

#output a diagram with one interval
printHeader("INTERVAL ANALYSIS: ")
printf("The following diagram shows what we have so far: ")
println("\n",
        interval(["(", aS],
                [")[", xS],
                ["](", yS],
                [")", aB],
                labels=["$Vshares $V-shs", "0", "$Wshares $W-shs"]))
printLine()
printfT("Buddies", "Because there is a gap between $xS and $yS, there must also be a new gap between $yB and $xB.")

output=false #boolean operator used to produce a conclusion

if Wshares > Vshares #according to VV conjecture the gap will exist in the Wshares
    newgapshr= Wshares-Vshares
#defining the new gap
printfT("New gap", "The new gap will exist within the $W-shares. Because $Vshares $V-shares exist within [$aS, $xS], there must be $Vshares $W-shares within their buddies.")

#interval graph with gaps
printHeader("INTERVAL DIAGRAM: ")
printf("The following diagram depicts the interval diagram with the new gap: ")
println("\n",
        interval(["(", aS],
                [")[", xS],
                ["](", yS],
                [")[", yB],
                ["](", xB],
                [")", aB],
                labels=["$Vshares $V-shs", "0", "$newgapshr $W-shares", "0", "$Vshares $W-shs"]))


#defining small/largeshares
printLine()
printfT("Defining terms", "The $W-shares that lie in [$yS, $yB] are called smallshares. $W-shares in [$xB, $aB] are largeshares.")

#defining variables
ubmin=Int64(floor(Vshares/Wnum)) #upper bound for # of W largeshares
lbmin = Int64(floor((newgapshr)/Wnum)) #lower bound for # of W smallshares

#checking for a contradiction
check1 =(W-ubmin)*(ybuddy)+(ubmin)*abuddy #looking for a contradiction in largeshaes
check2 = (W-lbmin)*xbuddy+(lbmin)*y #looking for a contradiction in smallshares

#case3 - do shares total up to m/s?
printHeader("CASE 3: FINDING A CONTRADICTION")
if check1<=total
    printfT("Case 3.1", "If Alice is a $W student and she has ≤$(ubmin) largeshares, then she has $(W-ubmin) * $(yB) + $(ubmin)*$a ≤ $totalS.", "", "However, since Alice gets less than $totalS, this case is impossible.")
    printfT("Case 3.2", "If all $W-students have $(ubmin+1) large shares, there will be a total of $((ubmin+1)*(Wnum)) shares.", "", "This is a contradiction because there are only $Wnum $W-students and $Vshares largeshares.")
    output=true

elseif check2>=total
    printfT("Case 3.1", "If Alice had ≤ $(lbmin) smallshares, then she has $(W-lbmin) * $(xB) + $(lbmin) * $aS ≥ $totalS.", "", "However, since Alice gets more than $totalS, this case is impossible.")
    printfT("Case 3.2", "If all $W-students have $(lbmin+1) smallshares, there will be a total of $((lbmin+1)*(Wnum)) shares.", "", "This is a contradiction because there are only $Wnum $W-students and $newgapshr smallshares.")
    output=true
else
    printf("The totaling of sharesizes do not result in a contradiction. Alpha does not work")
    return false
end


elseif Vshares>Wshares

newgapshr=Vshares-Wshares

#defining the new gap
printfT("New gap", "The new gap will exist within the $V-shares. Because $Wshares $W-shares exist within [$yS, $aB], there must be $Wshares $V-shares within their buddies.")

#interval diagram
printHeader("INTERVAL DIAGRAM: ")
printf("The following diagram shows the interval diagram with the new gap: ")
println("\n",
        interval(["(", aS],
                [")[", yB],
                ["](", xB],
                [")[", xS],
                ["](", yS],
                [")", aB],
                labels=["$Wshares $V-shs", "0", "$newgapshr $V-shares", "0", "$Wshares $W-shs"]))

#defining small/largeshares
printLine()
printfT("Defining terms", "The $V-shares that lie in [$aS, $yB] are called smallshares. $V-shares in [$xB, $xS] are largeshares.")


#defining variables
ubmin = Int64(floor(newgapshr/Vnum))
lbmin = Int64(floor(Wshares/Vnum))

#case 3: do shares total up to m/s, finding a contradiction
check1 = (V-ubmin)*ybuddy+(ubmin)*x
check2=(V-lbmin)*xbuddy+(lbmin)*a

if check1<=total
    printfT("Case 3.1", "If Alice is a $V student and she has ≤$(ubmin) largeshares, then she has $(V-ubmin) * $(yS) + $(ubmin)*$xS ≤ $totalS.", "", "However, since Alice gets less than $totalS, this case is impossible.")
    printfT("Case 3.2", "If all $V-students have $(ubmin+1) large shares, there will be a total of $((ubmin+1)*(Vnum)) shares.", "", "This is a contradiction because there are only $Vnum $V-students and $newgapshr largeshares.")
    output=true

elseif check2>=total
    printfT("Case 3.1", "If Alice is a $V student and she has ≤$(lbmin) smallshares, then she has $(V-lbmin) * $(aS) + $(lbmin)*$xB ≥ $totalS.", "", "However, since Alice gets more than $totalS, this case is impossible.")
    printfT("Case 3.2", "If all $V-students have $(lbmin+1) smallshares, there will be a total of $((lbmin+1)*(Vnum)) shares.", "", "This is a contradiction because there are only $Vnum $V-students and $Wshares smallshares.")
    output=true

else
    printf("The totaling of sharesizes do not result in a contradiction. Alpha does not work")
    return false
end

else
    return "V-shares = Wshares. In this case, use FC(m,s)"

end
#conclusion
if output
printHeader("CONCLUSION: ")
printfT("Final note", "Each possible case above derives a lower bound (alpha) through finding a contradiction, therefore: ", "", "muffins($m,$s)≤ α, , ∀ α ≥ $aS", "", "muffins($m,$s) ≤ $aS.")


end



end


end


else #else if proof is inputted as false
    return "input true to print proof"
end
end
end
