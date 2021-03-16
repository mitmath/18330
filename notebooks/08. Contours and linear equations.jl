### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ a84eae8a-8678-11eb-39c2-939d8885d6a6
using Plots

# ╔═╡ a36827d0-8683-11eb-14f7-77e0a6cda87b
using LinearAlgebra

# ╔═╡ b6a96f1c-8678-11eb-1198-ad94af8eb2ae
f(x, y) = x^2 + y^2

# ╔═╡ 533a305c-867c-11eb-2b09-ab20b8ffccc2
contour(-2:0.1:2, -2:0.1:2, f, ratio=1)

# ╔═╡ 6122c3c8-867c-11eb-2a3b-392e9df4849e
contour(-2:0.1:2, -2:0.1:2, f, ratio=1, levels=[1, 2])

# ╔═╡ 7700530e-867c-11eb-2d9f-1304ddf9b620
surface(-2:0.1:2, -2:0.1:2, f, ratio=1, xlabel="x", ylabel="y")

# ╔═╡ 7a3e80ea-867c-11eb-1f9e-efe94ec051c6
md"""
You can't rotate!
"""

# ╔═╡ 94089a54-867c-11eb-300f-bdaccc93baa6
plotly()  # load a different plotting library as a "backend"

# ╔═╡ a19b59ec-867c-11eb-3538-8b4d812ae71f
surface(-2:0.1:2, -2:0.1:2, f, ratio=1, xlabel="x", ylabel="y", alpha=0.5)

# ╔═╡ e7b8fe00-867c-11eb-0f83-793e13fc9677
v = [1, 2, 3]

# ╔═╡ e9742172-867c-11eb-2246-81058086303f
push!(v, 4)

# ╔═╡ 4493028a-867d-11eb-07d8-01822452f516
g(x, y) = x * y

# ╔═╡ 771637d6-867d-11eb-306b-9ffe25efc8cb
gr()   # original plotting engine

# ╔═╡ 3a01f6d2-867d-11eb-139f-6555f4ded702
contour(-2:0.01:2, -2:0.01:2, g, levels=[0])

# ╔═╡ 2fefc52e-8683-11eb-2d09-5d14d6ed7362
md"""
## Solving linear systems in Julia
"""

# ╔═╡ 2d25dc20-8683-11eb-2d2f-3f6be4b96932
A = rand(2, 2) # random matrix b = rand(2) # random vector


# ╔═╡ 373f1ed8-8683-11eb-25ab-05d161be487f
b = rand(2)

# ╔═╡ 44b65392-8683-11eb-1c40-bd4012c80280
x = A \ b

# ╔═╡ 4bccd502-8683-11eb-13b1-6b49fc486297
A * x

# ╔═╡ 58365070-8683-11eb-1f6c-6b0049df1be0
residual = A * x - b

# ╔═╡ a9c5d636-8683-11eb-1b36-d501639c3d63
 norm(residual)

# ╔═╡ 5f2e7650-8683-11eb-23fb-7708d482c4eb
A2 = big.(A)

# ╔═╡ 75c2b70a-8683-11eb-38e7-f5592b67b647
b2 = big.(b)

# ╔═╡ 7800efd2-8683-11eb-244b-4ff7efb113e7
x2 = A2 \ b2

# ╔═╡ 9095e798-8683-11eb-3b8f-57110846983d
residual2 = A2 * x2 - b2

# ╔═╡ d709f67c-8683-11eb-0059-59ce9bb38040
norm(residual2)

# ╔═╡ Cell order:
# ╠═a84eae8a-8678-11eb-39c2-939d8885d6a6
# ╠═b6a96f1c-8678-11eb-1198-ad94af8eb2ae
# ╠═533a305c-867c-11eb-2b09-ab20b8ffccc2
# ╠═6122c3c8-867c-11eb-2a3b-392e9df4849e
# ╠═7700530e-867c-11eb-2d9f-1304ddf9b620
# ╠═7a3e80ea-867c-11eb-1f9e-efe94ec051c6
# ╠═94089a54-867c-11eb-300f-bdaccc93baa6
# ╠═a19b59ec-867c-11eb-3538-8b4d812ae71f
# ╠═e7b8fe00-867c-11eb-0f83-793e13fc9677
# ╠═e9742172-867c-11eb-2246-81058086303f
# ╠═4493028a-867d-11eb-07d8-01822452f516
# ╠═771637d6-867d-11eb-306b-9ffe25efc8cb
# ╠═3a01f6d2-867d-11eb-139f-6555f4ded702
# ╠═2fefc52e-8683-11eb-2d09-5d14d6ed7362
# ╠═2d25dc20-8683-11eb-2d2f-3f6be4b96932
# ╠═373f1ed8-8683-11eb-25ab-05d161be487f
# ╠═44b65392-8683-11eb-1c40-bd4012c80280
# ╠═4bccd502-8683-11eb-13b1-6b49fc486297
# ╠═58365070-8683-11eb-1f6c-6b0049df1be0
# ╠═a36827d0-8683-11eb-14f7-77e0a6cda87b
# ╠═a9c5d636-8683-11eb-1b36-d501639c3d63
# ╠═5f2e7650-8683-11eb-23fb-7708d482c4eb
# ╠═75c2b70a-8683-11eb-38e7-f5592b67b647
# ╠═7800efd2-8683-11eb-244b-4ff7efb113e7
# ╠═9095e798-8683-11eb-3b8f-57110846983d
# ╠═d709f67c-8683-11eb-0059-59ce9bb38040
