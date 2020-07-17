function findproc(muffins::Int64, students::Int64, alpha::Int64)



c = numerator(alpha)
d = denominator(alpha)
b = lcm(d::Int64, students:: Int64)
a = Int((b*c)/d)

V = Int(ceil(2*muffins/students))

lb = alpha
ub = 1-alpha

B = collect(a:1:b-a)
n=length(B)
T=20
j=4
return solve(B, n, T, j)
end

#helper function for findprof, B is set, n is length of set, T is sum, j is target size of multiset
function solve(B, n, T, j)

#error if negative or 0 numbers inputted
if j<=0||T<=0||n<=0
    return false

#error if first sum is 0 and first object is 0
elseif B[1]==0 && T==0
    return false

#if size is 1, test all pieces if they equal sum
elseif j==1
    for i=1:n
        if B[i]!=T
            i+=1
        else
            return [B[i]]
        end
    end

#if length is 1
elseif n==1 && B[1]!=T
    return false



elseif B[1]*j==T
    array=Array{Int64}(undef, j)
    for i=1:length(array)
        array[i]=B[1]
    end
    return [array]
end
include = solve(B, n-1, T, j)
exclude = solve(B, n, T-B[n-1], j-1)

println(include, exclude)
end
#=if sum == 0
    return true
elseif n<=0 && sum!=0
    return false

elseif B[n-1]>sum
    return solve(B, n-1, sum)
else
    include = solve(B, n-1, sum - B[n])
    exclude = solve(B, n-1, sum)
    return include || exlude
end

if solve(B, n, sum)==true
    println("Yes, there is a solution")
else
    println("No solution")
end=#
