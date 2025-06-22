using InterfaceFunctions
using Documenter

DocMeta.setdocmeta!(InterfaceFunctions, :DocTestSetup, :(using InterfaceFunctions); recursive=true)

makedocs(;
    modules=[InterfaceFunctions],
    authors="Martin Kunz <martinkunz@email.cz> and contributors",
    sitename="InterfaceFunctions.jl",
    format=Documenter.HTML(;
        canonical="https://kunzaatko.github.io/InterfaceFunctions.jl",
        edit_link="trunk",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/kunzaatko/InterfaceFunctions.jl",
    devbranch="trunk",
)
