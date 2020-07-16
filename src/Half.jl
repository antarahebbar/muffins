
include("tools.jl")
export sv, findend

include("halfproof.jl")
export halfproof

function vhalf(m,s,a, proof)

total=m//s
V,W,Vshr,Wshr = sv(m,s)

lowerproof= 1-(m//s)*(1//(V-2))
upperproof=(m//s)*(1//(V+1))

if lowerproof>a||upperproof>a
    return false
elseif m<=0||s<=0||a<=0
    return false
elseif a<1//3
    return false
elseif a>1
    return false
else

((_, x,), (y,_)) = findend(m,s,a,V)

check1 = (total-x)*(1//(V-1))
check2= 1-(total-y)*(1//(W-1))

if check1!=a ||check2!=a
    return false
else

    if x<=1//2 && V*Vshr>m
        return true
    elseif y>=1/2 && W*Wshr>m
        return true
    else
        return false
end

end
end
end

function half(m::Int64, s::Int64, proof::Bool=false)

if m % s==0
        return "s divides into m, output is 1"
elseif m < s
    return "Bad input, m has to be > s"
else

V, W, Vshr, Wshr = sv(m,s)

alpha1=1-(m//s-1//2)//(V-2)
alpha2 = (m//s-1//2)//(V-1)

if W*Wshr>V*Vshr
    if alpha1<1//3
        a = 1//3
        return a
    else
        a=alpha1
        if vhalf(m,s,a)
            return a
        else
            return "No output"
        end
    end

elseif W*Wshr<V*Vshr
    if alpha2<1//3
        a = 1//3
        return a
    else
        a=alpha2
        if vhalf(m,s,a)
            return a
        else
            return "No output"
        end
    end
end
end

end
