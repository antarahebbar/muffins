

function findproc(muffins,students, alpha)
    lcmalpha=lcm(students, denominator(alpha))
    V = Int64(ceil((2 * muffins)/students))
    W = V-1

    #proper num/den
    if denominator(alpha)==lcmalpha
        alphanum=numerator(alpha)
        alphaden=denominator(alpha)
        dividemuf=denominator(alpha)/students
        muffinnum=Int64(numerator(alpha)*dividemuf)

    else
        dividealpha=(lcm(students, denominator(alpha)))/denominator(alpha)
        dividemuf=(lcm(students, denominator(alpha)))/students
        alphanum=Int64(numerator(alpha)*dividealpha)
        alphaden=lcm(students, denominator(alpha))
        muffinnum=Int64(numerator(alpha)*dividemuf)
    end

    #finding range of shares
    alphabuddy=alphaden-alphanum
    sharesizes=[alphanum, alphabuddy]
    for n =alphanum:alphabuddy
        if alphanum<alphabuddy
            alphanum+=1
            alphabuddy-=1
            append!(sharesizes, alphanum)
            append!(sharesizes, alphabuddy)
        else
            break
        end
    end

    #combos of shares
    for c in with_replacement_combinations(sharesizes, V)
        if sum(c)==muffinnum
            println(c)
        else
            continue
        end
    end

    for c in with_replacement_combinations(sharesizes, W)
        if sum(c)==muffinnum
            println(c)
        else
            continue
        end
    end

end
