using InterfaceFunctions
using Documenter, DocumenterInterLinks


DocMeta.setdocmeta!(InterfaceFunctions, :DocTestSetup, :(
        include(joinpath(@__DIR__, "../test", "doctestsetup.jl"))
    ); recursive=true)

links = InterLinks(
    "Julia" => "https://docs.julialang.org/en/v1/",
    "MacroTools" => "https://fluxml.ai/MacroTools.jl/dev/"
)

makedocs(;
    modules=[InterfaceFunctions],
    authors="Martin Kunz <martinkunz@email.cz> and contributors",
    sitename="InterfaceFunctions.jl",
    format=Documenter.HTML(;
        canonical="https://kunzaatko.github.io/InterfaceFunctions.jl",
        edit_link="trunk",
        assets=["assets/favicon.ico"],
    ),
    pages=[
        "Home" => "index.md",
        "Quick Start" => "quickstart.md",
        "Manual" => "manual.md",
    ],
    plugins=[links],
    doctest=false # tests run in `test/runtests.jl`
)

deploydocs(;
    repo="github.com/kunzaatko/InterfaceFunctions.jl",
    devbranch="trunk",
)
