
export AbstractChain

export samples, meta, logp, logweights, info, pushsample!
export initialize!, step!, drawsamples!
import Base

abstract type AbstractChain{T} <: AbstractVector{T} end

function resizablefields(::AbstractChain) end
function pushsample!(::AbstractChain, sample) end
function initialize!(ch::AbstractChain, args...; kwargs) end
function step!(ch::AbstractChain) end
function drawsamples!(ch::AbstractChain) end

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
