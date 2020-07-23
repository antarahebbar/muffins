include("tools.jl")
export findend, sv

include("text.jl")
export fracstring

include("formatj.jl")
export printf, printfT, printHeader, findlast

function intproof(m, s, a, proof::Bool=true)

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
printf("There is a ($m, $s) procedure where the smallest piece is ≥ $aS.")

#assumptions
printHeader("ASSUMPTIONS:")
printfT("Theorem 2.6", "If there is an ($m, $s) procedure with smallest piece α > 1/3, there is an ($m, $s) procedure where every muffin is cut into 2 pieces. Hence, there are $(2*m) shares.")
printfT("Buddies", "If there exists share size α, there also must exist a share size 1-α. All possible shares sizes exist between [$aS, $aB].")

#verifying v-conjecture
printHeader("CASEWORK:")
printfT("V-Conjecture", "Case 1: If Alice has ≤ $(V-2) shares, a share is ≥ $(totalS) * $(1//(V-2)), which = $lpbuddyS. Its buddy is $lpS < $aS")
printfT("V-Conjecture", "Case 2: If Bob has ≥ $(V+1) shares, a share is ≥ than $(total) * $(1//(V+1)), which = $upS. $upS < $aS")

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

output=false
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
    printfT("Case 3.1", "Alice is a $W student. If she has $(ubmin+1) large shares, we get a contradiction - there are only $Wnum $W-students and $Vshares largeshares.")
    printfT("Case 3.2", "If Alice had ≤ $(ubmin) largeshares, then she has $(W-ubmin) * $(yB) + $((ubmin)*a) ≤ $totalS.", "However, since Alice gets less than $totalS, this case is impossible.")
    output=true

elseif check2>=total
    printfT("Case 3.1", "Alice is a $W student. If she has $(lbmin+1) smallshares, we get a contradiction:", "", "There are only $Wnum $W-students and $newgapshr smallshares.")
    printfT("Case 3.2", "If Alice had ≤ $(lbmin) smallshares, then she has $(W-lbmin) * $(xB) + $((lbmin)*a) ≥ $totalS.", "", "However, since Alice gets more than $totalS, this case is impossible.")
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
    printfT("Case 3.1", "Alice is a $V student. If Alice has $(ubmin+1) large shares, there is a contradiction:", "", "There are only $Vnum $V-students and $newgapshr largeshares.")
    printfT("Case 3.2", "If she had ≤$(ubmin) largeshares, then she has $(V-ubmin) * $(yS) + $(ubmin)*$xS ≤ $totalS.", "", "However, since Alice gets less than $totalS, this case is impossible.")
    output=true

elseif check2>=total
    printfT("Case 3.1", "Alice is a $V student. If Alice has $lbmin smallshares, there is a contradiction:", "", "There are there are only $Vnum $V-students and $Wshares smallshares.")
    printfT("Case 3.2", "If she had ≤$(lbmin-1) smallshares, then she has $(V-lbmin+1) * $(aS) + $(lbmin-1)*$xB) ≥ $totalS. Therefore alpha works.", "", "However, since Alice gets more than $totalS, this case is impossible.")
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
