### A Pluto.jl notebook ###
# v0.14.3

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

# ╔═╡ d4b034ac-a75f-11eb-3862-3dc827383b51
using Plots, PlutoUI

# ╔═╡ 811bb210-d4ea-482f-845f-d57d4e31b7d5
md"""
# Understanding the modified Euler method
"""

# ╔═╡ 87010a6e-1afe-4537-b6c6-7ff24c709bc9
md"""
The modified Euler method is one of the simplest Runge--Kutta methods. It uses two Euler steps to approximate the true solution of a differential equation to second order, i.e. it reproduces the Taylor expansion of the true solution to 2nd order.
"""

# ╔═╡ 1f49863b-5c7b-48d9-8aa8-8a957ec32508
md"""
Let's see visually how this works.
"""

# ╔═╡ c6f68673-b947-48ad-8972-01bf298e5d5a
"""Straight line through (x0, y0) with slope m is

y - y0 = m * (x - x0)

Returns a function of x
"""
line(x0, y0, m) = x -> y0 + m * (x - x0)

# ╔═╡ 3bd6185a-66e8-4407-a73c-96d7f87372d1
md"""
Let's try to solve $\dot{x} = 2x$ with $x(t=0) = 1$.

The exact solution of this ODE is $x(t) = \exp(2t)$.
"""

# ╔═╡ 5aae6c6d-f7f3-46c5-82bd-2c0309c7a3ce
plots = []

# ╔═╡ 4edc9965-2270-46f6-9994-7ea12c547dce
p1 = plot(0:0.01:2, t -> exp(2t), xlabel="t", ylims=(0, 50), size=(500, 300), label="exact", leg=:topleft)

# ╔═╡ 1d18b02d-cc95-418a-801c-7308c9e11eba
md"""
Let's suppose that we start at $t_0=1$. The true $x$ value there is
"""

# ╔═╡ ef7ed38d-8fea-4b06-8965-7237482a98f1
begin
	t₀ = 1.0
	x₀ = exp(2t₀)
end

# ╔═╡ 41d5a2fa-1861-4a2e-bf05-bf4626db734b
md"""
Let's take an Euler step with width $h=0.25$.
"""

# ╔═╡ 7e4edb55-188d-48e6-9bf4-67acbb054f75
h = 0.25

# ╔═╡ 3611134d-33d6-4ff0-84ca-5ef69c927810
md"""
The right-hand side of the ODE is 
"""

# ╔═╡ 1d0fa1d5-7ef8-4c74-877c-a56af595f5e1
f(x) = 2x

# ╔═╡ 88a82583-4880-4839-8534-dfc7440280fb
md"""
So the initial slope at $t_0$ is 
"""

# ╔═╡ ceaa52a7-d8db-44ed-9ee7-ed928ea305bb
k₁ = f(x₀)

# ╔═╡ 2b367226-3426-405d-bf01-4e9af33ade33
begin
	p2 = deepcopy(p1)

	plot!(p2, line(t₀, x₀, k₁), ls=:dash, label="Euler 1", leg=:topleft)
	scatter!(p2, [t₀], [x₀], label="initial condition")
end

# ╔═╡ a792d609-0adc-4088-a0d3-07d43685fef6
md"""
The new $x$ value after this Euler step is
"""

# ╔═╡ c074f87e-8371-4462-afad-f87358ddb898
x_new = x₀ + h * k₁

# ╔═╡ dc8db7b5-0108-4161-ad6d-13c14703f5c6
begin
	p3 = deepcopy(p2)
	
	scatter!(p3, [t₀ + h], [x₀ + h * k₁], label="end of Euler 1")
	
	xlims!(p3, 0.75, 1.5)
	ylims!(p3, 5, 15)
end

# ╔═╡ 0246c40a-1aab-4f65-8b06-319a5a003b59
md"""
Now we evaluate $f$ again at this *new value of $x$*. This gives us a *new estimate of the slope*, $k_2$.
"""

# ╔═╡ 3ae2f465-aa5f-414d-8a8c-68a08486781f
k₂ = f(x_new)

# ╔═╡ 2938819c-ec2e-4d63-af83-2d602fd3ff4c
begin
	p4 = deepcopy(p3)
	
	plot!(p4, line(t₀ + h, x_new, k₂), ls=:dash, label="new slope")
end

# ╔═╡ 0c43b263-fa81-4eb0-a4f6-9456a44e2921
md"""
Note that we are evaluating the slope *of a different curve*! The first Euler step moved us *away* from the original curve, onto a new solution curve of the same ODE (which corresponds to a *different* initial condition). Nonetheless, the slope we are evaluating now (using the same ODE) should be *close to* the true slope of the original solution curve.
"""

# ╔═╡ 9077491f-1df9-4d36-ac06-3dce1ba9daae
md"""
We now have two slopes, $k_1$ and $k_2$. The modified Euler method takes the *mean* of these two slopes and does a full Euler step of width $h$ using that mean as a slope:
"""

# ╔═╡ bcd74957-9850-4205-a27b-b8cafad731b8
k = (k₁ + k₂) / 2

# ╔═╡ 2f38c66b-6cc8-4ec2-a3ec-1741dcecf95c
begin
	p5 = deepcopy(p4)
	
	plot!(p5, line(t₀, x₀, k), ls=:dot, lw=2, label="Euler 2")
	scatter!([t₀ + h], [x₀ + h * k], label="end of Euler 2")

	xlims!(p5, 0.75, 1.5)
	ylims!(p5, 5, 15)
end

# ╔═╡ fb179af2-d4ca-4c72-aed6-c82955852ae2
md"""
We see visually that the result is much closer to the true solution, since we have shown that this method approximates the original curve using an order-2 Taylor expansion.

In fact we can calculate the order-2 Taylor expansion of the exact solution around $t_0 = 1$:
"""

# ╔═╡ f0609b9a-ff21-46f6-86da-f00d3cd523b6
md"""
Let's call the exact solution $\phi(t) = \exp(2t)$. Let $s$ be the distance $t-t_0$. Then we want to expand $\phi(t_0 + s)$ in powers of $s$:
"""

# ╔═╡ a72378c0-c98e-48f4-95a8-7f77537496a0
md"""
$$\phi(t_0 + s) = \phi(t_0) + s \, \phi'(t_0) + \textstyle \frac{1}{2} s^2 \, \phi''(t_0) + \cdots$$
"""

# ╔═╡ a394e58a-c134-4c89-906a-9302a5602ce1
md"""
So 

$$\phi(t_0 + s) = \exp(2t_0) + 2s \, \exp(2t_0) + \textstyle 4 \cdot \frac{1}{2} s^2 \,  \exp(2t_0)$$
"""

# ╔═╡ 35476ff2-bba5-43f4-b02b-9167b7da40e3
md"""
Note that $\exp(2t_0)$ is $x_0$. Hence the Taylor expansion to 2nd order is

$$\phi(t_0 + s) \simeq x_0 ( 1 + 2s + 2s^2 )$$

In other words

$$\phi(t) \simeq x_0 [ 1 + 2(t - t_0) + 2(t - t_0)^2 ]$$


"""

# ╔═╡ 81950a2b-65fa-408b-af87-b44b88675b8a
begin
	p6 = deepcopy(p5)
	
	plot!(p6, t -> x₀ * (1 + 2*(t - t₀) + 2*(t - t₀)^2), label="Taylor to order 2")
end

# ╔═╡ 618bbe6e-7906-4468-ad70-0d661bee4700
md"""
## Run back and forth between the different plots
"""

# ╔═╡ d8fb2d27-3dc1-4923-b281-d2a7f9d9c8b0
all_plots = [p1, p2, p3, p4, p5, p6]

# ╔═╡ 7d5a735b-97a5-4636-a8ca-2bc67c9846c7
md"""
which plot = $(@bind plot_i Slider(1:length(all_plots), show_value=true))
"""

# ╔═╡ 202bf207-983e-4ebd-aa20-86111eeff1a9
plot(all_plots[plot_i])

# ╔═╡ Cell order:
# ╠═d4b034ac-a75f-11eb-3862-3dc827383b51
# ╟─811bb210-d4ea-482f-845f-d57d4e31b7d5
# ╟─87010a6e-1afe-4537-b6c6-7ff24c709bc9
# ╟─1f49863b-5c7b-48d9-8aa8-8a957ec32508
# ╠═c6f68673-b947-48ad-8972-01bf298e5d5a
# ╟─3bd6185a-66e8-4407-a73c-96d7f87372d1
# ╠═5aae6c6d-f7f3-46c5-82bd-2c0309c7a3ce
# ╠═4edc9965-2270-46f6-9994-7ea12c547dce
# ╟─1d18b02d-cc95-418a-801c-7308c9e11eba
# ╠═ef7ed38d-8fea-4b06-8965-7237482a98f1
# ╟─41d5a2fa-1861-4a2e-bf05-bf4626db734b
# ╠═7e4edb55-188d-48e6-9bf4-67acbb054f75
# ╟─3611134d-33d6-4ff0-84ca-5ef69c927810
# ╠═1d0fa1d5-7ef8-4c74-877c-a56af595f5e1
# ╟─88a82583-4880-4839-8534-dfc7440280fb
# ╠═ceaa52a7-d8db-44ed-9ee7-ed928ea305bb
# ╠═2b367226-3426-405d-bf01-4e9af33ade33
# ╟─a792d609-0adc-4088-a0d3-07d43685fef6
# ╠═c074f87e-8371-4462-afad-f87358ddb898
# ╠═dc8db7b5-0108-4161-ad6d-13c14703f5c6
# ╟─0246c40a-1aab-4f65-8b06-319a5a003b59
# ╠═3ae2f465-aa5f-414d-8a8c-68a08486781f
# ╠═2938819c-ec2e-4d63-af83-2d602fd3ff4c
# ╟─0c43b263-fa81-4eb0-a4f6-9456a44e2921
# ╟─9077491f-1df9-4d36-ac06-3dce1ba9daae
# ╠═bcd74957-9850-4205-a27b-b8cafad731b8
# ╠═2f38c66b-6cc8-4ec2-a3ec-1741dcecf95c
# ╟─fb179af2-d4ca-4c72-aed6-c82955852ae2
# ╟─f0609b9a-ff21-46f6-86da-f00d3cd523b6
# ╟─a72378c0-c98e-48f4-95a8-7f77537496a0
# ╟─a394e58a-c134-4c89-906a-9302a5602ce1
# ╟─35476ff2-bba5-43f4-b02b-9167b7da40e3
# ╠═81950a2b-65fa-408b-af87-b44b88675b8a
# ╟─618bbe6e-7906-4468-ad70-0d661bee4700
# ╠═d8fb2d27-3dc1-4923-b281-d2a7f9d9c8b0
# ╟─7d5a735b-97a5-4636-a8ca-2bc67c9846c7
# ╠═202bf207-983e-4ebd-aa20-86111eeff1a9
