using InterfaceFunctions: InterfaceFunctions as IF
using MacroTools

@interface i1(a::Real, b::Float64)
@test length(methods(i1)) == 1

@test_throws IF.UnimplementedInterface i1(5.0, 6.0)
@test_throws MethodError i1(:A, 6.0)
@test_throws MethodError i1(5.0)

@interface i2(a::Real, b::Float64)
@test length(methods(i2)) == 1
@test_throws MethodError i2(5.0, 5)
@test_throws IF.UnimplementedInterface i2(5.0, 5.0)

@interface i3(a::Real, b::T) where {T}
@test length(methods(i3)) == 1
@test_throws IF.UnimplementedInterface i3(5.0, 5)
@test_throws IF.UnimplementedInterface i3(5.0, :C)

@interface i4(a::Real, b::T) where {T<:Real}
@test length(methods(i4)) == 1
@test_throws IF.UnimplementedInterface i4(5.0, 5)
@test_throws MethodError i4(5.0, :C)

@interface i5(a::Real, b::Float64)::Float64
@test length(methods(i5)) == 1
@test_throws IF.UnimplementedInterface i5(5.0, 5.0)
@test_throws MethodError i5(5.0, 5)

@interface i6(a::Real, b; kwargs...)
@test length(methods(i6)) == 1
@test_throws IF.UnimplementedInterface i6(4,4)
@test_throws IF.UnimplementedInterface i6(4,4;kw1=1,kw2=1)
@test_throws IF.UnimplementedInterface i6(4,:A)

@interface i7(a::Real, args...; kwargs...)
@test length(methods(i7)) == 1
@test_throws IF.UnimplementedInterface i7(5,3,2,1;kw1=1,kw2=1)

@test_broken @expand @interface function i8(a::Real, b::Float64) end

@test_throws ArgumentError @expand @interface i(a::Float64) # Concrete type
@test_throws ArgumentError @expand @interface i(a) # Missing type
@test_throws ArgumentError @expand @interface i() # No arguments

# TODO: Test: Documentation for interfaces <23-06-25> 
