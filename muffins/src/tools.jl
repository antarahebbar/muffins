module TOOLS

using Combinatorics

import Base.match
match(m,s,frac1::Rational{Int64}, frac2::Rational{Int64}) = match(m.x,s.x,frac1.x,frac2.x)

export sv, findend, buddy, match, combs, perm, targperm

#uses v conejcture to solve for V&W shares
function sv(m::Int64,s::Int64)

V = Int64(ceil((2 * m)/s))
W = V-1

Vshr = Int64(2*m - W*s)
Wshr= Int64(V*s - 2*m)

return V, W, Vshr, Wshr

end

#finds shares within a and 1-a
function findend(m, s, a, V)

x= m//s - a*(V-1)
y = m//s -(1-a)*(V-2)

if y>=1-a
    y=1-a
elseif y<=a
    y=a
end

if x>=1-a
    x=1-a
elseif x<=a
    x=a
end

((a, x,), (y, 1-a))

end


#Helper function for embproof that matches numbers
function match(m,s,frac1::Rational{Int64}, frac2::Rational{Int64})
total=m//s

frac1<frac2 ? m1=frac2 : m1=frac1
frac1<frac2 ? m2=frac1 : m2=frac2

return total-m1, total-m2

end


#Helper function for emb, finds buddy of two fractions
function buddy(m,s,frac1::Rational{Int64}, frac2::Rational{Int64})
total=m//s

frac1<frac2 ? m1=frac2 : m1=frac1
frac1<frac2 ? m2=frac1 : m2=frac2

return 1-m1, 1-m2

end

#function that returns all permutations from 0 to targ that sum to targ of size n
function combs(targ::Any,n::Any)

openvec = Vector{Int64}(undef, 0)
if n==0 #if length is 0, return empty vector
    return openvec
else

sol = Vector{Int64}(undef, 0)
fullsol = Vector{Vector{Int64}}(undef, 0)


for i = 0:targ
    push!(sol, i)
end

fullsol = reverse.(digits.(0:targ^n-1,base=targ,pad=n))
len=length(fullsol)

finalsol = Array{Array{Int64,1}}(undef, 0)

for i = 1:len
    element = fullsol[i]
    if sum(element)==targ
        push!(finalsol, element)
    end
end
othersolutions = Array{Array{Int64}}(undef, 0)

othersolutions = targperm(targ, n)

splitting(x, n) = [x[i:min(i+n-1,length(x))] for i in 1:n:length(x)] #function will split targperm output into increments of length n

append!(finalsol, splitting(othersolutions, n))



end
end


#helper function for combs, retuns permuations of target number and 0

function targperm(targ, n)

littlesol = Array{Int64, 1}(undef, 0)
zero = Array{Int64, 1}(undef, 0)
bigsol = Array{Array{Int64, 1}}(undef, 0)
answer = Array{Int64, 1}(undef, 0)

for i = 1:n
    push!(zero, 0)
    push!(bigsol, zero) #generates n arrays consisting of zeros
end


#combinations of 0 and target number
index = 1
for i = 1:n
    littlesol = bigsol[i];
    for j = 1:n
        if index == j
            littlesol[j] =targ
            append!(answer, littlesol[j])
        else
            littlesol[j]=0
            append!(answer, littlesol[j])
        end
    end
    index+=1

end

return answer


end
end
