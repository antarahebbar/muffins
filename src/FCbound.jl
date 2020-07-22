# FC bound, Antara Hebbar
include("text.jl")
export fracstring

function fc(m, s)

#FC calculations
V = (2 * m) / s
minceil=m//(Int64(s * ceil(V)))
minfloor=1-(m//(Int64(s * floor(V))))
lowerbound=min(minceil, minfloor)
ans=max(1//3,lowerbound)
den = lcm(s, denominator(ans))
ansS = fracstring(ans, den)

#output
if m%s==0
    return 1
elseif m<s
    return false #cannot m<s
elseif m>s
    return ansS
else
    return false

end
end



#key = (2 * s)/m
#min1=min(1//Int64(ceil(key)), m//s-(1-(Int64(floor(key)))))
#ans= max((m//s*1//3), min1, (1-m//s))
#println(min1)
