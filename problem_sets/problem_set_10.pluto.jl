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

# ╔═╡ 73c21295-6a80-47ab-9f2a-a30a0db098fb
using LinearAlgebra, Plots, PlutoUI

# ╔═╡ 56758636-7209-11eb-3f8f-f99a6aec934b
md"""
# Problem set 10

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

- Submit on Canvas by **Friday, 7th May 2021** at **11:59pm EDT**. 
"""

# ╔═╡ 067bba83-1c8d-4da6-a742-beaf9ce4fcda
TableOfContents()

# ╔═╡ 53176882-ef8d-4a08-8ca4-191ca7d64b6f
md"""
### Exercise 1: Runge--Kutta methods

In this exercise we will look at the convergence of Runge--Kutta methods for solving ODEs.
"""

# ╔═╡ bf786bb4-3241-4b16-ba41-14a69bb0d9cc
md"""

The **midpoint method** is a Runge--Kutta method defined as follows. Starting at $(t_n, x_n)$, we take an Euler step of length $h/2$ to $(t_{n+1/2}, x_{n+1/2})$ and then evaluate $f$ at that point to then take a complete Euler step from $(t_n, x_n)$ of length $h$.

1. Write out this method using the $k_i$ notation from lectures, and hence find its Butcher tableau. (You can just write the coefficients $a_{11} = \cdots$, etc; it is not necessary to write it in the form of a table.)

   Find the theoretical order of this method using a Taylor expansion.
"""

# ╔═╡ 2619486e-9c3f-4a23-b7f2-d8fce459cdb3


# ╔═╡ e325deb7-088a-4c15-acff-85c41430a1f8
md"""
2. Write functions `midpoint` and `RK4` to carry out one step of the midpoint method and one step of the RK4 method, respectively. 

   They should have a signature like `midpoint(f, x, t, h)` and should return the new value of `x` after a time step of length $h$ starting at the position $x$ at time $t$.

   They should assume that the function $f$ has signature `f(t, x)` (i.e. it allows for an explicit dependence on $t$).
"""

# ╔═╡ a1744468-9579-4c1d-8d37-ac83e5267f8e


# ╔═╡ d97b492b-890a-45d4-9fc4-3f1123c44b0e
md"""
3. Write a function `integrate` with the signature

   `function integrate(method, f, x0, t0, t_final, h)`

   where `method` is a RK method as defined above and $h$ is a fixed step size.

   Make sure that the final step lands exactly at the final time by taking that final step as a special case.
"""

# ╔═╡ 414eaf14-2f22-475d-9b6c-e607b17c7676


# ╔═╡ 0293eba2-8920-4744-a936-32e6e754a51a
md"""

4. Use both methods to integrate the ODE $\dot{x} = 1.5x$ with $x_0 = 2$ from time $0$ up to time $t_\text{final} = 3$.

   Find the rate of convergence of the numerical solution at $t=3$ to the exact solution as $h \to 0$ for each method. Do they correspond to theory?
"""

# ╔═╡ e101ceaf-69de-49e6-9a3a-b2ea1e0afddc


# ╔═╡ 70f85b11-586e-441e-a4bf-46abb7483d72
md"""

5. Even Runge--Kutta methods may not be good enough without adaptivity: Consider the ODE

   $$\dot{u}(t) = \exp \left[t - u \, \sin(u) \right],$$

   with initial condition $u_0 = 0$ at time $t = 0$.

   Integrate it using RK4 from $t=0$ to $t=5$ with a step size $h=10^{-2}$. Now integrate it with a step size $h = 10^{-3}$.

   Plot both numerical solutions as a function of $t$ on one graph. 

   What do you observe? What do you think is happening?

"""

# ╔═╡ 36be4fd0-e2d3-449f-bb10-f6b76982512e


# ╔═╡ 8fd05681-e376-4478-999e-9b1d5b1799c4
md"""

### Exercise 2: Adaptivity in the Euler method

In this exercise we will investigate adaptivity in ODE solvers by taking the simplest case: an adaptive Euler method.
"""

# ╔═╡ b73e241c-2718-406a-8fdb-8886d27066a1
md"""
1. Consider one step of the Euler method. Write down the local (single-step) error in terms of the step size $h$ and the unknown constant $C$. Call the approximation obtained at the end of the step $x^{(1)}$.
"""

# ╔═╡ 06689900-e6f8-4c15-98db-6a4f0994c566


# ╔═╡ afe0758a-33ee-45be-baa7-34a39cf42029
md"""
2. If you now take two consecutive Euler steps of size $h/2$, would you expect this to give a better or a worse approximation to the true solution? Write down the total error after taking the two steps, assuming that the constant $C$ is the same for both steps. Call the approximation at the end of this combined step $x^{(2)}$.
"""

# ╔═╡ c5b11a4f-ebb7-4727-8354-261db6ce8b4f


# ╔═╡ 8d991a10-4b82-4d5c-8375-96583d339d93
md"""
3. Define $\Delta x$ as the difference between the two approximations. Assume that the constant $C$ is the same for both methods. Use this to find the step size $h'$ that will give an error (per unit time) for the step of a given size $\epsilon$.

   Hint: Follow the same kind of argument as for the Runge--Kutta case from lectures.
"""

# ╔═╡ 3c8a21f5-afdb-412b-a51e-90d16c10af6e


# ╔═╡ 4699ca64-f9c0-48aa-a03f-f370f139f4bd
md"""

4. Use your result from [3] to write an adaptive Euler integrator `adaptive_euler(f, t0, t_final, ϵ)` that varies the step size $h$ in a similar way to what we saw in class.

   It should try to keep the local error below `ϵ`, using an update rule similar to the one we discussed in class (in the case of Runge--Kutta methods). Include an extra factor $0.9$ in the definition of the new step size $h'$, and allow the maximum increase to be from $h$ to $2h$.

"""

# ╔═╡ 6509cc37-4a19-4c09-9c2d-26fdc5a44640


# ╔═╡ 1ab3d6fc-d555-4260-8433-8106c963f947
md"""
5. Use your adaptive method to integrate the same ODE as in [Exercise 1.5]. 

   Compare the solution with the solution using the Runge--Kutta method.
   
"""

# ╔═╡ 4df7e8f6-bbdd-4fa7-b5b6-862e2e9a0618


# ╔═╡ bf43b6a1-860f-4d81-bd1d-b30c86823f13
md"""
6. Plot the step size taken as a function of time. 

   What do you observe?

"""

# ╔═╡ 745820a6-9041-43aa-b976-f995c8b03793


# ╔═╡ Cell order:
# ╟─56758636-7209-11eb-3f8f-f99a6aec934b
# ╟─8ad1bd54-791f-11eb-2127-6d180e178d93
# ╠═067bba83-1c8d-4da6-a742-beaf9ce4fcda
# ╠═73c21295-6a80-47ab-9f2a-a30a0db098fb
# ╟─53176882-ef8d-4a08-8ca4-191ca7d64b6f
# ╟─bf786bb4-3241-4b16-ba41-14a69bb0d9cc
# ╠═2619486e-9c3f-4a23-b7f2-d8fce459cdb3
# ╟─e325deb7-088a-4c15-acff-85c41430a1f8
# ╠═a1744468-9579-4c1d-8d37-ac83e5267f8e
# ╟─d97b492b-890a-45d4-9fc4-3f1123c44b0e
# ╠═414eaf14-2f22-475d-9b6c-e607b17c7676
# ╟─0293eba2-8920-4744-a936-32e6e754a51a
# ╠═e101ceaf-69de-49e6-9a3a-b2ea1e0afddc
# ╟─70f85b11-586e-441e-a4bf-46abb7483d72
# ╠═36be4fd0-e2d3-449f-bb10-f6b76982512e
# ╟─8fd05681-e376-4478-999e-9b1d5b1799c4
# ╟─b73e241c-2718-406a-8fdb-8886d27066a1
# ╠═06689900-e6f8-4c15-98db-6a4f0994c566
# ╟─afe0758a-33ee-45be-baa7-34a39cf42029
# ╠═c5b11a4f-ebb7-4727-8354-261db6ce8b4f
# ╟─8d991a10-4b82-4d5c-8375-96583d339d93
# ╠═3c8a21f5-afdb-412b-a51e-90d16c10af6e
# ╟─4699ca64-f9c0-48aa-a03f-f370f139f4bd
# ╠═6509cc37-4a19-4c09-9c2d-26fdc5a44640
# ╟─1ab3d6fc-d555-4260-8433-8106c963f947
# ╠═4df7e8f6-bbdd-4fa7-b5b6-862e2e9a0618
# ╟─bf43b6a1-860f-4d81-bd1d-b30c86823f13
# ╠═745820a6-9041-43aa-b976-f995c8b03793
