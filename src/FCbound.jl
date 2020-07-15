# FC bound, Antara Hebbar
function fc(muffins, students)

if muffins>students
    m=muffins
    s=students
else
    m=students
    s=muffins
end

#FC calculations
V = (2 * m) / s
minceil=m//(Int64(s * ceil(V)))
minfloor=1-(m//(Int64(s * floor(V))))
lowerbound=min(minceil, minfloor)
ans=max(1//3,lowerbound)


#output
if muffins%students==0
    return 1
elseif muffins<students
    newans=(muffins//students)*ans
    return newans
elseif muffins>students
    return ans
else
    return "error"

end
end



#key = (2 * s)/m
#min1=min(1//Int64(ceil(key)), m//s-(1-(Int64(floor(key)))))
#ans= max((m//s*1//3), min1, (1-m//s))
#println(min1)
