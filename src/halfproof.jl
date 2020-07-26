include("formatj.jl")
export printf, printfT, printHeader, findlast, printEnd, center

include("tools.jl")
export findend, sv

include("text.jl")
export fracstring

# gives a proof and interval diagram of half(m,s,alpha)
function halfproof(m::Int64, s::Int64, a, proof::Bool=true)

output=false #boolean variable used to determine to output a diagram


if proof

#defining variables used in algorithms
total=m//s
V,W,Vshr,Wshr = sv(m,s) #type and number of shares

#verifying if v-conejcture applies to f(m,s)
lp= 1-(m//s)*(1//(V-2))
lpbuddy=1-lp
up=(m//s)*(1//(V+1))
total=m//s

#defining variables used in proof
base1=(1//(V+1))
base2=(1//(W-1))
base3=(1//(V-1))

#formatting
lpstr = fracstring(lp, denominator(lp))
lpB=fracstring(lpbuddy, denominator(lpbuddy))
upstr = fracstring(up, denominator(up))
den = lcm(s, denominator(a))
alpha = fracstring(a, denominator(a))
aS = fracstring(a, den)
aB=fracstring(1-a, den)

totalS=fracstring(total, den)

base1S=fracstring(base1, denominator(base1))
base2S=fracstring(base2, denominator(base2))
base3S=fracstring(base3, denominator(base3))



#proof - checking if m,s verifies V-Conjecture
if lp>a||up>a
    printf("This case does not verify V-Conjecture, therefore it is impossible")
    printEnd()

#checking if inputs are viable
elseif m<=0||s<=0||a<=0
    printf("Input m,s & a>0")
    printEnd()
elseif a<1//3||a>1//2
    printf("Alpha must be greater than 1//3 and less than 1//2")
    printEnd()
elseif a>1
    println("Alpha must be a ≤1")
    printEnd()
else

#claim
printHeader("CLAIM:")
printf("There is a ($m, $s) procedure where the smallest piece is ≥ $alpha.")
printfT("Note", "Let the common denominator $den. Therefore, alpha will be referred to as $aS.")
printLine()

#assumptions
printHeader("ASSUMPTIONS:")
printfT("Determining muffin pieces", "If there is an ($m, $s) procedure with smallest piece α > 1/3, there is an ($m, $s) procedure where every muffin is cut into 2 pieces.
Therefore there are $(2*m) total shares.")
printfT("Buddies", "If there exists share size α, there also must exist a share size 1-α.
Therefore, all possible shares sizes exist between [$aS, $aB].")


#v-conjecture cases
printHeader("CASEWORK:")
printfT("Case 1", "Alice gets ≥ $(V+1) shares, then one of them is $totalS * $base1S = $upstr, which is ≤ $aS.")

if (W-1)<=1&&m/s>1
    printfT("Case 2", "Bob cannot have ≤$(W-1) shares since $totalS >1, so this case is impossible. ")
else
    printfT("Case 2", "Bob gets ≤ $(V-2) shares, one of them is $totalS * $base2S = $lpB, Its buddy is $lpstr, which is ≤ $aS.")
end


#solving for # of shares using v-conjecture
printHeader("SOLVING FOR # OF SHARES")
printf("Each student has ≥ $V pieces or ≤ $W pieces.")
printfT("Solving for sharesizes" , "There are total $(Int(m*2)) pieces and $s students.", "", "($V)s_$V + ($W)s_$W = $(2*m)", "s_$V + s_$W = $s", "", "s_$V = $Vshr and s_$W = $Wshr. $Vshr students get $V pieces and $Wshr students get $W pieces.", "There are $(V*Vshr) $V -shares and $(W*Wshr) $W-shares.")


#findend to solve for intervals
((_, x,), (y,_)) = findend(m,s,a,V)

#cases 3 and 4

#defining variables
total1=total-x
total2=total-y
check1 = (total1)*(1//(V-1))
check2= 1-(total2)*(1//(W-1))
checkbuddy=1-check2

#formatting into strings
xS=fracstring(x, den)
yS=fracstring(y, den)
c1S=fracstring(check1, den)
c2S=fracstring(check2, den)
cB=fracstring(checkbuddy, denominator(checkbuddy))
total1s=fracstring(total1, denominator(total1))
total2s=fracstring(total2, denominator(total2))

#v-conjecture error, derived alpha != input alpha
if check1!=a ||check2!=a
    printf("Error with V-Conjecture, VHalf cannot verify alpha.")
    printEnd()

#verifying derived alpha is = to inputted alpha with v-conjecture
else

#diagram outputs if variable output is true
if x==a && y==1-a
    printf("Half method does not work for these intervals, Findend is inconclusive")
    printEnd()
elseif x!=a
    printHeader("CONTUINING CASE ANLYSIS:")
    printfT("Case 3", "Alice has a $V share ≥ $xS. Alice's other $V shares add up to ≥ $totalS-$xS.
    Hence one of them is $total1s * $base3S = $c1S")

elseif y!=(1-a)
    printHeader("CONTUINING CASE ANALYSIS:")
    printfT("Case 4", "Bob is a $W share ≤ $yS. Bob's other shares add up to ≤ $totalS-$yS,
    hence one of them is $total2s* $base2S = $cB, whose buddy is $c2S")
else
    printf("Half method does not work for these intervals, Findend is inconclusive")
    printEnd()
end


#diagram output
printHeader("INTERVAL DIAGRAM: ")
if x>a && y<1-a && x<y
    printf("The following captures the previous statements: ")
    println("\n",
            interval(["(", aS],
                    [")[", xS],
                    ["](", yS],
                    [")", aB],
                    labels=["$(V*Vshr) $V-shs", "0", "$(W*Wshr) $W-shs"]))

else
    printf("vHalf could not generate conclusive intervals for this case")
    printEnd()
end

#final proof, contradiction
if x<=1//2 && V*Vshr>m
    printHeader("CONTRADICTION:")
    printfT("Case 5", "There are more than $m shares that are ≤1/2, making this case impossible.")
    output=true

elseif y>=1/2 && W*Wshr>m
    printHeader("CONTRADICTION:")
    printfT("Case 5", "There are more than $m shares that are ≥1/2, making this case impossible")
    output=true

else
    printf("vHalf was not able to find a contradiction within interval shares, vHalf failed.")
    printEnd()
end

#final conclusion
if output
    printHeader("CONCLUSION:")
    printfT("Upper Bound", "The previous cases derive a lower bound for α.", "", "We are looking for α that contradicts the assumption that at most $m shares >1/2.", "",
    "Of the cases that give a contradiction:", "", "α ≥ max($upstr, $lpstr, $aS).", "α≥ $aS & muffins($m, $s) ≤ α",
    "Therefore, we derive the upper bound: muffins($m, $s) ≤ $aS.")
end
end
end

else
    return ("input true to proof")
end
end
