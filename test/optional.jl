using InterfaceFunctions: InterfaceFunctions as IF
using MacroTools, Markdown

@interface function o1(a::Real, b::Float64)
    return b
end
@test length(methods(o1)) == 1
@test o1(1, 2.0) == 2.0

@interface function o2(a::AbstractArray{T}, b::Real) where {T<:Integer}
    a .* b
end
@test length(methods(o2)) == 1
@test o2([1, 2, 3], 2.0) == [2.0, 4.0, 6.0]
@test_throws MethodError o2([1.0, 2.0, 3.0], 2.0)

@interface function o3(a::AbstractArray{<:Integer}, b::Real)
    a .* b
end
@test length(methods(o3)) == 1
@test o3([1, 2, 3], 2.0) == [2.0, 4.0, 6.0]
@test_throws MethodError o3([1.0, 2.0, 3.0], 2.0)

# TODO: Further testing for the correct debugging messages <14-07-25> 
