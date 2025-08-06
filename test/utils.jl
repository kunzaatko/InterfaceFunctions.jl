using InterfaceFunctions: InterfaceFunctions as IF

@test IF.param_names(:(A)) == [:A]
@test IF.param_names(:(AbstractArray{A})) == [:AbstractArray, :A]
@test IF.param_names(:(AbstractArray{A,N})) == [:AbstractArray, :A, :N]
@test IF.param_names(:(AbstractArray{AbstractArray{A}})) == [:AbstractArray, :AbstractArray, :A]
@test IF.param_names(:(AbstractArray{AbstractArray{A},N})) == [:AbstractArray, :AbstractArray, :A, :N]

@test IF.where_param_names((:(T <: AbstractArray{A, N}), :(A <: AbstractArray{B}), :(B <: Real))) == Dict(:T => Any[:AbstractArray, :A, :N], :A => Any[:AbstractArray, :B], :B => Any[:Real])
@test IF.where_param_names((:(T),)) == Dict(:T => [])
