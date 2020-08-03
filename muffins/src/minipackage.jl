module Main

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

export mini


#given m,s, program will output min of half, int, and fc
function mini(m::Int64, s::Int64)

alpha_fc = fc(m,s)

alpha_half = half(m,s)

alpha_int = int(m,s)

alpha_ebm = ebm(m,s)

verify = true

if m%s==0
    return "The # of students divides into the # of muffins, so the answer is 1."
    verify=false
elseif m<s||m<=0||s<=0
    return "M has to be greater than s, and both values should be >0."
    verify=false
else

#checking if any method did not get conclusive alpha, 2 signifies the method failed
alpha_int = alpha_int== -1 ? alpha_int = "2" : alpha_int=alpha_int
alpha_half = alpha_half== -1 ? alpha_half = "2" : alpha_half=alpha_half
alpha_fc = alpha_fc== -1 ? alpha_fc = "2" : alpha_fc=alpha_fc
alpha_ebm = alpha_ebm == -1 ? alpha_ebm = "2" : alpha_ebm=alpha_ebm

#converting to rational integers
fracfc = toFrac(alpha_fc)
fracint = toFrac(alpha_int)
frachalf = toFrac(alpha_half)
fracebm = toFrac(alpha_ebm)

#finding min of four methods
alpha= min(fracfc, frachalf, fracint, fracebm)
alphaS=formatFrac(alpha, denominator(alpha))


if alpha==2//1
    return "FC, Half, EBM, and INT failed. Minipackage does not work for muffins($m,$s)."
    verify = false

else


methodhalf=false
methodint=false


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
else
    printf("Mini package failed, cannot find a method used to derive alpha")
end


#outputting a proof for half and int
printHeader("PROOF: ")
if methodhalf
    return halfproof(m,s,alpha), findproc(m,s,alpha)

elseif methodint
    return intproof(m,s,alpha), findproc(m,s,alpha)

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
