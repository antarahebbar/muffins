# FC bound, Antara Hebbar
function FC(muffins, students)
    if muffins<students
        println("Moron! We only deal with muffins >= students.")
    elseif muffins%students==0
        println(1)
    else
        V = (2 * muffins) / students
        minceil=muffins//(Int64(students * ceil(V)))
        minfloor=1-muffins//(Int64(students * floor(V)))
        lowerbound=min(minceil, minfloor)
        answer=max(1//3,lowerbound)
        println(answer)
    end
end
