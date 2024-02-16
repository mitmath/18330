### A Pluto.jl notebook ###
# v0.14.5

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

# ╔═╡ eacad457-5dce-4f2c-b678-cf875e6d5cfd
begin
	using Plots
	using PlutoUI
end

# ╔═╡ 050d4bd1-8625-4cdf-afb0-b1d1b22f4828
using LinearAlgebra

# ╔═╡ d67e8fe7-a773-4f0d-a224-ba01549eb556
md"""
# Spectral methods for boundary-value problems
"""

# ╔═╡ 99ed9049-76d0-4b37-a5af-7ecc6c8f012f
md"""
In this notebook we will see how to solve some boundary-value problems for differential equations using spectral methods. This is based on Trefethen, *Spectral Methods in MATLAB*, Chaps. 6 and 7.
"""

# ╔═╡ a72002be-27b2-4005-965e-8e3c3328eff9
md"""
## Chebyshev differentiation matrix

"""

# ╔═╡ 3172ec04-c724-49b6-a514-d5368c0e4f27
md"""
- Given a function $f$, sample it at Chebyshev points $x_j := \cos \left( \frac{\pi j}{N} \right)$ for $j = 0, \ldots, N$ to get $f_j$.

- Let $p(x)$ be the unique interpolating polynomial of degree $N$ through the points $(x_j, f_j)$.

- Calculate $u_j := p'(x_j)$.

- The map from $\mathbf{f} := (f_j)$ to $\mathbf{u} := (u_j)$ is linear, so is given by a matrix $\mathsf{D}$ with $\mathbf{u} = \mathsf{D} \mathbf{f}$. 

- Trefethen gives expressions for the matrix elements of $\mathsf{D}$ and an exercise to derive the expressions (chap. 6).
"""

# ╔═╡ 5b00a15f-8e1a-42ff-9a0b-c6146ed34c9e
md"""
Recall that Lagrange interpolation gives us

$p(x) = \sum_k f_k \, \ell_k(x)$

in terms of the Lagrange cardinal functions $\ell_k$.

"""

# ╔═╡ 9fef1218-888c-4871-b294-6c768f606d7a
md"""

Hence

$p'(x) = \sum_k f_k \, \ell'_k(x)$
"""

# ╔═╡ 58b2c2a3-5a34-48a4-9bf0-dcc3cb3e845d
md"""

So

$p'(x_j) = \sum_k f_k \, \ell'_k(x_j).$

Defining $u_j := p'(x_j)$ and $D_{jk} := \ell_k'(x_j)$ we get

$$u_j = \sum_k D_{jk} f_k$$

or

$$\mathbf{u} = \mathsf{D} \, \mathbf{f}$$

"""

# ╔═╡ 532eedf3-74b0-4a13-aef3-5997f2975f15
md"""
In general there is no reason for $\ell_k'(x_j)$ to be zero, so $M_{jk}$ will be a dense matrix.
"""

# ╔═╡ ee9cfe79-ee66-416c-a750-3f6dd85c0da9
chebyshev_points(N) = [cos(π * j / N) for j in 0:N]   # N+1 points

# ╔═╡ 88c34fe9-63c0-40d0-80d4-28e83eae1332
function chebyshev_differentiation_matrix(N)
    x = chebyshev_points(N)
    c = [2; ones(N-1); 2]

    D = zeros(N+1, N+1)   # we really want indices 0:N -- could use an OffsetArray

    D[1, 1] = (2N^2 + 1) / 6
    D[N+1, N+1] = -D[1, 1]

    for j in 2:N
        D[j, j] = -x[j] / (2*(1 - x[j]^2))
    end

    for i in 1:N+1, j in 1:N+1  # double for loop
        j == i && continue      # syntax for a 1-line "if-then" -- skip i=j

        D[i, j] = (c[i] / c[j]) * (-1)^(i+j) / (x[i] - x[j])
    end

    return D, x
end

# ╔═╡ 101abca4-bf41-4cb2-875c-eabe5ed86d40
md"""
N = $(N_slider = @bind N Slider(1:50, show_value=true, default=1))
"""

# ╔═╡ 61cd0e6f-021c-485d-b320-dfa045b958b0
D1, x1 = chebyshev_differentiation_matrix(N);

# ╔═╡ f7acd5c3-369d-43b3-9062-343baaf9e780
round.(D1, digits=3)

# ╔═╡ 34259cad-55c2-448f-b522-c5ea8b61a86a
md"""
## Barycentric Lagrange interpolation
"""

# ╔═╡ b7eaddde-b60e-491d-8ec1-2f7bbb798b4d
"Weights for Chebyshev barycentric Lagrange interpolation"
w_cheb(j, n) = (-1)^j * ((j==0 || j == n) ? 0.5 : 1.0)

# ╔═╡ 308e3d87-b329-4e23-9c1e-463fbd55b0d8
"Evaluate f(x) given samples `fs` at points `ts`. Defaults to Chebyshev weights"
function barycentric_lagrange(x, fs, xs, w=w_cheb)
    n = length(xs) - 1

    numerator = 0.0
    denominator = 0.0

    for j in 0:n

        x == xs[j+1] && return fs[j+1]   # exactly at node
        
        weight = w(j, n) / (x - xs[j+1])

        numerator += (weight * fs[j+1])
        denominator += weight
    end

    return numerator / denominator
end

# ╔═╡ 0ebeb4c5-d5ff-4b1c-8ea3-08a864acaa1d
md"""
## Example: Differentiating an analytic function
"""

# ╔═╡ c740673e-eecc-4a6d-881c-9c1dd38424e1
md"""
Let's differentiate the following function:
"""

# ╔═╡ 6507cd03-81c3-4123-940e-7171dc45940c
begin
	# 
	g(x) = exp(x) * sin(5x)
	g_prime(x) = exp(x) * 5cos(5x) + exp(x) * sin(5x)
end

# ╔═╡ e9c96d66-1804-4340-a90c-685137d713fa
begin
	D, xs = chebyshev_differentiation_matrix(N)

	plot(-1:0.01:1, g, leg=false)
	
	fs = g.(xs)
	
	scatter!(xs, fs)
	scatter!(xs, fill(0, length(xs)))
	
	for i in 1:length(xs)
		plot!([xs[i], xs[i]], [0, fs[i]], ls=:dash, c=:black, alpha=0.5)
	end
	
	hline!([0], ls=:dash)
	
	plot!()
end

# ╔═╡ 96fd4e11-417e-44db-b7d2-72f96b92966a
# begin
	
# 		fs = f.(xs)
	
# 		us = D * fs;   # using Chebyshev differentiation matrix
		
# 		scatter(xs, us)
	
# end

# ╔═╡ 4bc33d9d-949e-405f-a353-7b4e650f1343
us = D * fs

# ╔═╡ 71df42ba-2bf4-4f0f-bd0a-93fb42e47d49
plot(xs, D * fs, m=:o)

# ╔═╡ fb927f99-0475-4afa-995f-dec487e664e9
md"""
These points interpolate the derivative *function* $f'$. We can reconstruct an interpolant of $f'$ using barycentric Lagrange interpolation. We want to sample the function at many points in the interval and compare it to the exact result:
"""

# ╔═╡ cd05711c-fd02-4f3a-a4c5-186ebda266a1
g_prime_approx(x) = barycentric_lagrange(x, us, xs)

# ╔═╡ d71f96b9-75c9-4982-9637-3ddcf1991a85
N_slider

# ╔═╡ d3854dce-16a2-4a62-8c07-ffc319cefb90
begin
	r = -1:0.001:1
	
	scatter(xs, us)
	plot!(g_prime_approx)
	plot!(g_prime)
end

# ╔═╡ dd747bf4-2bb5-4495-9e34-e900bdc5f857
md"""
Since in this particular case we know the analytical result $g'$, we can calculate how far away the approximation is:
"""

# ╔═╡ 965f13a2-c171-4af5-922f-7ab2d3004f47
plot(x -> g_prime(x) - g_prime_approx(x), -1, 1, label=false)

# ╔═╡ 0f356ca9-ad51-4fb1-a26b-b6387da0d3fd
L∞_norm(f1, f2) = maximum(abs(f1(x) - f2(x)) for x in -1:0.0001:1)

# ╔═╡ e4f77f46-13ea-4fb2-9aa1-6e4d9d3bdd06
L∞_norm(g_prime, x -> barycentric_lagrange(x, us, xs))

# ╔═╡ 01c8a856-a344-4465-9dc0-d0389fa3464c
md"""
Let's redo the calculation as a function of the number of points $N$:
"""

# ╔═╡ 55fe7b0e-2a15-4c11-88ba-544e033b11f3
begin
	norms = Float64[]
	Ns = 1:100
	
	for N in Ns
	
	    DD, xx = chebyshev_differentiation_matrix(N)
	    
	    fff = g.(xx)
	    uu = DD * fff;   # using Chebyshev differentiation matrix
	    
	    push!(norms, L∞_norm(g_prime, x -> barycentric_lagrange(x, uu, xx)))
	    
	end
end

# ╔═╡ cb2702ac-aa94-4138-9f4b-ef45558a2e6e
plot(Ns, norms, m=:o, yscale=:log10)

# ╔═╡ 7328502b-2b8b-4f29-806e-93248d73ca02
md"""
We again see spectral convergence.
"""

# ╔═╡ 268c028f-26a3-4f88-a9b0-28a9bf460d90
md"""
## Boundary-value problem
"""

# ╔═╡ fdcb4b33-cde5-47f6-bed5-809e51655cbd
md"""
We would like to solve the boundary-value problem

$$u_{xx} = f(x)$$

on $-1 \le x \le 1$, with Dirichlet boundary conditions

$$u(-1) = u(+1) = 0.$$

When $f(x) = e^{4x}$ this has the known exact solution $u(x) = \frac{1}{16} \left[e^{4x} - x \sinh(4) - \cosh(4) \right]$.
"""

# ╔═╡ 188aced1-bf5a-410e-a61f-177f74c4da99
md"""
We could discretize space using finite differences. Instead let's apply a Chebyshev **collocation** method.
"""

# ╔═╡ 35cfb4fb-a16f-401b-82ab-f0b9fcefbb4c
md"""
Let's take a Chebyshev grid with $N+1$ points, and impose that the ODE is satisfied at the grid points, in other words that the residual is exactly 0 there:
"""

# ╔═╡ 2adc1048-83a2-4841-8c7a-cabf31019f56
md"""
$(u_{xx})(x_j) = f(x_j) \quad \forall j$
"""

# ╔═╡ 082493c3-3aa4-4b5d-88cf-afba6f627a15
md"""
We have 

$$(u_{xx})(x_j) = (D^2 \mathbf{u})_j$$
"""

# ╔═╡ 584c05a1-d7bc-49c3-86f9-1c6cf6e2aa4a
md"""
This holds for the internal (**bulk**) points $x_j$. At the boundaries we instead impose the Dirichlet conditions by **boundary bordering**, i.e. using rows of the matrix to impose the boundary conditions on $u$.
"""

# ╔═╡ a28bc126-0c82-45a7-bfe1-9d6ed53775e9
md"""
Defining a matrix $M$ which is equal to $D^2$ except for the first and last row, we have

$\mathsf{M} \, \mathbf{u} = \mathbf{f}$

so that

$\mathbf{u} = \mathsf{M} \backslash \mathbf{f}$.
"""

# ╔═╡ 3b210c6b-6ba2-485e-9c93-10b22386e77c
begin
	
	M = copy(D^2)

	# bulk:
			
	ff(x) = exp(4x)  # right-hand side
	ffs = ff.(xs)

	## boundary conditions:

	M[1, :] .= 0
	M[1, 1] = 1
	
	M[N+1, :] .= 0
	M[N+1, N+1] = 1

	ffs[1] = 0
	ffs[N+1] = 0
	
	
	solution = M \ ffs
end

# ╔═╡ 4555f896-fb49-4a45-b5b6-abe27d02eda9
N_slider

# ╔═╡ 04837a7d-1b7b-4642-af70-4a23f95b98d0
begin
	plot(xs, solution, m=:o, label="Chebyshev", ratio=1)
	plot!(-1:0.01:1, x->(exp(4x) - x*sinh(4) - cosh(4))/16, label="exact")
	
end

# ╔═╡ 15fe821c-a472-4fff-a2fa-ef762d9cc8d5
md"""
We can calculate the residual at the nodes:
"""

# ╔═╡ 65c4da37-a89a-4c14-ba93-f5e63db5e790
M * solution - exp.(4 .* xs)

# ╔═╡ f96c8082-0429-47a9-bf9b-0d250d575d8a
md"""
## Nonlinear boundary-value problem
"""

# ╔═╡ 4b4e455d-8fed-4ef5-a70d-07d806358182
md"""
Let's try to solve the *nonlinear* boundary-value problem
    
$$u_{xx} = \exp(u)$$
    
with $u(-1) = u(+1) = 0$.

Note that the right-hand side *depends on the unknown function $u$*!

How can we solve this?
"""

# ╔═╡ 599c8d1a-0008-4baa-99ad-f4cc622b6be5
md"""
We have experience solving nonlinear problems. One solution that often works is **fixed-point iteration**:
"""

# ╔═╡ 60235868-f6b1-4c36-9a40-7bcac63a6d0a
md"""
Try $u^{(n+1)}_{xx} = \exp(u^{(n)})$
"""

# ╔═╡ 6a3f109c-89fe-4018-8ab4-1f2753ecbaac
begin
	us2 = zeros(N+1)
	
	M2 = copy(D^2)

	
	# boundaries:
	M2[1, :] .= 0
	M2[1, 1] = 1
		
	M2[N+1, :] .= 0
	M2[N+1, N+1] = 1

	for i in 1:30
		rhs = exp.(us2)  # right-hand side (bulk)
		rhs[1] = 0       # right-hand side (boundary)
		rhs[N+1] = 0

	    us2 .= M2 \ rhs
	end
end

# ╔═╡ 7a4bbe87-1d92-4034-a185-986bdb5719d6
us2

# ╔═╡ 58de9675-6baa-4dcd-96b7-c3c863ecfa7d
plot(xs, us2, m=:o)

# ╔═╡ 612c0228-1de5-47ec-810e-031d2e5dbf55
md"""
Residual:
"""

# ╔═╡ 94ce1751-4703-4160-9860-a81a1b3505d3
M2 * us2 - exp.(us2)

# ╔═╡ 1eb524bc-4b09-4c46-a461-6a814e74aa2a
md"""
## Eigenvalue problem
"""

# ╔═╡ 55a36555-c6ef-4c2e-8df4-8be6ab78d5a9
md"""
We would like to solve

$$u_{xx} = \lambda u$$

with boundary conditions $u(-1) = u(+1) = 0$.

This is an eigenvalue problem *for the differential operator $\partial_{xx}$*!
"""

# ╔═╡ 9ae0a2c1-2409-444e-8c66-e2e1283f96a2
begin
	M3 = copy(D^2)

	# boundaries:
	M3[1, :] .= 0
	M3[1, 1] = 1
		
	M3[N+1, :] .= 0
	M3[N+1, N+1] = 1

end

# ╔═╡ f4ff3964-fbf9-4c84-bc60-4f7b3b6ed60b
md"""
With the above `M3` the first row imposes the condition $u_1 = \lambda u_1$, and hence $u_1 = 0$ (provided $\lambda \neq 0$).
"""

# ╔═╡ f71574a9-da15-4c93-9d9c-7774fbfc9f73
N_slider

# ╔═╡ e5669aaa-ef41-4c0c-a598-acb4335b9401
λ, v = eigen(M);

# ╔═╡ 36326a2a-647f-4d92-8a77-e429028bf0e4
md"""
Let's visualise the eigenvectors:
"""

# ╔═╡ 47e7870a-16d9-468e-9dc9-29fabbefd07e
md"""
n = $(@bind which Slider(1:size(v, 1), show_value=true, default=1))
"""

# ╔═╡ d44aeb26-c1e4-4d6e-9114-19e417f24829
begin
	scatter(xs, v[:,end-which], m=:o)
	
	plot!(x -> barycentric_lagrange(x, v[:, end-which], xs), -1, 1)
	
end

# ╔═╡ 229b9e16-886e-443e-aebb-333840fa6068
λ

# ╔═╡ a037b02b-2c23-4519-ab14-99baca6d7e9a
rescaled = λ .* (4 / pi^2)  # from analytical calculation

# ╔═╡ Cell order:
# ╠═eacad457-5dce-4f2c-b678-cf875e6d5cfd
# ╟─d67e8fe7-a773-4f0d-a224-ba01549eb556
# ╟─99ed9049-76d0-4b37-a5af-7ecc6c8f012f
# ╟─a72002be-27b2-4005-965e-8e3c3328eff9
# ╟─3172ec04-c724-49b6-a514-d5368c0e4f27
# ╟─5b00a15f-8e1a-42ff-9a0b-c6146ed34c9e
# ╟─9fef1218-888c-4871-b294-6c768f606d7a
# ╟─58b2c2a3-5a34-48a4-9bf0-dcc3cb3e845d
# ╟─532eedf3-74b0-4a13-aef3-5997f2975f15
# ╠═ee9cfe79-ee66-416c-a750-3f6dd85c0da9
# ╠═88c34fe9-63c0-40d0-80d4-28e83eae1332
# ╟─101abca4-bf41-4cb2-875c-eabe5ed86d40
# ╠═61cd0e6f-021c-485d-b320-dfa045b958b0
# ╠═f7acd5c3-369d-43b3-9062-343baaf9e780
# ╟─34259cad-55c2-448f-b522-c5ea8b61a86a
# ╠═b7eaddde-b60e-491d-8ec1-2f7bbb798b4d
# ╠═308e3d87-b329-4e23-9c1e-463fbd55b0d8
# ╟─0ebeb4c5-d5ff-4b1c-8ea3-08a864acaa1d
# ╟─c740673e-eecc-4a6d-881c-9c1dd38424e1
# ╠═6507cd03-81c3-4123-940e-7171dc45940c
# ╠═e9c96d66-1804-4340-a90c-685137d713fa
# ╠═96fd4e11-417e-44db-b7d2-72f96b92966a
# ╠═4bc33d9d-949e-405f-a353-7b4e650f1343
# ╠═71df42ba-2bf4-4f0f-bd0a-93fb42e47d49
# ╟─fb927f99-0475-4afa-995f-dec487e664e9
# ╠═cd05711c-fd02-4f3a-a4c5-186ebda266a1
# ╠═d71f96b9-75c9-4982-9637-3ddcf1991a85
# ╠═d3854dce-16a2-4a62-8c07-ffc319cefb90
# ╟─dd747bf4-2bb5-4495-9e34-e900bdc5f857
# ╠═965f13a2-c171-4af5-922f-7ab2d3004f47
# ╠═0f356ca9-ad51-4fb1-a26b-b6387da0d3fd
# ╠═e4f77f46-13ea-4fb2-9aa1-6e4d9d3bdd06
# ╟─01c8a856-a344-4465-9dc0-d0389fa3464c
# ╠═55fe7b0e-2a15-4c11-88ba-544e033b11f3
# ╠═cb2702ac-aa94-4138-9f4b-ef45558a2e6e
# ╟─7328502b-2b8b-4f29-806e-93248d73ca02
# ╟─268c028f-26a3-4f88-a9b0-28a9bf460d90
# ╟─fdcb4b33-cde5-47f6-bed5-809e51655cbd
# ╟─188aced1-bf5a-410e-a61f-177f74c4da99
# ╟─35cfb4fb-a16f-401b-82ab-f0b9fcefbb4c
# ╟─2adc1048-83a2-4841-8c7a-cabf31019f56
# ╟─082493c3-3aa4-4b5d-88cf-afba6f627a15
# ╟─584c05a1-d7bc-49c3-86f9-1c6cf6e2aa4a
# ╟─a28bc126-0c82-45a7-bfe1-9d6ed53775e9
# ╠═3b210c6b-6ba2-485e-9c93-10b22386e77c
# ╠═4555f896-fb49-4a45-b5b6-abe27d02eda9
# ╠═04837a7d-1b7b-4642-af70-4a23f95b98d0
# ╟─15fe821c-a472-4fff-a2fa-ef762d9cc8d5
# ╠═65c4da37-a89a-4c14-ba93-f5e63db5e790
# ╟─f96c8082-0429-47a9-bf9b-0d250d575d8a
# ╟─4b4e455d-8fed-4ef5-a70d-07d806358182
# ╟─599c8d1a-0008-4baa-99ad-f4cc622b6be5
# ╟─60235868-f6b1-4c36-9a40-7bcac63a6d0a
# ╠═6a3f109c-89fe-4018-8ab4-1f2753ecbaac
# ╠═7a4bbe87-1d92-4034-a185-986bdb5719d6
# ╠═58de9675-6baa-4dcd-96b7-c3c863ecfa7d
# ╟─612c0228-1de5-47ec-810e-031d2e5dbf55
# ╠═94ce1751-4703-4160-9860-a81a1b3505d3
# ╟─1eb524bc-4b09-4c46-a461-6a814e74aa2a
# ╟─55a36555-c6ef-4c2e-8df4-8be6ab78d5a9
# ╠═050d4bd1-8625-4cdf-afb0-b1d1b22f4828
# ╠═9ae0a2c1-2409-444e-8c66-e2e1283f96a2
# ╟─f4ff3964-fbf9-4c84-bc60-4f7b3b6ed60b
# ╠═f71574a9-da15-4c93-9d9c-7774fbfc9f73
# ╠═e5669aaa-ef41-4c0c-a598-acb4335b9401
# ╟─36326a2a-647f-4d92-8a77-e429028bf0e4
# ╟─47e7870a-16d9-468e-9dc9-29fabbefd07e
# ╠═d44aeb26-c1e4-4d6e-9114-19e417f24829
# ╠═229b9e16-886e-443e-aebb-333840fa6068
# ╠═a037b02b-2c23-4519-ab14-99baca6d7e9a
