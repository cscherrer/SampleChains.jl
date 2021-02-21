
export Chain
@concrete terse struct Chain{T} <: AbstractVector{T}
    value
    meta
    globals
end

function Chain(data::AbstractVector{T}, meta::AbstractVector, globals) where {T}
    @assert size(data) == size(meta)
    return Chain{T}(data,meta,globals)
end

value(ch::Chain) = getfield(ch, :value)
meta(ch::Chain) = getfield(ch, :meta)
globals(ch::Chain) = getfield(ch, :globals)

Base.size(ch::Chain) = size(value(ch))

Base.length(ch::Chain) = length(value(ch))

Base.getindex(ch::Chain, n) = getindex(value(ch), n)

# struct MultiChain{T}
#     chains::AbstractArray{Chain{T}}
# end

Base.propertynames(ch::Chain) = propertynames(value(ch))

# TODO: Make this pass @code_warntype
Base.getproperty(ch::Chain, k::Symbol) = getproperty(ch, k)

# function Base.showarg(io::IO, ch::Chain{T}, toplevel) where T
#     io = IOContext(io, :compact => true)
#     print(io, "Chain")
#     toplevel && println(io, " with schema ", schema(T))
# end

function Base.show(io::IO, ::MIME"text/plain", ch::Chain)
    print(io, summarize(ch))
end


function Base.showarg(io::IO, tv::Chain{T}, toplevel) where T
    io = IOContext(io, :compact => true)
    print(io, "Chain")
    toplevel && println(io, " with schema ", schema(T))
end

function Base.show(io::IO, ::MIME"text/plain", tv::Chain)
    summary(io, tv)
    print(io, summarize(tv))
end

# function Base.setindex!(a::Chain{T,X}, x::T, j::Int) where {T,X}
#     a1 = flatten(unwrap(a))
#     x1 = flatten(x)

#     setindex!.(a1, x1, j)
#     return a
# end








# leaf_setter(ch::Chain) = Chain ∘ leaf_setter(unwrap(ch))

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

function Base.resize!(ch::Chain, n::Int)
    resize!(value(ch), n)
    resize!(meta(ch), n)
end
