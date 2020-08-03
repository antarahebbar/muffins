module testing

include("format.jl")
using .Formatting

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

test1(a,b) = printfT("Hello World!", fc(a,b), half(a,b), int(a,b))

end # module
