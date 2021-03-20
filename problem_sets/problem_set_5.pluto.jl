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
# Problem set 5

## 18.330 Spring 2021
"""

# ╔═╡ 8ad1bd54-791f-11eb-2127-6d180e178d93
md"""
## Your name: 

### Instructions

- Figures should be plotted using the `Plots.jl` package, and interactive visualizations with `@bind` from the PlutoUI package.

- You are encouraged to create intermediate functions if it makes your code more readable and/or re-usable.

- Anything in your algorithm that is not obvious from the code should be briefly commented. Use better variable names to reduce the need for comments. Remember that longer names may be filled in using tab-completion (i.e. pressing the `<TAB>` key after writing the start of the word).

- Use a single blank line to separate parts of your functions, e.g. initialization from the main loop.

- Submit on Canvas by **Friday, 26 March 2021** at **11:59pm EDT**. 
"""

# ╔═╡ 89e057a2-8826-11eb-3402-1b21e3377c51
md"""

### Exercise 1: Finite-difference approximations

In this exercise we will look in more detail at finite-difference approximations of derivatives.
"""

# ╔═╡ 01f7629e-8827-11eb-2098-b9710dc9c427
md"""
1. Define a function `forward_derivative` that takes a function $f$, a number $a$ and an optional $h$ with default value 0.001, and calculates the forward finite difference approximation $[f(a + h) - f(a)] / h$ of the derivative $f'(a)$.

   Similarly define the function `centred_derivative` using the approximation $[f(a + h) - f(a - h)] / (2h)$.

"""

# ╔═╡ 05c18ec2-8827-11eb-1ca5-5931b53466ce


# ╔═╡ 01f79bba-8827-11eb-3d3a-ab055a1d7c78
md"""
2. To see how good the finite-difference approximation is, make a function `finite_diff_error`, which accepts a finite difference method `method`, a function `f`, its true (analytical) derivative `fp`, a point `a` and a size `h`, and calculates the error $\epsilon(h)$ that the finite-difference approximation makes.

"""

# ╔═╡ 7b938b3c-8827-11eb-145a-15f7a8e883d6


# ╔═╡ 01f7ea48-8827-11eb-0623-7b9c6b502561
md"""
3. For the function $f(x) = x^3 - 2x$, plot the error for calculating $f'(a=3)$ on a log--log scale for 50 values of $h$ ranging from $10^{-16}$ to $10^0$ that are *equally spaced on the log scale*, for the same function $f$ as above. 

   You will need to calculate its analytical derivative $f'$ and provide that by hand to the function. 

   You should plot the error for both of the above finite-difference methods on the same graph.
"""

# ╔═╡ 7c3a8d56-8827-11eb-306d-17e628eeb9f3


# ╔═╡ 02011c9e-8827-11eb-1eea-3d6f1298fb6f
md"""
4. What is the rate of decrease of $\epsilon(h)$ as a function of $h$ for larger values of $h$ for each of the two approximation methods? 

   Does this agree with the theoretical rates that we derived in lectures?

   Hint: Plot the theoretical rate on top of the graph to visually compare.
"""

# ╔═╡ 8fac9438-8827-11eb-079a-a368c3bedfbe


# ╔═╡ 02018404-8827-11eb-117c-d16ebdbd6123
md"""

5. For smaller values of $h$ the error starts to *increase*. This turns out to be due to *round-off* error, coming from using floating-point arithmetic. 

   Which arithmetic operation in the calculation do you think gives rise to this? Try to isolate the problem by using `BigFloat`s as the ground truth (i.e. the true value) to compare with the results from using usual `Float64`s with values of $h$ in the range of $10^{-15}$.

"""

# ╔═╡ cca16d98-8825-11eb-1862-b5002a53c1ea


# ╔═╡ 03a7a964-8831-11eb-157b-ff6e891269ab
md"""
6. Find a finite-difference approximation for the *second* derivative, $f''(a)$, by manipulating Taylor series, and give the theoretical order of the truncation error.
"""

# ╔═╡ 2d804034-8831-11eb-113a-8fe5f9fa7f2a


# ╔═╡ 17220d2c-8831-11eb-30d6-b16458958187
md"""
7. Use your functions from previous parts of the problem to plot the error in the second derivative $g''(a=3)$  for $g(x) = x^4 - 2x$ as a function of $h$.
"""

# ╔═╡ e6622cf0-8831-11eb-2332-91fa929eb685


# ╔═╡ 76e7b614-8831-11eb-2538-315700760b1a
md"""
8. [Extra credit] Find an even better finite-difference approximation to the first derivative by manipulating Taylor series.
"""

# ╔═╡ a21932c0-8831-11eb-0680-834ef3a8a59b


# ╔═╡ ccd2537c-8825-11eb-2065-916281172b57
md"""
#### Exercise 2: Algorithmic (automatic) differentiation

In this exercise we will implement the other numerical method we saw in lectures for calculating derivates: (forward-mode) **algorithmic differentiation**.

As you define each function, you should test that it works correctly on simple cases.

"""

# ╔═╡ d76fde32-8828-11eb-0ddc-dd086b873d51
md"""

1. Define the `Dual` type as in lectures and implement `+`, `-` and `*`.

    Include methods for each function to e.g. add a real number (type `::Real`) to a `Dual`. Treat a real number as having derivative 0.

   Tip: Recall that the syntax is `Base.+(x::Dual, y::Dual) = Dual( ... )`

"""

# ╔═╡ 23fff8e0-8829-11eb-355c-6f43f818bcf3


# ╔═╡ d7701974-8828-11eb-39f7-dbda20617f88
md"""

2. For functions $f$ such as `exp`, we define the action of the function on a `Dual` using

   $$f(a + b\epsilon) = f(a) + \epsilon \, b f'(a)$$

   Use this to define `exp`, `sin` and `log` on `Dual` numbers.
"""

# ╔═╡ 5b4d7156-8829-11eb-0c22-577680da4a76


# ╔═╡ 6fd2f290-8829-11eb-3430-b328610e5d3c
md"""
3. Define `^` for positive integer powers of `Dual` numbers, via repeated multiplication.
"""

# ╔═╡ 848d1b98-8829-11eb-01cf-37dbd049df7f


# ╔═╡ 507cd292-8829-11eb-2de0-b919e2cbea78
md"""
4. Write a function `derivative` that takes a function $f$ and a point $a$, and uses `Dual` numbers to calculate the derivative $f'(a)$. It should return *only* the derivative.
"""

# ╔═╡ 98c8b43e-8829-11eb-111f-bd80841e3625


# ╔═╡ 66c807e4-8829-11eb-3559-b5357b2fd3ef
md"""
5. Use your code to calculate $f'(a=3)$ for $f(x) = \exp(2x^3 + 3x)$. 

   Check with the analytical value that you get the correct result.
"""

# ╔═╡ 082ae522-8832-11eb-2ac4-e377e286153f


# ╔═╡ caa529e8-8832-11eb-0926-7f192a4e584a
md"""
6. Use `derivative` to define functions `∂x` and `∂y` that calculate the *partial* derivatives in $x$ and $y$ of a function $f: \mathbb{R}^2 \to \mathbb{R}$ at a vector $\mathbf{a}$. 
"""

# ╔═╡ 28b04764-8833-11eb-2c36-bd4547c16681


# ╔═╡ 18498dbe-8832-11eb-38f5-85fc1cece718
md"""
7. Write a function `jacobian` that calculates the Jacobian matrix of a function $f: \mathbb{R}^2 \to \mathbb{R}^2$ at $\mathbf{a}$.

   Check that it correctly calculates the Jacobian of $f(x, y) = (x^2 + y^2, y - x)$ at $(1, 2)$.
"""

# ╔═╡ 3b73d0a0-8833-11eb-1008-597afd05c239


# ╔═╡ 32dff4e6-8833-11eb-11dd-6b993b45e7f9
md"""
8. [Extra credit] Write a function to calculate the Jacobian matrix for a function $f: \mathbb{R}^n \to \mathbb{R}^n$ at $\mathbf{a}$.
"""

# ╔═╡ 71fd4dfc-8833-11eb-03ce-930d8b9c28e8


# ╔═╡ d9ec3cee-8825-11eb-36d5-1384b51ffe18
md"""
### Exercise 3: Solving systems of nonlinear equations

"""

# ╔═╡ 6e89f696-8832-11eb-30e2-4b74e16e7fdd


# ╔═╡ ead16f00-882f-11eb-21d2-fbf35447570f
md"""

1. Implement the Newton method for functions $f: \mathbb{R}^2 \to \mathbb{R}^2$. It should take a function $f$ and an initial guess $\mathbf{x}_0$.

   You should first do a basic check that $f$ does the right thing by checking that $\mathbf{x}_0$ and $f(\mathbf{x}_0)$ are both in $\mathbb{R}^2$.

   Iterate until the residual is small enough or until some maximum number of iterations is reached. To check the residual, write a `norm_squared` function that calculates the squared norm of a vector.

   The function should return a pair `(flag, r)`, where `flag` is a Boolean that indicates if a root was found, and `r` is the location of the root (if one was found).

   Hint: Use your code from Exercise 2 for the Jacobian if possible, or the function `ForwardDiff.jacobian` from the `ForwardDiff.jl` package if necessary (without any penalty).

   You may use the built-in "black-box" `\` function for solving the linear system, as  in lectures.
"""

# ╔═╡ 66d38202-89a2-11eb-31dd-616b55315253


# ╔═╡ 8917ad30-882f-11eb-2fef-3f86e5360727
md"""

2. Consider the nonlinear system

   $$\begin{cases}
   x^2 + y^2 = 3  \\
   \left(\frac{x}{2} \right)^2 + (y-a)^2 = 1
   \end{cases}$$

   Plot the two functions for $a = 1/2$.
   How many roots does the system have?
"""

# ╔═╡ 101fd3ac-8830-11eb-000e-835f3fff5a9b


# ╔═╡ 8917eec8-882f-11eb-11ef-c1500a6a93ae
md"""
3. From your plot, identify (by eye) roughly where the top right root is.

   Find it accurately using the Newton method.
"""

# ╔═╡ a3260554-8830-11eb-37c0-19fdd5466e40


# ╔═╡ a0adc906-8830-11eb-3219-11325d099dd0
md"""
4. Similar to the previous homework, make a function `all_roots` that searches for all roots in a given rectangular box. (The minimum and maximum positions of the box in each direction should be passed as arguments to the function).

   It should keep a list of the *unique* roots found so far (i.e. without duplicates), using a tolerance to decide whether two roots are "the same" or not.
"""

# ╔═╡ a6f71aec-8830-11eb-33dd-67ae681727ae


# ╔═╡ a0ae100a-8830-11eb-0bb3-afc56c51afc8
md"""
5. Find all solutions of the system of equations from part [2], and add them to the figure.
"""

# ╔═╡ a920347c-8830-11eb-16ef-4103e310eb7e


# ╔═╡ a0ae8526-8830-11eb-1828-0b764a983c05
md"""
6. Make an interactive visualization where you plot the curves together with all roots for different values of $a$.

   Which qualitative change (**bifurcation**) occurs, and why? 

   How could you think finding numerically the critical value $a_c$ of $a$ for which this happens? (It is not necessary to calculate the value, just think about how you *could* do it.)

"""

# ╔═╡ ac02bf8c-8830-11eb-3bea-4b858e6d9e78


# ╔═╡ a0b914f8-8830-11eb-058b-4b4773900d29
md"""
7. [Extra credit] Implement your suggestion from [6] to calculate $a_c$ numerically.
"""

# ╔═╡ af20de60-8830-11eb-01e5-536ef1adb994


# ╔═╡ d9ec7bdc-8825-11eb-3fc1-4b6c6ace3d04
md"""
### Exercise 4: A more complicated example

Consider the system

$$\begin{cases}
(x+3) (y^3-7) + 18 = 0 \\
\sin(y \exp(x)-1)) = 0
\end{cases}$$

(taken from [here](https://github.com/JuliaNLSolvers/NLsolve.jl)).
"""

# ╔═╡ e884e73c-8830-11eb-1ddf-33466c379b07
md"""
1. Plot the two functions.
"""

# ╔═╡ eda27c6e-8830-11eb-33ff-f1260cb294d6


# ╔═╡ e8852f12-8830-11eb-363d-392cb19a7174
md"""
2. Find as many roots as you can in the region $[-5, 5]^2$. How many are there?
"""

# ╔═╡ f16d5e4c-8830-11eb-3646-ef1d3f705ad8


# ╔═╡ e88ba752-8830-11eb-29c8-cd1c22fca738
md"""
3. Plot them on top of the graph. Did you find them all?
"""

# ╔═╡ 9085221c-8453-11eb-0fbe-9fb9c38fcc39


# ╔═╡ Cell order:
# ╟─56758636-7209-11eb-3f8f-f99a6aec934b
# ╟─8ad1bd54-791f-11eb-2127-6d180e178d93
# ╟─89e057a2-8826-11eb-3402-1b21e3377c51
# ╟─01f7629e-8827-11eb-2098-b9710dc9c427
# ╠═05c18ec2-8827-11eb-1ca5-5931b53466ce
# ╟─01f79bba-8827-11eb-3d3a-ab055a1d7c78
# ╠═7b938b3c-8827-11eb-145a-15f7a8e883d6
# ╟─01f7ea48-8827-11eb-0623-7b9c6b502561
# ╠═7c3a8d56-8827-11eb-306d-17e628eeb9f3
# ╟─02011c9e-8827-11eb-1eea-3d6f1298fb6f
# ╠═8fac9438-8827-11eb-079a-a368c3bedfbe
# ╟─02018404-8827-11eb-117c-d16ebdbd6123
# ╠═cca16d98-8825-11eb-1862-b5002a53c1ea
# ╟─03a7a964-8831-11eb-157b-ff6e891269ab
# ╠═2d804034-8831-11eb-113a-8fe5f9fa7f2a
# ╟─17220d2c-8831-11eb-30d6-b16458958187
# ╠═e6622cf0-8831-11eb-2332-91fa929eb685
# ╟─76e7b614-8831-11eb-2538-315700760b1a
# ╠═a21932c0-8831-11eb-0680-834ef3a8a59b
# ╟─ccd2537c-8825-11eb-2065-916281172b57
# ╟─d76fde32-8828-11eb-0ddc-dd086b873d51
# ╠═23fff8e0-8829-11eb-355c-6f43f818bcf3
# ╟─d7701974-8828-11eb-39f7-dbda20617f88
# ╠═5b4d7156-8829-11eb-0c22-577680da4a76
# ╟─6fd2f290-8829-11eb-3430-b328610e5d3c
# ╠═848d1b98-8829-11eb-01cf-37dbd049df7f
# ╟─507cd292-8829-11eb-2de0-b919e2cbea78
# ╠═98c8b43e-8829-11eb-111f-bd80841e3625
# ╟─66c807e4-8829-11eb-3559-b5357b2fd3ef
# ╠═082ae522-8832-11eb-2ac4-e377e286153f
# ╟─caa529e8-8832-11eb-0926-7f192a4e584a
# ╠═28b04764-8833-11eb-2c36-bd4547c16681
# ╟─18498dbe-8832-11eb-38f5-85fc1cece718
# ╠═3b73d0a0-8833-11eb-1008-597afd05c239
# ╟─32dff4e6-8833-11eb-11dd-6b993b45e7f9
# ╠═71fd4dfc-8833-11eb-03ce-930d8b9c28e8
# ╟─d9ec3cee-8825-11eb-36d5-1384b51ffe18
# ╠═6e89f696-8832-11eb-30e2-4b74e16e7fdd
# ╟─ead16f00-882f-11eb-21d2-fbf35447570f
# ╠═66d38202-89a2-11eb-31dd-616b55315253
# ╟─8917ad30-882f-11eb-2fef-3f86e5360727
# ╠═101fd3ac-8830-11eb-000e-835f3fff5a9b
# ╟─8917eec8-882f-11eb-11ef-c1500a6a93ae
# ╠═a3260554-8830-11eb-37c0-19fdd5466e40
# ╟─a0adc906-8830-11eb-3219-11325d099dd0
# ╠═a6f71aec-8830-11eb-33dd-67ae681727ae
# ╟─a0ae100a-8830-11eb-0bb3-afc56c51afc8
# ╠═a920347c-8830-11eb-16ef-4103e310eb7e
# ╟─a0ae8526-8830-11eb-1828-0b764a983c05
# ╠═ac02bf8c-8830-11eb-3bea-4b858e6d9e78
# ╟─a0b914f8-8830-11eb-058b-4b4773900d29
# ╠═af20de60-8830-11eb-01e5-536ef1adb994
# ╟─d9ec7bdc-8825-11eb-3fc1-4b6c6ace3d04
# ╟─e884e73c-8830-11eb-1ddf-33466c379b07
# ╠═eda27c6e-8830-11eb-33ff-f1260cb294d6
# ╟─e8852f12-8830-11eb-363d-392cb19a7174
# ╠═f16d5e4c-8830-11eb-3646-ef1d3f705ad8
# ╟─e88ba752-8830-11eb-29c8-cd1c22fca738
# ╠═9085221c-8453-11eb-0fbe-9fb9c38fcc39
