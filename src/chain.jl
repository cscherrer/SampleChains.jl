
export AbstractChain

export samples, meta, logp, logweights, info, pushsample!
export initialize!, step!, drawsamples!
import Base

abstract type AbstractChain{T} <: AbstractVector{T} end

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
    initialize!(C::Type{<:AbstractChain}, args...) -> C

Initialize a new chain of type C.
"""
function initialize!(C::Type{<:AbstractChain}, args...) end

"""
    step!(ch::AbstractChain)

Take a single step in the chain, returning the next sample. The return type
depends on AbstractChain subtype. The only change in the chain `ch` is the
iterator state; the samples are unchanged.
"""
function step!(ch::AbstractChain) end

"""
    drawsamples!(ch::AbstractChain, n::Int)

Draw `n` samples from the chain `ch` and append them.
"""
function drawsamples!(ch::AbstractChain, n::Int) end

using MappedArrays

meta(ch::AbstractChain) = getfield(ch, :meta)
globals(ch::AbstractChain) = getfield(ch, :globals)
logweights(chain::AbstractChain) = mappedarray(_ -> 0.0, logp(chain))
info(chain::AbstractChain) = getfield(chain, :info)
samples(chain::AbstractChain) = getfield(chain, :samples)
logp(chain::AbstractChain) = getfield(chain, :logp)

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

function Base.resize!(ch::AbstractChain, n::Int)
    for v in resizablefields(ch)
        resize!(v, n)
    end
end
