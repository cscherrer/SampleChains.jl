using LazyArrays: ApplyArray
using Accessors: set
export MultiChain
struct MultiChain{T} <: AbstractVector{T}
    chains
end


export chains

Base.size(mc::MultiChain) = size(samples(mc))

chains(mc::MultiChain) = getfield(mc, :chains)

function Base.getindex(mc::MultiChain, n::Int)
    getindex(samples(mc), n)
end

Base.propertynames(mc::MultiChain) = propertynames(first(samples(mc)))

Base.getproperty(mc::MultiChain, p::Symbol) = ApplyArray(vcat, getproperty.(chains(mc), p)...)

MultiChain(chains::AbstractChain...) = MultiChain([chains...])

function MultiChain(chains::Vector{<:AbstractChain{T}}) where {T}
    return MultiChain{T}(chains)
end

function summarize(mc::MultiChain)
    summarize(samples(mc))
end




function samples(mc::MultiChain{T}) where {T}
    chs = chains(mc)
    nt = deepcopy(unwrap(samples(first(chs))))
    for lens in lenses(nt)
        vecs = (lens(unwrap(ch)) for ch in chs)
        nt = set(nt, lens, ApplyArray(vcat, vecs...))
    end
    return TupleVector{T, typeof(nt)}(nt)
end

function Base.showarg(io::IO, mc::MultiChain{T}, toplevel) where T
    io = IOContext(io, :compact => true)
    numchains = length(chains(mc))
    print(io, "MultiChain")
    if toplevel 
        println(io, " with $numchains chains and schema ", schema(T))
    end
end

function Base.show(io::IO, ::MIME"text/plain", mc::MultiChain)
    summary(io, mc)
    print(io, summarize(mc))
end
