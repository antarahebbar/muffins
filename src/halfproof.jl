include("tools.jl")
export findend, sv

# this program gives a proof of an f(m,s,alpha) input, using the half method
function halfproof(m::Int64, s::Int64, a, proof::Bool=false)

if proof
total=m//s
V,W,Vshr,Wshr = sv(m,s)

lowerproof= 1-(m//s)*(1//(V-2))
upperproof=(m//s)*(1//(V+1))

#checking if alpha is viable
if lowerproof>a||upperproof>a
    println("This case is impossible")
    return false

elseif m<=0||s<=0||a<=0
    println("Input m,s & a>0")
    return false
elseif a<1//3||a>1//2
    println("Alpha must be greater than 1//3 and less than 1//2")
    return false
elseif a>1
    println("Alpha must be a <=1")
    return false
else
#cases and claim

println("Claim: there is a ($m, $s) procedure where the smallest piece is >= $a")
println("")

println("Case 1: Alice gets >= $(V+1) shares, then one of them is $total * $(1//(V+1)) = $upperproof, which is <= $a.")
println("Case 2: Bob gets <= $(V-2) shares, one of them is $total * $lowerproof = $(m//s*(1//(V-2))), Its buddy is $lowerproof <= $a.")
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

if check1!=a ||check2!=a
    println("Error, alpha does not work.") #add V-conjecture error?
    return false
else
println("Case 3: Alice has a $V share >= $x. Alice's other $V shares add up to >= $total-$x. Hence one of them is $(total-x) * $(1//(V-1)) = $check1")
println("Case 4: Bob is a $W share <= $y. Bob's other shares add up to <= $total-$y, hence one of them is $(total-y)* $(1//(W-1)) = $(1-check2), whose buddy is $check2")



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
        return false
end

#diagram output

if output
if x==a ||y==1-a
    println("Intervals in the diagram are overlapping, alpha does not work")
    false
elseif x>a && y<1-a && x<y
    println("The following diagram is created: ")
    println("(    ", V*Vshr, " " , V, "-shares   )-(0)-(   ", W*Wshr, " ", W, "-shares   )")
    println(a, "          ", x, "  ", y, "            ", 1-a)

else
    println("diagram could not be found, intervals did not work")
    false
end

end
end
end

else
    exit(0)
end
end
