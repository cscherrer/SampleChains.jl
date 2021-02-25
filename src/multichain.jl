using LazyArrays: ApplyArray
using Accessors: set
export MultiChain
struct MultiChain{T} <: AbstractVector{T}
    chains
end


export getchains

Base.size(mc::MultiChain) = size(samples(mc))

getchains(mc::MultiChain) = getfield(mc, :chains)

function Base.getindex(mc::MultiChain, n::Int)
    getindex(samples(mc), n)
end

Base.propertynames(mc::MultiChain) = propertynames(first(samples(mc)))

Base.getproperty(mc::MultiChain, p::Symbol) = ApplyArray(vcat, getproperty.(getchains(mc), p)...)

MultiChain(chains::AbstractChain...) = MultiChain([chains...])

function MultiChain(chains::Vector{<:AbstractChain{T}}) where {T}
    return MultiChain{T}(chains)
end

function summarize(mc::MultiChain)
    summarize(samples(mc))
end

function initialize!(nchains::Int, T::Type{<:AbstractChain}, args...)
    chains = T[initialize!(T, args...) for n in 1:nchains]
    return MultiChain(chains...)
end

function drawsamples!(chains::MultiChain, n::Int)
    rawchains = getchains(chains)
    for i in 1:length(rawchains)
        drawsamples!(rawchains[i], n)
    end
    
    return chains
end

function samples(mc::MultiChain{T}) where {T}
    chs = getchains(mc)
    # Get the appropriate NamedTuple to use as a template
    nt = unwrap(samples(first(chs)))

    # For each leaf of our template, ...
    for lens in lenses(nt)
        # Get the corresponding leaves of the chains...
        vecs = (lens(unwrap(ch)) for ch in chs)

        # and concatenate them.
        nt = set(nt, lens, ApplyArray(vcat, vecs...))
    end
    return TupleVector{T, typeof(nt)}(nt)
end

function Base.showarg(io::IO, mc::MultiChain{T}, toplevel) where T
    io = IOContext(io, :compact => true)
    numchains = length(getchains(mc))
    print(io, "MultiChain")
    if toplevel 
        println(io, " with $numchains chains and schema ", schema(T))
    end
end

function Base.show(io::IO, ::MIME"text/plain", mc::MultiChain)
    summary(io, mc)
    print(io, summarize(mc))
end

NestedTuples.rmap(f, mc::MultiChain) = rmap.(f, getchains(mc))
