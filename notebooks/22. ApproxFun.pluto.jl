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

# ╔═╡ 63b35655-c222-4115-93a6-680472be1e51
begin
	using ApproxFun
	using Plots
	using PlutoUI
end

# ╔═╡ c7b99c6b-3710-4d3f-a99f-911805e46159
using FFTW

# ╔═╡ de9efa26-6223-4afc-adac-a23c90d1c578
TableOfContents()

# ╔═╡ df5b6f78-b262-11eb-366a-95e7997225f0
md"""
# Chebyshev technology using ApproxFun.jl
"""

# ╔═╡ e7fd18c8-7363-4911-848c-65f0bd9d794e
md"""
ApproxFun.jl is a Julia package that implements the Chebyshev methods we have been looking at.

Given a function $f$, it automatically calculates the "correct" (minimal) number of Chebyshev coefficients $\alpha_k$ necessary such that
	
$$f \simeq f_n := \sum_{k=0}^n \alpha_k T_k$$
	
gives an excellent approximation to $f$ within close to machine precision.
"""

# ╔═╡ 0f4b655a-7c00-40fa-84b5-5c0af65c7749
md"""
## Usage
"""

# ╔═╡ cb665fe7-2ceb-4c04-86b8-23c688cdd07b
md"""
We define a function using the `Fun` object. We can pass it a function to approximate and a range over which to approximate it:
"""

# ╔═╡ f103f184-e4a7-4e8a-a236-765eefa1089a
x = Fun(identity, -5..5)

# ╔═╡ 8c99c415-484d-44ad-9110-974510f32a33
md"""
Note that `x` here is a *function* -- the identity function $x \to x$
"""

# ╔═╡ 91e12a21-375c-4794-9124-b5a084878a71
md"""
The vector is the vector of computed Chebyshev coefficients.
"""

# ╔═╡ ed9f366a-d824-48c7-95b2-2a573642cd45
domain(x)

# ╔═╡ d13cf8fe-604f-442d-a1e0-dc7a27a239b0
coefficients(x)

# ╔═╡ d2c6355d-98ae-40eb-a73f-45f35737e50f
md"""
The package provides a **plot recipe** for "hooking into" `Plots.jl`, so we can plot `Fun` objects easily:
"""

# ╔═╡ a1c35bd6-0ed7-40c7-af49-02fdda547fa7
plot(x, ratio=1, size=(400, 300), leg=false)

# ╔═╡ fdedab6e-0eb8-4ddd-8e9a-ae6d02723e60
md"""
Let's look at the `sin` function:
"""

# ╔═╡ 7655fca1-5e32-4d11-b09e-16c2b6c14875
f = sin(x)

# ╔═╡ 9761f594-9144-47e2-93b4-140f399cb22a
plot(f, ratio=1, size=(400, 300), leg=false)

# ╔═╡ 0a22e4c3-2d33-41bc-97ea-0d50fafdb7e0
md"""
Since `x` is a `Fun`, so is `f`. It is calculated as we discussed in lectures: sample the function on denser and denser Chebyshev grids, calculate the Chebyshev coefficients using the Fast Cosine Transform (FCT), and keep going until the coefficients decay fast.
"""

# ╔═╡ 8786d20c-8c1a-424d-b231-50f1636f6b46
coefficients(f)

# ╔═╡ f5757c00-c1bf-475b-9d0c-0cae9ab97ddb
scatter(coefficients(f), size=(400, 300), leg=false)

# ╔═╡ f5450167-6858-4512-97f7-14a381c8233d
scatter(abs.(coefficients(f)), size=(400, 300), leg=false, yscale=:log10)

# ╔═╡ 1c400a80-2cd6-45fe-b6c0-97a92011b53d
ncoefficients(f)

# ╔═╡ 84fc75f6-f85b-47a2-a81b-c4ab8d3eb3f3
md"""
We can evaluate the function at any point within the original interval:
"""

# ╔═╡ bd409bb3-4955-4b9b-abcc-7e689321071e
f(3.14)

# ╔═╡ 1143f243-9c17-4caf-9a12-6326ccd7d9f9
md"""
The Chebyshev approximations are stored as Chebyshev coefficients $\alpha_k$. In order to reconstruct the sampled values $f_j$, the inverse FCT is used. Then  **barycentric Lagrange interpolation** is used to evaluate the function at other values!
"""

# ╔═╡ de7b0500-a7b9-40f8-bf1b-f9fa67d5c1d3
md"""
## Reconstructing a function
"""

# ╔═╡ 0a81970a-95d4-4424-afb3-bd992d938338
md"""
We can see the effect of taking different numbers of coefficients:
"""

# ╔═╡ 32e0d477-6c27-4a70-be91-fd1b68e44f10
md"""
## The power of Chebyshev
"""

# ╔═╡ a3e31b19-5f7e-410d-b367-ef5960b323c7
md"""
As we have seen in lectures, using Chebyshev approximation allows us to do many useful calculations relatively easily. Fortunately `ApproxFun` already has many things implemented. 

Let's make a complicated function:
"""

# ╔═╡ 022980cc-14a9-4b51-881c-57385deb4e53
x

# ╔═╡ 1f1634d3-605b-44f8-87d9-ab75b78d62d9
h = sin(x^2) +  cos(x)

# ╔═╡ 7d52118c-789b-44c6-9ed9-fbd09ad61623
coefficients(h)

# ╔═╡ 863f9a1a-a8d1-4fc8-a65b-044c122b970b
md"""
m = $(@bind m Slider(1:length(coefficients(h)), show_value=true, default=1))
"""

# ╔═╡ 557beafd-a952-431b-a803-42f892f85747
h2 = Fun(space(h), coefficients(h)[1:m])

# ╔═╡ 72b3bc14-f0f2-4e95-b452-9dafdaae87f7
begin
	plot(h, label="exact", ylims=(-1.5, 1.5), size=(400, 300))
	plot!(h2, label="$m terms")
end

# ╔═╡ 40c5f1c5-bafa-4779-a9e2-319779eb4804
begin
	as_svg(plot(-5:0.001:5, f - f2, label="error", size=(400, 300)))
	pts = points(Chebyshev(-5..5), m)
	scatter!(pts, zero.(pts))
end

# ╔═╡ dd502309-fe0b-4eb9-9018-ef9c1996df01
ncoefficients(h)

# ╔═╡ 6cc2c264-ceab-4662-9c79-175d1f2137f2
plot(h, ratio=1, size=(400, 300), leg=false)

# ╔═╡ 9ff46fc5-8fdb-4a14-b8ad-c7262e67144b
md"""
We can differentiate it using `'`:
"""

# ╔═╡ 8ee166a7-81f3-4981-bc34-1790bebb902a
plot(h', size=(400, 300), leg=false, xlims=(-5, 5))

# ╔═╡ 26c801ef-1b0b-49f5-a902-5afcea057e37
md"""
We can find the roots:
"""

# ╔═╡ 92687aed-e0c7-44f3-8bb1-7c34256cf3d6
zeros = roots(h)

# ╔═╡ db79cae5-a1b6-452a-8273-0b9b97b4c0dc
begin
	plot(h, label="h")
	scatter!(zeros, zero.(zeros), 
			size=(400, 300), label="roots", ratio=1)
end

# ╔═╡ 165b61a3-a67f-470c-9dcd-9620849247a2
md"""
We can now find *all stationary points* as the roots of the derivative!
"""

# ╔═╡ 7617ac1a-c18a-4c41-bb5c-44ff73097241
begin
	stationary = roots(h')
	
	scatter!(stationary, h.(stationary), 
				size=(400, 300), label="stationary", ratio=1)
	
end

# ╔═╡ 0e4f50b2-0784-41c9-bd5c-288d378de3e1
md"""
We can also find the indefinite integral:
"""

# ╔═╡ 7cfe9baf-afaf-40c1-9973-38be03c830cb
I = ∫(h)

# ╔═╡ c387541b-106c-4a9c-89ca-5349cfe11efa
plot(I, size=(400, 300), leg=false, ratio=1)

# ╔═╡ 2b4a8890-ce79-4ac5-9c18-e1ab65d554cd
md"""
Its stationary points should be the roots of the original function!
"""

# ╔═╡ 8d3c8d91-7f85-4582-b35d-00ca11eca4be
rts2 = roots( I' )

# ╔═╡ 6ae74417-2929-4cbb-9197-cabcaceaf3c3
begin
	
	plot(I, size=(400, 300), leg=false, ratio=1)
	plot!(h)
	scatter!(rts2, zero.(rts2), size=(400, 300), leg=false, ratio=1)
	scatter!(rts2, I.(rts2), size=(400, 300), leg=false, ratio=1)

	
end

# ╔═╡ 4cff6ccf-63d7-46fc-a917-488277c88e4c
md"""
## The technology: Chebyshev nodes and the Discrete Cosine Transform
"""

# ╔═╡ 8e02baa2-b4f5-4df8-a53d-a792d2e0de85
md"""
ApproxFun.jl is "just" a (very neat, clever and well-executed!) implementation of the technology we have seen in class. We can "easily" do it ourselves instead:
"""

# ╔═╡ 555d0cc3-f708-487b-b210-fa5324faff75
md"""
The Chebyshev nodes are available as follows:
"""

# ╔═╡ e1d77695-81c4-4808-961e-2f38c87aece4
n = 16

# ╔═╡ 72e5b55c-8c43-436d-a20d-493047cfaf47
points(Chebyshev(-1..1), n)

# ╔═╡ dfbeb827-a183-4e0d-b078-70da0f069368
md"""
They are slightly different rom the ones in class, to avoid problems coming from the including the ends of the interval:
"""

# ╔═╡ 1d1fc6c6-0775-4e8a-978f-e63c00500fc1
md"""
$x_k = \cos \left( \frac{2k - 1}{2n} \pi \right)$
"""

# ╔═╡ 5dbdcc00-25ec-4f11-aeff-b254cf260425
xs = [cos( (2k - 1) / (2n) * π) for k in 1:n]

# ╔═╡ 2feb66fc-eb7f-4cd3-94af-25299d170908
md"""
We can calculate the Chebyshev coefficients using `dct` from the `FFTW.jl` package and then dividing by 2:
"""

# ╔═╡ fa15e0db-33bd-4b2f-b5d0-f5fa3a9e1844
dct(xs)

# ╔═╡ 668a244c-f289-4d35-b4dd-52a8dd677575
dct(sin.(xs))

# ╔═╡ 3c5ce37c-bec5-43ad-9d66-1617e6dc9f3c
xx = Fun(identity, -1..1)

# ╔═╡ 3ec4bded-7c04-468f-a237-f2e60554ec3b
sin(xx)

# ╔═╡ 3de55dcf-6fd6-4576-b2d6-51d9557bfa94
round.(coefficients(sin(xx)), digits=15)

# ╔═╡ 7736f394-02f5-48e9-9e9f-344406dafbc3
round.(dct(sin.(xs)), digits=15) ./ 2

# ╔═╡ 89d5596f-7311-4c59-ba13-f875031a3b05
md"""
Note that we could implement the DCT by hand instead using a slow algorithm; FFTW is "just" giving us a (very neat, clever and well-executed!) version of the fast cosine transform version.
"""

# ╔═╡ 76881b1e-e66b-423d-a252-72cf659f2ca7
p = abs(sin(x))

# ╔═╡ 03194ee7-a0d2-49cd-b070-b1dc8575b2f8
plot(p)

# ╔═╡ 9d4efd6c-fba6-43b3-8880-697338183a18


# ╔═╡ Cell order:
# ╠═63b35655-c222-4115-93a6-680472be1e51
# ╠═de9efa26-6223-4afc-adac-a23c90d1c578
# ╟─df5b6f78-b262-11eb-366a-95e7997225f0
# ╟─e7fd18c8-7363-4911-848c-65f0bd9d794e
# ╟─0f4b655a-7c00-40fa-84b5-5c0af65c7749
# ╟─cb665fe7-2ceb-4c04-86b8-23c688cdd07b
# ╠═f103f184-e4a7-4e8a-a236-765eefa1089a
# ╟─8c99c415-484d-44ad-9110-974510f32a33
# ╟─91e12a21-375c-4794-9124-b5a084878a71
# ╠═ed9f366a-d824-48c7-95b2-2a573642cd45
# ╠═d13cf8fe-604f-442d-a1e0-dc7a27a239b0
# ╟─d2c6355d-98ae-40eb-a73f-45f35737e50f
# ╠═a1c35bd6-0ed7-40c7-af49-02fdda547fa7
# ╟─fdedab6e-0eb8-4ddd-8e9a-ae6d02723e60
# ╠═7655fca1-5e32-4d11-b09e-16c2b6c14875
# ╠═9761f594-9144-47e2-93b4-140f399cb22a
# ╟─0a22e4c3-2d33-41bc-97ea-0d50fafdb7e0
# ╠═8786d20c-8c1a-424d-b231-50f1636f6b46
# ╠═f5757c00-c1bf-475b-9d0c-0cae9ab97ddb
# ╠═f5450167-6858-4512-97f7-14a381c8233d
# ╠═1c400a80-2cd6-45fe-b6c0-97a92011b53d
# ╟─84fc75f6-f85b-47a2-a81b-c4ab8d3eb3f3
# ╠═bd409bb3-4955-4b9b-abcc-7e689321071e
# ╟─1143f243-9c17-4caf-9a12-6326ccd7d9f9
# ╟─de7b0500-a7b9-40f8-bf1b-f9fa67d5c1d3
# ╟─0a81970a-95d4-4424-afb3-bd992d938338
# ╠═557beafd-a952-431b-a803-42f892f85747
# ╠═72b3bc14-f0f2-4e95-b452-9dafdaae87f7
# ╟─7d52118c-789b-44c6-9ed9-fbd09ad61623
# ╠═863f9a1a-a8d1-4fc8-a65b-044c122b970b
# ╠═40c5f1c5-bafa-4779-a9e2-319779eb4804
# ╟─32e0d477-6c27-4a70-be91-fd1b68e44f10
# ╟─a3e31b19-5f7e-410d-b367-ef5960b323c7
# ╠═022980cc-14a9-4b51-881c-57385deb4e53
# ╠═1f1634d3-605b-44f8-87d9-ab75b78d62d9
# ╠═dd502309-fe0b-4eb9-9018-ef9c1996df01
# ╠═6cc2c264-ceab-4662-9c79-175d1f2137f2
# ╟─9ff46fc5-8fdb-4a14-b8ad-c7262e67144b
# ╠═8ee166a7-81f3-4981-bc34-1790bebb902a
# ╟─26c801ef-1b0b-49f5-a902-5afcea057e37
# ╠═92687aed-e0c7-44f3-8bb1-7c34256cf3d6
# ╟─db79cae5-a1b6-452a-8273-0b9b97b4c0dc
# ╟─165b61a3-a67f-470c-9dcd-9620849247a2
# ╠═7617ac1a-c18a-4c41-bb5c-44ff73097241
# ╟─0e4f50b2-0784-41c9-bd5c-288d378de3e1
# ╠═7cfe9baf-afaf-40c1-9973-38be03c830cb
# ╠═c387541b-106c-4a9c-89ca-5349cfe11efa
# ╟─2b4a8890-ce79-4ac5-9c18-e1ab65d554cd
# ╠═8d3c8d91-7f85-4582-b35d-00ca11eca4be
# ╠═6ae74417-2929-4cbb-9197-cabcaceaf3c3
# ╟─4cff6ccf-63d7-46fc-a917-488277c88e4c
# ╟─8e02baa2-b4f5-4df8-a53d-a792d2e0de85
# ╟─555d0cc3-f708-487b-b210-fa5324faff75
# ╠═e1d77695-81c4-4808-961e-2f38c87aece4
# ╟─72e5b55c-8c43-436d-a20d-493047cfaf47
# ╟─dfbeb827-a183-4e0d-b078-70da0f069368
# ╟─1d1fc6c6-0775-4e8a-978f-e63c00500fc1
# ╠═5dbdcc00-25ec-4f11-aeff-b254cf260425
# ╟─2feb66fc-eb7f-4cd3-94af-25299d170908
# ╠═c7b99c6b-3710-4d3f-a99f-911805e46159
# ╠═fa15e0db-33bd-4b2f-b5d0-f5fa3a9e1844
# ╠═668a244c-f289-4d35-b4dd-52a8dd677575
# ╠═3c5ce37c-bec5-43ad-9d66-1617e6dc9f3c
# ╠═3ec4bded-7c04-468f-a237-f2e60554ec3b
# ╟─3de55dcf-6fd6-4576-b2d6-51d9557bfa94
# ╠═7736f394-02f5-48e9-9e9f-344406dafbc3
# ╟─89d5596f-7311-4c59-ba13-f875031a3b05
# ╠═76881b1e-e66b-423d-a252-72cf659f2ca7
# ╠═03194ee7-a0d2-49cd-b070-b1dc8575b2f8
# ╠═9d4efd6c-fba6-43b3-8880-697338183a18
