### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 25961462-9316-11eb-2c82-c130ea4cc0e9
using Plots

# ╔═╡ 797cd1d2-9317-11eb-117c-1fa9adc86361
using LinearAlgebra

# ╔═╡ 3210d218-9316-11eb-142e-4f1e9829763f
θs = 0:0.01:2π

# ╔═╡ 3d3af5f6-9316-11eb-3f8b-9980d6652197
begin
	xs = cos.(θs)
	ys = sin.(θs)
end

# ╔═╡ 44a6601e-9316-11eb-1929-79b082c263d9
plot(xs, ys, ratio=1, m=:o, alpha=0.5)

# ╔═╡ 6dfdbc00-9316-11eb-0655-1fa12dab4d0b
[xs ys]

# ╔═╡ 7b53ca5c-9316-11eb-2acf-bfc59a741902
hcat(xs, ys)

# ╔═╡ 81dca3f8-9316-11eb-001f-8d9f73b3114d
data = hcat(xs, ys)'   # ' = transpose

# ╔═╡ 5579b696-9316-11eb-1ed4-f92b54f7fde1
# A = [2 1; 1 1]

A = 5 * randn(2, 2)

# ╔═╡ 8e5910f8-9316-11eb-0417-819c1bb12628
image = A * data

# ╔═╡ 95626a98-9316-11eb-2661-af58643d1812
begin
	plot(data[1, :], data[2, :], m=:o, alpha=0.5, legend=false, ratio=1)
	plot!(image[1, :], image[2, :], m=:o, alpha=0.5)
	
	title!("det = $(det(A))")
end

# ╔═╡ d07accb4-9317-11eb-233f-193344c5776a
svdvals(A)

# ╔═╡ dcb36e78-9317-11eb-0cae-5594f269415c
prod(svdvals(A))

# ╔═╡ Cell order:
# ╠═25961462-9316-11eb-2c82-c130ea4cc0e9
# ╠═3210d218-9316-11eb-142e-4f1e9829763f
# ╠═3d3af5f6-9316-11eb-3f8b-9980d6652197
# ╠═44a6601e-9316-11eb-1929-79b082c263d9
# ╠═6dfdbc00-9316-11eb-0655-1fa12dab4d0b
# ╠═7b53ca5c-9316-11eb-2acf-bfc59a741902
# ╠═81dca3f8-9316-11eb-001f-8d9f73b3114d
# ╠═8e5910f8-9316-11eb-0417-819c1bb12628
# ╠═797cd1d2-9317-11eb-117c-1fa9adc86361
# ╠═5579b696-9316-11eb-1ed4-f92b54f7fde1
# ╠═95626a98-9316-11eb-2661-af58643d1812
# ╠═d07accb4-9317-11eb-233f-193344c5776a
# ╠═dcb36e78-9317-11eb-0cae-5594f269415c
