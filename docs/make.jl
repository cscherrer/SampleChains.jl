using SampleChains
using Documenter

DocMeta.setdocmeta!(SampleChains, :DocTestSetup, :(using SampleChains); recursive=true)

makedocs(;
    modules=[SampleChains],
    authors="Chad Scherrer <chad.scherrer@gmail.com> and contributors",
    repo="https://github.com/cscherrer/SampleChains.jl/blob/{commit}{path}#{line}",
    sitename="SampleChains.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://cscherrer.github.io/SampleChains.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/cscherrer/SampleChains.jl",
)
