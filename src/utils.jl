
export expect

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
