include("tools.jl")
export findend, sv

include("text.jl")
export fracstring

include("formatj.jl")
export printf, printfT, printHeader, findlast

function intproof(m, s, a, proof::Bool=false)
a = toFrac(a)

V, W, Vnum, Wnum = sv(m,s)

if proof

total=m//s
abuddy=1-a
lowerproof= 1-(total*(1//(V-2)))
lpbuddy = 1-lowerproof
upperproof=(total)*(1//(V+1))

Wshares=W*Wnum
Vshares=V*Vnum
den=lcm(s, denominator(a))

#formatting into fractions
lpS=fracstring(lowerproof, denominator(lowerproof))
upS=fracstring(upperproof, denominator(upperproof))
aS=fracstring(a, den)
totalS=fracstring(total, den)
aB=fracstring(abuddy, den)
lpbuddyS = fracstring(lpbuddy, denominator(lpbuddy))

if lowerproof>a ||upperproof >a
    printf("Alpha does not comply with v-conjecture, V-Int failed")
    printEnd()
elseif a<1//3||a>1//2
    printf("Alpha must be >1//3 and <1//2")
    printEnd()
elseif m%s==0
    printf("Int method does not apply to input, alpha is 1 since s divides into m")
    printEnd()
elseif m<s
    printf("Int method does not apply, m must be > than s")
    printEnd()
else

#claim
    printHeader("CLAIM:")
    printf("There is a ($m, $s) procedure where the smallest piece is >= $aS.")

#assumptions
    printHeader("ASSUMPTIONS:")
    printfT("Theorem 2.6", "If there is an ($m, $s) procedure with smallest piece α > 1/3, there is an ($m, $s) procedure where every muffin is cut into 2 pieces. Hence, there are $(2*m) shares.")
    printfT("Buddies", "If there exists share size α, there also must exist a share size 1-α. All possible shares sizes exist between [$aS, $aB].")

#verifying v-conjecture
printHeader("CASEWORK:")
printfT("V-Conjecture", "Case 1: If Alice has <= $(V-2) shares, a share is >= $(totalS) * $(1//(V-2)), which = $lpbuddyS. Its buddy is $lpS < $aS")
printfT("V-Conjecture", "Case 2: If Bob has >= $(V+1) shares, a share is >= than $(total) * $(1//(V+1)), which = $upS. $upS < $aS")

#solving for shares
printHeader("USING V-CONJECTURE TO SOLVE FOR # OF SHARES:")
printf("Assuming the V-Conjecture, each student will get either $V or $W shares.")
printLine()

#number of shares
printfT("V-Conjecture", "While s_$V is the number of $V-shares and s_$W is the number of $W-shares: ","", "($V)s_$V + ($W)s_$W = $(2*m)  (total shares) ", "s_$V + s_$W = $s  (total students)", "", "$Vnum students get $V pieces and $Wnum students get $W pieces. There are $Vshares $V-shares and $Wshares $W-shares.")
println("")


#cases

((_, x), (y,_)) = findend(m,s,a,V)
xbuddy = 1-x
ybuddy = 1-y

#format
xS=fracstring(x, den)
yS=fracstring(y, den)
xB=fracstring(xbuddy, den)
yB=fracstring(ybuddy, den)



if x>y
    printf("Intervals are not disjoint, you should use half/fc to solve for alpha")
    printEnd()
elseif x==a || y==(1-a)
    printf("Findend failed, intproof failed")
    printEnd()

else

#output a diagram with one interval
printHeader("INTERVAL ANALYSIS: ")
printf("The following diagram shows what we have so far: ")
println("\n",
        interval(["(", aS],
                [")[", xS],
                ["](", yS],
                [")", aB],
                labels=["$Vshares $V-shs", "0", "$Wshares $W-shs"]))
printLine()
printfT("Buddies", "Because there is a gap between $xS and $yS, there must also be a new gap between $yB and $xB.")


if Wshares > Vshares #according to VV conjecture the gap will exist in the Wshares
    newgapshr= Wshares-Vshares
#defining the new gap
printfT("New gap", "The new gap will exist within the $W-shares. Because $Vshares $V-shares exist within [$aS, $xS], there must be $Vshares $W-shares within their buddies.")

##interval graph with gaps
printHeader("INTERVAL DIAGRAM: ")
printf("The following diagram depicts the interval diagram with the new gap: ")
println("\n",
        interval(["(", aS],
                [")[", xS],
                ["](", yS],
                [")[", yB],
                ["](", xB],
                [")", aB],
                labels=["$Vshares $V-shs", "0", "$newgapshr $W-shares", "0", "$Wshares $W-shs"]))

#defining small/largeshares
printfT("Defining terms", "The $W-shares that lie in [$yS, $yB] are called smallshares. $W-shares in [$xB, $aB] are largeshares.")

#defining variables
ubmin=Int64(floor(Vshares/Wnum)) #upper bound for # of W largeshares
lbmin = Int64(floor((newgapshr)/Wnum)) #lower bound for # of W smallshares



#checking for a contradiction
check1 =(W-ubmin)*(ybuddy)+(ubmin)*abuddy #looking for a contradiction in largeshaes
check2 = (W-lbmin)*xbuddy+(lbmin)*a #looking for a contradiction in smallshares

#case3 - do shares total up to m/s?

if check1<=total
    println("Case 3: Alice is a $W student. If she has $key1 large shares, we get a contradiction - there are only $Wnum $W-students and $key1 largeshares.")
    println("If she had <= $(key1-1) largeshares, then she has < $(key1-1) * $(yB) + $((key1-1)*a) <= $totalS. Therefore, alpha works.")
    println("")
elseif check2>=total
    println("Case 3: Alice is a $W student. If she has $key2 middleshares, we get a contradiction - there are only $Wnum $W-students and $key2 middleshares.")
    println("If she had <= $(key2-1) middleshares, then she has < $(key2-1) * $(yB) + $((key2-1)*a) <= $totalS. Therefore, alpha works.")
    println("")
else
    println("shares do not add up to total, alpha does not work")
end


elseif Wshares<Vshares

newgapshr=Vshares-Wshares

#defining the new gap
printfT("New gap", "The new gap will exist within the $V-shares. Because $Wshares $W-shares exist within [$yS, $aB], there must be $Wshares $V-shares within their buddies.")

#interval diagram
printHeader("INTERVAL DIAGRAM: ")
printf("The following diagram shows the interval diagram with the new gap: ")
println("\n",
        interval(["(", aS],
                [")[", yB],
                ["](", xB],
                [")[", xS],
                ["](", yS],
                [")", aB],
                labels=["$Vshares $V-shs", "0", "$newgapshr $V-shares", "0", "$Vshares $W-shs"]))

printfT("Defining terms", "The $V-shares that lie in [$aS, $yB] are called smallshares. $V-shares in [$xB, $xS] are largeshares.")



#defining small/largeshares

#defining variables
ubmin = Int64(floor(newgapshr/Vnum))
lbmin = Int64(floor(Wshares/Vnum))

#case 3: do shares total up to m/s?
check1 = (V-ubmin)*y+(ubmin)*x
check2=(V-lbmin)*xbuddy+(lbmin)*a #not sure if algorithm is correct

if check1<=total
    println("Case 3: Alice is a $V student. If Alice has $key1 large shares, there is a contradiction:")
    println("(There are $Vnum $V-students - we can't have $(Vnum*key1) largeshares.")
    println("If she had <=$(key1-1) largeshares, then she has < $(V-key1+1) * $(yB) + $(key1-1)*$xS) <= $totalS. Therefore alpha works.")
    println("")
elseif check2>=total
    println("Case 3: Alice is a $V student. If Alice has $key2 smallhares, there is a contradiction:")
    println("(There are $Vnum $V-students - we can't have $(Vnum*j) smallshares.")
    println("If she had <=$(key2-1) smallshares, then she has < $(V-key2+1) * $(aS) + $(key2-1)*$xB) <= $totalS. Therefore alpha works.")
    println("")

else
    println("share distribution do not add up to total, alpha does not work")
end

else
    return "V-shares = Wshares. In this case, use FC(m,s)"

end
end
end
else
    return "input true to print proof"
end
end


include("tools.jl")
export findend, sv

include("text.jl")
export fracstring

include("formatj.jl")
export printf, printfT, printHeader, findlast

function vint2(m::Int64, s::Int64, alpha::Rational{Int64}, proof::Bool=true)
    if m < s || m % s == 0
        printf("VInt does not apply", line=true)
        false
    elseif alpha < 1/3
        printfT("Theorem 4.5",
                "For m ≥ s, α must be ≥ 1/3")
        false
    elseif alpha > 1
        printfT("",
                "α must be ≤ 1")
        false
    else
        (V, W, sV, sW) = sv(m, s)
        numV = (V)sV
        numW = (W)sW

        # Initialize Interval Method proof
        if proof
            # Define and format variables for proof
            alphaF = formatFrac(alpha)
            size = formatFrac(m//s)

            # Establish assumptions and premises
            printHeader("OVERVIEW")
            printfT("Goal",
                    "Prove:",
                    "muffins($m,$s) ≤ α = $alphaF",
                    "by contradicting the assumption")
            printfT("Assumption",
                    "Assume:",
                    "The desired upper bound is α",
                    "muffins($m,$s) > α ≥ 1/3")
            printfT("Theorem 2.6.2",
                    "Since muffins($m,$s) > 1/3, each muffin must be cut into 2 shs, totaling $(2m) shs")
            printfT("Property of Buddies",
                    "Since each muffin is cut into 2 shs that are buddies, each sh of size x must imply the existence of a sh of size 1-x")
        end

        # Check if V-Conjecture applies
        if m//s * 1//(V+1) > alpha || 1 - m//s * 1//(W-1) > alpha
            printf("V-Conjecture does not apply, VInt failed", line=true)
            return false
        end

        ((_, x), (y, _)) = findend(m, s, alpha, V)

        # Check if FindEnd works
        if x == alpha && y == 1-alpha
            printf("FindEnd inconclusive, VInt failed", line=true)
            return false
        end

        # Define and format variables for proof
        cd = lcm(s, denominator(x), denominator(y))
        alphaF = formatFrac(alpha, cd)
        alphabuddy = formatFrac(1-alpha, cd)
        size = formatFrac(m//s, cd)
        a = formatFrac(m//s-x, cd)
        b = formatFrac(m//s-y, cd)
        xF = formatFrac(x, cd)
        xbuddy = formatFrac(1-x, cd)
        yF = formatFrac(y, cd)
        ybuddy = formatFrac(1-y, cd)
        diff = abs(numV-numW)

        # Continue proof
        if proof
            # Describe casework
            printHeader("CASEWORK")

            printfT("V-Conjecture",
                    "The only cases that need to be considered deal with everyone having either $W or $V shs, so:",
                    "",
                    "$(W)s_$W + $(V)s_$V = $(2m)  (total shs)",
                    "s_$W + s_$V = $s  (total students)",
                    "where s_N = # of students with N shs",
                    "",
                    "The solution to the system is:",
                    "s_$W = $sW, s_$V = $sV",
                    "So there are $numW $W-shs and $numV $V-shs")

            if x != alpha
                printfT("Case 1",
                        "Alice has a $V-sh ≥ $xF",
                        "Her other $(V-1) $V-shs sum to ≤ ($size - $xF) = $a",
                        "One of them is ≤ ($a × 1/$(V-1)) = $alphaF",
                        "",
                        "Contradicts assumption if α ≥ $alphaF")
            else
                printfT("Case 1",
                        "FindEnd did not produce a conclusive bound for $V-shs")
            end

            if y != 1-alpha
                printfT("Case 2",
                        "Bob has a $W-sh ≤ $yF",
                        "His other $(W-1) $W-shs sum to ≥ ($size - $yF) = $b",
                        "One of them is ≥ ($b × 1/$(W-1)) = $alphabuddy",
                        "Its buddy is ≤ (1 - $alphabuddy) = $alphaF",
                        "",
                        "Contradicts assumption if α ≥ $alphaF")
            else
                printfT("Case 2",
                        "FindEnd did not produce a conclusive bound for $W-shs")
            end

            printHeader("CASE 3: INTERVAL ANALYSIS")
            println()
            printf("The following intervals capture the negation of the previous cases:")
            if x <= y && x > alpha && y < 1-alpha
                println("\n",
                        interval(["(", alphaF],
                                [")[", xF],
                                ["](", yF],
                                [")", alphabuddy],
                                labels=["$numV $V-shs", "0", "$numW $W-shs"]))
                printLine()
            else
                if xF != alphaF
                    println("\n",
                            interval(["(", alphaF],
                                    [")[", xF],
                                    [")", alphabuddy],
                                    labels=["$numV $V-shs", "0 $V-shs"]))
                end
                if yF != alphabuddy
                    println("\n",
                            interval(["(", alphaF],
                                    ["](", yF],
                                    [")", alphabuddy],
                                    labels=["0 $W-shs", "$numW $W-shs"]))
                end

                printfT("Case 3",
                        "The Interval Method is inconclusive on these intervals, VInt failed")
            end
        end

        # Fail if interval inconclusive
        if x > y || x == alpha || y == 1-alpha
            !proof && printf("Could not generate conclusive interval, VInt failed", line=true)
            return false
        end

        # Define and format variables for proof
        (vMin, vMax, sMin, sMax) = (V, W, sV, sW)
        (f, g) = (Int64(floor(numV/sW)), Int64(floor(diff/sW)))
        (lim1, lim2) = ((vMin)sMin, diff)
        (i, j, k, l) = (xF, yF, ybuddy, xbuddy)
        (rngMin, rngMax, rngS, rngL) = ((alphaF, xF), (xbuddy, alphabuddy), (yF, ybuddy), (xbuddy, alphabuddy))
        if numV > numW
            (vMin, vMax, sMin, sMax) = (W, V, sW, sV)
            (f, g) = (Int64(floor(diff/sV)), Int64(floor(numW/sV)))
            (lim1, lim2) = (lim2, lim1)
            (i, j, k, l) = (ybuddy, xbuddy, xF, yF)
            (rngMin, rngMax, rngS, rngL) = ((yF, alphabuddy), (alphaF, yF), (alphaF, ybuddy), (xbuddy, xF))
        end
        numMin = (vMin)sMin

        # Conclude interval case
        if proof
            printfT("Property of Buddies",
                    "Because $numMin $vMin-shs lie in ($(rngMin[1]),$(rngMin[2])), $numMin $vMax-shs must lie in ($(rngMax[1]),$(rngMax[2]))",
                    "",
                    "Similary, the gap that lies in [$xF,$yF] implies a gap that lies in [$ybuddy,$xbuddy]")
            println()
            printf("The following intervals capture the previous statements:")
            println("\n",
                    interval(["(", alphaF],
                            [")[", i],
                            ["](", j],
                            [")[", k],
                            ["](", l],
                            [")", alphabuddy],
                            labels=["$numMin $V-shs", "0", "$diff $vMax-shs", "0", "$numMin $W-shs"]))
            printLine()

            printfT("Note",
                    "Let the $vMax-shs that lie in ($(rngS[1]),$(rngS[2])) be small $vMax-shs",
                    "Let the $vMax-shs that lie in ($(rngL[1]),$(rngL[2])) be large $vMax-shs")
        end

        upperB = (vMax-f)*toFrac(rngS[2]) + (f)*toFrac(rngL[2])
        lowerB = (vMax-g)*toFrac(rngL[1]) + (g)*toFrac(rngS[1])
        u = formatFrac(upperB, cd)
        l = formatFrac(lowerB, cd)

        if upperB <= m//s
            if proof
                printfT("Case 3.1",
                        "All $sMax $vMax-sh students have at least $(f+1) large $vMax-shs",
                        "",
                        "This is impossible because $(f+1)×$sMax = $((f+1)sMax) ≥ $lim1")
                printfT("Case 3.2",
                        "∃ student Alice with ≤ $f large $vMax-shs",
                        "She must also have ≥ $(vMax-f) small $vMax-shs, so her maximum amount of muffins is:",
                        "< ($(vMax-f) × $(rngS[2])) + ($f × $(rngL[2])) = $u",
                        "",
                        "Since Alice's muffin amount can not reach $size, this case is impossible")
            end
        elseif lowerB >= m//s
            if proof
                printfT("Case 3.1",
                        "All $sMax $vMax-sh students have at least $(g+1) small $vMax-shs",
                        "",
                        "This is impossible because $(g+1)×$sMax = $((g+1)sMax) ≥ $lim2")
                printfT("Case 3.2",
                        "∃ student Bob with ≤ $g small $vMax-shs",
                        "He must also have ≥ $(vMax-g) large $vMax-shs, so his minimum amount of muffins is:",
                        "> ($g × $(rngS[1])) + ($(vMax-g) × $(rngL[1])) = $l",
                        "",
                        "Since Bob's muffin amount can not reach $size, this case is impossible")
            end
        else
            if proof
                printfT("Case 3.1",
                        "All $sMax $vMax-sh students have at least $(f+1) large $vMax-shs",
                        "",
                        "This is impossible because $(f+1)×$sMax = $((f+1)sMax) ≥ $lim1")
                printfT("Negation of Case 3.1",
                        "∃ student Alice with ≤ $f large $vMax-shs",
                        "She must also have ≥ $(vMax-f) small $vMax-shs, so her maximum amount of muffins is:",
                        "< ($(vMax-f) × $(rngS[2])) + ($f × $(rngL[2])) = $u",
                        "",
                        "Since $size lies below the upper bound, this case is inconclusive")
                printfT("Case 3.2",
                        "All $sMax $vMax-sh students have at least $(g+1) small $vMax-shs",
                        "",
                        "This is impossible because $(g+1)×$sMax = $((g+1)sMax) ≥ $lim2")
                printfT("Negation of Case 3.2",
                        "∃ student Bob with ≤ $g small $vMax-shs",
                        "He must also have ≥ $(vMax-g) large $vMax-shs, so his minimum amount of muffins is:",
                        "> ($g × $(rngS[1])) + ($(vMax-g) × $(rngL[1])) = $l",
                        "",
                        "Since $size lies above the lower bound, this case is inconclusive")

                printf("Bounding # of large and small $vMax-shs inconclusive, proceeding with individual case analysis", line=true)
            end

            for k=0:vMax
                upperB = (vMax-k)*toFrac(rngL[2]) + (k)*toFrac(rngS[2])
                lowerB = (vMax-k)*toFrac(rngL[1]) + (k)*toFrac(rngS[1])
                u = formatFrac(upperB, cd)
                l = formatFrac(lowerB, cd)
                if upperB <= m//s || lowerB >= m//s
                    if proof
                        printfT("Case 3.$(k+3)",
                                "Alice has $k small $vMax-shs and $(vMax-k) large $vMax-shs",
                                "Her possible muffin amount lies in:",
                                "",
                                "($k × $(rngS[1]) + $(vMax-k) × $(rngL[1]),",
                                "$k × $(rngS[2]) + $(vMax-k) × $(rngL[2]))",
                                "= ($l, $u)",
                                "",
                                "Since $size lies outside this interval, this case is impossible")
                    end
                else
                    # Fail if interval analysis inconclusive
                    if proof
                        printfT("Case 3.$(k+3)",
                                "Bob has $k small $vMax-shs and $(vMax-k) large $vMax-shs",
                                "His possible muffin amount lies in:",
                                "",
                                "($k × $(rngS[1]) + $(vMax-k) × $(rngL[1]),",
                                "$k × $(rngS[2]) + $(vMax-k) × $(rngL[2]))",
                                "= ($l, $u)",
                                "",
                                "Since $size lies inside this interval, this case is inconclusive")
                    else
                        printf("Interval analysis inconclusive, VInt failed", line=true)
                    end
                    return false
                end
            end
        end

        # Conclude proof
        alpha = formatFrac(alpha)
        if proof
            # Conclude with alpha's value
            printHeader("CONCLUSION")
            printfT("Compute α",
                    "Each possible case derive the same lower bound for α that contradicts the assumption",
                    "",
                    "All possible cases contradict the assumption iff.",
                    "α ≥ $alpha")
            printfT("Conclusion",
                    "muffins($m,$s) ≤ α, ∀ α ≥ $alpha",
                    "",
                    "muffins($m,$s) ≤ $alpha")
        else
            printfT("Interval Method",
                    "Upper bound of muffins($m,$s) is $alpha")
        end
        printEnd()

        true
    end
end
