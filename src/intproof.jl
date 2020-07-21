include("tools.jl")
export findend, sv

include("text.jl")
export fracstring

include("formatj.jl")
export printf, printfT, printHeader, findlast

function intproof(m, s, a, proof::Bool=false)
a = toFrac(a)

V, W, q, r = sv(m,s)

if proof

total=m//s
abuddy=1-a
lowerproof= 1-(total*(1//(V-2)))
lpbuddy = 1-lowerproof
upperproof=(total)*(1//(V+1))

Wshares=W*r
Vshares=V*q
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
    printfT("Theorem 2.6", "If there is an ($m, $s) procedure with smallest piece α > 1/3, there is an ($m, $s) procedure where every muffin is cut into 2 pieces, therefore there are $(2*m) total shares.")
    printfT("Buddies", "If there exists share size α, there also must exist a share size 1-α. Therefore, all possible shares sizes exist between [$aS, $aB].")

#verifying v-conjecture
printHeader("CASEWORK:")
printfT("V-Conjecture", "Case 1: If Alice has <= $(V-2) shares, a share is >= $(totalS) * $(1//(V-2)), which = $lpbuddyS. Its buddy is $lpS < $aS")
printfT("V-Conjecture", "Case 2: If Bob has >= $(V+1) shares, a share is >= than $(total) * $(1//(V+1)), which = $upS. $upS < $aS")

#solving for shares
printHeader("USING V-CONJECTURE TO SOLVE FOR # OF SHARES:")
printfT("V-Conjecture", "Assuming the V-Conjecture, each student will get either $V or $W shares.")

#number of shares
printfT("V-Conjecture", "While s_$V is the number of $V-shares and s_$W is the number of $W-shares: ","", "($V)s_$V + ($W)s_$W = $(2*m)", "s_$V + s_$W = $s", "", "$q students get $V pieces and $r students get $W pieces. There are $Vshares $V-shares and $Wshares $W-shares.")
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

#interval graph
if Wshares > Vshares #according to VV conjecture the gap will exist in the Wshares
    newgapshr= Wshares-Vshares

#diagram
printHeader("INTERVAL DIAGRAM: ")
printf("($Vshares $V-shares)(---0---)($newgapshr $W-shares)(---0---)($Vshares $W-shares)")
printf("$aS     $xS     $yS       $yB     $xB       $aB")

#calculating minimum i to create contradiction for largeshares
i=0
j=0
key1=0
key2=0

for i=1:W
    if i*r<Vshares
        i+=1
    else
        key1=i
        break
    end
end

#minimum j for contradiction in smallshares
for j=1:W
    if j*r<newgapshr
        j+=1
    else
        key2=j
        break
    end
end
check1 = (W-key1+1)*(ybuddy)+(key1-1)*(abuddy)
check2 = (key2-1)*xbuddy+(W-key2+1)*y #not sure if this algorithm is correct

#case3 - do shares total up to m/s?

if check1<=total
    println("Case 3: Alice is a $W student. If she has $key1 large shares, we get a contradiction - there are only $r $W-students and $key1 largeshares.")
    println("If she had <= $(key1-1) largeshares, then she has < $(key1-1) * $(yB) + $((key1-1)*a) <= $totalS. Therefore, alpha works.")
    println("")
elseif check2<=total
    println("Case 3: Alice is a $W student. If she has $key2 middleshares, we get a contradiction - there are only $r $W-students and $key2 middleshares.")
    println("If she had <= $(key2-1) middleshares, then she has < $(key2-1) * $(yB) + $((key2-1)*a) <= $totalS. Therefore, alpha works.")
    println("")
else
    println("shares do not add up to total, alpha does not work")
end


elseif Wshares<Vshares

newgapshr=Vshares-Wshares

#diagram
printHeader("INTERVAL DIAGRAM: ")
printf("", "($Vshares $V-shares)(---0---)($newgapshr $V-shares)(---0---)($Vshares $W-shares)")
printf("$a      $yB      $xB        $xS       $yS          $aB")

#calculating minimum i to create contradiction in largeshares
i=0
j=0
key1=0
key2=0
for i=1:V
    if i*q<=newgapshr
        i+=1
    else
        key1=i
    break
    end
end

#calculating minimum j for contradiction in smallshares
for j=1:V
    if j*q<=newgapshr
        j+=1
    else
        key1=j
    break
    end
end

#case 3: do shares total up to m/s?
check1 = (V-key1+1)*ybuddy+(key1-1)*x
check2=(V-key2+1)*a+(key2-1)*xbuddy #not sure if algorithm is correct

if check1<=total
    println("Case 3: Alice is a $V student. If Alice has $key1 large shares, there is a contradiction:")
    println("(There are $q $V-students - we can't have $(q*key1) largeshares.")
    println("If she had <=$(key1-1) largeshares, then she has < $(V-key1+1) * $(yB) + $(key1-1)*$xS) <= $totalS. Therefore alpha works.")
    println("")
elseif check2<=total
    println("Case 3: Alice is a $V student. If Alice has $key2 smallhares, there is a contradiction:")
    println("(There are $q $V-students - we can't have $(q*j) smallshares.")
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
