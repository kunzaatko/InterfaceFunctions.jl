module InterfaceFunctions

using MacroTools

# NOTE: `@interface` uses covered
# - `@interface f(t::T)`
# - `@interface f(t::T1, ::T2)`
# - `@interface f(t::Type{<:T})`
# - `@interface f(t::T1, ::Type{<:T2})`
# - `@interface function f(t::T1) end`

"""
    gatherwheres(ex) 
Separate the function signature from the `where` statement and return tuple of `(function_call_signature, where_parameters_tuple)`

Taken from [`MacroTools.jl`](@extref)
"""
function gatherwheres(ex)
    if @capture(ex, (f_ where {params1__}))
        f2, params2 = gatherwheres(f)
        (f2, (params1..., params2...))
    else
        (ex, ())
    end
end

"""
    UnimplementedInterface <: Exception 
Thrown when a subtype does not implement an obligatory interface.
"""
struct UnimplementedInterface{T} <: Exception
    t::T
    function_dict::Dict{Symbol,Any}
end
function Base.showerror(io::IO, err::UnimplementedInterface{T}) where {T}
    kwargs, name, args, whereparams, rtype = err.function_dict[:kwargs],
    err.function_dict[:name], err.function_dict[:args], err.function_dict[:whereparams],
    err.function_dict[:rtype]
    return print(
        io,
        "UnimplementedInterface{$(nameof(T))}: `$(nameof(typeof(err.t)))` does not implement the obligatory interface `$name($(join(args, ", "))$(length(kwargs) > 0 ? "; " : "")$(join(kwargs, ", ")))$(rtype !== nothing ? "::$rtype" : "")$(length(whereparams) > 0 ? " where {$(join(whereparams, ", "))}" : "")`",
    )
end

"""
    @interface fn_expr
Define an interface function for the abstract type in the first argument of the function signature in `fn_expr`.

It is common to define empty functions for interfaces
```julia
function fn(a::A, b::B) end
```
This macro creates the function and adds an informative error message to the user so that he knows what went wrong and how to fix it.
```julia
@inteface fn(a::A, b::B)
```
roughly translates to
```julia
function fn(a::A, b::B)
    throw(UnimplementedInterface{A}(#=signature=#))
end
```

An interface on an abstract type is a way to indicate that every subtype has to provide a custom method for this
function. Interfaces are useful for code re-usability in higher order methods. Higher order methods of abstract types
can use the interfaces defined on these types to provide implementations for their subtypes.
"""
macro interface(ex)
    func = nothing
    fdict = Dict{Symbol,Any}(
        (t => nothing for t in (:name, :args, :rtype, :whereparams, :body))...
    )
    fdict[:kwargs] = []
    fcall = if isexpr(ex, :function)
        @capture(longdef(ex), function (fcall_ | fcall_)
            return body_
        end)
        fcall
    else
        ex
    end
    fcall_nowhere, fdict[:whereparams] = gatherwheres(fcall)

    # Note: Taken from `MacroTools.jl`
    if @capture(
        fcall_nowhere,
        (
            (func_(args__; kwargs__)) |
            (func_(args__; kwargs__)::rtype_) |
            (func_(args__)) |
            (func_(args__)::rtype_)
        )
    )
    elseif isexpr(fcall_nowhere, :tuple)
        if length(fcall_nowhere.args) > 0 && isexpr(fcall_nowhere.args[1], :parameters)
            # Handle both cases: parameters with args and parameters only
            if length(fcall_nowhere.args) > 1
                fdict[:args] = fcall_nowhere.args[2:end]
            else
                fdict[:args] = []
            end
            fdict[:kwargs] = fcall_nowhere.args[1].args
        else
            fdict[:args] = fcall_nowhere.args
        end
    elseif isexpr(fcall_nowhere, :(::))
        fdict[:args] = Any[fcall_nowhere]
    else
        throw(
            ArgumentError(
                lazy"`@interface` may only be used on functions or `:call` expressions. Got $ex",
            ),
        )
    end

    if func !== nothing
        @capture(func, (fname_{params__} | fname_))
        fdict[:name] = fname
    end
    if kwargs !== nothing
        fdict[:kwargs] = kwargs
    end
    if args !== nothing
        fdict[:args] = args
    end
    if rtype !== nothing
        fdict[:rtype] = rtype
    end
    if params !== nothing
        fdict[:params] = params
    end

    length(fdict[:args]) > 0 || throw(
        ArgumentError(lazy"In `@interface`, an interface must have atleast one argument."),
    )

    isexpr(first(fdict[:args]), :(::)) || throw(
        ArgumentError(
            lazy"In `@interface`, the first argument `$(first(fdict[:args]))` of the interface function must have a known type otherwise the interfacing type is unknown.",
        ),
    )
    @capture(first(fdict[:args]), (t_::T_ | ::T_))
    isabstracttype(@eval(@__MODULE__, $T)) || throw(
        ArgumentError(lazy"In `@interface`, the interfacing type `$T` must be abstract."),
    )
    if t === nothing
        t = Symbol(lowercase(first(string(T))))
        fdict[:args][1] = :($t::$T)
    end

    fdict[:body] = :(return throw($UnimplementedInterface{$T}($(t), $(fdict))))

    return esc(combinedef(fdict))
end

export @interface

end
