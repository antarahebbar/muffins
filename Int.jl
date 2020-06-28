function int(muffins,students)
    V = Int64(ceil((2 * muffins)/students))
    W = V-1
    q = Int64(2*muffins - W*students)
    r = Int64(V*students - 2*muffins)
    Wshares=W*r
    Vshares=V*q

    if Wshares>Vshares
        newdown1=1-muffins//students+(W-1)
        newdown2=1-muffins//students
        key=Int64(floor(Vshares/r))
        other=W-key
        answer1= (key+other*newdown1-muffins//students)//(key+other*(W-1))
        answer2=(muffins//students-(V-other)*(newdown2)-(other-1)*(1-newdown1))//((V-other)*(V-1)-(other-1)*(W-1))
        if answer1<=1//3
            return 1//3
        else
            return min(answer1, answer2)
        end

    else
        key=Int64(floor((Vshares-Wshares)/q))
        other=V-key
        answer=(other*(1-muffins//students+(W-1))+(key-1)*(muffins//students))//(other+key*(V-1))
        if answer<=1//3
            return 1//3
        else
            return answer
        end
    end


end
