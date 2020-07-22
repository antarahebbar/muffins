include("tools.jl")
export findend, sv

include("text.jl")
export fracstring

include("formatj.jl")
export printf, printfT, printHeader, findlast

function intproof(m, s, a, proof::Bool=false)
a = toFrac(a)

V, W, Vnum, Wnum = sv(m,s)

if proof

total=m//s
abuddy=1-a
lowerproof= 1-(total*(1//(V-2)))
lpbuddy = 1-lowerproof
upperproof=(total)*(1//(V+1))

Wshares=W*Wnum
Vshares=V*Vnum
den=lcm(s, denominator(a))

#formatting into fractions
lpS=fracstring(lowerproof, denominator(lowerproof))
upS=fracstring(upperproof, denominator(upperproof))
aS=fracstring(a, den)
totalS=fracstring(total, den)
aB=fracstring(abuddy, den)
lpbuddyS = fracstring(lpbuddy, denominator(lpbuddy))

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
    printf("There is a ($m, $s) procedure where the smallest piece is >= $aS.")

#assumptions
    printHeader("ASSUMPTIONS:")
    printfT("Theorem 2.6", "If there is an ($m, $s) procedure with smallest piece α > 1/3, there is an ($m, $s) procedure where every muffin is cut into 2 pieces. Hence, there are $(2*m) shares.")
    printfT("Buddies", "If there exists share size α, there also must exist a share size 1-α. All possible shares sizes exist between [$aS, $aB].")

#verifying v-conjecture
printHeader("CASEWORK:")
printfT("V-Conjecture", "Case 1: If Alice has <= $(V-2) shares, a share is >= $(totalS) * $(1//(V-2)), which = $lpbuddyS. Its buddy is $lpS < $aS")
printfT("V-Conjecture", "Case 2: If Bob has >= $(V+1) shares, a share is >= than $(total) * $(1//(V+1)), which = $upS. $upS < $aS")

#solving for shares
printHeader("USING V-CONJECTURE TO SOLVE FOR # OF SHARES:")
printf("Assuming the V-Conjecture, each student will get either $V or $W shares.")
printLine()

#number of shares
printfT("V-Conjecture", "While s_$V is the number of $V-shares and s_$W is the number of $W-shares: ","", "($V)s_$V + ($W)s_$W = $(2*m)  (total shares) ", "s_$V + s_$W = $s  (total students)", "", "$Vnum students get $V pieces and $Wnum students get $W pieces. There are $Vshares $V-shares and $Wshares $W-shares.")
println("")


#cases

((_, x), (y,_)) = findend(m,s,a,V)
xbuddy = 1-x
ybuddy = 1-y

#format
xS=fracstring(x, den)
yS=fracstring(y, den)
xB=fracstring(xbuddy, den)
yB=fracstring(ybuddy, den)



if x>y
    printf("Intervals are not disjoint, you should use half/fc to solve for alpha")
    printEnd()
elseif x==a || y==(1-a)
    printf("Findend failed, intproof failed")
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


if Wshares > Vshares #according to VV conjecture the gap will exist in the Wshares
    newgapshr= Wshares-Vshares
#defining the new gap
printfT("New gap", "The new gap will exist within the $W-shares. Because $Vshares $V-shares exist within [$aS, $xS], there must be $Vshares $W-shares within their buddies.")

##interval graph with gaps
printHeader("INTERVAL DIAGRAM: ")
printf("The following diagram depicts the interval diagram with the new gap: ")
println("\n",
        interval(["(", aS],
                [")[", xS],
                ["](", yS],
                [")[", yB],
                ["](", xB],
                [")", aB],
                labels=["$Vshares $V-shs", "0", "$newgapshr $W-shares", "0", "$Wshares $W-shs"]))

#defining small/largeshares
printfT("Defining terms", "The $W-shares that lie in [$yS, $yB] are called smallshares. $W-shares in [$xB, $aB] are largeshares.")

#defining variables
ubmin=Int64(floor(Vshares/Wnum)) #upper bound for # of W largeshares
lbmin = Int64(floor((newgapshr)/Wnum)) #lower bound for # of W smallshares



#checking for a contradiction
check1 =(W-ubmin)*(ybuddy)+(ubmin)*abuddy #looking for a contradiction in largeshaes
check2 = (W-lbmin)*xbuddy+(lbmin)*a #looking for a contradiction in smallshares

#case3 - do shares total up to m/s?

if check1<=total
    println("Case 3: Alice is a $W student. If she has $key1 large shares, we get a contradiction - there are only $Wnum $W-students and $key1 largeshares.")
    println("If she had <= $(key1-1) largeshares, then she has < $(key1-1) * $(yB) + $((key1-1)*a) <= $totalS. Therefore, alpha works.")
    println("")
elseif check2>=total
    println("Case 3: Alice is a $W student. If she has $key2 middleshares, we get a contradiction - there are only $Wnum $W-students and $key2 middleshares.")
    println("If she had <= $(key2-1) middleshares, then she has < $(key2-1) * $(yB) + $((key2-1)*a) <= $totalS. Therefore, alpha works.")
    println("")
else
    println("shares do not add up to total, alpha does not work")
end


elseif Wshares<Vshares

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
                labels=["$Vshares $V-shs", "0", "$newgapshr $V-shares", "0", "$Vshares $W-shs"]))

printfT("Defining terms", "The $V-shares that lie in [$aS, $yB] are called smallshares. $V-shares in [$xB, $xS] are largeshares.")



#defining small/largeshares

#defining variables
ubmin = Int64(floor(newgapshr/Vnum))
lbmin = Int64(floor(Wshares/Vnum))

#case 3: do shares total up to m/s?
check1 = (V-ubmin)*y+(ubmin)*x
check2=(V-lbmin)*xbuddy+(lbmin)*a #not sure if algorithm is correct

if check1<=total
    println("Case 3: Alice is a $V student. If Alice has $key1 large shares, there is a contradiction:")
    println("(There are $Vnum $V-students - we can't have $(Vnum*key1) largeshares.")
    println("If she had <=$(key1-1) largeshares, then she has < $(V-key1+1) * $(yB) + $(key1-1)*$xS) <= $totalS. Therefore alpha works.")
    println("")
elseif check2>=total
    println("Case 3: Alice is a $V student. If Alice has $key2 smallhares, there is a contradiction:")
    println("(There are $Vnum $V-students - we can't have $(Vnum*j) smallshares.")
    println("If she had <=$(key2-1) smallshares, then she has < $(V-key2+1) * $(aS) + $(key2-1)*$xB) <= $totalS. Therefore alpha works.")
    println("")

else
    println("share distribution do not add up to total, alpha does not work")
end

else
    return "V-shares = Wshares. In this case, use FC(m,s)"

end
end
end
else
    return "input true to print proof"
end
end
