include("tools.jl")
export sv, findend

include("text.jl")
export fracstring

include("intproof.jl")
export intproof


#taking m,s, program will output int if vint verifies it, will also ouput optional proof
function int(m,s, proof::Bool=false)
V, W, Vnum, Wnum = sv(m,s)

total = m//s
Wshares= W*Wnum
Vshares= V*Vnum

#format

if m<=0||s<=0
    return "inputs must be >0"
elseif m%s==0
    return "s divides into m, so a=1"
elseif m<s
    return "input m>s"
else

    if Wshares>Vshares
        newgap = Wshares-Vshares
        newdown1=1-total+(W-1)
        newdown2=1-total
        ubmin=Int64(floor(Vshares/Wnum)) #upper bound for # of W largeshares
        lbmin = Int64(floor((newgap)/Wnum)) #lower bound for # of W smallshares
        f=W-ubmin
        a1= (ubmin+f*newdown1-total)//(ubmin+f*(W-1))
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

            if vint1(m,s,a)==0 #vint worked
                if proof
                    return intproof(m,s,a,true)
                end

                ans=fracstring(a, den)
                return ans
            else
                if proof
                    return intproof(m,s,a,true)
                end
                return -1 #int failed, could not find conclusive alpha
        end
        end

    elseif Vshares>Wshares

        j = Int64(floor((Vshares-Wshares)/Vnum))
        k=Int64(floor((Wshares/Vnum)))
        a = min(((V-j)W + (2j -V-1)m//s)//((V-j)W + (j-1)V),
                    ((V-k+1)m//s + k - V)//((V-k-1)V + 2k))
        f=V-k
        den=lcm(s, denominator(a))
        if a<=1//3
            ans=fracstring(1//3, 3)
            if proof
                return intproof(m,s,1//3,true)
            end
            return ans
        else
            if vint1(m,s,a)==0
                if proof
                    return intproof(m,s,a,true)
                end
            ans = fracstring(a, den)
            return ans

            else
                if proof
                    return intproof(m,s,a,true)
                end
            return -1 #int failed, could not find conclusive alpha

            end
        end
    else
        return -1
    end

end
end

#inputting m,s,a, program will verify if a works with the half method - outputs 0 if vhalf works, -1 if it doesn't work
function vint1(m, s, a)
V, W, Vnum, Wnum = sv(m,s)

total=m//s
lowerproof= 1-(total*(1//(V-2)))
upperproof=(total)*(1//(V+1))

Wshares=W*Wnum
Vshares=V*Vnum

if lowerproof>a ||upperproof >a #checking to see if v-conjecture works
    return -1
elseif a<1//3||a>1//2  #checks to see if a bounds are correct
    return -1
elseif m%s==0||m<s #checks to see if m&s are incompatible with int
    return -1
else

#cases

((_, x), (y,_)) = findend(m,s,a,V)
abuddy = 1-a
xbuddy = 1-x
ybuddy = 1-y

#=alpha1 = (total-x)*(1//(V-1))
alpha2= 1-(total-y)*(1//(W-1))=#

#=f alpha1!=a ||alpha2!=a
    return false=#
if x>y||x<a||y>1-a
    return -1
elseif x==a || y==(1-a)
    return -1
else


if Wshares > Vshares #according to VV conjecture the gap will exist in the Wshares
    newgapshr= Wshares-Vshares

#checking if shares add up to m/s

#defining variables
ubmin=Int64(floor(Vshares/Wnum)) #upper bound for # of W largeshares
lbmin = Int64(floor((newgapshr)/Wnum)) #lower bound for # of W smallshares

#checking for a contradiction
check1 =(W-ubmin)*(ybuddy)+(ubmin)*abuddy #looking for a contradiction in largeshaes
check2 = (W-lbmin)*xbuddy+(lbmin)*y #looking for a contradiction in smallshares


    if check1<=total
        return 0
    elseif check2>=total
        return 0
    else
        return -1
    end


elseif Wshares<Vshares

    newgapshr=Vshares-Wshares

    #defining variables
    ubmin = Int64(floor(newgapshr/Vnum))
    lbmin = Int64(floor(Wshares/Vnum))

    #case 3: do shares total up to m/s?
    check1 = (V-ubmin)*ybuddy+(ubmin)*x
    check2=(V-lbmin)*xbuddy+(lbmin)*a


    if check1<=total
        return 0
    elseif check2>=total
        return 0
    else
        return -1
    end

    else
        return -1

    end
    end
    end
end
