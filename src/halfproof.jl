include("tools.jl")
export findend, sv

include("text.jl")
export fracstring

# this program gives a proof of an f(m,s,alpha) input, using the half method
function halfproof(m::Int64, s::Int64, a, proof::Bool=true)
output=false

if proof
total=m//s
V,W,Vshr,Wshr = sv(m,s)

lp= 1-(m//s)*(1//(V-2))
lpbuddy=1-lp
up=(m//s)*(1//(V+1))
total=m//s

base1=(1//(V+1))
base2=(1//(W-1))
base3=(1//(V-1))

#formatting
lpstr = fracstring(lp, denominator(lp))
lpB=fracstring(lpbuddy, denominator(lpbuddy))
upstr = fracstring(up, denominator(up))
den = lcm(s, denominator(a))
aS = fracstring(a, den)
aB=fracstring(1-a, den)

totalS=fracstring(total, den)

base1S=fracstring(base1, denominator(base1))
base2S=fracstring(base2, denominator(base2))
base3S=fracstring(base3, denominator(base3))


#checking if alpha is viable
if lp>a||up>a
    println("This case is impossible")

elseif m<=0||s<=0||a<=0
    println("Input m,s & a>0")
elseif a<1//3||a>1//2
    println("Alpha must be greater than 1//3 and less than 1//2")
elseif a>1
    println("Alpha must be a <=1")
else
#cases and claim

println("Claim: there is a ($m, $s) procedure where the smallest piece is >= $aS")
println("")

println("Case 1: Alice gets >= $(V+1) shares, then one of them is $totalS * $base1S = $upstr, which is <= $aS.")
println("Case 2: Bob gets <= $(V-2) shares, one of them is $totalS * $base2S = $lpB, Its buddy is $lpstr <= $aS.")
println("Hence, the student has >= $V pieces or <= $W pieces. There are total", Int(m*2), " pieces and $s students.")
println("")

#checking if V-conjecture holds


println(V, "s_",V," + ", W, "s_", W, " = ", 2*m)
println("s_", V," + s_", W, " = ", s)
println("")
println("Hence, s_$V = $Vshr and s_$W = $Wshr. $Vshr students get $V pieces and $Wshr students get $W pieces.")
println("There are $(V*Vshr) $V -shares and $(W*Wshr) $W-shares.")
println("")


#findend to solve for intervals
((_, x,), (y,_)) = findend(m,s,a,V)

#cases 3 and 4
check1 = (total-x)*(1//(V-1))
check2= 1-(total-y)*(1//(W-1))
checkbuddy=1-check2
total1=total-x
total2=total-y

#formatting
xS=fracstring(x, den)
yS=fracstring(y, den)
c1S=fracstring(check1, den)
c2S=fracstring(check2, den)
cB=fracstring(checkbuddy, denominator(checkbuddy))
total1s=fracstring(total1, denominator(total1))
total2s=fracstring(total2, denominator(total2))

if check1!=a ||check2!=a
    println("Error, alpha does not work.") #add V-conjecture error?

else
println("Case 3: Alice has a $V share >= $xS. Alice's other $V shares add up to >= $totalS-$xS. Hence one of them is $total1s * $base3S = $c1S")
println("Case 4: Bob is a $W share <= $yS. Bob's other shares add up to <= $totalS-$yS, hence one of them is $total2s* $base2S = $cB, whose buddy is $c2S")



#proof

    if x<=1//2 && V*Vshr>m
        println("Alpha works. There are more than $m shares that are <=1/2")
        println("")
        output=true

    elseif y>=1/2 && W*Wshr>m
        println("Alpha works. There are more than $m shares that are >=1/2")
        println("")
        output=true

    else
        println("There are not enough shares in the intervals, alpha does not work")
end

#diagram output

if output
if x==a ||y==1-a
    println("Intervals in the diagram are overlapping, alpha does not work")
    output=false
elseif x>a && y<1-a && x<y
    println("The following diagram is created: ")
    println("(    ", V*Vshr, " " , V, "-shares   )-(0)-(   ", W*Wshr, " ", W, "-shares   )")
    println(aS, "          ", xS, "  ", yS, "            ", aB)

else
    println("diagram could not be found, intervals did not work")
    output=false
end

end
end
end

else
    exit(0)
end
end
