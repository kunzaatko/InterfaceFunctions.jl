# InterfaceFunctions

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://kunzaatko.github.io/InterfaceFunctions.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kunzaatko.github.io/InterfaceFunctions.jl/dev/)
[![Build Status](https://github.com/kunzaatko/InterfaceFunctions.jl/actions/workflows/CI.yml/badge.svg?branch=trunk)](https://github.com/kunzaatko/InterfaceFunctions.jl/actions/workflows/CI.yml?query=branch%3Atrunk)
[![Coverage](https://coveralls.io/repos/github/kunzaatko/InterfaceFunctions.jl/badge.svg?branch=trunk)](https://coveralls.io/github/kunzaatko/InterfaceFunctions.jl?branch=trunk)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/AquaFunctions.jl)

InterfaceFunctions.jl provides a robust and flexible way to define and manage function interfaces of abstract types in
Julia, supporting both obligatory (necessary to implement by the concrete type creator) and optional (ones that provide
a default implementation) interfaces with clear error handling and debug logging.

## Installation

To install InterfaceFunctions.jl, open the Julia REPL and run:

```julia
using Pkg
Pkg.add("InterfaceFunctions")
```

## Quick Start

Define an obligatory interface:

```julia
using InterfaceFunctions

abstract type MyAbstractType end

@interface my_required_function(x::MyAbstractType)

struct MyConcreteType <: MyAbstractType end

# This will throw an UnimplementedInterface error
try
    my_required_function(MyConcreteType())
catch e
    println(e)
end

# Implement the interface
my_required_function(x::MyConcreteType) = "Hello from MyConcreteType!"
println(my_required_function(MyConcreteType()))
```

## Documentation

For more detailed information, examples, and API reference, please refer to the [stable
documentation](https://kunzaatko.github.io/InterfaceFunctions.jl/stable/) or the [development
documentation](https://kunzaatko.github.io/InterfaceFunctions.jl/dev/).

## Contributing

Contributions are welcome! Please refer to the [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to this project.

## Citing

See [`CITATION.bib`](CITATION.bib) for the relevant reference(s).
