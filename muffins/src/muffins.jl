module test

include("format.jl")
using .Format

include("FCBound.jl")
using .FC

include("half.jl")
using .Half

include("Int.jl")
using .IntMethod

include("ebm.jl")
using .EBM

include("findproc.jl")
using .FindProc

export test1

test1() = printfT("Hello World!", fc(5,3), half(11,5), int(35,13), findproc(5,3,5//12))

end # module
