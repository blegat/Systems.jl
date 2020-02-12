__precompile__(true)
module MathematicalSystems

using LinearAlgebra, SparseArrays
using LinearAlgebra: checksquare

#=======================
Identity operator
=======================#
include("identity.jl")

export IdentityMultiple, I

#=========================
Abstract Types for Systems
==========================#
include("abstract.jl")

#=======================
Utility functions
=======================#
include("utilities.jl")

# types
export AbstractSystem,
       AbstractDiscreteSystem,
       AbstractContinuousSystem

# methods
export statedim,
       inputdim,
       noisedim,
       stateset,
       inputset,
       noiseset,
       state_matrix,
       input_matrix,
       noise_matrix,
       affine_term

# traits
export islinear,
       isaffine,
       ispolynomial,
       isnoisy,
       iscontrolled,
       isconstrained

#====================================
Concrete Types for Continuous Systems
====================================#
include("systems.jl")

export ContinuousIdentitySystem,
       ConstrainedContinuousIdentitySystem,
       LinearContinuousSystem,
       AffineContinuousSystem,
       LinearControlContinuousSystem,
       ConstrainedLinearContinuousSystem,
       ConstrainedAffineContinuousSystem,
       ConstrainedAffineControlContinuousSystem,
       ConstrainedLinearControlContinuousSystem,
       LinearAlgebraicContinuousSystem,
       ConstrainedLinearAlgebraicContinuousSystem,
       PolynomialContinuousSystem,
       ConstrainedPolynomialContinuousSystem,
       BlackBoxContinuousSystem,
       ConstrainedBlackBoxContinuousSystem,
       ConstrainedBlackBoxControlContinuousSystem,
       NoisyConstrainedLinearContinuousSystem,
       NoisyConstrainedLinearControlContinuousSystem,
       NoisyConstrainedAffineControlContinuousSystem,
       NoisyConstrainedBlackBoxControlContinuousSystem

#==================================
Concrete Types for Discrete Systems
===================================#
export DiscreteIdentitySystem,
       ConstrainedDiscreteIdentitySystem,
       LinearDiscreteSystem,
       AffineDiscreteSystem,
       LinearControlDiscreteSystem,
       ConstrainedLinearDiscreteSystem,
       ConstrainedAffineDiscreteSystem,
       ConstrainedLinearControlDiscreteSystem,
       ConstrainedAffineControlDiscreteSystem,
       LinearAlgebraicDiscreteSystem,
       ConstrainedLinearAlgebraicDiscreteSystem,
       PolynomialDiscreteSystem,
       ConstrainedPolynomialDiscreteSystem,
       BlackBoxDiscreteSystem,
       ConstrainedBlackBoxDiscreteSystem,
       ConstrainedBlackBoxControlDiscreteSystem,
       NoisyConstrainedLinearDiscreteSystem,
       NoisyConstrainedLinearControlDiscreteSystem,
       NoisyConstrainedAffineControlDiscreteSystem,
       NoisyConstrainedBlackBoxControlDiscreteSystem

#==========================================
Concrete Types for an Initial Value Problem
===========================================#
include("ivp.jl")

export InitialValueProblem, IVP,
       initial_state

#=====================
Input related methods
=====================#
include("inputs.jl")

export AbstractInput,
       ConstantInput,
       VaryingInput,
       nextinput

#==================================
Maps
===================================#
include("maps.jl")

# types
export AbstractMap,
       IdentityMap,
       ConstrainedIdentityMap,
       LinearMap,
       ConstrainedLinearMap,
       AffineMap,
       ConstrainedAffineMap,
       LinearControlMap,
       ConstrainedLinearControlMap,
       AffineControlMap,
       ConstrainedAffineControlMap,
       ResetMap,
       ConstrainedResetMap

# methods
export outputmap,
       outputdim,
       apply

#=========================
Systems with outputs
==========================#
include("outputs.jl")

export SystemWithOutput,
       LinearTimeInvariantSystem,
       LTISystem

#=========================
Macros
==========================#
include("macros.jl")

export @map

#===================================
Successor state for discrete systems
====================================#
include("successor.jl")

export successor

#===================================
Discretization for affine systems
====================================#
include("discretize.jl")

export discretize

end # module
