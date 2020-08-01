include("tools.jl")
export sv, findend

include("format.jl")
export printf, printfT, printHeader, findlast, formatFrac


#Helper function for HBM, verifies whether (m,s) is a candidate for hbm method

function vhbm(j, k, d, X)

#preprocessing stage - determining if inputs can be used for hbm method

pre = false
if j<1||j>(3*d)
    return -1
elseif j==(2*d)
    pre=true
elseif X<j//3
    return -1
elseif X>=(j//2)
    pre=true
elseif X>=(j+d)//4
    pre=true
end
