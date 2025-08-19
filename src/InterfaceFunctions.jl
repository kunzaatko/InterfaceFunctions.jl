# TODO: Allow interfaces for types which are not in the first position <29-07-25> 
# TODO: Documenter.jl extension to generate an AbstractType tree with the interfaces. It should be a mermaid diagram. It
# will be used for generating developer documentation. <29-07-25> 
# TODO: Add a test extension that allows to check that all obligatory interfaces are implemented <08-08-25> 

module InterfaceFunctions
using MacroTools

# TODO: Differentiate between interfaces that have default implementations and those that don't. There has to be
# a difference for how the interfaces can be accessed in the `@docs` section of the documentation pages such that we can
# separate the obligatory interfaces and those that aren't obligatory. See how storing the defined units is this is done
# by the register function in the `Units` package. <14-07-25> 

# TODO: Add a similar documentation constant for all the interfaces such as are the defined constants in
# DocStringExtensions.jl <23-06-25> 

# TODO: Add a default value signature example and test <14-07-25> 
# TODO: `@interface` uses covered add to documentation
# - `@interface f(t::T)`
# - `@interface f(t::T1, ::T2)`
# - `@interface f(t::Type{<:T})`
# - `@interface f(t::T1, ::Type{<:T2})`
# - `@interface function f(t::T1) #=default_body=# end`

# TODO: Add the source of the default interface call to the @debug log message <14-07-25> 

"""
    UnimplementedInterface <: Exception 
Thrown when a subtype does not implement an obligatory interface.
"""
struct UnimplementedInterface{T,X} <: Exception
    signature::String
end
function Base.showerror(io::IO, err::UnimplementedInterface{T,X}) where {T,X}
    return print(
        io,
        "UnimplementedInterface{$(nameof(T))}: `$(nameof(X))` does not implement the obligatory interface `$(err.signature)`",
    )
end

"""
    param_names(type_exp)
Determine the names of the type parameters needed for a correct type definition from the type expression.

```jldoctest
julia> IF.param_names(:(A{B, C{D}}))
4-element Vector{Any}:
 :A
 :B
 :C
 :D
```
"""
function param_names(type_exp, params=[])
    if @capture(type_exp, T_{P__})
        push!(params, namify(T))
        for p in P
            param_names(p, params)
        end
    elseif @capture(type_exp, T__)
        # NOTE: Some parameters are non-symbols for example `AbstractArray{T, 2}` and `namify` would not work on those. But also, we do not care about them. <19-08-25> 
        filter!(Base.Fix2(isa, Symbol), T)
        append!(params, namify.(T))
    else
        return []
    end
    return params
end

"""
    where_param_names(where_exps)
Determine the names of the type parameters for every parameter in `where_exps`

```jldcotest
julia> IF.where_param_names((:(T <: A{B, N}), :(A <: AbstractArray), :(B <: Real), :(N)))
Dict{Symbol, Vector{Any}} with 4 entries:
  :T => [:A, :B, :N]
  :N => []
  :A => [:AbstractArray]
  :B => [:Real]
```
"""
function where_param_names(where_exps)
    return Dict(map(where_exps) do e
        if @capture(e, T_ <: V_)
            namify(T) => param_names(V)
        elseif @capture(e, T_)
            namify(T) => []
        end
    end...)
end

"""
    interfacetype(type_exp, where_exps)
Determine the exact defined interfacing type from the signature of the function and the type expression of the first
argument.
"""
function interfacetype(type_exp, where_exps)
    interface_param_names = param_names(type_exp)
    where_param_names_dict = where_param_names(where_exps)
    interface_whereparams_names = []
    needed_param_names = [interface_param_names...]
    """
        collect_needed(added, needed, needed_dict)
    Collect the names of the needed type parameters starting with `added` and `needed` and going throught the
    `added` to recursively add the necesary type parameter names from `needed_dict[k]` to `needed` for every `k` in
    needed.
    """
    function collect_needed(added, needed, needed_dict)
        if isempty(added)
            return needed
        else
            for n in added
                append!(needed, get(needed_dict, n, []))
            end
            new = mapreduce(vcat, added) do n
                get(needed_dict, n, [])
            end
            empty(added)
        end
        return collect_needed(new, needed, needed_dict)
    end
    needed_param_names = collect_needed(
        interface_param_names, interface_param_names, where_param_names_dict
    )
    for w in where_exps
        if namify(w) ∈ needed_param_names
            push!(interface_whereparams_names, w)
        end
    end

    return quote
        $type_exp where {$(interface_whereparams_names...)}
    end
end

"""
    @interface fn_expr
Define an interface function for the abstract type in the first argument of the function signature in `fn_expr`.

There are two situations in which you would want to use this macro. Both define an interface. The difference is whether
you would want to define the interface as obligatory for the implementer or as an optional interface with a default
implementation. The use for these two situations differs only in the object on which you apply this macro. If the
interface should be obligatory, you call `@interface` on a function signature. For optional interfaces call the
interface macro on the default implementation of the interface.

# Obligatory interfaces
> An obligatory interface on an abstract type is a way to indicate that every subtype has to provide a custom method for
> this function. Interfaces are useful for code re-usability in higher order methods. Higher order methods of abstract
> types can use the interfaces defined on these types to provide implementations for their subtypes.

It is common to define empty functions for obligatory interfaces
```julia
function obligatoryfn(a::A, b::B) end
```
This macro creates the function and adds an informative error message to the user so that he knows what went wrong and
how to fix it (what method he has to implement to fix the issue)
```julia
"Documentation"
@inteface obligatoryfn(a::A, b::B)
```
roughly translates to 
```julia
"Documentation"
function obligatoryfn(a::A, b::B)
    throw(UnimplementedInterface{A}(#=signature=#))
end
```
# Optional interfaces 
> An optional interface on an abstract type signifies to the developer working with the abstract type that he has the
> option to change the behaviour of the higher order functions by defining a specialized method for his subtype.

The benefit of using the `@interface` macro for defining such a function is that it can be then used in the
documentation as a group of interfaces that are optional for a type and there are `@debug` messages added automatically
to the calls indicating that the default implementation for the interface is used.

If you want to create an optional interface you have to add the `@interface` annotation in front of the default
implementation 
```julia
@interface optionalfn(a::A, b::B) = :default
# OR
@interface function optionalfn(a::A, b::B) 
    return :default
end
```
These translate roughly to
```julia
function optionalfn(a::A, b::B)
    @debug "Calling default implementation of \$(#=signature=#) at \$(#=source=#) for type \$(#=caller=#)"
    return :default
end
```
"""
macro interface(ex)
    obligatory = !isdef(ex)
    fcall = isdef(ex) ? ex.args[1] : ex
    if obligatory
        ex = MacroTools.@q $ex = begin end
    end
    fdict = MacroTools.splitdef(ex)

    length(fdict[:args]) > 0 || throw(
        ArgumentError(lazy"In `@interface`, an interface must have atleast one argument."),
    )

    isexpr(first(fdict[:args]), :(::)) || throw(
        ArgumentError(
            lazy"In `@interface`, the first argument `$(first(fdict[:args]))` of the interface function must have a known type otherwise the interfacing type is unknown.",
        ),
    )

    interface_arg = MacroTools.splitarg(first(fdict[:args]))
    t, T = interface_arg[[1, 2]]

    T_interface = interfacetype(T, fdict[:whereparams])

    if interface_arg[1] === nothing
        t = Symbol(lowercase(first(string(T))))
        fdict[:args][1] = :($t::$T)
    end

    signature = string(fcall)
    fdict[:body] = if obligatory
        :(return throw($UnimplementedInterface{$T_interface,typeof($t)}($signature)))
    else
        body = fdict[:body]
        logmsg = "Calling default implementation of `" * signature * "`"
        MacroTools.@q begin
            @debug $logmsg * " for type `$(typeof($t))`" _group = :interfaces
            $body
        end
    end

    interface_expr = combinedef(fdict)
    return Expr(
        :block,
        esc(
            quote
                isabstracttype($T_interface) || throw(
                    ArgumentError(
                        "In `@interface`, the interfacing type " *
                        string(nameof($T_interface)) *
                        " must be abstract.",
                    ),
                )
            end,
        ),
        esc(
            quote
                Core.@__doc__ $interface_expr
            end,
        ),
    )
end

export @interface

end
