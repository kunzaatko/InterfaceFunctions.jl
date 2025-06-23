using InterfaceFunctions: InterfaceFunctions as IF
using MacroTools

@interface i1(a::Real, b::Float64)
@test length(methods(i1)) == 1
@test_throws IF.UnimplementedInterface{Real} i1(5.0, 6.0)
@test_throws MethodError i1(:A, 6.0)
@test_throws MethodError i1(5.0)
@test_throws MethodError i1(5.0, 5)

@interface i2(a::Real, b::Real)
@test length(methods(i2)) == 1
@test_throws IF.UnimplementedInterface{Real} i2(5.0, 5.0)
@test_throws IF.UnimplementedInterface{Real} i2(5.0, 5)

@interface i3(a::Real, b::T) where {T}
@test length(methods(i3)) == 1
@test_throws IF.UnimplementedInterface{Real} i3(5.0, 5)
@test_throws IF.UnimplementedInterface{Real} i3(5.0, :C)

@interface i4(a::Real, b::T) where {T<:Real}
@test length(methods(i4)) == 1
@test_throws IF.UnimplementedInterface{Real} i4(5.0, 5)
@test_throws MethodError i4(5.0, :C)

@interface i5(a::Real, b::Float64)::Float64
@test length(methods(i5)) == 1
@test_throws IF.UnimplementedInterface{Real} i5(5.0, 5.0)
@test_throws MethodError i5(5.0, 5)

@interface i6(a::Real, b; kwargs...)
@test length(methods(i6)) == 1
@test_throws IF.UnimplementedInterface{Real} i6(4,4)
@test_throws IF.UnimplementedInterface{Real} i6(4,4;kw1=1,kw2=1)
@test_throws IF.UnimplementedInterface{Real} i6(4,:A)

@interface i7(a::Real, args...; kwargs...)
@test length(methods(i7)) == 1
@test_throws IF.UnimplementedInterface{Real} i7(5.0)
@test_throws IF.UnimplementedInterface{Real} i7(5,3,2,1;kw1=1,kw2=1)

@interface i8(::Real)
@test length(methods(i8)) == 1
@test_throws IF.UnimplementedInterface{Real} i8(5.0) 

@test_broken @expand @interface function i8(a::Real, b::Float64) end

struct I9{T} end 
@interface I9{Float64}(a::Real)
@test length(methods(I9{Float64}, [Real])) == 1
@test_throws IF.UnimplementedInterface{Real} I9{Float64}(5.0)

struct I10{T} end 
@interface I10{Float64}(a::Real; kwargs...)
@test length(methods(I10{Float64}, [Real])) == 1
@test_throws IF.UnimplementedInterface{Real} I10{Float64}(5.0)

struct I11 end
@interface (a::I11)(b::Real)
@test length(methods(I11())) == 1
@test_throws IF.UnimplementedInterface{Real} (I11())(5.0)

struct I12 end
@interface (::I12)(a::Real)
@test length(methods(I12())) == 1
@test_throws IF.UnimplementedInterface{Real} (I12())(5.0)

struct I13{T} end
@interface (a::I13{T})(b::Real) where {T}
@test length(methods(I13{Any}())) == 1
@test_throws IF.UnimplementedInterface{Real} (I13{Any}())(5.0)

struct I14{T} end
@interface (a::I14{Float64})(b::Real)
@test length(methods(I14{Float64}())) == 1
@test_throws IF.UnimplementedInterface{Real} (I14{Float64}())(5.0)

@interface i15(a::Real, b::Float64)
@test_throws ["UnimplementedInterface{Real}:", "`i15(a::Real, b::Float64)`"] i15(4.0, 1.0)

@test_throws ["ArgumentError:", "abstract"] @expand @interface i(a::Float64) # Concrete type
@test_throws ["ArgumentError:", "known type"] @expand @interface i(a) # Missing type
@test_throws ["ArgumentError:", "atleast one argument"] @expand @interface i() # No arguments
@test_throws ["ArgumentError:", "atleast one argument"] @expand @interface A{Float64}()

# TODO: Test: Documentation for interfaces <23-06-25> 
