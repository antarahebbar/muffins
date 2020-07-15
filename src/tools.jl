


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
