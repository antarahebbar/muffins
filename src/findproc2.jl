#jason's findproc

using JuMP
using Cbc

include("Formatj.jl")
export printf, printfT, printHeader, findlast, center

B = []
memo = Dict()

# Determines procedure with minimum piece size alpha -- Work in progress
function findproc(m::Int64, s::Int64, alpha::Rational{Int64}; output::Int64=1)
    output > 0 && printHeader(center("FIND PROCEDURE"))

    # Clear globals
    global B = []
    global memo = Dict()

    c = numerator(alpha)
    d = denominator(alpha)
    b = lcm(s, d)

    a = Int64(b * c / d)
    B = [x for x in a:(b-a)]

    M = []
    S = []
    solutions = []

    try
        # Determine vector sets
        L = b - 2a + 1
        V = Int64(ceil(2m/s))
        T = Int64(b * m / s)
        M = vectorize(f(L, b, 2))
        S = vectorize(unionF(f(L, T, V), f(L, T, V-1)))

        # Initialize model
        model = Model(Cbc.Optimizer)
        set_optimizer_attribute(model, "logLevel", 0)
        set_optimizer_attribute(model, "allowableGap", 1e-5)
        set_optimizer_attribute(model, "cuts", "off")

        @variable(model, 0 <= x[i=1:length(M)], Int)
        @variable(model, 0 <= y[i=1:length(S)], Int)

        for k=1:L
            @constraint(model, sum(x .* getindex.(M, k)) == sum(y .* getindex.(S, k)))
        end

        @constraint(model, sum(x) == m)
        @constraint(model, sum(y) == s)

        # Solve for natural number solutions
        for i=1:length(M)
            @objective(model, Min, x[i])
            optimize!(model)
            append!(solutions, [[value.(x), value.(y)]])

            @objective(model, Max, x[i])
            optimize!(model)
            append!(solutions, [[value.(x), value.(y)]])
        end

        solutions = unique(solutions)
    catch
        # TODO -- implement error reporting
        Nothing
    end

    alpha = formatFrac(alpha)

    # Display solutions
    if output > 0
        printHeader("OVERVIEW")
        printfT("Goal",
                "Find procedures for dividing $m muffins among $s students where $alpha is the smallest piece size")
        printfT("Note",
                "Let the common denominator be $b")

        printHeader("SOLUTIONS")
    end

    # Exit if no solutions
    if length(solutions) == 0
        if output > 0
            printf("No solutions for muffins($m, $s, $alpha", line=true)
            printEnd()
        end
        return Nothing
    end

    # Output each solution
    if output > 0
        for k=1:length(solutions)
            x = solutions[k][1]
            y = solutions[k][2]

            divide = ["Divide $(Int64(x[i])) muffins {$(unpack(M[i]))}" for i=1:length(M) if x[i] > 0]
            give = ["Give $(Int64(y[i])) students {$(unpack(S[i]))}" for i=1:length(S) if y[i] > 0]

            printfT("Solution $k",
                    divide...,
                    give...)
        end
        printEnd()
    end

    #return [b, B, M, S, solutions]
end

# Helper function for findproc -- "vectorizes" arrays in set S based on B
function vectorize(S)
    S == Nothing ? Nothing : sort([[count(i->(i==x), s) for x in B] for s in S], rev=true)
end

# Helper function for findproc -- "unpacks" vectors into strings based on B
function unpack(V)
    join(vcat(map(i->repeat([B[i]], V[i]), 1:length(V))...), ", ")
end

# Helper function for findproc -- "recursively" determines k-size subsets of B[1:i] that sum to T
function f(i, T, k)
    # Base cases
    if i >= 1 && T == 0 && k == 0
        Set()
    elseif T == 0 && k >= 1
        Nothing
    elseif i == 0 && T >= 1
        Nothing
    elseif T >= 1 && k == 0
        Nothing
    elseif T <= -1
        Nothing
    elseif i == 1
        T == k * B[1] ? Set([repeat([B[1]], k)]) : Nothing
    elseif i >= 1 && k == 1
        index = findall(x->x==T, B[1:i])
        length(index) > 0 ? Set([[B[index[1]]]]) : Nothing
    # Recursive case with memoization
    else
        if haskey(memo, (i, T, k))
            get(memo, (i, T, k), 0)
        else
            set = unionF( f(i-1, T, k), mapCat(f(i, T-B[i], k-1), [B[i]]) )
            get!(memo, (i, T, k), set)
        end
    end
end

# Helper function for f -- set unions with Nothing
function unionF(x, y)
    if x == Nothing && y == Nothing
        Nothing
    elseif x == Nothing
        y
    elseif y == Nothing
        x
    else
        union(x, y)
    end
end

# Helper function for f -- concatenate e with each element in set S
function mapCat(S, e)
    S == Nothing ? Nothing : Set([vcat(s, e) for s in S])
end









#=function findproc(muffins::Int64, students::Int64, alpha::Int64)



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
if sum == 0
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
