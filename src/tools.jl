import Base.match
match(m,s,frac1::Rational{Int64}, frac2::Rational{Int64}) = match(m.x,s.x,frac1.x,frac2.x)


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
