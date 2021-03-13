### A Pluto.jl notebook ###
# v0.12.21

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
# Problem set 4

## 18.330 Spring 2021
"""

# ╔═╡ 8ad1bd54-791f-11eb-2127-6d180e178d93
md"""
## Your name: 

### Instructions

- Figures should be plotted using the `Plots.jl` package, and interactive visualizations with `@bind` from the PlutoUI package.

- You are encouraged to create intermediate functions if it makes your code more readable and/or re-usable.

- Anything in your algorithm that is not obvious from the code should be briefly commented. Use better variable names to reduce the need for comments. Remember that longer names may be filled in using tab-completion (i.e. pressing the `<TAB>` key after writing the start of the word).

- Submit on Canvas by **Friday, 19 March 2021** at **11:59pm EDT**. (If you are outside the US, note that daylight savings time begins on Sunday, 14 March.)
"""

# ╔═╡ 2d1ecace-82c4-11eb-3772-630af2bbcb87


# ╔═╡ 198d557a-82c4-11eb-3eac-c5f1b8913411
md"""
### Exercise 1: The Newton method for real functions
"""

# ╔═╡ 57310138-82c4-11eb-171a-1b1dcd1688ab
md"""
In this exercise we will implement the **Newton method** for finding **roots** of a function $f$. Recall that it is given by the following iteration:

$$x_{n+1} = x_n - \frac{f(x_n)}{f'(x_n)},$$

where $f'$ is the derivative of $f$.


"""

# ╔═╡ 551f9f64-82c4-11eb-077b-c16672ceb4e6
md"""
1. Write a function `newton` to implement the Newton method. It should take a function $f$, its derivative $f^\prime$, and an initial guess $x_0$.

   It should terminate when the **residual** $f(x)$ is less than an input tolerance $\epsilon$, or when the number of iterations is too large (say greater than 100).

   It should return the sequence of iterates visited during the iteration.
"""

# ╔═╡ 0755eccc-82c5-11eb-337c-db132a22ee4e


# ╔═╡ 04cbb81a-82c5-11eb-2cbb-cdb181858f42
md"""
2. Use `newton` to calculate the fixed point of the cosine iteration $x_{n+1} = \cos(x_n)$ from class. 

   You will need to specify the derivative by hand for now.
"""

# ╔═╡ 393517c4-82c5-11eb-0a4b-d356ecfcdc12


# ╔═╡ 04cbe894-82c5-11eb-2775-43e0225a2a87
md"""
3. Plot the convergence of the Newton method and of the cosine iteration on the same graph.  

   Use `BigFloat` and a lower tolerance if necessary to get more points. Use suitable scales on the axes.

   How does the Newton method compare to the cosine iteration?

"""

# ╔═╡ 166c5984-82c6-11eb-3c14-03df9131a6b7


# ╔═╡ 13bf24a0-82c6-11eb-3af6-65f50b8c5acd
md"""
4. Write a method of `newton` that accepts a `Vector`, representing the coefficients of a polynomial (as in previous problem ets) and an initial condition $x_0$.

   Use your code for calculating the derivative and evaluating the polynomial from previous problem sets. You may copy it here.

   Test this on the cubic polynomial $x^3 - 2x^2 - x + 0.1$ with initial condition $x_0 = 4$. 
""" 

# ╔═╡ a2989472-82c6-11eb-0034-595839541577


# ╔═╡ 48742632-82c6-11eb-187c-4bc5956c399d
md"""
5. Write a function `all_real_roots` that tries to find all the real roots of a polynomial by calling `newton` repeatedly with different initial conditions inside a certain region, say $[-100, 100]$.

   You should return a vector of the roots you have found, *without* repetition. 

   Hint: You will need to check if two roots that you have found are "equal"; do this check within a certain tolerance, e.g. $10^{-6}$.

"""

# ╔═╡ 31cc10bc-82c7-11eb-0ac6-cb79370c4e37


# ╔═╡ 99236fee-82c8-11eb-2445-1b6f17c0fb45
md"""
6. Apply your function `all_real_roots` to the polynomial from question 4.
"""

# ╔═╡ a3015e56-82c8-11eb-384b-e500b41362fd


# ╔═╡ a36f5e6a-82c8-11eb-39e3-154ec939ff6f
md"""
7. [Extra credit] Apply `all_real_roots` to find "all" the roots of the (non-polynomial) function $f(x) = x \sin(\frac{1}{x})$.
"""

# ╔═╡ d075b328-82c8-11eb-045a-0d9dfa620b0a


# ╔═╡ 2e2c3e7c-82c6-11eb-03c6-397b35d19f31
md"""
### Exercise 2: Newton in the complex plane

As we saw in lectures, Newton can behave badly. To see just how badly, let's use the *same* Newton method to find roots of polynomials in the *complex plane* $\mathbb{C}$.

"""

# ╔═╡ a092bbb6-82c7-11eb-044d-a5ea4df05331
md""" 
1. How many roots does the polynomial $f(z) = z^3 - 1$ have in the complex plane
    $\mathbb{C}$? Where are they?
"""

# ╔═╡ a7cc6794-82c7-11eb-15b1-0367a79d65c2


# ╔═╡ a0931a0e-82c7-11eb-0c7e-4d575ef7e5d2
md""" 


2. Write a function `newton_grid` that takes a parameter $n$. It should run the Newton method with *complex* initial values $a + ib$
    forming a square grid in the complex plane, with real and imaginary parts having $n$ equally-spaced values between $-3$ and $3$.  

   Run the Newton method and the imaginary part of the resulting root
    (or the final value, if no root is reached) in a matrix, which should be returned from the function

   [Note that it should not be necessary to modify your `newton` code in order to run it with complex numbers as input / output!]

"""

# ╔═╡ 1b8b281e-82c8-11eb-3e97-e9621a881c0b


# ╔═╡ 1a69c8c4-82c8-11eb-2026-e7a26d978b5e
md"""


3. Make an interactive visualisation of the resulting matrix as a function of $n$.

   To do so, use the `heatmap` function from `Plots.jl` and also plot the true roots as points. 

   What kind of object are you seeing? What does this imply for the Newton method? What happens close to the roots?

   Tip: Use the `yflip=true` argument to the `heatmap` function.

   Hint: Vary the value of $n$ slowly starting at low values and do not try values of $n$ that are too large for your computer to calculate / plot!
"""

# ╔═╡ ab4922b6-7d3d-11eb-0f19-6d8db9ae4603


# ╔═╡ aa58c4e8-82cb-11eb-3a07-ef3d809dc540
md"""
4. [Extra credit] What happens to the picture when you use polynomials of different degrees? When you use non-polynomial functions?
"""

# ╔═╡ baab5126-82cb-11eb-0fe1-174d679afc14


# ╔═╡ d5d58730-82c8-11eb-23a3-a90f959fa05f
md"""
### Exercise 3: Order of convergence of the Newton method

1. Defining $\delta_n := x_n - x^*$ as in lectures, find how $\delta_{n+1}$ is related to $\delta_n$ for the Newton method.

"""

# ╔═╡ 0452c9c6-82c9-11eb-12ea-978eb7137cf0


# ╔═╡ 04bf3622-82c9-11eb-2bc7-e34f0f06ff7e
md"""
2. Hence calculate the **order of convergence** of the Newton method.
"""

# ╔═╡ 0f5cd62a-82c9-11eb-0867-b559d210c725


# ╔═╡ bf493d7e-82cb-11eb-2d99-73a27b5f1553
md"""
3. [Extra credit] How could you make a method that converged even *faster* than Newton?
"""

# ╔═╡ ca415d92-82cb-11eb-3f89-4b4624c7e9cc


# ╔═╡ ca4b5236-7d3d-11eb-073c-952cc3ab7a4d
md"""
#### Exercise 4: Aberth method

With the Newton method we find only a single root at a time. The [Aberth method](https://en.wikipedia.org/wiki/Aberth_method)
calculates *all* of the roots of a polynomial in $\mathbb{C}$ at once! 

Given estimates $(z_k)_{k=1}^n$ for the $k$th root of a polynomial of degree $n$, it calculates
  a new estimate $\tilde{z}_k$, where $\tilde{z}_k := z_k - w_k$, with

  $$w_{k} := {\frac{\frac{p(z_{k})}{p'(z_{k})}}{1-{\frac{p(z_{k})}{p'(z_{k})}}\cdot \sum_{j\neq k}{\frac {1}{z_{k}-z_{j}}}}}.$$

  In order to guarantee convergence, the initial guess must be chosen in a special way. The [**Cauchy bound**](https://en.wikipedia.org/wiki/Geometrical_properties_of_polynomial_roots#Lagrange's_and_Cauchy's_bounds) tells us that all
  the roots of a polynomial $p(x) = a_0 + a_1x + \cdots + a_n x^n$ must have absolute value bounded between the lower bound 


  $$L = \frac{1}{1+\max \left\{ \left \lvert \frac{a_{n}}{a_{0}} \right\rvert,\left\lvert \frac{a_{n-1}}{a_{0}} \right\rvert, \ldots ,\left\lvert \frac{a_{1}}{a_{0}}\right\rvert \right\} }$$

and upper bound

  $$U = 1+\max \left\{ \left \lvert \frac{a_{n-1}}{a_{n}} \right\rvert,\left\lvert \frac{a_{n-2}}{a_{n}} \right\rvert,\ldots ,\left\lvert \frac{a_{0}}{a_{n}}\right\rvert \right\}.$$

  The starting points should be chosen so that their absolute value lies in between these bounds.

"""

# ╔═╡ 720c924c-82c9-11eb-1ba4-072086d6892e
md"""

1. Implement a function `poly_bounds` that takes in vector of coefficients representing a polynomial and returns $L$ and $U$.

"""

# ╔═╡ d63c4a5a-82c9-11eb-1cae-edb4927e68d2


# ╔═╡ d008c18e-82c9-11eb-048e-55afddb59746
md"""

2. Use `poly_bounds` to write a function `initialize_points` that finds a suitable starting group of points. Do this by choosing $\rho$s sampled from a uniform distribution over $[L, U]$ and $\theta$s sampled from a uniform distribution over $[0, 2\pi]$. Then calculate $z = \rho e^{i\theta}$.

   Hint: The `rand()` function generates uniform random numbers between $0$ and $1$. Use `rand` to write a function `uniform(a, b)` to generate uniform numbers between $a$ and $b$.]
"""

# ╔═╡ da0cdc24-82c9-11eb-07c9-f13320e3eb63


# ╔═╡ d008f656-82c9-11eb-03e5-65eb69cfe1c5
md"""

3. Implement the Aberth method for a polynomial $p$ which uses initial conditions from  `initialize_points` and terminates either after a certain number of iterations or when a certain tolerance is met.

   Test your function for the polynomials in the previous exercises.

"""

# ╔═╡ febd4218-82c9-11eb-3161-2d3feee11f9b


# ╔═╡ fc683144-82c9-11eb-1616-c366421dbcc0
md"""

4. Make an interactive visualization of the progress over time on some random
    polynomials of degree 10 or 20.

"""

# ╔═╡ ffcee95e-82c9-11eb-300a-534faf584b24


# ╔═╡ fc68e26a-82c9-11eb-2df5-b17a3bcdd669
md"""
5. Try the polynomial with multiple roots $(x^2 + 1)^3$. What happens?

"""

# ╔═╡ 036beaa6-82ca-11eb-0b37-796e461f11c5


# ╔═╡ 2b4f28a4-8453-11eb-3895-6dfea575f443
md"""
### Exercise 5 [Extra credit]: Order of convergence
"""

# ╔═╡ 355c4a14-8453-11eb-080d-33dde37237e3
md"""
1. Find a way to calculate the order of convergence $\alpha$ of a sequence $x_n$ *numerically*, *without* using the limit $x^*$.
"""

# ╔═╡ 46b612ae-8453-11eb-1419-fb60e3f62147


# ╔═╡ fc686eaa-82c9-11eb-201f-9b6ee3d935cf
md"""
2. Apply this to verify the order of convergence of the cosine iteration and of the  Newton method.

   Tip: You may want to use `BigFloat`s. Recall that you can change the precision with e.g. `setprecision(BigFloat, 1000)`.


"""

# ╔═╡ 8875a698-8453-11eb-1336-6d5f37235108


# ╔═╡ 88d49ee4-8453-11eb-3468-e5010c6a6754
md"""
3. What does your method say about the order of convergence of the Aberth method?
"""

# ╔═╡ 9085221c-8453-11eb-0fbe-9fb9c38fcc39


# ╔═╡ Cell order:
# ╟─56758636-7209-11eb-3f8f-f99a6aec934b
# ╟─8ad1bd54-791f-11eb-2127-6d180e178d93
# ╠═2d1ecace-82c4-11eb-3772-630af2bbcb87
# ╟─198d557a-82c4-11eb-3eac-c5f1b8913411
# ╟─57310138-82c4-11eb-171a-1b1dcd1688ab
# ╟─551f9f64-82c4-11eb-077b-c16672ceb4e6
# ╠═0755eccc-82c5-11eb-337c-db132a22ee4e
# ╟─04cbb81a-82c5-11eb-2cbb-cdb181858f42
# ╠═393517c4-82c5-11eb-0a4b-d356ecfcdc12
# ╟─04cbe894-82c5-11eb-2775-43e0225a2a87
# ╠═166c5984-82c6-11eb-3c14-03df9131a6b7
# ╟─13bf24a0-82c6-11eb-3af6-65f50b8c5acd
# ╠═a2989472-82c6-11eb-0034-595839541577
# ╟─48742632-82c6-11eb-187c-4bc5956c399d
# ╠═31cc10bc-82c7-11eb-0ac6-cb79370c4e37
# ╟─99236fee-82c8-11eb-2445-1b6f17c0fb45
# ╠═a3015e56-82c8-11eb-384b-e500b41362fd
# ╟─a36f5e6a-82c8-11eb-39e3-154ec939ff6f
# ╠═d075b328-82c8-11eb-045a-0d9dfa620b0a
# ╟─2e2c3e7c-82c6-11eb-03c6-397b35d19f31
# ╟─a092bbb6-82c7-11eb-044d-a5ea4df05331
# ╠═a7cc6794-82c7-11eb-15b1-0367a79d65c2
# ╟─a0931a0e-82c7-11eb-0c7e-4d575ef7e5d2
# ╠═1b8b281e-82c8-11eb-3e97-e9621a881c0b
# ╟─1a69c8c4-82c8-11eb-2026-e7a26d978b5e
# ╠═ab4922b6-7d3d-11eb-0f19-6d8db9ae4603
# ╟─aa58c4e8-82cb-11eb-3a07-ef3d809dc540
# ╠═baab5126-82cb-11eb-0fe1-174d679afc14
# ╟─d5d58730-82c8-11eb-23a3-a90f959fa05f
# ╠═0452c9c6-82c9-11eb-12ea-978eb7137cf0
# ╟─04bf3622-82c9-11eb-2bc7-e34f0f06ff7e
# ╠═0f5cd62a-82c9-11eb-0867-b559d210c725
# ╟─bf493d7e-82cb-11eb-2d99-73a27b5f1553
# ╠═ca415d92-82cb-11eb-3f89-4b4624c7e9cc
# ╟─ca4b5236-7d3d-11eb-073c-952cc3ab7a4d
# ╟─720c924c-82c9-11eb-1ba4-072086d6892e
# ╠═d63c4a5a-82c9-11eb-1cae-edb4927e68d2
# ╟─d008c18e-82c9-11eb-048e-55afddb59746
# ╠═da0cdc24-82c9-11eb-07c9-f13320e3eb63
# ╟─d008f656-82c9-11eb-03e5-65eb69cfe1c5
# ╠═febd4218-82c9-11eb-3161-2d3feee11f9b
# ╟─fc683144-82c9-11eb-1616-c366421dbcc0
# ╠═ffcee95e-82c9-11eb-300a-534faf584b24
# ╟─fc68e26a-82c9-11eb-2df5-b17a3bcdd669
# ╠═036beaa6-82ca-11eb-0b37-796e461f11c5
# ╟─2b4f28a4-8453-11eb-3895-6dfea575f443
# ╟─355c4a14-8453-11eb-080d-33dde37237e3
# ╠═46b612ae-8453-11eb-1419-fb60e3f62147
# ╟─fc686eaa-82c9-11eb-201f-9b6ee3d935cf
# ╠═8875a698-8453-11eb-1336-6d5f37235108
# ╟─88d49ee4-8453-11eb-3468-e5010c6a6754
# ╠═9085221c-8453-11eb-0fbe-9fb9c38fcc39
