using MCMCDiagnostics
export expect
using Measurements
using StructArrays: StructVector

# Expected value of x log-weighted by ℓ
function expect(ℓ,x)
    ℓmax = maximum(ℓ)
    xw = 0.0
    ∑w = 0.0
    for (ℓi, xi) in zip(ℓ,x)
        wi = exp(ℓi - ℓmax)
        xw += xi * wi
        ∑w += wi
    end
    return xw / ∑w
end

function expect(x)
    (μ,σ) = mean_and_std(x)
    neff = effective_sample_size(x)
    return μ ± (σ / √neff)
end

export @cleanbreak

macro cleanbreak(ex)
    quote
        try
            $(esc(ex))
        catch e
            if e isa InterruptException
                @warn "Computation interrupted"
            else
                rethrow()
            end    
        end
    end 
end

"""
    chainvec(x::T, n=1)

Return a vector used to store the type T in a SampleChain. Satisfies the law
    chainvec(x,n)[1] == x

If `n>1`, the remaining entries will be `undef`. Note that `x` should correspond
to information stored in a single sample. 
"""
function chainvec end


function chainvec(nt::NamedTuple, n=1)
    tv = TupleVector(undef, nt, n)
    @inbounds tv[1] = nt
    return tv
end

function chainvec(x::T, n=1) where {T<:Real}
    ev = ElasticVector{T}(undef, n)
    @inbounds ev[1] = x
    return ev
end

function chainvec(x::T, n=1) where {T}
    if isstructtype(T)
        v = replace_storage(ElasticVector, StructVector{T}(undef, n))
        @inbounds v[1] = x
        return v
    end
    ev = ElasticVector{T}(undef, n)
    @inbounds ev[1] = x
    return ev
end

function chainvec(x::DenseArray{T,N}, n=1) where {T,N}
    nv = nestedview(ElasticArray{T,N+1}(undef, size(x)..., n), N)
    @inbounds nv[1] = x
    return nv
end
