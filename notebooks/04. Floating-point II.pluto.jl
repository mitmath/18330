### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 7b9a0076-7799-11eb-04ea-97dd466c17ea
using PlutoUI

# ╔═╡ 97d0261c-77af-11eb-2df9-d556005fd215
md"""
## Floating point II
"""

# ╔═╡ 7cf5c8c0-7795-11eb-037b-2bf8ae456597
3.3 * 1.2

# ╔═╡ 98c55b92-7795-11eb-195f-9374ae00052c
big(3.3)

# ╔═╡ a0e2422c-7795-11eb-1c91-33dc74ecea80
big(1.2)

# ╔═╡ aab44642-7795-11eb-2ad8-f30b92f2b8d7
3.96

# ╔═╡ af1281c2-7795-11eb-2faf-8d947190826b
prevfloat(3.96)

# ╔═╡ bcd249c8-7795-11eb-2af4-9bf3e9d7461a
big(3.96)

# ╔═╡ 0bf8284c-7796-11eb-1e78-33c4375d4467
round(3.3 * 1.2, digits=2)

# ╔═╡ 18a1d6ce-7796-11eb-323a-dd8d7eac380f
1.2345

# ╔═╡ 1ddd280a-7796-11eb-0006-e9b161918f85
(1.234523432, 1.22343345)

# ╔═╡ 2e23307e-7796-11eb-36ff-91a3bfb61af8
(a, b) = (1.234523432, 1.22343345)

# ╔═╡ 32245a40-7796-11eb-3229-6d931d23e817
Text( (a, b) )

# ╔═╡ 3ae2236a-7796-11eb-3873-6fb68803221c
big(0.1)

# ╔═╡ 47bd1b1c-7796-11eb-1d53-9da2b233a8c0
0.1f0

# ╔═╡ 4d0fae4a-7796-11eb-153b-b38d46dfc9fd
typeof(0.1f0)

# ╔═╡ 43951178-7796-11eb-114e-a3f4a61c2763
y = Float32(0.1)

# ╔═╡ 5740084c-7796-11eb-2974-35a021cde251
big(y)

# ╔═╡ 6246f8ae-7796-11eb-2881-4f709827b472
big"0.1"

# ╔═╡ 82bc0340-7796-11eb-35c5-311dc175b4a6
x = 1e305  # 10^305

# ╔═╡ 87329da8-7796-11eb-1f7c-f71e3ce6e209
x * 10_000

# ╔═╡ 9ddc8cbc-7796-11eb-320d-af8147a7a966
typeof(Inf)

# ╔═╡ af3d2e30-7796-11eb-3f70-e9ceab358045
bitstring(Inf)

# ╔═╡ c5694a22-7796-11eb-0f0e-bd6f05e15048
bitstring(-Inf)

# ╔═╡ ca5ee46a-7796-11eb-2990-91bf3f1fa13a
z = 0.0 / 0.0   # nonsense mathematical result

# ╔═╡ f04ca9bc-7796-11eb-30ee-35dc687003b8
z == NaN

# ╔═╡ fa2b3590-7796-11eb-3fbf-d99df6de8cf3
isnan(z)

# ╔═╡ 0f6b90bc-7797-11eb-10bf-fd8b1478b0f2
1 / Inf

# ╔═╡ 2c81a9de-7797-11eb-3b78-590b4f6eb6ab
-1 / Inf

# ╔═╡ 47404d34-7797-11eb-2cf1-6b6a0c522771
md"""
## Julia internals
"""

# ╔═╡ 3c703cc8-7799-11eb-10c1-6739e8896cbc
f(x) = sin(x^2) + x

# ╔═╡ 42feac0a-7799-11eb-3cf7-53261981af7b
f(3)

# ╔═╡ 453bbb98-7799-11eb-3f4d-7399e8edc4d1
@code_lowered f(3)

# ╔═╡ 60cc435a-7799-11eb-008c-e9f3e8474d80
@code_typed f(3.1)

# ╔═╡ 74f87132-7799-11eb-0857-47415b9eb5ed
with_terminal() do
	@code_native f(3.1)
end

# ╔═╡ ad957652-7799-11eb-3137-774a9902dad5
md"""
## Compute functions
"""

# ╔═╡ b22ea0d0-7799-11eb-0590-af050c2a47dd
exp(1.3)   # e^1.3

# ╔═╡ b7535008-7799-11eb-3ccb-b1745638611d
exp(big(1.3))

# ╔═╡ 30de37b0-779a-11eb-06c0-a710995b0abc
precision(BigFloat)

# ╔═╡ Cell order:
# ╟─97d0261c-77af-11eb-2df9-d556005fd215
# ╠═7cf5c8c0-7795-11eb-037b-2bf8ae456597
# ╠═98c55b92-7795-11eb-195f-9374ae00052c
# ╠═a0e2422c-7795-11eb-1c91-33dc74ecea80
# ╠═aab44642-7795-11eb-2ad8-f30b92f2b8d7
# ╠═af1281c2-7795-11eb-2faf-8d947190826b
# ╠═bcd249c8-7795-11eb-2af4-9bf3e9d7461a
# ╠═0bf8284c-7796-11eb-1e78-33c4375d4467
# ╠═18a1d6ce-7796-11eb-323a-dd8d7eac380f
# ╠═1ddd280a-7796-11eb-0006-e9b161918f85
# ╠═2e23307e-7796-11eb-36ff-91a3bfb61af8
# ╠═32245a40-7796-11eb-3229-6d931d23e817
# ╠═3ae2236a-7796-11eb-3873-6fb68803221c
# ╠═47bd1b1c-7796-11eb-1d53-9da2b233a8c0
# ╠═4d0fae4a-7796-11eb-153b-b38d46dfc9fd
# ╠═43951178-7796-11eb-114e-a3f4a61c2763
# ╠═5740084c-7796-11eb-2974-35a021cde251
# ╠═6246f8ae-7796-11eb-2881-4f709827b472
# ╠═82bc0340-7796-11eb-35c5-311dc175b4a6
# ╠═87329da8-7796-11eb-1f7c-f71e3ce6e209
# ╠═9ddc8cbc-7796-11eb-320d-af8147a7a966
# ╠═af3d2e30-7796-11eb-3f70-e9ceab358045
# ╠═c5694a22-7796-11eb-0f0e-bd6f05e15048
# ╠═ca5ee46a-7796-11eb-2990-91bf3f1fa13a
# ╠═f04ca9bc-7796-11eb-30ee-35dc687003b8
# ╠═fa2b3590-7796-11eb-3fbf-d99df6de8cf3
# ╠═0f6b90bc-7797-11eb-10bf-fd8b1478b0f2
# ╠═2c81a9de-7797-11eb-3b78-590b4f6eb6ab
# ╟─47404d34-7797-11eb-2cf1-6b6a0c522771
# ╠═3c703cc8-7799-11eb-10c1-6739e8896cbc
# ╠═42feac0a-7799-11eb-3cf7-53261981af7b
# ╠═453bbb98-7799-11eb-3f4d-7399e8edc4d1
# ╠═60cc435a-7799-11eb-008c-e9f3e8474d80
# ╠═7b9a0076-7799-11eb-04ea-97dd466c17ea
# ╠═74f87132-7799-11eb-0857-47415b9eb5ed
# ╟─ad957652-7799-11eb-3137-774a9902dad5
# ╠═b22ea0d0-7799-11eb-0590-af050c2a47dd
# ╠═b7535008-7799-11eb-3ccb-b1745638611d
# ╠═30de37b0-779a-11eb-06c0-a710995b0abc
