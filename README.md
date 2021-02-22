# SampleChains

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://cscherrer.github.io/SampleChains.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://cscherrer.github.io/SampleChains.jl/dev)
[![Build Status](https://github.com/cscherrer/SampleChains.jl/workflows/CI/badge.svg)](https://github.com/cscherrer/SampleChains.jl/actions)
[![Coverage](https://codecov.io/gh/cscherrer/SampleChains.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/cscherrer/SampleChains.jl)

```julia
julia> chain
MultiChain with 4 Chains, 2000 total samples
(σ = 1.0±1.1, α = 2.2±39.0, β = [0.047±0.97, 0.023±1.0, 0.062±1.0, -0.015±0.99, 0.033±1.0])
```

Some features (many still in progress):
- Simple visual representation 
- "Samples first", though diagnostic information is easily available
- Each `Chain` can be indexed as a Vector, or as a NamedTuple
- Interrupting (CTRL-C) returns the current chain, including iterator information so work can be resumed
- Built on [ElasticArrays](https://github.com/JuliaArrays/ElasticArrays.jl) to make it easy to add new samples after the fact
- Adaptable to many different sampling algorithms, including with or without (log-)weights
- Easy summarization functions: expectations per-dimension quantiles, etc
