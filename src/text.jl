function fracstring(f::Rational{Int64}, d::Int64)
    num=numerator(f)
    den = denominator(f)

    if d%den==0
        num = num*Int64(d/den)
        den = den*Int64(d/den)
        return string(num, "/", den)
    else
        return string(num, "/", den)
    end
end
