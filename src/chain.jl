
export AbstractChain

export samples, meta, logp, logweights, info, pushsample!
export initialize!, step!, drawsamples!

abstract type AbstractChain{T} <: AbstractVector{T} end

function resizablefields(::AbstractChain) end
function pushsample!(::AbstractChain, sample) end
function initialize!(ch::AbstractChain, args...; kwargs) end
function step!(ch::AbstractChain) end
function drawsamples!(ch::AbstractChain) end

# @concrete terse struct Chain{T} <: AbstractVector{T}
#     samples     # :: AbstractVector{T}
#     logweights  # For importance sampling, etc
#     logp        # log-density for distribution the sample was drawn from
#     meta        # Per-sample metadata, type depends on sampler used
#     globals     # Metadata associated with the sample as a whole
#     iter        # The sampling iterator, can be used to draw additional samples
# end
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


Base.propertynames(ch::AbstractChain) = propertynames(samples(ch))

# TODO: Make this pass @code_warntype
Base.getproperty(ch::AbstractChain, k::Symbol) = getproperty(samples(ch), k)

# function Base.showarg(io::IO, ch::AbstractChain{T}, toplevel) where T
#     io = IOContext(io, :compact => true)
#     print(io, "Chain")
#     toplevel && println(io, " with schema ", schema(T))
# end

function Base.showarg(io::IO, chain::AbstractChain{T}, toplevel) where T
    io = IOContext(io, :compact => true)
    print(io, "Chain")
    toplevel && println(io, " with schema ", schema(T))
end

function Base.show(io::IO, ::MIME"text/plain", chain::AbstractChain)
    summary(io, chain)
    print(io, summarize(chain))
end

# function Base.setindex!(a::AbstractChain{T,X}, x::T, j::Int) where {T,X}
#     a1 = flatten(unwrap(a))
#     x1 = flatten(x)

#     setindex!.(a1, x1, j)
#     return a
# end








# leaf_setter(ch::AbstractChain) = Chain ∘ leaf_setter(unwrap(ch))

# function Chain{T}(::UndefInitializer) where {T}
#     return EmptyChain{T}()
# end


# function Base.push!(::EmptyChain{T}, nt::NamedTuple) where {T}
#     function f(x::t, path) where {t}
#         ea = ElasticArray{t}(undef, 0)
#         push!(ea, x)
#         return ea
#     end

#     function f(x::DenseArray{t}, path) where {t}
#         ea = ElasticArray{t}(undef, size(x)..., 0)
#         nv = nestedview(ea, 1)
#         push!(nv, x)
#         return nv
#     end

#     data = fold(f, nt)
#     X = typeof(data)
#     Chain{T,X}(data)
# end

function Base.resize!(ch::AbstractChain, n::Int)
    for v in resizablefields(ch)
        resize!(v, n)
    end
end
