include("tools.jl")
export sv, findend

include("text.jl")
export fracstring

function int(m,s, proof::Bool=false)
V, W, q, r = sv(m,s)

total = m//s
Wshares=W*r
Vshares=V*q

#format

if m<=0||s<=0
    return "inputs must be >0"
elseif m%s==0
    return "s divides into m, so a=1"
elseif m<s
    return "input m>s"
else

    if Wshares>Vshares
        newdown1=1-total+(W-1)
        newdown2=1-total
        k=Int64(floor(Vshares/r))
        f=W-k
        a1= (k+f*newdown1-total)//(k+f*(W-1))
        a2=(total-(V-f)*(newdown2)-(f-1)*(1-newdown1))//((V-f)*(V-1)-(f-1)*(W-1))

        if a1<=1//3||a2<=1//3
            ans=fracstring(1//3, 3)
            if proof
                return intproof(m,s,1//3, true)
            end
            return ans
        else
            a = min(a1, a2)
            den=lcm(s, denominator(a))

            if vint1(m,s,a)
                if proof
                    return intproof(m,s,a,true)
                end

                ans=fracstring(a, den)
                return ans
            else
                return "v-int does not verify alpha"
        end
        end

    elseif Vshares>Wshares
        k=Int64(floor((Vshares-Wshares)/q))
        f=V-k
        a=(f*(1-total+(W-1))+(k-1)*(total))//(f+k*(V-1))
        den=lcm(s, denominator(a))
                #a = ((V-k)W + (2k -V-1)total)//((V-k)W + (k-1)V) -- another possibility
        if a<=1//3
            ans=fracstring(1//3, 3)
            if proof
                return intproof(m,s,1//3,true)
            end
            return ans
        else
            if vint1(m,s,a)
                if proof
                    return intproof(m,s,a,true)
                end
                ans = fracstring(a, den)
                return ans
            else
                return "v-int does not verify alpha"
            end
        end
    else
        return "# of V shares = # of V-1 shares, therefore we can use FC to solve this"
    end

end
end


function vint1(m, s, a, proof::Bool=false)
V, W, q, r = sv(m,s)

total=m//s
lowerproof= 1-(total*(1//(V-2)))
upperproof=(total)*(1//(V+1))

Wshares=W*r
Vshares=V*q

if lowerproof>=a ||upperproof >=a
    return false
elseif a<1//3||a>1//2
    return false
elseif m%s==0||m<s
    return false
else

#cases

((_, x), (y,_)) = findend(m,s,a,V)
abuddy = 1-a
xbuddy = 1-x
ybuddy = 1-y

check1 = (total-x)*(1//(V-1))
check2= 1-(total-y)*(1//(W-1))

if check1!=a ||check2!=a
    return false
elseif x>y
    return false
else

if x>y
    return false

else

if Wshares > Vshares #according to VV conjecture the gap will exist in the Wshares
    newgapshr= Wshares-Vshares

    #calculating minimum i to create contradiction for largeshares
    i=0
    j=0
    key1=0
    key2=0

    for i=1:W
        if i*r<Vshares
            i+=1
        else
            key1=i
            break
        end
    end

    #minimum j for contradiction in smallshares
    for j=1:W
        if j*r<newgapshr
            j+=1
        else
            key2=j
            break
        end
    end

    check1 = (W-key1+1)*(ybuddy)+(key1-1)*(abuddy)
    check2 = (key2-1)*xbuddy+(W-key2+1)*y #not sure if this algorithm is correct

    #case3 - do shares total up to m/s?

    if check1<=total
        return true
    elseif check2<=total
        return true
    else
        return false
    end


    elseif Wshares<Vshares

    newgapshr=Vshares-Wshares

    #calculating minimum i to create contradiction in largeshares
    i=0
    j=0
    key1=0
    key2=0
    for i=1:V
        if i*q<=newgapshr
            i+=1
        else
            key1=i
        break
        end
    end

    #calculating minimum j for contradiction in smallshares
    for j=1:V
        if j*q<=newgapshr
            j+=1
        else
            key1=j
        break
        end
    end

    #case 3: do shares total up to m/s?
    check1 = (V-key1+1)*ybuddy+(key1-1)*x
    check2=(V-key2+1)*a+(key2-1)*xbuddy #not sure if algorithm is correct

    if check1<=total
        return true
    elseif check2<=total
        return true
    else
        return false
    end

    else
        return false

    end
    end
    end
end



end
