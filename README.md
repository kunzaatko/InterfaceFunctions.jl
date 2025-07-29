<p align="center">
    <img src="./docs/src/assets/logo.png" alt="InterfaceFunctions.jl Logo: A puzzle piece in Julia colours" style="width: 35%">
</p>

# InterfaceFunctions

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://kunzaatko.github.io/InterfaceFunctions.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kunzaatko.github.io/InterfaceFunctions.jl/dev/)
[![Build Status](https://github.com/kunzaatko/InterfaceFunctions.jl/actions/workflows/CI.yml/badge.svg?branch=trunk)](https://github.com/kunzaatko/InterfaceFunctions.jl/actions/workflows/CI.yml?query=branch%3Atrunk)
[![Coverage](https://coveralls.io/repos/github/kunzaatko/InterfaceFunctions.jl/badge.svg?branch=trunk)](https://coveralls.io/github/kunzaatko/InterfaceFunctions.jl?branch=trunk)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/AquaFunctions.jl)

InterfaceFunctions.jl provides a robust and flexible (although light and very simple) way to define and manage function
interfaces of abstract types in Julia, supporting both obligatory (necessary to implement by the concrete type creator)
and optional (ones that provide a default implementation) interfaces with clear error handling and debug logging.

## Installation

To install InterfaceFunctions.jl, open the Julia REPL and run:

```julia
using Pkg
Pkg.add("InterfaceFunctions")
```

## Quick Start

There is only a single macro that this package publicly provides: `@interface`.

Defining interfaces can be simply done by preceding a function (optional interface) or a call (obligatory interface)
by the `@interface` macro:

```julia
using InterfaceFunctions

abstract type AbstractType end

@interface required_function(x::AbstractType)

struct ConcreteType <: AbstractType end

# This will throw an UnimplementedInterface error
try
    required_function(ConcreteType())
catch e
    println(e)
end

# Implement the interface
required_function(x::ConcreteType) = "Hello from ConcreteType!"
println(required_function(ConcreteType())) # Prints "Hello from ConcreteType!"

@interface optional_function(x::AbstractType) = "Hello from AbstractType!"
println(optional_function(ConcreteType())) # Prints "Hello from AbstractType!"
```

## Documentation

For more detailed information, examples, and API reference, please refer to the [stable
documentation](https://kunzaatko.github.io/InterfaceFunctions.jl/stable/) or the [development
documentation](https://kunzaatko.github.io/InterfaceFunctions.jl/dev/).

## Contributing

All contributions are welcome. For instructions on how to contribute in the correct manner, read the Julia
[__ColPrac__](https://github.com/SciML/ColPrac) collaboration practices guidelines or create a PR and let the
maintainers help you out.

## Citing

See [`CITATION.bib`](CITATION.bib) for the relevant reference(s).
