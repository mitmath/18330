### This file implements banded matrices for use in 18.330 problem set 7 (2020)

"""
Stores the bands in the matrix bands and information about the bands in p and q. This is a subttype of a matrix which means that it can be indexed etc. assuming we tell julia how to do that
"""
struct Banded{T} <: AbstractMatrix{T}
    bands::Matrix{T}
    p::Int
    q::Int
end

# We have to tell julia how to calculate the size of this new matrix type
# The size is equal to the length of the diagonal band which is equal to
# the number of rows in bands.
Base.size(B::Banded)  = (size(B.bands, 1), size(B.bands, 1))

# We have to tell julia how to index into the matrix e.g. B[1, 1] should return the
# first element in the diagonal band. See the problem set statement for more information
# on how this works
function Base.getindex(B::Banded{T}, i, j) where T
    p, q = B.p, B.q
    band = j - i         #what band we are in
    if - p ≤ band ≤ q    #check if this band exists in the matrix
        return B.bands[j, band + p + 1]
    else
        return zero(T)   #return the correctly typed 0
    end
end

# We have to tell julia how to set an index into the matrix e.g. B[1, 1] = 2 should change the
# first element in the diagonal band. The logic is similar to that of getindex
function Base.setindex!(B::Banded, x, i, j)
    p, q = B.p, B.q
    band = j - i
    if - p ≤ band ≤ q
        B.bands[j, band + p + 1] = x
    else
        return error("Cannot assign a value to a ($p, $q) banded matrix and index ($i, $j) which is in band $(band)")
    end
end

# Julia uses getindex to print the matrix in an AbstractMatrix show method so we do not have
# to define our own show method! We do want to make clear however, the structure we can so this
# by overloading Base.replace_in_print_matrix, which returns the string that is printed for each
# element in B::Banded, to return '*' for a structural 0.
function Base.replace_in_print_matrix(B::Banded, i::Integer, j::Integer, s::AbstractString)
    i - B.p ≤ j ≤ i + B.q ? s : Base.replace_with_centered_mark(s, c = '*')
    # replace_with_centered_mark replaces the string s with a string of
    # the same length containing only '*' centered in the middle of the string
end

# The initial row of the printed array is defined by the function summary
Base.summary(B::Banded{T}) where T = "$(size(B,1))×$(size(B,2)) Banded{$T}($(B.p), $(B.q))"
Base.summary(io::IO, B::Banded) = print(io, summary(B))

# How do we copy a banded matrix
Base.copy(B::Banded{T}) where T = Banded{T}(copy(B.bands), B.p, B.q)

# Define a function that returns the banded structure of the matrix
bands(B::Banded) = (B.p, B.q)
bands(B::Banded, i::Int) = bands(B)[i]

Base.fill!(B::Banded,  x) = (fill!(B.bands, 0); B)

# Allocates a m×m (p, q) Banded{T} matrix
Banded{T}(::UndefInitializer, m::Int, p::Int, q::Int) where T = Banded{T}(Matrix{T}(undef, m, p + q + 1), p, q)

# Generate a random banded matrix,
using Random
import Random.default_rng
rand_banded(r::AbstractRNG, T::Type, m::Int, p::Int, q::Int)  = Banded{T}(rand(r, T, m, p+q+1), p, q)
rand_banded(m::Int, p::Int, q::Int) = rand_banded(default_rng(), Float64, m, p, q)
rand_banded(T::Type, m::Int, p::Int, q::Int) = rand_banded(default_rng(), T, m, p, q)
### Linear Algebra for banded matrices. Below is an example of a function that
#   exploits the structure of a matrix to write a more efficient algorithm like you are
#   asked to do in the problem set
using LinearAlgebra

"""
Performs the calculation A*B for two banded matrices writing the solution to the banded matrix C.
The calculation is performed in place for performace similar to the julia function mul!(C, A, B).
"""
function mymul!(C::Banded, A::Banded, B::Banded)
    pa, qa = bands(A)
    pb, qb = bands(B)
    pc = pa + pb
    qc = qa + qb
    n = size(A, 1)
    # Check sized and banded structure
    @assert  n == size(B, 1)  == size(C, 1)
    @assert (pc, qc) == bands(C)

    # Zero out C
    fill!(C, 0)
    for j = 1:n
        for i = max(1, j - qc):min(n, j + pc) # We only need to loop over a limited number of rows
            for k = max(1, j-qb, i-pa):min(j+pb, i+qa, n) #Only calculate the nonzero terms
                C[i, j] +=  A[i, k]*B[k, j]
            end
        end
    end

    return C
end

# Below is an example of how this speeds things up
A = rand_banded(5000, 2, 1)  #Random matrix
B = rand_banded(5000, 1, 3)  #Random matrix
C = Banded{Float64}(undef, 5000, 3, 4) #Preallocate the C matrix

# Generate the dense arrays
dA = Array(A)
dB = Array(B)
dC = Array(C)

# Check the result using the built in function
mymul!(C, A, B) ≈ mul!(dC, dA, dB)

# Compare speeds
using BenchmarkTools
@belapsed mymul!($C, $A, $B)
@belapsed mul!($dC, $dA, $dB)
