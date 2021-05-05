### A Pluto.jl notebook ###
# v0.14.4

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

# ╔═╡ 2b81aab8-0bbf-4295-9028-7e80da05b193
using FFTW, Plots, PlutoUI

# ╔═╡ 51d71150-acea-11eb-0fe5-2f1421e80ccd
md"""
## Fourier coefficients of a function using the FFT
"""

# ╔═╡ 2c096e23-674a-4c3b-8234-cdc69b81fdc2
md"""
Example from Driscoll & Braun, *Fundamentals of Numerical Computation*, pg. 388
"""

# ╔═╡ f2173a0c-9374-4e34-b677-805ff0574a29
md"""
Approximate

$$f(x) = \sum_{k=-n}^{n} c_k e^{i k \pi x}$$

for a function $f$ with period 2.
"""

# ╔═╡ 58d84fdd-0af7-4947-bf27-f438bbc84aad
md"""
Define the nodes at which to sample our function:
"""

# ╔═╡ 031e7fb7-1593-4358-8474-dc6ef2427026
begin
	n = 15
	N = 2n + 1
end

# ╔═╡ 7090fab4-b213-48b9-a5c4-7055c46ff329
xs = 2 .* (0:N-1) ./ N

# ╔═╡ 0851c19e-8515-4210-9a89-f32ebb1a8903
md"""
Sample a periodic function:
"""

# ╔═╡ 35bc9ef6-5dad-4cf6-92ae-b9e2911e1711
# f(x) = exp(sin(pi * x))

f(x) = abs(sin(pi * x))


# ╔═╡ 07db031d-6dd6-4ce6-bcbb-953290fc36ca
plot(f, size=(400, 300), leg=false)

# ╔═╡ 2228bf91-d73c-4db1-b2b4-0153e5efd733
ys = f.(xs)

# ╔═╡ 4003a314-c75e-4e64-8c47-7ab600f8e3f9
scatter(xs, ys, size=(400, 300), leg=false, m=:o)

# ╔═╡ 431bcc32-b6eb-4923-906a-7ec2453e2539
md"""
Take the FFT:
"""

# ╔═╡ ca2f92b7-03e4-4fe8-93b1-d3aa89b166f7
cs = fft(ys) ./ N

# ╔═╡ 057a1780-bf12-4470-8781-088765849162
md"""
The resulting coefficients $c_k$ are returned in a particular order:
"""

# ╔═╡ 0360a8b2-c33f-4e21-98f0-5432d3410b0c
ks = [0:n; -n:-1]

# ╔═╡ 46057794-4771-4dfa-bb9b-b47c7a6ea537
md"""
Plot the magnitude of the Fourier coefficients:
"""

# ╔═╡ 8f58ba62-572c-49f2-98e9-9be5c9e032e7
scatter(ks, abs.(cs), size=(400, 300))

# ╔═╡ 2fe2c843-2cdc-4ecd-aa95-5d5125fd148b
scatter(ks, abs.(cs), size=(400, 300), yscale=:log10, leg=false, xlabel="k")

# ╔═╡ e6934165-44b6-41d2-b7f8-4dd7de84b33f
begin
	scatter(abs.(ks[N÷2+2:end]), abs.(cs[N÷2+2:end]), size=(400, 300), scale=:log10, leg=false, xlabel="k")
	
	plot!(k -> k^(-2))
end

# ╔═╡ 222ea199-3ac3-47d3-b2a5-d270e44410bd
plot(x -> x^2)

# ╔═╡ f66d6ccc-ee97-4ac4-b784-f4a0ec1e58f2
md"""
Sum the series
"""

# ╔═╡ c1f690e7-01a8-4ce6-88d9-21f151bfd48b
md"""
Reconstruct the Fourier series:
"""

# ╔═╡ 93976d78-e17c-4ea6-90f0-424ceff2614d
reconstructed(x, n) = sum(cs[j] * exp(im * ks[j] * pi * x) for j in 1:length(cs) if abs(ks[j]) < n)

# ╔═╡ b58ac578-0387-4288-a063-14b76005eaa6
md"""
m = $(@bind m Slider(1:n, show_value=true, default=1))
"""

# ╔═╡ 135730bc-8465-4c98-bc4c-810766746dc0
begin
	plot(f, size=(400, 300), label="original")
	plot!(x -> real(reconstructed(x, m)), label="sum up to n=$(m-1)")
	ylims!(0, 3)
end

# ╔═╡ 4cd7e5a0-3d51-4930-9da0-aa86675fe5e8
f(1.5)

# ╔═╡ 572bee53-c944-4ae9-b933-7f06837375a7
ks

# ╔═╡ Cell order:
# ╠═2b81aab8-0bbf-4295-9028-7e80da05b193
# ╟─51d71150-acea-11eb-0fe5-2f1421e80ccd
# ╟─2c096e23-674a-4c3b-8234-cdc69b81fdc2
# ╟─f2173a0c-9374-4e34-b677-805ff0574a29
# ╟─58d84fdd-0af7-4947-bf27-f438bbc84aad
# ╠═031e7fb7-1593-4358-8474-dc6ef2427026
# ╠═7090fab4-b213-48b9-a5c4-7055c46ff329
# ╟─0851c19e-8515-4210-9a89-f32ebb1a8903
# ╠═35bc9ef6-5dad-4cf6-92ae-b9e2911e1711
# ╠═07db031d-6dd6-4ce6-bcbb-953290fc36ca
# ╠═2228bf91-d73c-4db1-b2b4-0153e5efd733
# ╠═4003a314-c75e-4e64-8c47-7ab600f8e3f9
# ╟─431bcc32-b6eb-4923-906a-7ec2453e2539
# ╟─ca2f92b7-03e4-4fe8-93b1-d3aa89b166f7
# ╟─057a1780-bf12-4470-8781-088765849162
# ╠═0360a8b2-c33f-4e21-98f0-5432d3410b0c
# ╟─46057794-4771-4dfa-bb9b-b47c7a6ea537
# ╠═8f58ba62-572c-49f2-98e9-9be5c9e032e7
# ╠═2fe2c843-2cdc-4ecd-aa95-5d5125fd148b
# ╠═e6934165-44b6-41d2-b7f8-4dd7de84b33f
# ╠═222ea199-3ac3-47d3-b2a5-d270e44410bd
# ╟─f66d6ccc-ee97-4ac4-b784-f4a0ec1e58f2
# ╟─c1f690e7-01a8-4ce6-88d9-21f151bfd48b
# ╠═93976d78-e17c-4ea6-90f0-424ceff2614d
# ╟─b58ac578-0387-4288-a063-14b76005eaa6
# ╟─135730bc-8465-4c98-bc4c-810766746dc0
# ╠═4cd7e5a0-3d51-4930-9da0-aa86675fe5e8
# ╠═572bee53-c944-4ae9-b933-7f06837375a7
