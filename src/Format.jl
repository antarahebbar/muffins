module Format

using TextWrap

export printf, printfT, printHeader, printEnd, formatFrac, interval, center

LEFT_WIDTH = 45
RIGHT_WIDTH = 25
LINE_WIDTH = LEFT_WIDTH + RIGHT_WIDTH

# Formats and outputs a line of text
function printf(text...; line=false)
    println_wrapped(text..., width=LINE_WIDTH)
    if line
        println('—' ^ LINE_WIDTH)
    end
end

# Formats and outpus a line of text with a theorem reference
function printfT(theorem, text...)
    wrapped = join(map( line->wrap(string(line), width=LEFT_WIDTH), [text...] ), "\n")
    lastPos = occursin("\n", wrapped) ? findlast('\n', wrapped) : 0
    println()
    print(rpad(wrapped, lastPos + LEFT_WIDTH))
    println(lpad(theorem, RIGHT_WIDTH))
    println('—' ^ LINE_WIDTH)
end

# Formats and outputs text as a section header
function printHeader(text...)
    println("\n")
    println(text...)
    println('—' ^ LINE_WIDTH)
end

# Outputs the end of a procedure
function printEnd()
    println(center("END"))
end

# Formats a Rational type variable into its string representation
function formatFrac(frac::Rational{Int64})
    if denominator(frac) == 1
        numerator(frac)
    else
        string(numerator(frac), "/", denominator(frac))
    end
end

# Outpus a string interval that concatenates given ranges labeled with given labels
function interval(rngs...; labels=repeat([" "], length(rngs) - 1))
    int = ""
    val = ""
    w = maximum(length(rng[2]) for rng in rngs) + 1
    for i in 1:(2length(rngs) - 1)
        if i % 2 == 0
            label = labels[Int64(i/2)]
            int *= label
            val *= ' ' ^ length(label)
        else
            rng = rngs[Int64(ceil(i/2))]
            int *= center(rng[1], width=w)
            val *= center(rng[2], width=w)
        end
    end
    center(int, val)
end

# Centers text within width spaces
function center(text...; width::Int64 = LINE_WIDTH)
    out = []
    half = Int64(floor(width/2))
    for line in text
        mid = Int64(floor(length(line)/2))
        append!(out, [lpad(line[1:mid], half) * rpad(line[(mid+1):length(line)], width-half)])
    end
    join(out, "\n")
end

# Helper function for printfT -- Unicode-compatible version of built-in findlast
function findlast(char::Char, str::String)
    o = 0
    e = 1
    i = 1
    while i <= length(str)
        if str[e] == char
            o = i
        end
        e += nextind(string(str[e]), 1) - 1
        i += 1
    end
    o
end

end