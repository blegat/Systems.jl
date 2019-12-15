using LinearAlgebra: inv, rank

import Base.==
import Base.≈

function ==(sys1::AbstractSystem, sys2::AbstractSystem)
    if typeof(sys1)!== typeof(sys2)
        return false
    end
    for field in fieldnames(typeof(sys1))
        if getfield(sys1, field) != getfield(sys2, field)
            return false
        end
    end
    return true
end

function ≈(sys1::AbstractSystem, sys2::AbstractSystem)
    if typeof(sys1)!== typeof(sys2)
        return false
    end
    for field in fieldnames(typeof(sys1))
        if !(getfield(sys1, field) ≈ getfield(sys2, field))
            return false
        end
    end
    return true
end

# get _corresponding_type with system as input
function _corresponding_type(abstract_type, sys::AbstractSystem)
    fields = fieldnames(typeof(sys))
    return _corresponding_type(abstract_type, fields)
end

# get _corresponding_type with type of system as input
function _corresponding_type(abstract_type, sys_type::typeof(AbstractSystem))
    fields = fieldnames(sys_type)
    return _corresponding_type(abstract_type, fields)
end

function _corresponding_type(abstract_type, fields::Tuple)
      @show abstract_type, fields
    TYPES = subtypes(abstract_type)
    TYPES_FIELDS = fieldnames.(TYPES)
    is_in(x, y) = all([el ∈ y for el in x])
    idx = findall(x -> is_in(x, fields) && is_in(fields,x), TYPES_FIELDS)
    if length(idx) == 0
        error("$(fields) does not match any system type of MathematicalSystems")
    end
    return TYPES[idx][1]
end

function discretize(sys::AbstractContinuousSystem, ΔT::Real; algo=:exact)
    noset(x) = !(x ∈ [:X,:U,:W])
    fields = collect(fieldnames(typeof(sys)))
    cont_nonset_values = [getfield(sys, f) for f in filter(noset, fields)]
    if algo == :exact && !(rank(sys.A) == size(sys.A,1))# check if A is invertible
        # if A is not invertible, use approximative disretization
        @info("Euler Approximation")
        algo = :euler
    end
    disc_nonset_values = discretize(cont_nonset_values...,ΔT; algo=algo)
    set_values = [getfield(sys, f) for f in filter(!noset, fields)]
    discrete_type = _corresponding_type(AbstractDiscreteSystem, sys)
    return discrete_type(disc_nonset_values..., set_values...)
end

function discretize(A::AbstractMatrix,
                    B::AbstractMatrix,
                    c::AbstractVector,
                    D::AbstractMatrix, ΔT::Real; algo=:exact)
    if algo == :exact
        A_d = exp(A*ΔT)
        B_d = inv(A)*(A_d - I)*B
        c_d = inv(A)*(A_d - I)*c
        D_d = inv(A)*(A_d - I)*D
    elseif algo == :euler
        A_d = (I + ΔT*A)
        B_d = ΔT*B
        c_d = ΔT*c
        D_d = ΔT*D
    end
    return [A_d, B_d, c_d, D_d]
end

function discretize(A::AbstractMatrix, ΔT::Real; algo=:exact)
    n = size(A,1)
    A_d, _, _, _ = discretize(A, zeros(n,n), zeros(n), zeros(n,n), ΔT; algo=algo)
    return [A_d]
end

# works for (:A,:D) and (:A, :B)
function discretize(A::AbstractMatrix,
                    B::AbstractMatrix, ΔT::Real; algo=:exact)
    n = size(A,1)
    A_d, B_d, c_d, D_d = discretize(A, B, zeros(n), zeros(n,n), ΔT; algo=algo)
    return [A_d, B_d]
end

function discretize(A::AbstractMatrix,
                    c::AbstractVector, ΔT::Real; algo=:exact)
    n = size(A,1)
    A_d, B_d, c_d, D_d = discretize(A, zeros(n,n), c, zeros(n,n), ΔT; algo=algo)
    return [A_d, c_d]
end

function discretize(A::AbstractMatrix,
                    B::AbstractMatrix,
                    c::AbstractVector, ΔT::Real; algo=:exact)
    n = size(A,1)
    A_d, B_d, c_d, D_d = discretize(A, B, c, zeros(n,n), ΔT; algo=algo)
    return [A_d, B_d, c_d]
end

function discretize(A::AbstractMatrix,
                    B::AbstractMatrix,
                    D::AbstractMatrix, ΔT::Real; algo=:exact)
    n = size(A,1)
    A_d, B_d, c_d, D_d = discretize(A, B, zeros(n), D, ΔT; algo=algo)
    return [A_d, B_d, D_d]
end