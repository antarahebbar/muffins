
include("tools.jl")
export sv, findend, match, buddy

include("format.jl")
export printf, printfT, printHeader, findlast, formatFrac

include("FCBound.jl")
export fc

#given (m,s), program outputs alpha using easy-buddy match method, returns either alpha or -1 if no answer
function ebm(m::Int64, s::Int64, proof::Bool=false)

V, W, Vnum, Wnum = sv(m,s)
Wshares=W*Wnum
Vshares=V*Vnum

if V==3 #EBM only works if there are two shares

if m%s==0
        return 1
elseif ceil((2*m)/s) >=4
        return 1
else

#defining variables needed for emb
d = m-s

i=0
while 3*d*i<s
        i+=1
end

k=i-1
j = s-(3*d*k) #Note: s=3dk+a and m=3dk+a+d.

if j>=(2*d+1)&&j<=(3*d)
        X=j//3
        a = (d*k+X)//(3*d*k+j)
elseif j==2*d
        a = fc(m,s)
elseif j>=1&&j<=d
        X=min(j//2)
        a = (d*k+X)//(3*d*k+j)
elseif j>=d&&j<=(2*d-1)
        X=min((j+d)//4)
        a = (d*k+X)//(3*d*k+j)
else
        return -1
end

aS = formatFrac(a, denominator(a))
return aS
end

else
        return -1

end
end




#Helper function for emb, optionally outputs a proof using easy-buddy match method
function embproof(m, s, a, proof::Bool=true)

#finding V and W
V, W, Vnum, Wnum = sv(m,s)
Wshares=W*Wnum
Vshares=V*Vnum
abuddy=1-a


#formatting fractions into strings
den = lcm(s, denominator(a))
total = m//s
aS = formatFrac(a, den)
alpha = formatFrac(a, denominator(a))
totalS=formatFrac(total, den)
aB=formatFrac(abuddy, den)


if proof

if V==3 #ebm only works if there are 2-shares

#claim
printHeader("CLAIM:")
printf("There is a ($m, $s) procedure where the smallest piece is ≥ $alpha.")
printfT("Note", "Let the common denominator $den. Therefore, alpha will be referred to as $aS.")

#assumptions
printHeader("ASSUMPTIONS:")
printfT("Determining muffin pieces", "If there is an ($m, $s) procedure with smallest piece α > 1/3, there is an ($m, $s) procedure where every muffin is cut into 2 pieces. Hence, there are $(2*m) shares.")
printfT("Buddies", "If there exists share size α, there also must exist a share size 1-α. All possible shares sizes exist between [$aS, $aB].")

#solving for shares
printHeader("SOLVING FOR # OF SHARES:")
printf("Each student will get either $V or $W shares.")
printLine()
printfT("Determining sharesizes", "While s_$V is the number of $V-shares and s_$W is the number of $W-shares: ","", "($V)s_$V + ($W)s_$W = $(2*m)  (total shares) ", "s_$V + s_$W = $s  (total students)", "", "$Vnum students get $V pieces and $Wnum students get $W pieces. There are $Vshares $V-shares and $Wshares $W-shares.")
println("")

#using findend function to solve for interval gaps
((_, x), (y,_)) = findend(m,s,a,V)


#defining buddies and matches
xbuddy, ybuddy = 1-x
ybuddy = 1-y
xmatch = total-x
ymatch = total-y

#formatting intervals
xS=formatFrac(x, den)
yS=formatFrac(y, den)
xB=formatFrac(xbuddy, den)
yB=formatFrac(ybuddy, den)
xM=formatFrac(xmatch, den)
yM=formatFrac(ymatch, den)

#interval graph
printHeader("INTERVAL DIAGRAM: ")
printf("The following diagram depicts what we know so far: ")
println("\n",
        interval(["(", aS],
                [")[", xS],
                ["](", yS],
                [")", aB],
                labels=["$Vshares $V-shs", "0", "$Wshares $W-shs"]))


#using a buddy-match sequence to find a contradiction


end #if v==3 or 2
end #if proof end
end #function end
