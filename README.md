# SampleChains

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://cscherrer.github.io/SampleChains.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://cscherrer.github.io/SampleChains.jl/dev)
[![Build Status](https://github.com/cscherrer/SampleChains.jl/workflows/CI/badge.svg)](https://github.com/cscherrer/SampleChains.jl/actions)
[![Coverage](https://codecov.io/gh/cscherrer/SampleChains.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/cscherrer/SampleChains.jl)

```julia
julia> chains
3003-element MultiChain with 3 chains and schema (σ = Float64, α = Float64, β = Vector{Float64})
(σ = 0.9±0.88, α = -5.1±10.0, β = [-0.0±0.9, 0.04±0.99, 0.04±1.1, 0.02±0.92, 0.06±0.95])
```

Some features (many still in progress):
- Simple visual representation 
- "Samples first", though diagnostic information is easily available
- Each `Chain` can be indexed as a Vector, or as a NamedTuple
- Interrupting (CTRL-C) returns the current chain, including iterator information so work can be resumed
- Built on [ElasticArrays](https://github.com/JuliaArrays/ElasticArrays.jl) to make it easy to add new samples after the fact
- Adaptable to many different sampling algorithms, including with or without (log-)weights
- Easy summarization functions: expectations per-dimension quantiles, etc

In progress:
- More back-ends (currently just DynamicHMC, using [SampleChainsDynamicHMC](https://github.com/cscherrer/SampleChainsDynamicHMC.jl))
- Diagnostic warnings during sampling
- Callbacks for plotting, etc
- Sample count based on desired standard error of a specified expected value
- Summarization by different functions
    - Highest posterior density intervals
    - R-hat statistics
