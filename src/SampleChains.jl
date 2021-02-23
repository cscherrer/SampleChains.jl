module SampleChains

using NestedTuples
import Base


include("tuplevectors.jl")
include("chain.jl")
include("summarize.jl")
include("utils.jl")
include("backends/dynamichmc.jl")

end
