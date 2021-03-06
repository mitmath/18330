### A Pluto.jl notebook ###
# v0.12.20

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

# ╔═╡ 56758636-7209-11eb-3f8f-f99a6aec934b
md"""
# Problem set 3

## 18.330 Spring 2021
"""

# ╔═╡ 8ad1bd54-791f-11eb-2127-6d180e178d93
md"""
## Your name: 

### Instructions

- Figures should be plotted using the `Plots.jl` package, and interactive visualizations with `@bind` from the PlutoUI package.

- Submit on Canvas by **Friday, 12 March 2021** at **11:59pm EST**.
"""

# ╔═╡ e24306d0-77bc-11eb-2ec1-996ff91a5397
md"""
### Exercise 1: Calculating and plotting Taylor polynomials

In this exercise we will calculate and plot some Taylor polynomials for some functions and compare them to the "exact" function from Julia.

(Here we will use the known analytical formulas for the Taylor coefficients. Later in the course we will hopefully see how to get the computer to actually calculate them.)

"""

# ╔═╡ 712ce5c2-7d31-11eb-2b8f-8fbe7e399804
md"""
1. Write a function `coefficient` that calculates the $n$th Taylor coefficient (coefficient of the Taylor series) of the function $\exp$, where $n$ is an integer $\ge 0$.

   To do so, use the following template for the function:

		function coefficient(::typeof(exp), n)
	    	missing   # fill in your code here
		end
"""

# ╔═╡ 94c8831e-7d32-11eb-1b63-d9fef2e25f6e


# ╔═╡ 3c485962-7d32-11eb-1047-f144a18d7bec
md"""
2. Check that calling `coefficient(exp, 0)` and `coefficient(exp, 3)` gives the correct results.
"""

# ╔═╡ 929cc2be-7d32-11eb-0c89-f9e0b9473751


# ╔═╡ 3d6e0a42-7d32-11eb-16ac-a98126877830
md"""
3. Write a function `taylor(f, n, x)` that uses `coefficient` to evaluate the Taylor series of the function $f$ up to order $n$ at the point $x$.
"""

# ╔═╡ be77508c-7d32-11eb-140c-cfbc4a03a2d8


# ╔═╡ befaf694-7d32-11eb-0652-d54bbd78f9f6
md"""
4. Write a function `taylor_visualize` that creates an interactive visualisation  where you draw the Taylor polynomials of order $n$ and compare it (on the same plot) to the exponential function on the range $[-2, 2]$. You should (of course) use your `taylor` function to do the calculation of the Taylor polynomials.

   Tip: Adding `!` at the end of the name of a plotting command adds a new plot to a previous figure, e.g. `plot!(...)`.
"""

# ╔═╡ d36a2a28-7d32-11eb-310f-4140a532ced4


# ╔═╡ 57206df4-7d3e-11eb-1fad-853b3ff0c36f
md"""
5. Use `taylor_visualize` to visualize the exponential function. How many Taylor coefficients do you need to get a visually-accurate approximation over the given range?
"""

# ╔═╡ 6b455b5a-7d3e-11eb-274a-5f6fd794ad86


# ╔═╡ d6e4c4ce-7d32-11eb-1038-7b49eddd14d6
md"""
6. Calculate the Taylor coefficients of the functions $\sin(x)$ and $\log(1 + x)$ (called `log1p` in Julia), e.g. by hand. 

   Write methods of `coefficient` for these two functions and visualize the results with `taylor_visualize`. 

"""

# ╔═╡ 401fec84-7d33-11eb-1e55-c7fbaafe71d0


# ╔═╡ 40f764a2-7d33-11eb-08aa-6139230fcc79
md"""
7. What is different about the case of $\log(1+x)$? Why?
"""

# ╔═╡ 4d4b9d22-7d33-11eb-14af-833d3b3e2d63


# ╔═╡ 4dc505fe-7d33-11eb-2703-a7f990953523
md"""
### Exercise 2: The Babylonian algorithm

In this exercise we will investigate a famous iterative algorithm that was known to the Babylonians, and a similar algorithm that calculates the same quantity.

We will call them algorithm A:

$$x_{n+1    } = \frac{1}{2} \left( x_n + \frac{y}{x_n} \right),$$

and algorithm B:

$$x_{n+1    } = \frac{1}{4} \left( x_n + 3\frac{y}{x_n} \right),$$

It turns out that one of these converges much faster than the other. The one that converges faster is the Babylonian algorithm; your task is to find out which of A or B that is. (Without using the internet!, obviously.)

"""

# ╔═╡ 25170d76-7d35-11eb-0647-7b05bc1d3bd5
md"""
1. *Suppose* that $x_n$ converges to some limiting value $x^*$ as $n \to \infty$. Show that for both algorithms we must have $x^* = \sqrt{y}$. So these are, in fact,  iterations for calculating $\sqrt{y}$ ! 

   [Proving that they do, in fact, converge, is more difficult, but feel free to think about it.]
"""

# ╔═╡ 4d79aa28-7d38-11eb-33f3-1dcc74d8c6f1


# ╔═╡ 1b0600a4-7d36-11eb-2b25-adc5ef0613e1
md"""

2. Write a function `iterate(f, x0, ϵ)`, similar to the one that we wrote in class, to iterate a function `f` starting at `x0`. Instead of a fixed number of iterations, it takes a tolerance $\epsilon$ and iterates *until* the difference between *consecutive* values $x_n$ and $x_{n+1}$ is smaller than $\epsilon$. 

   Your function should return a vector of all the iterates $x_n$.

   Hint: What kind of loop do you need to keep calculating *until* a given condition occurs?

"""

# ╔═╡ 2eca2a00-7d36-11eb-0232-6d4116ccce41


# ╔═╡ 1b069696-7d36-11eb-3f8a-252ba3965049
md"""
3. Use your `iterate` function to run both algorithms with $\epsilon = 10^{-12}$, starting from $x_0=10$, and plot the resulting dynamics on a single graph.

   What value does each converge to? Is that consistent?

"""

# ╔═╡ 320a5d34-7d36-11eb-3ca5-3505c2fe5f23


# ╔═╡ 1b11935e-7d36-11eb-161c-dd33ffa252ab
md"""
4. Write a function `deltas` that takes in data $x_n$ and calculates $\delta_n := x_n - x^{*}$, taking the last data value as the limit $x^*$.
"""

# ╔═╡ 3d1377ce-7d36-11eb-0377-7db67d7de560


# ╔═╡ 1b16973c-7d36-11eb-09d9-f134a09debe0
md"""
5. For both algorithms plot the (absolute value of) $\delta_n$ as a function of $n$ on a semi-log plot (with logarithmic $y$ scale). How fast does each algorithm seem to converge?
"""

# ╔═╡ 86bb76d4-7d37-11eb-0bf2-6d6e7263c399


# ╔═╡ 52aea82e-7d3b-11eb-1080-4963206b58f1
md"""
6. Which of algorithm A or B is the Babylonian algorithm?
"""

# ╔═╡ 5e61ae8c-7d3b-11eb-0e3e-67de5982491a


# ╔═╡ 1b1c1fe2-7d36-11eb-20d6-ddcd5e1488cd
md"""
7. [Extra credit] For algorithm A, show that $\delta_{n+1} \simeq \delta_n^2$.

   Hint: You may need to use a Taylor series expansion.
"""

# ╔═╡ 631fc3aa-7d36-11eb-0b91-f580e7f3d085


# ╔═╡ 975646d0-7d3b-11eb-08e0-b73ffb0227a6
md"""
### Exercise 3: Designing fixed-point iterations

In this exercise we will *design* fixed-point iterations to find the roots of the equation

$$f_α(x) := x^3 - \alpha x + \sqrt{2} = 0.$$
"""

# ╔═╡ f0eb236e-7d3b-11eb-1d47-d99de8e21cee


# ╔═╡ a02d060e-7d3b-11eb-3d70-173aabc13952
md"""
1. Define a Julia function `f(α, x)` and make an interactive visualization of $f_\alpha(x)$ as $\alpha$ varies.

    Tip: Make sure to fix the plot limits so as to be able to see what's going on, using something like `xlims=(1, 2)` inside the plot command, or `xlims!(1, 2)` outside it. (1 and 2 here are just an example; experiment to find a useful range.)
"""

# ╔═╡ 26c9aaa0-7d3c-11eb-13de-85f6f48e826f


# ╔═╡ 20e50bcc-7d3c-11eb-3396-ebed835cb7d5
md"""

2. When $\alpha$ varies, the number of real roots changes. For which approximate value of $\alpha$ does the number of real roots change? (Use your visualisation to "eyeball" this.)

    How many real roots are there in which range of $\alpha$?
"""

# ╔═╡ 2bb4f7ea-7d3c-11eb-37cc-c753970208cd


# ╔═╡ 20e5489c-7d3c-11eb-2467-7d45dd0119fe
md"""
3. From now on, fix the value $\alpha = 2.5$. Eyeball approximately where the roots are for this value of $\alpha$.
"""

# ╔═╡ 397798a6-7d3c-11eb-21af-5f2405ed153c


# ╔═╡ 377d6d50-7d3c-11eb-2459-8b7f6b353fea
md"""
4. To design a fixed-point iteration to solve $f_\alpha(x) = 0$, the simplest method is to take  $g(x) = x + f(α, x)$ for our iteration $x_{n+1} = g(x_n)$, since then a
    *fixed point* of $g$ gives a *root* of $f$. (Check this.)

   Plot the function $g(x)$ and the function $y=x$. Taking into account the result we covered in lectures on *stability* of a fixed point,
    which root do you expect to be able to calculate by iterating $g$? 

   Fix an initial condition and show that it does converge there.
"""

# ╔═╡ ab4922b6-7d3d-11eb-0f19-6d8db9ae4603


# ╔═╡ 96164e7a-7d3c-11eb-01c4-afa668992d12
md"""

5. What happens with the initial condition $x=1.1$? Why?
"""

# ╔═╡ aa8eca4a-7d3d-11eb-325d-697b167df264


# ╔═╡ 9616d504-7d3c-11eb-3916-8d81b1ba3311
md"""
6. By using algebraic transformations, find different fixed-point iterations that
    converge to the other two roots.

    There are two alternative approaches
    you can take here. (Choose one of them):

    - The first is to find other iteration schemes $h$ to solve $x = h(x)$, by algebraically rearranging $f(\alpha, x) = 0$ to isolate an $x$ on one side and converting that into a fixed-point iteration scheme.

    - The second is to introduce the generalized function $g(c, x) := x + c f(x)$.
      Make an interactive plot of $g(c,x)$ and $y = x$ as $c$ varies. What do you notice about the slope of $g(c, x)$ at the fixed points as $c$ changes? Can you use this to change the stabilities of the fixed points in the iteration scheme?

"""

# ╔═╡ a9180e10-7d3d-11eb-3570-7b8963ac7ec4


# ╔═╡ aec1a8b2-7d3d-11eb-272a-6d885f0bdc7c
md"""

7. [Extra credit] Call $\alpha_c$ the **critical value** of $\alpha$ at which the number of roots
    changes. [This is called a **bifurcation point**.] Find (a good approximation to) $\alpha_c$ numerically.

"""

# ╔═╡ ca4b5236-7d3d-11eb-073c-952cc3ab7a4d


# ╔═╡ Cell order:
# ╟─56758636-7209-11eb-3f8f-f99a6aec934b
# ╟─8ad1bd54-791f-11eb-2127-6d180e178d93
# ╟─e24306d0-77bc-11eb-2ec1-996ff91a5397
# ╟─712ce5c2-7d31-11eb-2b8f-8fbe7e399804
# ╠═94c8831e-7d32-11eb-1b63-d9fef2e25f6e
# ╟─3c485962-7d32-11eb-1047-f144a18d7bec
# ╠═929cc2be-7d32-11eb-0c89-f9e0b9473751
# ╟─3d6e0a42-7d32-11eb-16ac-a98126877830
# ╠═be77508c-7d32-11eb-140c-cfbc4a03a2d8
# ╟─befaf694-7d32-11eb-0652-d54bbd78f9f6
# ╠═d36a2a28-7d32-11eb-310f-4140a532ced4
# ╟─57206df4-7d3e-11eb-1fad-853b3ff0c36f
# ╠═6b455b5a-7d3e-11eb-274a-5f6fd794ad86
# ╟─d6e4c4ce-7d32-11eb-1038-7b49eddd14d6
# ╠═401fec84-7d33-11eb-1e55-c7fbaafe71d0
# ╟─40f764a2-7d33-11eb-08aa-6139230fcc79
# ╠═4d4b9d22-7d33-11eb-14af-833d3b3e2d63
# ╟─4dc505fe-7d33-11eb-2703-a7f990953523
# ╟─25170d76-7d35-11eb-0647-7b05bc1d3bd5
# ╠═4d79aa28-7d38-11eb-33f3-1dcc74d8c6f1
# ╟─1b0600a4-7d36-11eb-2b25-adc5ef0613e1
# ╠═2eca2a00-7d36-11eb-0232-6d4116ccce41
# ╟─1b069696-7d36-11eb-3f8a-252ba3965049
# ╠═320a5d34-7d36-11eb-3ca5-3505c2fe5f23
# ╟─1b11935e-7d36-11eb-161c-dd33ffa252ab
# ╠═3d1377ce-7d36-11eb-0377-7db67d7de560
# ╟─1b16973c-7d36-11eb-09d9-f134a09debe0
# ╠═86bb76d4-7d37-11eb-0bf2-6d6e7263c399
# ╟─52aea82e-7d3b-11eb-1080-4963206b58f1
# ╠═5e61ae8c-7d3b-11eb-0e3e-67de5982491a
# ╟─1b1c1fe2-7d36-11eb-20d6-ddcd5e1488cd
# ╠═631fc3aa-7d36-11eb-0b91-f580e7f3d085
# ╟─975646d0-7d3b-11eb-08e0-b73ffb0227a6
# ╠═f0eb236e-7d3b-11eb-1d47-d99de8e21cee
# ╟─a02d060e-7d3b-11eb-3d70-173aabc13952
# ╠═26c9aaa0-7d3c-11eb-13de-85f6f48e826f
# ╟─20e50bcc-7d3c-11eb-3396-ebed835cb7d5
# ╠═2bb4f7ea-7d3c-11eb-37cc-c753970208cd
# ╟─20e5489c-7d3c-11eb-2467-7d45dd0119fe
# ╠═397798a6-7d3c-11eb-21af-5f2405ed153c
# ╟─377d6d50-7d3c-11eb-2459-8b7f6b353fea
# ╠═ab4922b6-7d3d-11eb-0f19-6d8db9ae4603
# ╟─96164e7a-7d3c-11eb-01c4-afa668992d12
# ╠═aa8eca4a-7d3d-11eb-325d-697b167df264
# ╟─9616d504-7d3c-11eb-3916-8d81b1ba3311
# ╠═a9180e10-7d3d-11eb-3570-7b8963ac7ec4
# ╟─aec1a8b2-7d3d-11eb-272a-6d885f0bdc7c
# ╠═ca4b5236-7d3d-11eb-073c-952cc3ab7a4d
