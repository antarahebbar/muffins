
include("tools.jl")
export sv

include("VHalf.jl")
export vhalf

function half(m::Int64, s::Int64)
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
        output = vhalf(m,s,a)
        if output
            return a
        else
            return "No output"
        end
    else
        a=alpha1
        output=vhalf(m,s,a)
        if output
            return a
        else
            return "No output"
        end
    end

elseif W*Wshr<V*Vshr
    if alpha2<1//3
        a = 1//3
        output=vhalf(m,s,a)
        if output
            return a
        else
            return "No output"
        end
    else
        a=alpha2
        output=vhalf(m,s,a)
        if output
            return a
        else
            return "No output"
        end
    end
end
end
end
