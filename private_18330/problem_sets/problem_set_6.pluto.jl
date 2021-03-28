### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 56758636-7209-11eb-3f8f-f99a6aec934b
md"""
# Problem set 6

## 18.330 Spring 2021
"""

# ╔═╡ 8ad1bd54-791f-11eb-2127-6d180e178d93
md"""
## Your name: 

### Instructions

- Figures should be plotted using the `Plots.jl` package, and interactive visualizations with `@bind` from the PlutoUI package.

- You are encouraged to create intermediate functions if it makes your code more readable and/or re-usable.

- Anything in your algorithm that is not obvious from the code should be briefly commented. Use better variable names to reduce the need for comments. Remember that longer names may be filled in using tab-completion (i.e. pressing the `<TAB>` key after writing the start of the word).

- Use a single blank line to separate parts of your functions, e.g. initialization from the main loop.

- Submit on Canvas by **Friday, 2 April 2021** at **11:59pm EDT**. 
"""

# ╔═╡ 010dc7b0-8db8-11eb-3c33-b71df92ed87b


# ╔═╡ 89e057a2-8826-11eb-3402-1b21e3377c51
md"""

### Exercise 1: The Jacobi method

In this exercise we will implement the Jacobi method for solving a system of linear equations.

"""

# ╔═╡ 17066e2e-8dcd-11eb-262d-7fb241247a8b
md"""
1. Make a function `make_matrix` that takes a parameter $n$ and makes an $(n \times n)$ matrix with 2 in each diagonal element and -1 along the first super- and sub-diagonals (the ones adjacent to the diagonal elements).

   Tip: The `zeros` and / or `diagind` functions may be useful.
"""

# ╔═╡ 7ab43eb8-8dcd-11eb-1a8c-6dc71301d5c7


# ╔═╡ 75a24744-8dcd-11eb-1cc5-5d8ca4722032
md"""
2. Write a function `jacobi` that implements the Jacobi method to solve $Ax = b$. It accepts a matrix `A`, a vector `b`, and an optional tolerance `ϵ` with default value 1e-5.

    It should first check that `A` is a square matrix, and then check that `b` is size-compatible with `A`.
    
    Then it should run the algorithm until the residual is less than the tolerance in norm. 

    It should return the solution vector `x`, together with the norms of the residuals at each step in the algorithm.

    Use a vector of all $1$s as the starting point for the iteration. [This is just for convenience, rather than because it is actually a good idea.]
"""

# ╔═╡ 19d0c872-8dce-11eb-173a-ebce173ee2f5


# ╔═╡ 8dacd3c2-8dcd-11eb-0f0b-cd0f0ac52aa0
md"""
3. Create a $(10 \times 10)$ matrix using your function `make_matrix`. Run it with the right-hand side given by the numbers from `1 to 10`.  

   Compare to the result you get using Julia's built-in `\` operator.
"""

# ╔═╡ 6f8ebea4-8dce-11eb-2c21-a70cf9c4d270


# ╔═╡ 65e5ca50-8dce-11eb-29ef-bb96d29360e6
md"""
4. To investigate how fast the Jacobi algorithm converges, plot the residuals as a function of time (iteration number). 

   What type of convergence do you observe?
"""

# ╔═╡ 33598db8-8dd0-11eb-34ea-77a5ad188fb5


# ╔═╡ 3a898098-8dd0-11eb-0f06-711a5e8a5bcf
md"""
5. [Extra credit] Find a matrix for which the Jacobi method does not converge.
"""

# ╔═╡ 450eb858-8dd0-11eb-265e-774e2366679a


# ╔═╡ 560c424c-8dd0-11eb-22e0-f983b93b0a95
md"""

### Exercise 2: Implementing LU factorization

In this exercise we will implement LU factorization (without pivoting) to find the "numerically exact" solution to a linear system.

"""

# ╔═╡ 6c893b6e-8dd1-11eb-1480-b76660f70bf5
md"""
1. Suppose you are given an upper-triangular $m \times m$  matrix $\mathsf{U}$, i.e. a normal matrix for which all elements below the main diagonal are known to be $0$. We wish to solve $\mathsf{U} \mathbf{x} = \mathbf{b}$ for the vector $\mathbf{x}$.

   Find the analytical solution for the components $x_i$ of $\mathbf{x}$ in terms of the $U_{i, j}$ and $b_i$ using backward substitution. 

   Hint: Where should you start?
"""

# ╔═╡ 73c221a2-8dd1-11eb-15f5-bf7332d19794


# ╔═╡ 6c897c50-8dd1-11eb-0b56-7ff0807a7d3d
md"""
2. Write a function `backward_substitution(U, b)` that implements this.
"""

# ╔═╡ 7708714a-8dd1-11eb-1144-09a104ed242d


# ╔═╡ 6c89f48c-8dd1-11eb-0c02-615a0d7b7f5a
md"""
3. Given a lower-triangular matrix $\mathsf{L}$, write a function `forward_substitution(L, b)` to solve $\mathsf{L} \, \mathbf{x} = \mathbf{b}$.

   Hint: Can you use the work you already did in [1--2]?
"""

# ╔═╡ 80477594-8dd1-11eb-2fcb-0f1202dafded


# ╔═╡ 6c980b12-8dd1-11eb-03a5-f3203b16c281
md"""
4. Implement Gaussian elimination for an $m \times m$ square matrix $\mathsf{A}$ to calculate the LU factorization *without* pivoting. Your function `LU_factorization` should accept $\mathsf{A}$ and return $\mathsf{L}$ and $\mathsf{U}$.

   Hint: Recall that $\mathsf{L}$ stores the coefficients involved in the elimination process.

   The matrices $\mathsf{L}$ and $\mathsf{U}$ should be returned as full matrices with zeros stored in the other half.
"""

# ╔═╡ bdec12d8-8dd1-11eb-12ea-8d4ff2cbb37a


# ╔═╡ 6c9b9e58-8dd1-11eb-0fc3-937e26e4e5a1
md"""
5. Write a function `solve_linear_system(A, b)` that combines the functions you have written to solve the linear system $\mathsf{A} \, \mathbf{x} = \mathbf{b}$.
"""

# ╔═╡ e1580b1a-8ddf-11eb-0d6f-551fcff2ed9e


# ╔═╡ db3f2b00-8ddf-11eb-1fe2-bdcf0444dfe1
md"""

6. To test how good our solver is, generate random $(n \times n)$ matrices $A$ and random $n$-vectors $b$, where each entry is generated by `randn()` (which generates a random number with a standard gaussian distribution).

   Average the norm of the residual over 10000 runs (or however many your computer can easily manage) for each $n$, for values of $n$ between 2 and 50.

   Plot the results. You should see a general upward trend, (although possibly with lots of noise and peaks), indicating that in general solving bigger systems leads to larger errors.

   Note that Gaussian elimination would be exact if we were able to compute with exact arithmetic, so the residual must be due to round-off error.
"""

# ╔═╡ fbd69d8c-8de2-11eb-1958-cfb9eb3153fe


# ╔═╡ 2d804034-8831-11eb-113a-8fe5f9fa7f2a
md"""
### Exercise 3: Exploiting structure in matrices: Solving tri-diagonal linear systems

In this exercise we will see a first example of  how *structure* can affect calculations in linear algebra.

A **tridiagonal** matrix has zeros everywhere except for the main diagonal and the first super- and sub-diagonals. Such matrices occur often in scientific computing. A tridiagonal matrix is an example of a **structured matrix**, which in general is one for which we know the pattern of elements that are known to be zero.
"""

# ╔═╡ 9c5b27e4-8db8-11eb-318e-f35dbed71f25
md"""
1. Think about the Gaussian elimination process for a tri-diagonal matrix. What is its approximate operation count?
"""

# ╔═╡ 6cb5d4be-8de3-11eb-1d74-e94824dc56d6


# ╔═╡ 6dfad57c-8de3-11eb-0e7d-cb545e20c493
md"""
2. What is the operation count for backward substitution using the resulting upper-triangular matrix?
"""

# ╔═╡ 8f72824a-8de3-11eb-3474-416b7b664f69


# ╔═╡ 81849d80-8de3-11eb-3995-dd071952c98b
md"""
3. Hence, what is the operation count and computational complexity for solving $A x = b$ for a tri-diagonal matrix $A$?

   Compare this with solving $Ax = b$ for a general ("dense") matrix to see why knowing the structure of your matrix is so important!
"""

# ╔═╡ a62a2d50-8de3-11eb-1d90-6b4bce7aa3e4


# ╔═╡ aa8988da-8de3-11eb-302c-bd714f24530a
md"""
4. [Extra credit] Implement a solver for $Ax = b$ for tri-diagonal matrices that has this complexity.
"""

# ╔═╡ c21b0d20-8de3-11eb-0397-55cd0bfec077


# ╔═╡ Cell order:
# ╟─56758636-7209-11eb-3f8f-f99a6aec934b
# ╟─8ad1bd54-791f-11eb-2127-6d180e178d93
# ╠═010dc7b0-8db8-11eb-3c33-b71df92ed87b
# ╟─89e057a2-8826-11eb-3402-1b21e3377c51
# ╟─17066e2e-8dcd-11eb-262d-7fb241247a8b
# ╠═7ab43eb8-8dcd-11eb-1a8c-6dc71301d5c7
# ╟─75a24744-8dcd-11eb-1cc5-5d8ca4722032
# ╠═19d0c872-8dce-11eb-173a-ebce173ee2f5
# ╟─8dacd3c2-8dcd-11eb-0f0b-cd0f0ac52aa0
# ╠═6f8ebea4-8dce-11eb-2c21-a70cf9c4d270
# ╟─65e5ca50-8dce-11eb-29ef-bb96d29360e6
# ╠═33598db8-8dd0-11eb-34ea-77a5ad188fb5
# ╟─3a898098-8dd0-11eb-0f06-711a5e8a5bcf
# ╠═450eb858-8dd0-11eb-265e-774e2366679a
# ╟─560c424c-8dd0-11eb-22e0-f983b93b0a95
# ╟─6c893b6e-8dd1-11eb-1480-b76660f70bf5
# ╠═73c221a2-8dd1-11eb-15f5-bf7332d19794
# ╟─6c897c50-8dd1-11eb-0b56-7ff0807a7d3d
# ╠═7708714a-8dd1-11eb-1144-09a104ed242d
# ╟─6c89f48c-8dd1-11eb-0c02-615a0d7b7f5a
# ╠═80477594-8dd1-11eb-2fcb-0f1202dafded
# ╟─6c980b12-8dd1-11eb-03a5-f3203b16c281
# ╠═bdec12d8-8dd1-11eb-12ea-8d4ff2cbb37a
# ╟─6c9b9e58-8dd1-11eb-0fc3-937e26e4e5a1
# ╠═e1580b1a-8ddf-11eb-0d6f-551fcff2ed9e
# ╟─db3f2b00-8ddf-11eb-1fe2-bdcf0444dfe1
# ╠═fbd69d8c-8de2-11eb-1958-cfb9eb3153fe
# ╟─2d804034-8831-11eb-113a-8fe5f9fa7f2a
# ╟─9c5b27e4-8db8-11eb-318e-f35dbed71f25
# ╠═6cb5d4be-8de3-11eb-1d74-e94824dc56d6
# ╟─6dfad57c-8de3-11eb-0e7d-cb545e20c493
# ╠═8f72824a-8de3-11eb-3474-416b7b664f69
# ╟─81849d80-8de3-11eb-3995-dd071952c98b
# ╠═a62a2d50-8de3-11eb-1d90-6b4bce7aa3e4
# ╟─aa8988da-8de3-11eb-302c-bd714f24530a
# ╠═c21b0d20-8de3-11eb-0397-55cd0bfec077
