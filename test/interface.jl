using InterfaceFunctions: InterfaceFunctions as IF
using MacroTools

@interface i1(a::Real, b::Float64)
@test length(methods(i1)) == 1
@test_throws IF.UnimplementedInterface{Real} i1(5.0, 6.0)
@test_throws ["UnimplementedInterface{Real}:", "`i1(a::Real, b::Float64)`"] i1(5.0, 5.0)
@test_throws MethodError i1(:A, 6.0)
@test_throws MethodError i1(5.0)
@test_throws MethodError i1(5.0, 5)

@interface i2(a::Real, b::Real)
@test length(methods(i2)) == 1
@test_throws ["UnimplementedInterface{Real}:", "`i2(a::Real, b::Real)`"] i2(5.0, 5.0)
@test_throws IF.UnimplementedInterface{Real} i2(5.0, 5.0)
@test_throws IF.UnimplementedInterface{Real} i2(5.0, 5)

@interface i3(a::Real, b::T) where {T}
@test length(methods(i3)) == 1
@test_throws ["UnimplementedInterface{Real}:", "`i3(a::Real, b::T) where {T}`"] i3(5.0, 5)
@test_throws IF.UnimplementedInterface{Real} i3(5.0, 5)
@test_throws IF.UnimplementedInterface{Real} i3(5.0, :C)

@interface i4(a::Real, b::T) where {T<:Real}
@test length(methods(i4)) == 1
@test_throws ["UnimplementedInterface{Real}:", "`i4(a::Real, b::T) where {T<:Real}`"] i4(4, 4.0)
@test_throws IF.UnimplementedInterface{Real} i4(5.0, 5)
@test_throws MethodError i4(5.0, :C)

@interface i5(a::Real, b::Float64)::Float64
@test length(methods(i5)) == 1
@test_throws ["UnimplementedInterface{Real}:", "`i5(a::Real, b::Float64)::Float64`"] i5(4, 4.0)
@test_throws IF.UnimplementedInterface{Real} i5(5.0, 5.0)
@test_throws MethodError i5(5.0, 5)

@interface i6(a::Real, b; kwargs...)
@test length(methods(i6)) == 1
@test_throws ["UnimplementedInterface{Real}:", "`i6(a::Real, b; kwargs...)`"] i6(4, 4)
@test_throws IF.UnimplementedInterface{Real} i6(4,4)
@test_throws IF.UnimplementedInterface{Real} i6(4,4;kw1=1,kw2=1)
@test_throws IF.UnimplementedInterface{Real} i6(4,:A)

@interface i7(a::Real, args...; kwargs...)
@test length(methods(i7)) == 1
@test_throws ["UnimplementedInterface{Real}:", "`i7(a::Real, args...; kwargs...)`"] i7(5.0)
@test_throws IF.UnimplementedInterface{Real} i7(5,3,2,1;kw1=1,kw2=1)

@interface i8(::Real)
@test length(methods(i8)) == 1
@test_throws ["UnimplementedInterface{Real}:", "`i8(r::Real)`"] i8(5.0)

@test_broken @expand @interface function i8(a::Real, b::Float64) end

struct I9{T} end 
@interface I9{Float64}(a::Real)
@test length(methods(I9{Float64}, [Real])) == 1
@test_throws ["UnimplementedInterface{Real}:", "`I9{Float64}(a::Real)`"] I9{Float64}(5.0)

struct I10{T} end 
@interface I10{Float64}(a::Real; kwargs...)
@test length(methods(I10{Float64}, [Real])) == 1
@test_throws ["UnimplementedInterface{Real}:", "`I10{Float64}(a::Real; kwargs...)`"] I10{Float64}(5.0)

@test_throws ["ArgumentError:", "abstract"] @expand @interface i(a::Float64) # Concrete type
@test_throws ["ArgumentError:", "known type"] @expand @interface i(a) # Missing type
@test_throws ["ArgumentError:", "atleast one argument"] @expand @interface i() # No arguments
@test_throws ["ArgumentError:", "atleast one argument"] @expand @interface A{Float64}()

# TODO: Test: Documentation for interfaces <23-06-25> 
