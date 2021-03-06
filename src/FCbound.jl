# FC bound, Antara Hebbar
module FC

include("format.jl")
using .FORMAT

export fc

#taking m,s, program will use floor-ceiling method to output alpha, -1 signifies no value
function fc(m, s)

#FC calculations
V = (2 * m) / s
minceil=m//(Int64(s * ceil(V)))
minfloor=1-(m//(Int64(s * floor(V))))
lowerbound=min(minceil, minfloor)
ans=max(1//3,lowerbound)
den = lcm(s, denominator(ans))

#output
if m%s==0 #if shares divide into muffin
    return 1
elseif m<s #incorrect input
    return false #cannot m<s
elseif m>s #answer as a string
    return ans
else # -1 is indicator for no answer
    return -1

end
end
end
