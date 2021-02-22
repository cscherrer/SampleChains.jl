using MCMCDiagnostics
export expect
using Measurements

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
