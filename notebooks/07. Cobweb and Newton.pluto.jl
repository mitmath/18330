### A Pluto.jl notebook ###
# v0.12.20

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

# ╔═╡ f4fda666-7b9c-11eb-0304-716c5e710462
begin
	using ForwardDiff
	using Plots
	using PlutoUI
	using LaTeXStrings
end

# ╔═╡ bccbfb08-8227-11eb-1cb5-03298c666e7d
md"""
# Cobweb diagrams
"""

# ╔═╡ c09f0cf2-8227-11eb-3300-f7442bb3bcc9
md"""
Cobweb diagrams are a technique to visualise 1D iterations.
"""

# ╔═╡ d022c0f0-8228-11eb-07a5-233172c167b0
md"""
m = $(@bind m Slider(0:20, show_value=true))
"""

# ╔═╡ d82f1eae-7b9c-11eb-24d8-e1dcb2eef71a
md"""
# The Newton method for solving equations
"""

# ╔═╡ e410c1d0-7ba1-11eb-394f-71dac89756b7
md"""
In science and engineering we often need to *solve systems of equations*. 

If the equations are *linear* then linear algebra tells us a general method to solve them; these are now routinely applied to solve systems of millions of linear equations.

If the equations are *non*linear then things are less obvious. The main solution methods we know work by... reducing the nonlinear equations to a sequence of linear equations! They do this by *approximating* the function by a linear function and solving that to get a better solution, then repeating this operation as many times as necessary to get a *sequence* of increasingly better solutions. This is an example of an **iterative algorithm**.

A well-known and elegant method, which can be used in many different contexts, is the **Newton method**. It does, however, have the disadvantage that it requires derivatives of the function. This can be overcome using **automatic differentiation** techniques.

We will illustrate the method using the `ForwardDiff.jl` package.
"""

# ╔═╡ 5ea7344c-7ba2-11eb-2cc5-0bbdca218c82
md"""
## What is the Newton method?

The idea of the Newton method is to *follow the direction in which the function is pointing*! We do this by building a **tangent line** at the current position and following that instead, until it hits the $x$-axis.

Let's look at that visually first:

"""

# ╔═╡ 2445da24-7b9d-11eb-02bd-eb99a3d95a2e
md"""
n = $(@bind n Slider(0:10, show_value=true, default=0))
"""

# ╔═╡ 9addbcbe-7b9e-11eb-3e8c-fbab3be40e05
md"""
x₀ = $(@bind x0 Slider(-10:10, show_value=true, default=6))
"""

# ╔═╡ b803743a-7b9e-11eb-203d-595e0a0493e2


# ╔═╡ ba570c4c-7ba2-11eb-2125-9f23e415a1dc
md"""
## Implementation in 1D
"""

# ╔═╡ 5123c038-7ba2-11eb-1be2-19f789b02c1f
md"""
## Mathematics of the Newton method
"""

# ╔═╡ 9bfafcc0-7ba2-11eb-1b67-e3a3803ead08
md"""
We can convert the idea of "following the tangent line" into equations as follows.
(You can also do so by just looking at the geometry in 1D, but that does not help in 2D.)
"""

# ╔═╡ f153b4b8-7ba0-11eb-37ec-4f1a3dbe20e8
md"""
Suppose we have a guess $x_0$ for the root and we want to find a (hopefully) better guess $x_1$.

Let's set $x_1 = x_0 + \delta$, where $x_1$ and $\delta$ are still unknown.

We want $x_1$ to be a root, so
"""

# ╔═╡ 9cfa9062-7ba0-11eb-3a93-197ac0287ab4
md"""
$$f(x_1) = f(x_0 + \delta) \simeq 0$$
"""

# ╔═╡ 1ba1ae44-7ba1-11eb-21ff-558c95446435
md"""
If we are already "quite close" to the root then $\delta$ should be small, so we can approximate $f$ using the tangent line:

$$f(x_0) + \delta \, f'(x_0) \simeq 0$$

and hence

$$\delta \simeq \frac{-f(x_0)}{f'(x_0)}$$

so that

$$x_1 = x_0 - \frac{f(x_0)}{f'(x_0)}$$

Now we can repeat so that 

$$x_2 = x_1 - \frac{f(x_1)}{f'(x_1)}$$

and in general

$$x_{n+1} = x_n - \frac{f(x_n)}{f'(x_n)}.$$


This is the Newton method in 1D.
"""

# ╔═╡ 1b77fada-7b9d-11eb-3266-ebb3895cb76a
straight(x0, y0, x, m) = y0 + m * (x - x0)

# ╔═╡ f25af026-7b9c-11eb-1f11-77a8b06b2d71
function standard_Newton(f, n, x_range, x0, ymin=-10, ymax=10)
    
    f′ = x -> ForwardDiff.derivative(f, x)


	p = plot(f, x_range, lw=3, ylim=(ymin, ymax), legend=:false)

	scatter!([x0], [0], c="green", ann=(x0, -5, L"x_0", 10))

	hline!([0.0], c="magenta", lw=3, ls=:dash)

	for i in 1:n

		plot!([x0, x0], [0, f(x0)], c=:gray, alpha=0.5)
		scatter!([x0], [f(x0)], c=:red)
		m = f′(x0)

		plot!(x_range, [straight(x0, f(x0), x, m) for x in x_range], c=:blue, alpha=0.5, ls=:dash, lw=2)

		x1 = x0 - f(x0) / m
		#scatter!([x1], [0], c="green", ann=(x1, -5, "x$i"))

		if i <= n
			scatter!([x1], [0], c="green", ann=(x1, -5, L"x_%$i", 10))
		end
		
		x0 = x1

	end

	p


end

# ╔═╡ ecb40aea-7b9c-11eb-1476-e54faf32d91c
let
	f(x) = x^2 - 2

	standard_Newton(f, n, -1:0.01:10, x0, -10, 70)
end

# ╔═╡ ec6c6328-7b9c-11eb-1c69-dba12ae522ad
let
	f(x) = 0.2x^3 - 4x + 1
	
	standard_Newton(f, n, -10:0.01:10, x0, -10, 70)
end

# ╔═╡ d0851b16-8227-11eb-109e-e7794e5499f7
function cobweb(f, n, x_range, x0, ymin=-10, ymax=10)
    
	p = plot(xlim=(0, 1.1), ylim=(0, 1.1), leg=:false, ratio=1)
	
	plot!(first(x_range):0.01:last(x_range), f, lw=3, label="g(x)")
	plot!(x -> x, ls=:dash, c=:black, label="y = x")

	plot!([x0, x0], [0, x0], c=:green, alpha=0.7, lw=1)
	
	xs = [x0]
	
	x = x0
	
	for i in 1:n
		x = f(x)
		push!(xs, x)
	end
	

	for i in 1:n
		
		if i > 1
			plot!( [xs[i-1], xs[i-1], xs[i]], 
			   	[xs[i-1], xs[i], xs[i]], 
				
				c=:green, alpha=0.7, lw=1, label="")
		end

		scatter!([xs[i]], [0.01], c="green", ann=(xs[i], 0.04, L"x_%$(i-1)", 10), label="")
		# end
		

	end
	
	xlabel!("x")
	ylabel!("iterations")

	p


end

# ╔═╡ dfa00272-8228-11eb-1e35-2b3353e6ce9e
cobweb(cos, m, (0, 1), 1.0)

# ╔═╡ 3982b718-8284-11eb-2e7a-8b2398769c39
cobweb(cos, 10, (0, 1), 1.0)

# ╔═╡ Cell order:
# ╟─bccbfb08-8227-11eb-1cb5-03298c666e7d
# ╟─c09f0cf2-8227-11eb-3300-f7442bb3bcc9
# ╟─d022c0f0-8228-11eb-07a5-233172c167b0
# ╠═dfa00272-8228-11eb-1e35-2b3353e6ce9e
# ╟─d82f1eae-7b9c-11eb-24d8-e1dcb2eef71a
# ╟─e410c1d0-7ba1-11eb-394f-71dac89756b7
# ╟─5ea7344c-7ba2-11eb-2cc5-0bbdca218c82
# ╟─f4fda666-7b9c-11eb-0304-716c5e710462
# ╟─2445da24-7b9d-11eb-02bd-eb99a3d95a2e
# ╟─9addbcbe-7b9e-11eb-3e8c-fbab3be40e05
# ╟─ecb40aea-7b9c-11eb-1476-e54faf32d91c
# ╠═b803743a-7b9e-11eb-203d-595e0a0493e2
# ╠═ec6c6328-7b9c-11eb-1c69-dba12ae522ad
# ╟─ba570c4c-7ba2-11eb-2125-9f23e415a1dc
# ╟─5123c038-7ba2-11eb-1be2-19f789b02c1f
# ╟─9bfafcc0-7ba2-11eb-1b67-e3a3803ead08
# ╟─f153b4b8-7ba0-11eb-37ec-4f1a3dbe20e8
# ╟─9cfa9062-7ba0-11eb-3a93-197ac0287ab4
# ╟─1ba1ae44-7ba1-11eb-21ff-558c95446435
# ╟─1b77fada-7b9d-11eb-3266-ebb3895cb76a
# ╠═f25af026-7b9c-11eb-1f11-77a8b06b2d71
# ╠═d0851b16-8227-11eb-109e-e7794e5499f7
# ╠═3982b718-8284-11eb-2e7a-8b2398769c39
