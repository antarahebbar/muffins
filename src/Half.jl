function half(muffins, students)
    if muffins % students==0
        return 1
    elseif muffins < students
        return "Input muffins > students"
    end
    V = Int64(ceil((2 * muffins)/students))
    W = V-1

    x = Int64(2*muffins - W*students)
    y = Int64(V*students - 2*muffins)

    Wshares = W*y
    Vshares = V*x
    if Wshares > muffins
        key = W
        other=V
    elseif Vshares>muffins
        key = V
        other=W
    end

    firstbound=(muffins//students-1//2)//(key-1)
    upperbound=max(firstbound, 1-firstbound)
    lowerbound=min(firstbound, 1-firstbound)
    if lowerbound<=1//3
        print("1//3")
    else
        println(lowerbound)
    end
end
