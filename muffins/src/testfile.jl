module testing

include("format.jl")
using .Formatting

include("FCBound.jl")
using .FloorCeiling

include("half.jl")
using .Half

include("Int.jl")
using .IntMethod

include("ebm.jl")
using .EBM

include("findproc.jl")
using .FindProc

include("tools.jl")
using .Tools

export test1, print_Intervals

test1(a,b) = printfT("Hello World!", fc(a,b), half(a,b), int(a,b))

end # module
