include("findproc.jl")
export findproc, vectorize, unpack, f, unionF, mapCat

include("FCBound.jl")
export fc

include("Half.jl")
export half, vhalf1

include("halfproof.jl")
export halfproof

include("tools.jl")
export sv, findend

include("Int.jl")
export vint1, int

include("intproof.jl")
export intproof

include("formatj.jl")
export toFrac


#given m,s, program will run floor-ceiling, half, and int methods and output the minimum, a proof, and solutions using findproc
function muffins(m::Int64, s::Int64)

alpha_fc = fc(m,s)

alpha_half = half(m,s)

alpha_int = int(m,s)


verify = true #bool variable to see whether ouput qualifies for proof

if m%s==0 #error if muffins divides into students
    return "The # of students divides into the # of muffins, so the answer is 1."
    verify=false

elseif m<s||m<=0||s<=0 #errors with inputs
    return "M has to be greater than s, and both values should be >0."
    verify=false
else

#checking if any method did not get conclusive alpha, "2" signifies the method failed
alpha_int = alpha_int== -1 ? alpha_int = "2" : alpha_int=alpha_int
alpha_half = alpha_half== -1 ? alpha_half = "2" : alpha_half=alpha_half
alpha_fc = alpha_fc== -1 ? alpha_fc = "2" : alpha_fc=alpha_fc


#converting to rational integers
fracfc = toFrac(alpha_fc)
fracint = toFrac(alpha_int)
frachalf = toFrac(alpha_half)

#finding min of three methods
alpha= min(fracfc, frachalf, fracint)
den = lcm(s, denominator(alpha))
alphaS=fracstring(alpha, den)

if alpha==2//1 #if all methods fail, alpha should equal 2
    return "FC, Half, and INT failed. Minipackage does not work for muffins($m,$s)."
    verify = false

else

#outputting the minimum alpha of int, fc, half
printHeader("DERIVED ALPHA:")
printf("Mini package found that muffins($m,$s) <= $alphaS")

#ouputs method(s) used
printHeader("METHOD USED: ")

methodhalf=false
methodint=false

#if more than one method was used
if fracfc==alpha&&frachalf==alpha
    printf("The FC and Half methods can be used to derive alpha.")
elseif fracfc==alpha&&fracint==alpha
    printf("The FC and Int methods can be used to derive alpha.")
elseif frachalf==alpha&&fracint==alpha
    printf("The Int and Half methods can be used to derive alpha.")
    methodhalf=true
    methodint=true
elseif frachalf==alpha&&fracint==alpha&&fracfc==alpha
    printf("Int, Half, and FC all outputted the same alpha. Any of these methods can be used.")
else

#if only one method was used
if fracfc==alpha
    printf("The Floor Ceiling method was used to derive alpha.")
elseif alpha==fracint
    methodint=true
    printf("The INT method was used to derive alpha.")
elseif alpha==frachalf
    methodhalf=true
    printf("The Half method was used to derive alpha")
else
    printf("Mini package failed, cannot find a method used to derive alpha")
end
end


#outputting a proof for half and int --> if fc was used, no proof will be outputted
printHeader("PROOF: ")
if methodhalf
    return halfproof(m,s,alpha), findproc(m,s,alpha) #returns halfproof and findproc solutions

elseif methodint
    return intproof(m,s,alpha), findproc(m,s,alpha) #returns intproof and findproc solutions

else
    print("Since Floor Ceiling can be used to derive alpha, no proof is necessary."), findproc(m,s,alpha) #returns findproc if int/half don't work

end

end


end


end