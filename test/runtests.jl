using InterfaceFunctions
using Test
using Aqua

@testset "InterfaceFunctions.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(InterfaceFunctions)
    end
    # Write your tests here.
end
