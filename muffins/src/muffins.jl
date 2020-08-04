module Muffins


include("FCBound.jl")
using .FloorCeiling

include("Half.jl")
using .Half

include("ebm.jl")
using .EBM

include("tools.jl")
using .Tools

include("Int.jl")
using .IntMethod

include("findproc.jl")
using .FindProc

include("format.jl")
using .Formatting

include("Mid.jl")
using .MidMethod

export muffins

#given m,s, program will output min of half, int, and fc
function muffins(m::Int64, s::Int64)

alpha_fc = fc(m,s)

alpha_half = half(m,s)

alpha_int = int(m,s)

alpha_ebm = ebm(m,s)

alpha_mid = mid(m,s)

verify = true

if m%s==0
    return "The # of students divides into the # of muffins, so the answer is 1."
    verify=false
elseif m<s||m<=0||s<=0
    return "M has to be greater than s, and both values should be >0."
    verify=false
else

#checking if any method did not get conclusive alpha, 2 signifies the method failed
alpha_int = alpha_int== 1 ? alpha_int = "1" : alpha_int=alpha_int
alpha_half = alpha_half== 1 ? alpha_half = "1" : alpha_half=alpha_half
alpha_fc = alpha_fc== 1 ? alpha_fc = "1" : alpha_fc=alpha_fc
alpha_ebm = alpha_ebm ==1 ? alpha_ebm = "1" : alpha_ebm=alpha_ebm
alpha_mid = alpha_mid ==1 ? alpha_mid = "1" : alpha_mid=alpha_mid

#converting to rational integers
fracfc = toFrac(alpha_fc)
fracint = toFrac(alpha_int)
frachalf = toFrac(alpha_half)
fracebm = toFrac(alpha_ebm)
fracmid = toFrac(alpha_mid)



#finding min of five methods
alpha= min(fracfc, frachalf, fracint, fracebm, fracmid)
alphaS=formatFrac(alpha, denominator(alpha))


if alpha==1//1
    return "FC, Half, EBM, INT, and MID could not find an upper bound for Muffins($m, $s) < 1, therefore muffins($m,$s) <= 1"
    verify = false

else


methodhalf=false
methodint=false
methodmid = false


#determining which method was used
if fracfc==alpha
    printf("The Floor Ceiling method found that muffins($m,$s) <= $alphaS")
elseif fracebm==alpha
    printf("The Easy-Buddy Match method found that muffins($m,$s) <= $alphaS")
elseif alpha==fracint
    methodint=true
    printf("The INT method found that muffins($m,$s) <= $alphaS")
elseif alpha==frachalf
    methodhalf=true
    printf("The Half method found that muffins($m,$s) <= $alphaS")
elseif alpha==fracmid
    printf("The Mid Method found that muffins($m, $s) <= $alphaS")
    methodmid = true
else
    printf("Mini package failed, cannot find a method used to derive alpha")
end


#outputting a proof for half and int
printHeader("PROOF: ")
if methodhalf
    return halfproof(m,s,alpha), findproc(m,s,alpha)

elseif methodint
    return intproof(m,s,alpha), findproc(m,s,alpha)
elseif methodmid
    return mid(m,s,output=2), findproc(m,s,alpha)

else
    if fracfc==alpha
    printf("Since Floor Ceiling can be used to derive alpha, no proof is necessary."), findproc(m,s,alpha)
    elseif fracebm==alpha
    printf("Since EBM can be used to derive alpha, no proof is necessary."), findproc(m,s,alpha)
end

end #proof



end #error 2


end #input problems
end
end
