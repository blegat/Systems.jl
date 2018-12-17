import MathematicalSystems.IdentityMultiple
using LazySets

@testset "Creation of an identity multiple" begin
    for n in [1, 2, 1000]
        In = IdentityMultiple(1.0*I, n)
        @test size(In) == n
        @test In[1, 1] == 1.0 && In[1, 2] == 0.0
    end
end

@testset "Operations between identity multiples" begin
    I2 = IdentityMultiple(1.0*I, 2)
    I10 = IdentityMultiple(1.0*I, 10)

    @test (I2 + I2).M == UniformScaling(2.0)
    @test (10.0 * I2).M == UniformScaling(10.0)
    @test (I2 * I2).M == I2.M

    @test_throws AssertionError I2 + I10
    @test_throws AssertionError I2 * I10
end

@testset "Create a continuous system with one matrix being a multiple of the identity" begin
    # See #40
    A, B = rand(4, 4), rand(4, 2)
    X = rand(Hyperrectangle, dim=4)
    U = rand(Ball2, dim=2)
    I4 = IdentityMultiple(1.0*I, 4)
    s = ConstrainedLinearControlContinuousSystem(A, I4, X, B*U);

    @test statedim(s) == 4
    @test stateset(s) == X
end