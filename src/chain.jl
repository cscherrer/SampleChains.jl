
export AbstractChain

export samples, meta, logq, logw, info, pushsample!
export initialize!, step!, sample!
import Base

abstract type AbstractChain{T} <: AbstractVector{T} end

abstract type ChainConfig{T} end

"""
    resizablefields(c::AbstractChain) -> Tuple{Symbol}

Return a tuple of the fieldnames `s` for which `getfield(c, s)` is a vector
which one element for each sample. 
"""
function resizablefields(::AbstractChain) end

"""
    function pushsample!(::AbstractChain, sample...) -> AbstractChain

Push a new sample to the chain. This is not `push!` because the sample may be
represented across multiple arguments.
"""
function pushsample!(::AbstractChain, sample) end

"""
    initialize!(config::ChainConfig{T}, args...) -> C

Initialize a new chain of type C.
"""
function initialize!(config::ChainConfig, args...) end

"""
    step!(ch::AbstractChain)

Take a single step in the chain, returning the next sample. The return type
depends on AbstractChain subtype. The only change in the chain `ch` is the
iterator state; the samples are unchanged.
"""
function step!(ch::AbstractChain) end

"""
    sample!(ch::AbstractChain, n::Int)

Draw `n` samples from the chain `ch` and append them.
"""
function sample!(ch::AbstractChain, n::Int) end

"""
    getlogdensity(ch::AbstractChain{T})

Get the log-density function the samples are drawn from. Returns a `T -> Real`
function. 
"""
function getlogdensity(chain::AbstractChain) end

using MappedArrays

meta(ch::AbstractChain) = getfield(ch, :meta)
globals(ch::AbstractChain) = getfield(ch, :globals)
logw(chain::AbstractChain) = mappedarray(_ -> 0.0, logq(chain))
info(chain::AbstractChain) = getfield(chain, :info)

"""
    samples(chain::AbstractChain{T}) -> AbstractVector{T}

Return a vector of the samples in the chain.
"""
samples(chain::AbstractChain) = getfield(chain, :samples)



"""
    logq(chain::AbstractChain) -> AbstractVector{AbstractFloat}

Return a vector of the log-densities of the sampled chain. Should satisfy

    logq(chain) == getlogdensity(chain).(samples(chain))
"""
logq(chain::AbstractChain) = getfield(chain, :logq)

Base.size(ch::AbstractChain) = size(samples(ch))

Base.length(ch::AbstractChain) = length(samples(ch))

Base.getindex(ch::AbstractChain, n) = getindex(samples(ch), n)


Base.propertynames(ch::AbstractChain) = propertynames(first(samples(ch)))

# TODO: Make this pass @code_warntype
Base.getproperty(ch::AbstractChain, k::Symbol) = getproperty(samples(ch), k)

function Base.showarg(io::IO, chain::AbstractChain{T}, toplevel) where T
    io = IOContext(io, :compact => true)
    print(io, "Chain")
    toplevel && println(io, " with schema ", schema(T))
end

function Base.show(io::IO, ::MIME"text/plain", chain::AbstractChain)
    summary(io, chain)
    print(io, summarize(chain))
end

function Base.show(io::IO, ::MIME"text/html", chain::AbstractChain)
    summary(io, chain)
    print(io, summarize(chain))
end

function Base.resize!(ch::AbstractChain, n::Int)
    for v in resizablefields(ch)
        resize!(v, n)
    end
end

NestedTuples.rmap(f, ch::AbstractChain) = rmap(f, samples(ch))
