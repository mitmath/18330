### A Pluto.jl notebook ###
# v0.14.1

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

# ╔═╡ 73c21295-6a80-47ab-9f2a-a30a0db098fb
using LinearAlgebra, Plots

# ╔═╡ 56758636-7209-11eb-3f8f-f99a6aec934b
md"""
# Problem set 9

## 18.330 Spring 2021
"""

# ╔═╡ 8ad1bd54-791f-11eb-2127-6d180e178d93
md"""
## Your name: 

### Instructions

- Figures should be plotted using the `Plots.jl` package, and interactive visualizations made with `@bind` from the PlutoUI package.

- You should create as many functions with suitable names as necessarry to make your code readable and re-usable.

- Anything in your algorithm that is not obvious from the code should be briefly commented. Use better variable names to reduce the need for comments. Remember that longer names may be filled in using tab-completion (i.e. pressing the `<TAB>` key after writing the start of the word).

- Use a single blank line to separate parts of your functions, e.g. initialization from the main loop.

- Submit on Canvas by **Saturday, 1st May 2021** at **11:59pm EDT**. 
"""

# ╔═╡ f97fa7ec-3ab2-444d-b257-45e4cca8f4b8
md"""

### Exercise 1: Barycentric Lagrange interpolation


In this exercise we will implement barycentric Lagrange interpolation using the formulas from [lecture 15](https://github.com/mitmath/18330/blob/spring21/lectures/15.%20Polynomial%20interpolation.pdf).
"""

# ╔═╡ f89eae50-34d8-4fd1-8626-c7ac12c41049
md"""
1. Given a vector of nodes $x_i$, write a function `weights` to calculate the weights for barycentric Lagrange interpolation. 

   Hint: Do as few divisions as possible, since divisions are expensive.

"""

# ╔═╡ 7e233414-39f6-4d4c-a44b-de77e0a13751


# ╔═╡ 4aaf8052-889c-4ffd-b7ae-56e4ba0c80d5
md"""
2. Write a function `interpolate` to calculate the barycentric Lagrange interpolant for the data $y_i$ at the nodes $x_i$. It should accept vectors `nodes`, `data` and `weights`, and a point $x$ at which to evaluate the interpolant.
"""

# ╔═╡ afacd497-ab79-44a5-9ba1-eb028d817dc9


# ╔═╡ 759fefe4-34f9-41a7-b75b-77f019e92efc
md"""

3. Calculate the Lagrange interpolant to the function $\exp(x)$, sampled at $N + 1$ equally spaced points in the interval $[-1, 1]$. 

   Make a plot of the interpolant over this interval when $N = 10$. Also add a plot of $\exp(x)$ using the built-in function and a scatter plot of the interpolating points. Do you see what you expect?
"""

# ╔═╡ e9e056d1-4296-4c48-a045-d12660838f97


# ╔═╡ f81f2834-cea0-4504-b513-514df7fb1a30
md"""
4. Calculate numerically and plot the error in the interpolant compared to the function $\exp(x)$ by sampling at, say, 100 points in the interval and taking the maximum error.

   How does the error vary with the degree $N$ of the interpolant? Use $N$ up to, say, 30.

   Note that the points at which we interpolated and the points where we later calculate / sample the interpolant (interpolating function) are *not* the same in general.

"""

# ╔═╡ 74575a12-11ae-41ba-8966-289ab963c5de


# ╔═╡ 546a4069-9586-4e83-8729-1f76c90b0170
md"""

5. Use your code to interpolate the Runge function $f(x) = \frac{1}{1 + 25x^2}$ on the interval $[-1, +1]$. What happens as you increase the number $N$ of equally-spaced points at which you interpolate? This is known as the **Runge phenomenon**.

   Make an interactive visualization of the original function, the points where you are interpolating, and the interpolant.
"""

# ╔═╡ 0c37a0ba-c609-4a38-b86c-a6d91f1f9c16


# ╔═╡ 536d7b4f-b02c-4814-9f35-2ecc4d252545
md"""
6. Now interpolate the Runge function instead at the **Chebyshev points**, given by $x_i := \cos(\theta_i)$, where $\theta_i$ are equally-spaced angles between $0$ and $\pi$. (Note that the $x_i$ also span the interval $[-1, +1]$.)

   Make an interactive visualization. 
"""

# ╔═╡ 36c98986-c4a6-4c89-b8fe-b29c09f2406c


# ╔═╡ 0754e7cf-b824-4ce8-a632-5a5bb1a0d87e
md"""
7. Calculate numerically and plot the distance between the interpolant and the true function as the number of Chebyshev points increases. How fast does it seem to be converging? 

"""

# ╔═╡ e4ecbe33-3a11-44e9-9d64-b5c1e6df7596


# ╔═╡ 54e9881d-660e-40d9-b529-d8f43ae9c073
md"""
8. Do the same for the function $x \mapsto \sin(2\pi x)$ on the same interval. Now how fast is the convergence?
"""

# ╔═╡ a1b9ba6c-c8d4-4cdf-9f78-2c364e834e59


# ╔═╡ 99704a91-7351-4d3a-b16e-575240237eea
md"""

### Exercise 2: Using interpolation to derive finite-difference and quadrature rules

In this problem we will use interpolation to derive finite-difference and quadrature rules, namely **Simpson’s rule**, the second-order Newton--Cotes rule.
"""

# ╔═╡ 5ef7115a-1102-4525-a4b7-80c1f38626b6
md"""
Consider a function $f$ and an interval $[a, b]$. Let $m$ be the midpoint of the interval. We will also use equally-spaced nodes $x_k$ with spacing $h$.
"""

# ╔═╡ 1feef08b-b3f0-4bee-99b5-a5db24135d67
md"""
1. Use Lagrange interpolation to find an analytical expression for the unique quadratic polynomial that passes through the three points $(a, f(a))$, $(m, f(m))$ and $(b, f(b))$.
"""

# ╔═╡ 32e0e1a9-f0df-4c43-afbf-a36f677a0dc6


# ╔═╡ 70f68146-0cf3-4511-996c-2e2bde4355c1
md"""
2. Which approximation does this give for the second derivative $f''(x_k)$ in terms of the nodes $x_{k-1}$, $x_k$ and $x_{k+1}$?
"""

# ╔═╡ 3e577c55-7418-4d9a-88a9-58896fdfa01d


# ╔═╡ 134dd6dc-9bae-4ae9-868b-bae667ec2635
md"""
3. Find a backward-difference approximation for $f'(x_k)$ using the nodes $x_{k-2}$, $x_{k-1}$ and $x_k$.
"""

# ╔═╡ caf4cff6-383b-43ed-b02e-a85298bc4991


# ╔═╡ a285cded-7eae-41f8-9f43-ff96b15c31b4
md"""
4. Find an approximation to the integral $\int_{a}^b f(x) \, \mathrm{d} x$ by integrating the approximating polynomial. Leave your result in terms of $f(a)$, $f(b)$ and $f(m)$. This is Simpson's basic rule.
"""

# ╔═╡ 22110492-31ed-486c-9b05-1c93a22b2bd6


# ╔═╡ c510138f-f528-40d6-ac65-641ceee15925
md"""
5. [Extra credit] If the interval $[a, b]$ is split into $N$ equal sub-intervals, find an expression for the approximation to the integral $\int_a^b f(x) \, \mathrm{d}x$ given by summing up Simpson approximations on each sub-interval. You may assume that $N$ is even if that is helpful. How many evaluations of $f$ are required?  
"""

# ╔═╡ 3859e498-6940-4f53-b2fc-e6598b726dcc


# ╔═╡ e8be0cc8-b876-4e6b-a3bf-fd5697201cba
md"""
### Exercise 3: Using Newton--Cotes methods

1. Implement the 0th (rectangle) and 1st (trapezoid)-order Newton--Cotes quadrature rules for integrating an arbitrary function over the interval $[a, b]$ with $N$ sub-intervals (so-called "composite rules"). Each should be a single function like `rectangle(f, a, b, N)`.
"""

# ╔═╡ ddc435a7-2c93-4f57-b89a-bf9d90a3dc37


# ╔═╡ fa19e489-d475-437c-9112-03cadc3b7ee3
md"""
2. Calculate $\int_{-1}^1 \exp(2x) \, dx$ using each method. Plot the relative error

   $$E(N) := \frac{I_\text{approx}(N) - I_\text{exact}}{I_\text{exact}}$$

   as a function of $N$ for $N$ in the range $[10, 10^6]$ (or use a higher or lower upper bound depending on the computing power you have available).

   Do these errors correspond with the expectations from the arguments in lectures?

   Note that the exact result for this integral is $\sinh(2)$.
"""

# ╔═╡ 5cb481ea-2b76-4bae-93a8-f5b89bdb2302


# ╔═╡ b6eee5ae-19f1-401e-bc93-4a19e07bd86a
md"""
3. We showed that the trapezoid rule has error at most $\mathcal{O}(h^2)$. Consider the following integral of a smooth, periodic function:

    $$I = \int_{0}^{2 \pi} \exp[\cos(\theta)] \, d\theta$$

    Plot the error in the trapezoid rule in this case. How fast does it decay with $N$? [This will be important later in the course.]

    Note that the exact integral can be calculated as $2π \, I_0(1)$, where $I_0$ is a **modified Bessel function**. This can be evaluated at 1 using the `SpecialFunctions.jl` package as `besseli(0, 1)` as follows.

"""

# ╔═╡ 69b88daf-3ccb-42c9-bc29-e169dbd011b1
# using SpecialFunctions

# I0_at_1 = besseli(0, 1)

# ╔═╡ 4121c704-4f6f-4c84-a627-56103fb53520
md"""
   The result is the following, which you may use as the exact value for calculating the error:
"""

# ╔═╡ b8299213-15a9-4de8-b79d-a1ada0ddb880
I0_at_1 = 1.2660658777520082

# ╔═╡ 61cf691f-368f-4a8d-a263-99322508fa3c
md"""
4. [Extra credit] Implement Simpson's rule (the 2nd-order Newton--Cotes method) and add it to the comparisons from the previous questions.
"""

# ╔═╡ 1e346d3d-f4d1-45f1-8e83-619a1e6e2c7d
md"""
### Exercise 4: Euler method for ODEs

1. Implement the Euler method in a function `euler(f, x0, δt, t_final)`, assuming that $t_0 = 0$. Your code should work equally well if you put vectors in, to solve the equation $\dot{\mathbf{x}} = \mathbf{f}(\mathbf{x})$.
"""

# ╔═╡ e44839c0-9897-41a4-92da-5955a2052140


# ╔═╡ d9e9f764-2de0-4820-8740-2799e1736506
md"""
2. Use your code to integrate the differential equation $\dot{x} = 2x$ from $t = 0$ to $t = 5$ with initial condition $x_0 = 0.5$. 

   Plot the exact solution and the numerical solution for values of $\delta t = 0.01, 0.05, 0.1, 0.5$. 

   On a different plot show the relative error as a function of time, compared to the analytical solution.
"""

# ╔═╡ 967a43f8-2fd6-4cd6-aee4-b9fe25b4da61


# ╔═╡ 0efad120-ae4c-4d59-8394-73a014e99d0f
md"""

3. Calculate the (global) error at $t=5$ when the time interval is split into $N$ pieces for $N$ between 10 and 1000. Plot the error as a function of $N$. What is the rate of convergence as $h \to 0$?
"""

# ╔═╡ 4f884655-1f72-4b2c-8b94-8ce7afe262d0


# ╔═╡ 4b40b0e6-bb19-4caf-9f08-6670da530c33
md"""

A pendulum satisfies the ODE $\quad \ddot{\theta} + \sin(\theta) = 0$, where $\theta$ is the angle with the vertical.

4. Show analytically that the quantity ("energy") $E(\theta, \dot{\theta}) := \frac{1}{2} \dot{\theta}^2 - \cos(\theta)$ is **conserved** along a trajectory, i.e. that $\frac{d}{dt} [ E(\theta(t), \dot{\theta}(t)) = 0 ]$, so that $E(\theta(t), \dot{\theta}(t)) = E(\theta(t_0), \dot{\theta}(t_0))$.
"""

# ╔═╡ 078cb160-e164-4b9d-9bb7-a4f8d82f6442


# ╔═╡ 373e1862-8e91-48c0-84a4-267500f41db2
md"""
5. Solve this equation using the Euler method for the initial condition $(x=0, y=1)$.

   Draw the dynamics on the $x$--$y$ plane (variously called the "state space", "phase space" or "phase plane"). Explain graphically what is happening in terms of what each step does.
"""

# ╔═╡ dc2c3d57-e7c5-4ee3-b6c4-3916b08bfc68


# ╔═╡ 49865662-aa30-48ca-94ba-f1d246d67ef6
md"""
6. Calculate the energy as a function of time to show that the method does *not* conserve energy. How fast does it seem to grow? Why do you think that is?
"""

# ╔═╡ c2f57861-c8d8-4b44-ae94-9a972b337ddd


# ╔═╡ Cell order:
# ╟─56758636-7209-11eb-3f8f-f99a6aec934b
# ╟─8ad1bd54-791f-11eb-2127-6d180e178d93
# ╠═73c21295-6a80-47ab-9f2a-a30a0db098fb
# ╟─f97fa7ec-3ab2-444d-b257-45e4cca8f4b8
# ╟─f89eae50-34d8-4fd1-8626-c7ac12c41049
# ╠═7e233414-39f6-4d4c-a44b-de77e0a13751
# ╟─4aaf8052-889c-4ffd-b7ae-56e4ba0c80d5
# ╠═afacd497-ab79-44a5-9ba1-eb028d817dc9
# ╟─759fefe4-34f9-41a7-b75b-77f019e92efc
# ╠═e9e056d1-4296-4c48-a045-d12660838f97
# ╟─f81f2834-cea0-4504-b513-514df7fb1a30
# ╠═74575a12-11ae-41ba-8966-289ab963c5de
# ╟─546a4069-9586-4e83-8729-1f76c90b0170
# ╠═0c37a0ba-c609-4a38-b86c-a6d91f1f9c16
# ╟─536d7b4f-b02c-4814-9f35-2ecc4d252545
# ╠═36c98986-c4a6-4c89-b8fe-b29c09f2406c
# ╟─0754e7cf-b824-4ce8-a632-5a5bb1a0d87e
# ╠═e4ecbe33-3a11-44e9-9d64-b5c1e6df7596
# ╟─54e9881d-660e-40d9-b529-d8f43ae9c073
# ╠═a1b9ba6c-c8d4-4cdf-9f78-2c364e834e59
# ╟─99704a91-7351-4d3a-b16e-575240237eea
# ╟─5ef7115a-1102-4525-a4b7-80c1f38626b6
# ╟─1feef08b-b3f0-4bee-99b5-a5db24135d67
# ╠═32e0e1a9-f0df-4c43-afbf-a36f677a0dc6
# ╟─70f68146-0cf3-4511-996c-2e2bde4355c1
# ╠═3e577c55-7418-4d9a-88a9-58896fdfa01d
# ╟─134dd6dc-9bae-4ae9-868b-bae667ec2635
# ╠═caf4cff6-383b-43ed-b02e-a85298bc4991
# ╟─a285cded-7eae-41f8-9f43-ff96b15c31b4
# ╠═22110492-31ed-486c-9b05-1c93a22b2bd6
# ╟─c510138f-f528-40d6-ac65-641ceee15925
# ╠═3859e498-6940-4f53-b2fc-e6598b726dcc
# ╟─e8be0cc8-b876-4e6b-a3bf-fd5697201cba
# ╠═ddc435a7-2c93-4f57-b89a-bf9d90a3dc37
# ╟─fa19e489-d475-437c-9112-03cadc3b7ee3
# ╠═5cb481ea-2b76-4bae-93a8-f5b89bdb2302
# ╟─b6eee5ae-19f1-401e-bc93-4a19e07bd86a
# ╠═69b88daf-3ccb-42c9-bc29-e169dbd011b1
# ╟─4121c704-4f6f-4c84-a627-56103fb53520
# ╠═b8299213-15a9-4de8-b79d-a1ada0ddb880
# ╟─61cf691f-368f-4a8d-a263-99322508fa3c
# ╟─1e346d3d-f4d1-45f1-8e83-619a1e6e2c7d
# ╠═e44839c0-9897-41a4-92da-5955a2052140
# ╟─d9e9f764-2de0-4820-8740-2799e1736506
# ╠═967a43f8-2fd6-4cd6-aee4-b9fe25b4da61
# ╟─0efad120-ae4c-4d59-8394-73a014e99d0f
# ╠═4f884655-1f72-4b2c-8b94-8ce7afe262d0
# ╟─4b40b0e6-bb19-4caf-9f08-6670da530c33
# ╠═078cb160-e164-4b9d-9bb7-a4f8d82f6442
# ╟─373e1862-8e91-48c0-84a4-267500f41db2
# ╠═dc2c3d57-e7c5-4ee3-b6c4-3916b08bfc68
# ╟─49865662-aa30-48ca-94ba-f1d246d67ef6
# ╠═c2f57861-c8d8-4b44-ae94-9a972b337ddd
