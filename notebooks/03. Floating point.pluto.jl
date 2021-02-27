### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 1d2a3bb4-7609-11eb-1705-41d4ada5aeaf
using Plots   # Pkg.add("Plots")

# ╔═╡ 3601117e-7559-11eb-0973-690bf5447dce


# ╔═╡ 21be88f0-755a-11eb-07de-1d8266ae07e6
const space = HTML("<span>&nbsp;</span>")

# ╔═╡ ebe2d872-7558-11eb-3f9a-7715c4672749
color(text, col) = HTML("<span style='color: $(col)'>$(text)</span>")

# ╔═╡ ff28db8c-7558-11eb-27a8-996a39b1ab3b
color("3", "red")

# ╔═╡ 701f8a48-7559-11eb-2c8e-99fac662d406


# ╔═╡ 7dc31454-7558-11eb-1b9d-9f9a757784d9
function display_float(sign, exponent, mantissa)

	return md"""
	Bits: $(space) $(color(sign, "black")) | $(color(exponent, "green")) | $(color(mantissa, "blue"))
	"""
	
end

# ╔═╡ 0d3d7c6c-755b-11eb-170b-65fb1dc8ff2a
begin
	widths(::typeof(Float32)) = (1, 8, 23)
	widths(::typeof(Float64)) = (1, 11, 52)
end

# ╔═╡ 995e7d24-7559-11eb-027a-9dff8660c276
function display_float(x::AbstractFloat)
	s = bitstring(x)
	
	w = cumsum(widths(typeof(x)))
	
	md"""
	Value: $x
	$(display_float(s[1:1], s[2:w[2]], s[w[2]+1:end]))
	
	Sign: $(s[1] == '0' ? "+" : "-"); 
	$(space) exponent: $(exponent(x)); 
	$(space) mantissa: $(abs(significand(x)))
	"""
end

# ╔═╡ e3b445d0-7607-11eb-0532-07a8b18bed96
md"""
## Dissecting floats
"""

# ╔═╡ 833a8eb0-755a-11eb-0701-f5059354d11a
significand(1.5)

# ╔═╡ 87d1f2f6-755a-11eb-091a-c9032fe83a37


# ╔═╡ ad4a789c-7559-11eb-12f3-2550677ef00a
display_float(-3.17)

# ╔═╡ 754e83b4-755b-11eb-0dbb-fd128a031dc2
display_float(-3.17f0)

# ╔═╡ 76046bba-760b-11eb-2bff-d7df9a186763
typeof(-3.17f0)

# ╔═╡ d1c6f916-7559-11eb-28a3-53f0a29880d7
bitstring(1.3)[1:1]

# ╔═╡ db1832ec-7607-11eb-105f-e79757c73fd0
md"""
## Spacing of floats
"""

# ╔═╡ 7792a3f4-7609-11eb-1184-b5aef9729671
x = Float16(1.0)

# ╔═╡ 7b4fd836-7609-11eb-0fa0-f779c29d135f
nextfloat(x)

# ╔═╡ 970804c2-7609-11eb-04f4-71f8de652f87
xs = [x]   # 1D array -- vector

# ╔═╡ a0339700-7609-11eb-1fbe-f14f2294c28f
typeof(xs)

# ╔═╡ b6f948d6-7609-11eb-1609-9750b06cb55a
xs

# ╔═╡ dc6b7972-7609-11eb-0acd-85d7aa3b4bcd
push!(xs, 37)

# ╔═╡ e211c584-7609-11eb-0762-ad950685d9b2
xs

# ╔═╡ e87aad98-7607-11eb-3bb1-6dfd80673e4e
function all_floats(n)

	x = Float16(1.0)   # local variable
	data = [x]   # 1D array -- vector
	
	for i in 1:n
	    x = nextfloat(x)
	    
		push!(data, x)   # extend the vector xs with the current value of x
	end
	
	return data
	
end

# ╔═╡ fba70306-7609-11eb-19b3-fb7aea66cbb3
let   # make local variables inside a cell
	data = all_floats(100)
	scatter(data, legend=false)   # no x coordinates -- uses 1, 2, 3, 4
end

# ╔═╡ 380cdbcc-760a-11eb-15f6-775cdee9d8ab
diff(data)   # differences between consecutive data

# ╔═╡ 7704b156-760a-11eb-3391-afb5f75bd698
let
	data = all_floats(1000)
	scatter(data, legend=false)   # no x coordinates -- uses 1, 2, 3, 4
end

# ╔═╡ 99cd736c-760a-11eb-0938-4d298185818e
let
	data = all_floats(3000)
	scatter(data, legend=false)   # no x coordinates -- uses 1, 2, 3, 4
end

# ╔═╡ 30c42c2a-760b-11eb-3cc3-51b7c522110a
y = 1.5

# ╔═╡ 348e060a-760b-11eb-20f3-9da5a9cd14ae
bitstring(y)

# ╔═╡ b3c2511a-760b-11eb-3f40-cfc96705d1ad
eps(1.0)

# ╔═╡ b92e6756-760b-11eb-0cc4-01dc04bba61e
nextfloat(1.0) - 1.0

# ╔═╡ bdeba7fe-760b-11eb-2b67-9f1589dbafa9
eps(2.0)

# ╔═╡ d24966be-760b-11eb-0584-8d7a8c5e5443
2.0^(-52)

# ╔═╡ e1cbf7b4-760b-11eb-3804-3f987860195c
log10(2.0^52)


# ╔═╡ f7a08690-760b-11eb-0074-97c61f722549
1.0

# ╔═╡ fa38ff9a-760b-11eb-33c2-3fca30cdcac0
nextfloat(1.0)

# ╔═╡ 3c2bb6cc-760c-11eb-0c18-691f9d7207aa
0.1 + 0.3

# ╔═╡ 491b8556-760c-11eb-242e-ad453ac25876
0.1 == 1//10

# ╔═╡ 71b88c5c-760c-11eb-332c-d778693f1cba
0.1

# ╔═╡ 7fed0776-760c-11eb-03df-97b6942485d9
big(0.1)

# ╔═╡ 8ccc0f32-760c-11eb-2017-e73e67c52ecb
z = 0.1   # this gives a floating-point number

# ╔═╡ 931d54e8-760c-11eb-38d2-ad82394d00e5
bitstring(0.1)

# ╔═╡ 9695e9c0-760c-11eb-330f-bb13cb398bc3
display_float(0.1)

# ╔═╡ c0b20fb8-760c-11eb-1077-7d47268f9fc4
1/11

# ╔═╡ Cell order:
# ╠═3601117e-7559-11eb-0973-690bf5447dce
# ╠═21be88f0-755a-11eb-07de-1d8266ae07e6
# ╠═ebe2d872-7558-11eb-3f9a-7715c4672749
# ╠═ff28db8c-7558-11eb-27a8-996a39b1ab3b
# ╠═701f8a48-7559-11eb-2c8e-99fac662d406
# ╠═7dc31454-7558-11eb-1b9d-9f9a757784d9
# ╠═0d3d7c6c-755b-11eb-170b-65fb1dc8ff2a
# ╠═995e7d24-7559-11eb-027a-9dff8660c276
# ╟─e3b445d0-7607-11eb-0532-07a8b18bed96
# ╠═833a8eb0-755a-11eb-0701-f5059354d11a
# ╠═87d1f2f6-755a-11eb-091a-c9032fe83a37
# ╠═ad4a789c-7559-11eb-12f3-2550677ef00a
# ╠═754e83b4-755b-11eb-0dbb-fd128a031dc2
# ╠═76046bba-760b-11eb-2bff-d7df9a186763
# ╠═d1c6f916-7559-11eb-28a3-53f0a29880d7
# ╟─db1832ec-7607-11eb-105f-e79757c73fd0
# ╠═1d2a3bb4-7609-11eb-1705-41d4ada5aeaf
# ╠═7792a3f4-7609-11eb-1184-b5aef9729671
# ╠═7b4fd836-7609-11eb-0fa0-f779c29d135f
# ╠═970804c2-7609-11eb-04f4-71f8de652f87
# ╠═a0339700-7609-11eb-1fbe-f14f2294c28f
# ╠═b6f948d6-7609-11eb-1609-9750b06cb55a
# ╠═dc6b7972-7609-11eb-0acd-85d7aa3b4bcd
# ╠═e211c584-7609-11eb-0762-ad950685d9b2
# ╠═e87aad98-7607-11eb-3bb1-6dfd80673e4e
# ╠═fba70306-7609-11eb-19b3-fb7aea66cbb3
# ╠═380cdbcc-760a-11eb-15f6-775cdee9d8ab
# ╠═7704b156-760a-11eb-3391-afb5f75bd698
# ╠═99cd736c-760a-11eb-0938-4d298185818e
# ╠═30c42c2a-760b-11eb-3cc3-51b7c522110a
# ╠═348e060a-760b-11eb-20f3-9da5a9cd14ae
# ╠═b3c2511a-760b-11eb-3f40-cfc96705d1ad
# ╠═b92e6756-760b-11eb-0cc4-01dc04bba61e
# ╠═bdeba7fe-760b-11eb-2b67-9f1589dbafa9
# ╠═d24966be-760b-11eb-0584-8d7a8c5e5443
# ╠═e1cbf7b4-760b-11eb-3804-3f987860195c
# ╠═f7a08690-760b-11eb-0074-97c61f722549
# ╠═fa38ff9a-760b-11eb-33c2-3fca30cdcac0
# ╠═3c2bb6cc-760c-11eb-0c18-691f9d7207aa
# ╠═491b8556-760c-11eb-242e-ad453ac25876
# ╠═71b88c5c-760c-11eb-332c-d778693f1cba
# ╠═7fed0776-760c-11eb-03df-97b6942485d9
# ╠═8ccc0f32-760c-11eb-2017-e73e67c52ecb
# ╠═931d54e8-760c-11eb-38d2-ad82394d00e5
# ╠═9695e9c0-760c-11eb-330f-bb13cb398bc3
# ╠═c0b20fb8-760c-11eb-1077-7d47268f9fc4
