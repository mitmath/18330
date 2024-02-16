### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 483ba7f2-7d18-11eb-1615-77486336d78e
using Plots

# ╔═╡ ea745fa2-7d16-11eb-1f62-ab46e1841c3b
x0 = 1.0

# ╔═╡ 046f5808-7d17-11eb-24c6-b1725a33fdfa
x1 = cos(x0)

# ╔═╡ 164d5020-7d17-11eb-2fa7-0505236d9644
x2 = cos(x1)

# ╔═╡ 18553946-7d17-11eb-2110-5f17df5bbb43
x3 = cos(x2)

# ╔═╡ 326fb2a2-7d17-11eb-11df-ab421d689845
num_iterations = 10   

# ╔═╡ 5640999e-7d17-11eb-0f1c-11ce80fa3a47
x = x0

# ╔═╡ 1c10ea12-7d17-11eb-24e5-f71bd0bc0eb1
function iterate(f, num_iterations, x0)
	
	x = x0
	xs = [x0]  # makes vector with the single value x0 inside
	
	for i in 1:num_iterations
		x′ = f(x)

		x = x′
		push!(xs, x)
	end
	
	return xs
end

# ╔═╡ f48ec724-7d17-11eb-0a15-3f37a1c676fa
[3.1]

# ╔═╡ 82c75728-7d17-11eb-3a07-934d4062109b
data = iterate(cos, 100, 1.0)

# ╔═╡ 395f8faa-7d18-11eb-1837-fdc1e47469cb
md"""
### Don't stare at the numbers; plot the results!
"""

# ╔═╡ 4a8dcc56-7d18-11eb-34e2-4337e378e94e
plot(data, m=:o, leg=false, xlabel="n", ylabel="x_n")

# ╔═╡ bf72422c-7d18-11eb-2244-6b05ba69e427
md"""
Limiting value
"""

# ╔═╡ db6b5962-7d18-11eb-1fb1-e1800f00139d
limit = data[end]

# ╔═╡ ee523034-7d18-11eb-319d-09f649a6ddb2
data[end-1] - data[end]

# ╔═╡ 046996a0-7d19-11eb-2494-a7ea5be8d416
cos(limit)

# ╔═╡ 0c75bd38-7d19-11eb-3504-a9f8db5f2e25
cos(limit) == limit

# ╔═╡ 3e41f200-7d19-11eb-0d32-3d195ad51b76
iterate(cos, 10, limit)

# ╔═╡ 8653dd7e-7d19-11eb-26de-195c43f0776f
data_big = iterate(cos, 100, big(1.0))

# ╔═╡ 7a8b941e-7d19-11eb-3a94-5f0d1d8192cc
data_big[1]

# ╔═╡ 7cdf9698-7d19-11eb-192e-59ddccfed96a
data_big[2]

# ╔═╡ 9044947c-7d19-11eb-3c5c-45fbab67903d
plot(data_big, m=:o)

# ╔═╡ 952befe4-7d19-11eb-0c50-479a4e128602
limit_big = data_big[end]

# ╔═╡ aadbd52c-7d19-11eb-0b92-733a4ce5a857
md"""
$\delta_n := x_n - x^*$
"""

# ╔═╡ c3a8054c-7d1e-11eb-3aee-3f63785d3671
δs = data .- limit  # subtract limit elementwise

# ╔═╡ d9d5eeb0-7d1e-11eb-1ca6-1dd5d1defede
plot(δs, m=:o)


# ╔═╡ e788508e-7d1e-11eb-2e49-9d238c9d603a
plot(abs.(δs), m=:o, xlabel="n", ylabel="δ_n")

# ╔═╡ 272e18e0-7d1f-11eb-0d77-3f20f599727a
plot(replace(abs.(δs), 0=>NaN), m=:o, xlabel="n", ylabel="δ_n", yscale=:log10)

# ╔═╡ 43b9c392-7d1f-11eb-06a1-594b8e0d0341
md"""
Straight line on a semi-log plot means exponential decay
"""

# ╔═╡ 89758d8a-7d1f-11eb-1d3d-8b3dd8e2822d


# ╔═╡ 7d6fcb36-7d1f-11eb-2c2e-6f1499f37c31
md"""
$$\delta_n = C \exp(-\lambda n)$$
"""

# ╔═╡ Cell order:
# ╠═ea745fa2-7d16-11eb-1f62-ab46e1841c3b
# ╠═046f5808-7d17-11eb-24c6-b1725a33fdfa
# ╠═164d5020-7d17-11eb-2fa7-0505236d9644
# ╠═18553946-7d17-11eb-2110-5f17df5bbb43
# ╠═326fb2a2-7d17-11eb-11df-ab421d689845
# ╠═5640999e-7d17-11eb-0f1c-11ce80fa3a47
# ╠═1c10ea12-7d17-11eb-24e5-f71bd0bc0eb1
# ╠═f48ec724-7d17-11eb-0a15-3f37a1c676fa
# ╠═82c75728-7d17-11eb-3a07-934d4062109b
# ╟─395f8faa-7d18-11eb-1837-fdc1e47469cb
# ╠═483ba7f2-7d18-11eb-1615-77486336d78e
# ╠═4a8dcc56-7d18-11eb-34e2-4337e378e94e
# ╟─bf72422c-7d18-11eb-2244-6b05ba69e427
# ╠═db6b5962-7d18-11eb-1fb1-e1800f00139d
# ╠═ee523034-7d18-11eb-319d-09f649a6ddb2
# ╠═046996a0-7d19-11eb-2494-a7ea5be8d416
# ╠═0c75bd38-7d19-11eb-3504-a9f8db5f2e25
# ╠═3e41f200-7d19-11eb-0d32-3d195ad51b76
# ╠═7a8b941e-7d19-11eb-3a94-5f0d1d8192cc
# ╠═7cdf9698-7d19-11eb-192e-59ddccfed96a
# ╠═8653dd7e-7d19-11eb-26de-195c43f0776f
# ╠═9044947c-7d19-11eb-3c5c-45fbab67903d
# ╠═952befe4-7d19-11eb-0c50-479a4e128602
# ╟─aadbd52c-7d19-11eb-0b92-733a4ce5a857
# ╠═c3a8054c-7d1e-11eb-3aee-3f63785d3671
# ╠═d9d5eeb0-7d1e-11eb-1ca6-1dd5d1defede
# ╠═e788508e-7d1e-11eb-2e49-9d238c9d603a
# ╠═272e18e0-7d1f-11eb-0d77-3f20f599727a
# ╟─43b9c392-7d1f-11eb-06a1-594b8e0d0341
# ╟─89758d8a-7d1f-11eb-1d3d-8b3dd8e2822d
# ╠═7d6fcb36-7d1f-11eb-2c2e-6f1499f37c31
