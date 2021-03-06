#program is from repo Mufins.jl, https://github.com/GeneralPoxter/Muffins.jl
module FINDPROC

using JuMP
using Cbc

include("format.jl")
using .FORMAT

export findproc, vectorize, unpack, unionF, mapCat, f

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
        M = vectorize(unionF(f(L, b, 2), f(L, b, 3)))
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

        # Solve for a natural number solutions
        for i=1:min(length(M), 3)
            @objective(model, Min, x[i])
            optimize!(model)
            append!(solutions, [[round.(value.(x)), round.(value.(y))]])

            @objective(model, Max, x[i])
            optimize!(model)
            append!(solutions, [[round.(value.(x)), round.(value.(y))]])
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
            printf("No solutions for muffins($m, $s, $alpha)", line=true)
            printEnd()
        end
        #return [b, B, M, S, Nothing]
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

    #return [b, B, M, S, solutions] -- this can be used to implement solutions in other programs
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
end
