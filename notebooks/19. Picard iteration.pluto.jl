### A Pluto.jl notebook ###
# v0.14.4

using Markdown
using InteractiveUtils

# ╔═╡ 06d9647c-73bf-40f9-8dbe-e5d140da70ae
using Polynomials, PlutoUI

# ╔═╡ e3aa530d-7c23-4cd9-b886-ca8104e0488c
md"""
# Picard iteration for series solutions of ODEs
"""

# ╔═╡ 1a7274e6-0c91-496e-af14-59466d54d9ad
md"""
The solution of $\dot{x} = f(x)$ with initial condition $x_0$ is

$$x(t) = x_0 + \int_{s=0}^t f(x(s)) \, ds$$
"""

# ╔═╡ 77dda9c3-40e1-4332-99f4-c440f75f18fe
md"""
Let's set up an iterative method to solve this; this is called **Picard iteration**.
For convenience we use the `Polynomials.jl` package, which allows us to easily manipulate polynomials, although it would be easy enough for us to write our own routines to do this by manipulating vectors of coefficients (and possibly by defining our own type).
"""

# ╔═╡ e3932954-648d-473e-af1a-dd315d861ed4
x0 = 1//1  # rational

# ╔═╡ 18f95597-f688-4de1-894a-949ba189816e
f(x) = x^2

# ╔═╡ e7d3869d-c186-4d30-9ab1-f8bb4165b1c8
md"""
We start with a polynomial version of the initial condition. We pass the coefficients of the polynomial as a vector to the constructor of the `Polynomial` type defined in the package:
"""

# ╔═╡ b3b53fcd-9504-4b96-a3ad-0b34b04ca31f
p0 = Polynomial([x0], "t")

# ╔═╡ c5d2f032-3ab9-4c43-afa0-b917e7bc4ce2
md"""
We integrate it using the function `Polynomials.integrate`.
"""

# ╔═╡ b68d75f0-d8ae-40d4-9122-21ae6e443f9f
p1 = x0 + Polynomials.integrate(f(p0))

# ╔═╡ 0a1b326c-3795-4109-b864-456f0ed3499d
typeof(p1)

# ╔═╡ f272b18e-0f93-4237-ad7c-6c4499fe4816
md"""
 Let's add a nice symbol for that function:
"""

# ╔═╡ 092cd7a9-1a55-4c9f-ae77-7545f5da6461
const ∫ = Polynomials.integrate

# ╔═╡ 6d994d74-dc91-40a6-b061-30c7939ca21a
md"""
Now we iterate the process and store the successive polynomials. At the $i$th stage we only want the coefficients up to the $i$th power; they are the ones that are correct, and if we don't do this it can lead to overflow issues:
"""

# ╔═╡ 982c08ba-362f-4fac-a0c5-e332edd54b91
begin
	x = Polynomial([x0], "t")  # initialise
	xs = [x]   # vector to store the results
	
	for i in 1:10
		p = x0 + ∫(f(x))
		
		# truncate to order i:
		x = Polynomial(p.coeffs[1:i+1], p.var)  # update x
		
		push!(xs, x)
	end
end

# ╔═╡ 0e513c26-3578-49ad-81e0-52115d21a1cd
Vector{Any}(xs)  # the conversion is just to hide the type in the output

# ╔═╡ 72d68fdc-97ed-4c0c-94f7-e7f46a4db038
md"""
Note that we are reproducing the *same* initial coefficients, and are only adding a *single* new coefficient at each step. So it should be possible to make an algorithm which takes this fact into account.

The difficulty is in calculating $f(x)$ where $x$ is a polynomial in $t$. We only want to calculate the $n$th coefficient of $f(x)$. It is possible to do this, but it requires tools from computer science: either lazy evaluation or parsing the syntax tree of the expression.
"""

# ╔═╡ 7b7bb53f-29c0-4b5c-aeb9-ef5afcdcfd00
md"""
#### Exercise

How would you deal with an ODE like $\dot{x} = \sin(x)$ ?
"""

# ╔═╡ Cell order:
# ╠═06d9647c-73bf-40f9-8dbe-e5d140da70ae
# ╟─e3aa530d-7c23-4cd9-b886-ca8104e0488c
# ╟─1a7274e6-0c91-496e-af14-59466d54d9ad
# ╟─77dda9c3-40e1-4332-99f4-c440f75f18fe
# ╠═e3932954-648d-473e-af1a-dd315d861ed4
# ╠═18f95597-f688-4de1-894a-949ba189816e
# ╟─e7d3869d-c186-4d30-9ab1-f8bb4165b1c8
# ╠═b3b53fcd-9504-4b96-a3ad-0b34b04ca31f
# ╟─c5d2f032-3ab9-4c43-afa0-b917e7bc4ce2
# ╠═b68d75f0-d8ae-40d4-9122-21ae6e443f9f
# ╠═0a1b326c-3795-4109-b864-456f0ed3499d
# ╟─f272b18e-0f93-4237-ad7c-6c4499fe4816
# ╠═092cd7a9-1a55-4c9f-ae77-7545f5da6461
# ╟─6d994d74-dc91-40a6-b061-30c7939ca21a
# ╠═982c08ba-362f-4fac-a0c5-e332edd54b91
# ╠═0e513c26-3578-49ad-81e0-52115d21a1cd
# ╟─72d68fdc-97ed-4c0c-94f7-e7f46a4db038
# ╟─7b7bb53f-29c0-4b5c-aeb9-ef5afcdcfd00
