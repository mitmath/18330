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

# ╔═╡ 217993f6-7b81-11eb-363d-17c4464773c1
# using Pkg
# Pkg.add("Plots")

using Plots

# ╔═╡ 74967e78-7b8b-11eb-2518-e13f6468393a
using PlutoUI  # User Interface

# ╔═╡ 9d82a060-7b9b-11eb-3dcd-879d4041a1d9
using Symbolics

# ╔═╡ eecb46a0-7b9b-11eb-153d-6bdf04587ff2
using Latexify

# ╔═╡ fc92bb86-7b89-11eb-3bdd-359838bd774f
md"""
Create a circle of radius $r$ in $\mathbb{C}$
"""

# ╔═╡ 7decb9ac-7b8a-11eb-370a-3143f16b5e9c
unit_circle() = [exp(im * θ) for θ in 0:0.01:2π]  # array comprehension

# ╔═╡ 29c71448-7b8b-11eb-1292-1d17a64732f2
circle(r) = r .* unit_circle()

# ╔═╡ fe1d21de-7b8a-11eb-1a6c-8f1d0647bcf6


# ╔═╡ f4ef0168-7b8a-11eb-0390-e1110a4473be
circle(2.0)

# ╔═╡ c3e2dc02-7b8a-11eb-0c7d-7513af048593
π

# ╔═╡ d818f9c0-7b8a-11eb-2994-61028413d65f
plot(circle(2.0), ratio=1, leg=false)

# ╔═╡ 644046ce-7b8b-11eb-3f67-bb56a401b8e1
md"""
## Interactive
"""

# ╔═╡ 6cb71134-7b8b-11eb-28fa-47a359165562
md"""
I want to change $r$ by some kind of interaction
"""

# ╔═╡ c263951e-7b8b-11eb-3848-53a2ac6ad5ea
f(z) = z^3 - 3z^2 + 1 + im

# ╔═╡ 6848f5fc-7b99-11eb-034f-4ff2465b28f8
f(cis(10))

# ╔═╡ 77fd0762-7b8b-11eb-19c7-7bc839780b46
@bind r Slider(0:0.01:10, show_value=true)

# ╔═╡ 8565b23c-7b8b-11eb-0bab-1da70e0a7018
r

# ╔═╡ 9632a930-7b8b-11eb-2100-3d427f5a81b9
plot(circle(r), ratio=1, leg=false, xlims=(-5, 5), ylims=(-5, 5), m=:o)  # m=marker

# ╔═╡ 8edd19f2-7b8b-11eb-03b1-87dd0764f60b
π * r^2

# ╔═╡ da19be3e-7b8b-11eb-2d11-bba1a152e91f
begin
	image = f.(circle(r))   # image of circle of radius r under the map f
	
	w = 1000
	plot(image, ratio=1, leg=false, xlims=(-w, w), ylims=(-w, w))
	
	scatter!([0 + 0im])
end

# ╔═╡ aded4612-7b99-11eb-1b77-959306031c25
plot(diff(angle.(image)))

# ╔═╡ 4a78254a-7b8d-11eb-04e6-0719d2da93b0


# ╔═╡ 68b14406-7b8d-11eb-18c6-ff95e88db3ba
v = [4, 5, 6]

# ╔═╡ 6be50202-7b8d-11eb-1949-89c2c1066dac
v[0]

# ╔═╡ 6f5a8970-7b8d-11eb-3fcb-95ab97eff15b
v[end - 1]

# ╔═╡ a49c1104-7b9b-11eb-2b5e-e7e8c5c1b83b
md"""
## Symbolic
"""

# ╔═╡ 9f83b5f0-7b9b-11eb-078c-2bb95c139fdb
@variables y

# ╔═╡ b119dfce-7b9b-11eb-05e1-f5440229bc21
x^2

# ╔═╡ b4c0e924-7b9b-11eb-3c08-0f78c8bad3a5
(x + y)^2

# ╔═╡ bdfdbe4a-7b9b-11eb-09a5-139558e0cf82
ex = simplify((x+y)^2, polynorm=true)

# ╔═╡ 1285cd04-7b9c-11eb-0dac-c7cfe44235ce
simplify(ex)

# ╔═╡ e111dc54-7b9b-11eb-3d75-2b848c550882
simplify((x+y)^3)

# ╔═╡ e433d4e6-7b9b-11eb-1b7d-c7da3836019f
A = [x y; x^2 y^2]

# ╔═╡ f32b555a-7b9b-11eb-3d79-cde25c50ded1
latexify(A)

# ╔═╡ fda02916-7b9b-11eb-34eb-f181adc85611


# ╔═╡ Cell order:
# ╠═217993f6-7b81-11eb-363d-17c4464773c1
# ╟─fc92bb86-7b89-11eb-3bdd-359838bd774f
# ╠═7decb9ac-7b8a-11eb-370a-3143f16b5e9c
# ╠═29c71448-7b8b-11eb-1292-1d17a64732f2
# ╠═fe1d21de-7b8a-11eb-1a6c-8f1d0647bcf6
# ╠═f4ef0168-7b8a-11eb-0390-e1110a4473be
# ╠═c3e2dc02-7b8a-11eb-0c7d-7513af048593
# ╠═d818f9c0-7b8a-11eb-2994-61028413d65f
# ╟─644046ce-7b8b-11eb-3f67-bb56a401b8e1
# ╟─6cb71134-7b8b-11eb-28fa-47a359165562
# ╠═8565b23c-7b8b-11eb-0bab-1da70e0a7018
# ╠═74967e78-7b8b-11eb-2518-e13f6468393a
# ╠═9632a930-7b8b-11eb-2100-3d427f5a81b9
# ╠═8edd19f2-7b8b-11eb-03b1-87dd0764f60b
# ╠═c263951e-7b8b-11eb-3848-53a2ac6ad5ea
# ╠═6848f5fc-7b99-11eb-034f-4ff2465b28f8
# ╠═77fd0762-7b8b-11eb-19c7-7bc839780b46
# ╠═aded4612-7b99-11eb-1b77-959306031c25
# ╠═da19be3e-7b8b-11eb-2d11-bba1a152e91f
# ╠═4a78254a-7b8d-11eb-04e6-0719d2da93b0
# ╠═68b14406-7b8d-11eb-18c6-ff95e88db3ba
# ╠═6be50202-7b8d-11eb-1949-89c2c1066dac
# ╠═6f5a8970-7b8d-11eb-3fcb-95ab97eff15b
# ╟─a49c1104-7b9b-11eb-2b5e-e7e8c5c1b83b
# ╠═9d82a060-7b9b-11eb-3dcd-879d4041a1d9
# ╠═9f83b5f0-7b9b-11eb-078c-2bb95c139fdb
# ╠═b119dfce-7b9b-11eb-05e1-f5440229bc21
# ╠═b4c0e924-7b9b-11eb-3c08-0f78c8bad3a5
# ╠═bdfdbe4a-7b9b-11eb-09a5-139558e0cf82
# ╠═1285cd04-7b9c-11eb-0dac-c7cfe44235ce
# ╠═e111dc54-7b9b-11eb-3d75-2b848c550882
# ╠═e433d4e6-7b9b-11eb-1b7d-c7da3836019f
# ╠═eecb46a0-7b9b-11eb-153d-6bdf04587ff2
# ╠═f32b555a-7b9b-11eb-3d79-cde25c50ded1
# ╠═fda02916-7b9b-11eb-34eb-f181adc85611
