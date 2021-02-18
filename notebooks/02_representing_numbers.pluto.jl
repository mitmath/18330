### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ bb27bee2-721c-11eb-07d9-4b5d1ac0005c
using PlutoUI

# ╔═╡ eafae420-7215-11eb-33f9-7dca7f1dafc7
md"""
# Number types
"""

# ╔═╡ 3a9ca5bc-7217-11eb-2d0a-df53a713ebed
md"""
### Booleans
"""

# ╔═╡ d7f3bc26-7215-11eb-1cea-2f4865d3d3f7
x = true   # one equals sign: assigning to a variable

# ╔═╡ ea6628bc-7215-11eb-3d91-d106e999e488
typeof(x)

# ╔═╡ ff5a3754-7215-11eb-35bf-9b8a3c88611e
bitstring(x)

# ╔═╡ 144be446-7216-11eb-35d9-ef441839207e
bitstring(false)

# ╔═╡ 230e9cb2-7216-11eb-3eb5-8760ceca5099
Int(true)

# ╔═╡ 25b4f0f6-7216-11eb-0f72-6fbf71814e27
true == 1  # testing equality: two equals signs

# ╔═╡ 3cd98206-7216-11eb-1913-09b1fdd6b98e
true === 1

# ╔═╡ 533030c2-7216-11eb-057a-7b5f7dd910db
!(true)

# ╔═╡ 5685db96-7216-11eb-0ddb-9bfbc2b4d41c
!true

# ╔═╡ 5880a386-7216-11eb-24ed-6592f9dc6853
true & false

# ╔═╡ 49eee2fa-7217-11eb-2c5f-f34684840392
md"""
## Integers
"""

# ╔═╡ 4c246600-7217-11eb-3256-1d1157bc53ff
bitstring(22)

# ╔═╡ d1ef3eca-7217-11eb-16bf-dfb579f2d282
bitstring(-22)

# ╔═╡ fd0ed656-7217-11eb-1461-119cb83d41ef
y = 3

# ╔═╡ 00bbf1d0-7218-11eb-08bf-5d91b223149b
typeof(y)

# ╔═╡ 05b0c7a6-7218-11eb-2165-833aeab56165
Int32(y)

# ╔═╡ 0c05825e-7218-11eb-193e-0f96c847a1b4
m = typemax(Int64)

# ╔═╡ 2143fc18-7218-11eb-3fb0-136bf150c890
factorial(19)

# ╔═╡ 5de5d18c-7218-11eb-38dd-49b92c096d94
21 * factorial(20)

# ╔═╡ 6c6b600a-7218-11eb-17ee-451d63345af1
2^2^2^2^2

# ╔═╡ 836688a2-7218-11eb-0ee9-6dbdbe1eab17
Base.checked_add(m, 1)

# ╔═╡ 7a39001e-7218-11eb-02e2-0907e7c79a0c
M = big(m)

# ╔═╡ c07712b6-7218-11eb-3706-0557538f573f
typeof(M)

# ╔═╡ c4cf4e1e-7218-11eb-0fba-fffe7c25eb47
M + 1

# ╔═╡ c8674428-7218-11eb-3789-f3b6b166bd61
big(2)^2^2^2^2

# ╔═╡ dd181384-7218-11eb-2446-d14cef5e84a0
big(2^2^2^2^2)

# ╔═╡ dcf93a2c-7218-11eb-17b8-a5b1ecdaa9a3
md"""
## Defining types
"""

# ╔═╡ dce623c4-7218-11eb-11be-598cc4d47ddd
struct MyRational
	p::Int64  # numerator
	q::Int64  # denominator
end

# ╔═╡ 3de45f32-721a-11eb-20eb-a5031d2ec2e0
r = MyRational(3, 4)

# ╔═╡ 476eddc0-721a-11eb-2d66-c9776dac0e7d
r.p

# ╔═╡ 4989ed52-721a-11eb-326d-5fd1ca1b45a4
r.q

# ╔═╡ 610ddcc2-721a-11eb-3299-05e86dbf6f4d
r2 = MyRational(5, 6)

# ╔═╡ 65ed4160-721a-11eb-1f64-e713eac8f496
r2.p

# ╔═╡ 8060157c-721a-11eb-248b-1162c4d069a7
r.p

# ╔═╡ 8c09d624-721a-11eb-3675-a9452dc3ec23
md"""
How do we add *behaviour* -- i.e. operate on these values
"""

# ╔═╡ a3256986-721a-11eb-0105-1f110db12f0f
r * r2

# ╔═╡ bd7aabc0-721a-11eb-1c5f-c776360de66f
*

# ╔═╡ cf51fc68-721a-11eb-1942-0bc5df86af9f
# Uncomment this to see the list of methods of the `*` function:

# methods(*)

# ╔═╡ d3358e52-721b-11eb-1eea-897faf33eead
function Base.:*(x::MyRational, y::MyRational)

	result = MyRational(x.p * y.p, x.q * y.q)
	
	return result
end

# ╔═╡ 23efa2d8-721c-11eb-1998-5df2b5e0dfda
r, r2

# ╔═╡ 2976f8dc-721c-11eb-1b8c-a1ca976dc3b2
r * r2

# ╔═╡ 331b5cd4-721c-11eb-0301-5f464e821c63
function Base.show(io::IO, x::MyRational)
	print(io, x.p, " / ", x.q)
end

# ╔═╡ 5d8e4a3a-721c-11eb-14a2-1513a0a06f1b
r * r2

# ╔═╡ 61851e7a-721c-11eb-0286-99d9b0b2b383
r

# ╔═╡ 627c0708-721c-11eb-0901-a5c9ee066787
r2

# ╔═╡ 680aa7a6-721c-11eb-2586-5d5493e96875
r * r2

# ╔═╡ 8f76f04a-721c-11eb-15cf-d3c361b8ba26
md"""
## Built-in rationals in Julia: `//`
"""

# ╔═╡ 950614d4-721c-11eb-16c6-ab11313494e8
3 // 4

# ╔═╡ 98416220-721c-11eb-07d1-97ce22c929b1
typeof(3//4)

# ╔═╡ a7f0e79a-721c-11eb-2e83-c39bc8706234
dump(typeof(3//4))  # normal Julia

# ╔═╡ b53ee2bc-721c-11eb-0ce6-85f815ec63c6
Dump(typeof(3//4))

# ╔═╡ c4fdff6c-721c-11eb-04e5-8b73932b2110
b = big(3//4)

# ╔═╡ c9e4ee00-721c-11eb-1cb1-4f14c5aa77cf
Dump(b)  # BigInt is written in C, not Julia

# ╔═╡ dc05c320-721c-11eb-1824-6373a46152cd
md"""
`{`, `}` tell me that the type is a *parametrised type*.
The `Int64` between the curly braces is the type of the fields inside the object.
"""

# ╔═╡ 2864d4ea-721d-11eb-12c6-79c253b03871
md"""
## Calculating with rationals
"""

# ╔═╡ 310e5404-721d-11eb-15d2-b5709c86f8d5
let 
	r = 34 // 56
	
	r^20
end

# ╔═╡ 573928a2-721d-11eb-0f14-6362bbf431bf
let 
	r = big(34 // 56)
	
	r^100, Float64(r^100)
end

# ╔═╡ 6731714c-721d-11eb-3828-f3980c168bf8
md"""
$2.1 \times 10^{-22}$
"""

# ╔═╡ aab41636-721d-11eb-20a5-53346e11ad0e
π 

# ╔═╡ dd0af2d0-721d-11eb-3952-a3a4305bd0e3
typeof(π)

# ╔═╡ e6f96038-721d-11eb-3956-6d8b7d2e2316
exp(1)

# ╔═╡ eb633770-721d-11eb-38a9-cfaa9c9d588b
ℯ

# ╔═╡ f5b393a0-721d-11eb-33be-1541a60fbd45
typeof(ℯ)

# ╔═╡ f8d222d6-721d-11eb-3e5d-274de2f6a7dc
Float64(π)

# ╔═╡ 056c5d72-721e-11eb-2daa-656081f62120
BigFloat(π)

# ╔═╡ 1298a4ba-721e-11eb-1e54-ef2e879149bd
# [3.14, 3.15]

# ╔═╡ 6a23474e-721e-11eb-3d9c-d94846c17a74
md"""
$\pi r^2$
"""

# ╔═╡ 98ece918-721e-11eb-1d4b-3983552f43d1
sin(3//4)

# ╔═╡ 56e1a328-721f-11eb-0096-af78620f3b89
p = big(π)

# ╔═╡ 569dd62a-721f-11eb-2b8a-f9d9605fda2e
precision(p)

# ╔═╡ 6962862a-721f-11eb-170b-e32b06c309bd
setprecision(10)

# ╔═╡ 6ee20f08-721f-11eb-03f1-3785cb090755
big(π)

# ╔═╡ 70918982-721f-11eb-1419-9b0ecbfb37ed
setprecision(10000)

# ╔═╡ 73bb1434-721f-11eb-2e3a-ddf50ba73ff0
BigFloat(π, 10)

# ╔═╡ 89a090da-721f-11eb-28b6-4b46ff9ea687
BigFloat(π, 100)

# ╔═╡ Cell order:
# ╟─eafae420-7215-11eb-33f9-7dca7f1dafc7
# ╟─3a9ca5bc-7217-11eb-2d0a-df53a713ebed
# ╠═d7f3bc26-7215-11eb-1cea-2f4865d3d3f7
# ╠═ea6628bc-7215-11eb-3d91-d106e999e488
# ╠═ff5a3754-7215-11eb-35bf-9b8a3c88611e
# ╠═144be446-7216-11eb-35d9-ef441839207e
# ╠═230e9cb2-7216-11eb-3eb5-8760ceca5099
# ╠═25b4f0f6-7216-11eb-0f72-6fbf71814e27
# ╠═3cd98206-7216-11eb-1913-09b1fdd6b98e
# ╠═533030c2-7216-11eb-057a-7b5f7dd910db
# ╠═5685db96-7216-11eb-0ddb-9bfbc2b4d41c
# ╠═5880a386-7216-11eb-24ed-6592f9dc6853
# ╟─49eee2fa-7217-11eb-2c5f-f34684840392
# ╠═4c246600-7217-11eb-3256-1d1157bc53ff
# ╠═d1ef3eca-7217-11eb-16bf-dfb579f2d282
# ╠═fd0ed656-7217-11eb-1461-119cb83d41ef
# ╠═00bbf1d0-7218-11eb-08bf-5d91b223149b
# ╠═05b0c7a6-7218-11eb-2165-833aeab56165
# ╠═0c05825e-7218-11eb-193e-0f96c847a1b4
# ╠═2143fc18-7218-11eb-3fb0-136bf150c890
# ╠═5de5d18c-7218-11eb-38dd-49b92c096d94
# ╠═6c6b600a-7218-11eb-17ee-451d63345af1
# ╠═836688a2-7218-11eb-0ee9-6dbdbe1eab17
# ╠═7a39001e-7218-11eb-02e2-0907e7c79a0c
# ╠═c07712b6-7218-11eb-3706-0557538f573f
# ╠═c4cf4e1e-7218-11eb-0fba-fffe7c25eb47
# ╠═c8674428-7218-11eb-3789-f3b6b166bd61
# ╠═dd181384-7218-11eb-2446-d14cef5e84a0
# ╟─dcf93a2c-7218-11eb-17b8-a5b1ecdaa9a3
# ╠═dce623c4-7218-11eb-11be-598cc4d47ddd
# ╠═3de45f32-721a-11eb-20eb-a5031d2ec2e0
# ╠═476eddc0-721a-11eb-2d66-c9776dac0e7d
# ╠═4989ed52-721a-11eb-326d-5fd1ca1b45a4
# ╠═610ddcc2-721a-11eb-3299-05e86dbf6f4d
# ╠═65ed4160-721a-11eb-1f64-e713eac8f496
# ╠═8060157c-721a-11eb-248b-1162c4d069a7
# ╟─8c09d624-721a-11eb-3675-a9452dc3ec23
# ╠═a3256986-721a-11eb-0105-1f110db12f0f
# ╠═bd7aabc0-721a-11eb-1c5f-c776360de66f
# ╠═cf51fc68-721a-11eb-1942-0bc5df86af9f
# ╠═d3358e52-721b-11eb-1eea-897faf33eead
# ╠═23efa2d8-721c-11eb-1998-5df2b5e0dfda
# ╠═2976f8dc-721c-11eb-1b8c-a1ca976dc3b2
# ╠═331b5cd4-721c-11eb-0301-5f464e821c63
# ╠═5d8e4a3a-721c-11eb-14a2-1513a0a06f1b
# ╠═61851e7a-721c-11eb-0286-99d9b0b2b383
# ╠═627c0708-721c-11eb-0901-a5c9ee066787
# ╠═680aa7a6-721c-11eb-2586-5d5493e96875
# ╟─8f76f04a-721c-11eb-15cf-d3c361b8ba26
# ╠═950614d4-721c-11eb-16c6-ab11313494e8
# ╠═98416220-721c-11eb-07d1-97ce22c929b1
# ╠═a7f0e79a-721c-11eb-2e83-c39bc8706234
# ╠═bb27bee2-721c-11eb-07d9-4b5d1ac0005c
# ╠═b53ee2bc-721c-11eb-0ce6-85f815ec63c6
# ╠═c4fdff6c-721c-11eb-04e5-8b73932b2110
# ╠═c9e4ee00-721c-11eb-1cb1-4f14c5aa77cf
# ╟─dc05c320-721c-11eb-1824-6373a46152cd
# ╟─2864d4ea-721d-11eb-12c6-79c253b03871
# ╠═310e5404-721d-11eb-15d2-b5709c86f8d5
# ╠═573928a2-721d-11eb-0f14-6362bbf431bf
# ╟─6731714c-721d-11eb-3828-f3980c168bf8
# ╠═aab41636-721d-11eb-20a5-53346e11ad0e
# ╠═dd0af2d0-721d-11eb-3952-a3a4305bd0e3
# ╠═e6f96038-721d-11eb-3956-6d8b7d2e2316
# ╠═eb633770-721d-11eb-38a9-cfaa9c9d588b
# ╠═f5b393a0-721d-11eb-33be-1541a60fbd45
# ╠═f8d222d6-721d-11eb-3e5d-274de2f6a7dc
# ╠═056c5d72-721e-11eb-2daa-656081f62120
# ╠═1298a4ba-721e-11eb-1e54-ef2e879149bd
# ╠═6a23474e-721e-11eb-3d9c-d94846c17a74
# ╠═98ece918-721e-11eb-1d4b-3983552f43d1
# ╠═56e1a328-721f-11eb-0096-af78620f3b89
# ╠═569dd62a-721f-11eb-2b8a-f9d9605fda2e
# ╠═6962862a-721f-11eb-170b-e32b06c309bd
# ╠═6ee20f08-721f-11eb-03f1-3785cb090755
# ╠═70918982-721f-11eb-1419-9b0ecbfb37ed
# ╠═73bb1434-721f-11eb-2e3a-ddf50ba73ff0
# ╠═89a090da-721f-11eb-28b6-4b46ff9ea687
