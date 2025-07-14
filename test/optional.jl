using InterfaceFunctions: InterfaceFunctions as IF
using MacroTools, Markdown

@interface function o1(a::Real, b::Float64)
    return b
end
@test length(methods(o1)) == 1
@test o1(1, 2.0) == 2.0

# TODO: Further testing for the correct debugging messages <14-07-25> 
