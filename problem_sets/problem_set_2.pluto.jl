### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 56758636-7209-11eb-3f8f-f99a6aec934b
md"""
# Problem set 2

## 18.330 Spring 2021
"""

# ╔═╡ 8ad1bd54-791f-11eb-2127-6d180e178d93
md"""
## Your name: 

### Instructions

- Submit on Canvas by **Friday, 5 March 2021** at **11:59pm EST**.
"""

# ╔═╡ e24306d0-77bc-11eb-2ec1-996ff91a5397
md"""
### Exercise 1: Make your own floating-point numbers

In this exercise we will make a *simple* version of floating-point numbers. The goal is understanding, *not* efficiency.

Following is the type definition we will use.

- We will store the exponent as just an integer that can be positive or negative.
- We are supposing that the precision `p` is the number of bits that the fractional part uses.
- `f` is the *integer* representation of the fractional part with precision `p`. [Hence we are only concerned with the "bottom" `p` bits of $f$.] You may assume that `f` always lies in the correct range.
- For simplicity we will ignore the sign and work only with positive numbers:

"""

# ╔═╡ bace73c2-77bd-11eb-0f64-67fac915efd7
struct MyFloat
	e::Int   # exponent
	p::Int   # precision
	f::Int   # *integer* representation of the fractional part
end

# ╔═╡ 1370c7b6-77be-11eb-1625-e1e5dc9b1905
md"""
Recall that we can make an object of this type as
"""

# ╔═╡ c96641ee-77bd-11eb-16d8-5d6ec861b5eb
x = MyFloat(2, 3, 4)

# ╔═╡ af0fb78c-77c0-11eb-1c9b-9b2bb5ea1512
md"""
1. What is the range of integer values of `f` that is allowed with precision `p`?

   Make a function `fractional_part(x::MyFloat)` that returns the corresponding value of the fractional part (lying between $0$ and $1$).
"""

# ╔═╡ f843a896-791e-11eb-226c-27aae04a225c


# ╔═╡ 3388abfc-77be-11eb-04fb-ebcea16d3d07
md"""
2. Write a method `Base.Float64(x::MyFloat)` that converts a `MyFloat` object to a `Float64`. You should re-use your function from [1].
"""

# ╔═╡ fb97d6b8-791e-11eb-0883-35a172cd98ab


# ╔═╡ dc79f98a-77c0-11eb-2817-95eca797585d
md"""
3. Test that you get the correct result for the value of `x` that we defined above.
"""

# ╔═╡ fd0c254c-791e-11eb-1012-210014c3c8da


# ╔═╡ efb52a92-77c0-11eb-12b1-4fb0bcda54f1
md"""
4. Write a function `my_next_float(x::MyFloat)` that finds the next float that you can represent with the same precision as `x`. 

   Here it is your responsibility to make sure that you deal correctly with what happens when $f$ reaches the maximum of its possible range of values.
"""

# ╔═╡ 019b0b4e-791f-11eb-2bfd-3d71625a1d99


# ╔═╡ 0905d778-77c1-11eb-0a3b-910f9651c4c9
md"""
5. What is the smallest representable value with the given range of the exponent $e$ and given precision $p$?

   Start there and use your function `my_next_float` to make a vector of all of the representable floats with $p=3$ bits of precision and a minimum and maximum exponent of $\pm 3$, in increasing order, starting from the smallest. Draw all these points using `Plots.jl`.
"""

# ╔═╡ 0401325e-791f-11eb-37ce-a760c2b9154f


# ╔═╡ 6d455eae-7209-11eb-3eca-21c358fac67b
md"""
### Exercise 2: Evaluating polynomials

Consider the polynomial 

$$p(a, x) = a_0 + a_1 x + \cdots + a_n x^n.$$

In this exercise and later, we will represent this as a single Julia `Vector`  a` which contains the coefficients $a_0, \ldots, a_n$, in that order in the vector, so that the first element of the vector is $a_0$ and the last is $a_n$.

For example, $1 + 2x + 3x^2$ is represented by `a = [1, 2, 3]`.

"""

# ╔═╡ 905269e6-77c2-11eb-361a-c77b6a8ed277
md"""
1. Write a function `poly_eval(a, x)` to evaluate $p(a, x)$ in the naive way by just summing the terms as written. 

   Tip: `length(v)` gives the number of elements in a `Vector`.   
"""

# ╔═╡ 0def2210-791f-11eb-0cf1-6bc6fef582fe


# ╔═╡ 6664caf6-77b9-11eb-2998-eb13b501be1e
md""" 

2. The **Horner method** is an alternative algorithm to evaluate a polynomial which does not use powers.

   For example, for a quadratic
   $p(x) = a_0 + a_1 x + a_2 x^2$, we rewrite $p$ as
   $p(x) = a_0 + x(a_1 + a_2 x)$

   Generalise this to polynomials of degree $3$ and then degree $n$
"""

# ╔═╡ 137fda26-791f-11eb-3f67-9b12cc532a00


# ╔═╡ 6698c374-77b9-11eb-17c5-6953ec0f845b
md"""
3. Implement this as a function `horner(a, x)`.
"""

# ╔═╡ 142ae1dc-791f-11eb-16ee-378cba8767b7


# ╔═╡ 66996414-77b9-11eb-047b-7bec89ab4c69
md"""
4. Test `horner` to make sure it gives the same result as `poly_eval` by evaluating the polynomial $1 + 2x + 3x^2 + 4x^3$ in both ways for all multiples of $0.1$ between $0$ and $10$ and checking that they give the same results.
"""

# ╔═╡ 15ff4908-791f-11eb-18ea-41241069171e


# ╔═╡ 66b9d30c-77b9-11eb-3c5c-c9463d1e29a8
md"""
5. Count (approximately) the *number of operations* required by each of the two algorithms, assume that powers are calculated in the naive way by repeated multiplication.

   Which do you think will be faster to execute? Which will probably have lower rounding error?

"""

# ╔═╡ 17ae196c-791f-11eb-1ac8-81bc285a0aae


# ╔═╡ 1183baaa-77ba-11eb-18c1-ed32e7ab4d25
md"""
6. [Extra credit] What would be a more efficient way of evaluating $x^n$? Approximately how many operations would that require?
"""

# ╔═╡ 1a0fb9a6-791f-11eb-300e-ffceeff43e6f


# ╔═╡ 65fe461a-77ba-11eb-3752-d774ffddd6a6
md"""

### Exercise 3: Calculating $\exp$

In this exercise we will calculate the polynomial approximation to $\exp$ from lectures:

$$\exp_N(x) = \sum_{n=0}^N \frac{x^n}{n!}.$$

"""

# ╔═╡ 806f3478-77c2-11eb-05fa-951e01d84b24
md"""
1. Let's denote the $n$th term by $t_n := x^n / n!$. 

   If you already know $t_n$, how can you compute $t_{n+1}$ *without* explicitly calculating the factorial?
"""

# ╔═╡ 1ecff564-791f-11eb-2470-7508f198357c


# ╔═╡ a2378570-77c1-11eb-1eb0-ed76e1107e2e
md"""
2. Use [1] to implement a function `my_exp(x, N)` for $\exp_N(x)$.
"""

# ╔═╡ 20c5f26a-791f-11eb-0f48-d38d2003c1d9


# ╔═╡ af6c5b02-77c2-11eb-3cdc-49f0568a672f
md"""
3. For $x=5.0$, calculate $\exp_N(x)$ for $N$ varying from 1 to 100 and store the results in a vector `my_exps`.  
"""

# ╔═╡ 21ddaca6-791f-11eb-3edc-278aa83797df


# ╔═╡ d0e92956-77c2-11eb-08b0-33393f29e7be
md"""
4. Use `BigFloat`s to calculate the distance $|\exp_N(x) - \exp(x)|$ and plot it as a function of $N$. 

   What do you notice?  How fast do you think $\exp_N(x)$ is **converging** to $\exp(x)$?

   Tip: You may want to try plotting on *logarithmic* scales by using the keyword argument `xscale=:log10` (and similarly for `yscale`).
"""

# ╔═╡ 24bac300-791f-11eb-03fe-490e93152cfc


# ╔═╡ 04680c48-77c3-11eb-07ee-d17a5d0eb43d
md"""
5. For large values of $x$ you would need many terms of the series to get a good approximation. An alternative is **range reduction**: 

   We calculate $\exp(x)$ for large $x$ by reducing it to the calculation of $\exp(r)$ for $r \in [-0.5, 0.5]$. To do so we use

   $$\exp(2x) = \exp(x)^2.$$

   Write a function `my_exp` that uses range reduction, together with your previous method of `my_exp` with a suitably large value of $N$, to calculate the exponential for any positive input value $x$.
	
"""

# ╔═╡ 3488f86a-791f-11eb-3380-e93271d7d04b


# ╔═╡ 73a427ac-77c3-11eb-3aed-9d25021c4e27
md"""
6. Compare your value of `my_exp(100)` to Julia's. How good is it?
"""

# ╔═╡ 364d467e-791f-11eb-2667-e15f9d2551a9


# ╔═╡ 27bbf608-77c8-11eb-21ab-99bbb3f08249
md"""
7. [Extra credit] What do you think you should do for negative values of $x$?
"""

# ╔═╡ 3f171f00-791f-11eb-0865-a7d64347642a


# ╔═╡ a17828d6-77c3-11eb-318b-fd30eb199f52
md"""
### Exercise 4: Functions of polynomials

In this exercise we will write some key mathematical operations for polynomials
$p(x) = \sum_{n=0}^N p_n x^n$ and $q(x) = \sum_{m=0}^N p_m x^m$. For simplicity we will take the degrees $N$ to be the same for both polynomials.

Each function should accept polynomial(s) written as vectors of coefficients, as in exercise [2], and return a vector of coefficients of the resulting polynomial.

"""

# ╔═╡ ab11288e-77c3-11eb-36e9-dbc10330486a
md"""
1. Write a function `add` to sum $p$ and $q$.
"""

# ╔═╡ 4123a89a-791f-11eb-3271-f10816c11954


# ╔═╡ 636da092-77c4-11eb-1649-c738d6870f5c
md"""
2. Write a function `derivative` for a polynomial $p$ that calculates the derivative $p'$. 
"""

# ╔═╡ 42bac77e-791f-11eb-23d8-3170089d2e97


# ╔═╡ a573c3b8-77c4-11eb-034f-db8b81efe7db
md"""
3. Find the mathematical expression for the product $p(x) q(x)$.

   Hint: Which terms contribute to $x^k$ in the resulting product?

   Tip: Remember that Julia's arrays have "1-based indexing", i.e. the first element is `x[1]`, not `x[0]`.

"""

# ╔═╡ 4a77705c-791f-11eb-03d6-0bae50764462


# ╔═╡ 27c61f5a-77c5-11eb-3fcb-fdfa24e57909
md"""
4. Implement the multiplication in a function `multiply`.
"""

# ╔═╡ 60e7c800-791f-11eb-3f08-3bc776e718b6


# ╔═╡ 86c34f36-77ba-11eb-1486-71072d533d25
md"""

### Exercise 5 [Extra credit]: Defining a type for polynomials


Although we have used polynomials a lot, we have not so far had a way
to say "this object is a polynomial". For this we need to **define a new type** to represent a polynomial!
"""

# ╔═╡ c6bd5166-77c3-11eb-2707-8f9908807c47
md"""


1. Define a type `Polynomial` to represent a polynomial. It should
    have fields `degree` and `coefficients`.

2. Write a **constructor** function with the same name (`Polynomial`)
    that accepts a vector of coefficients and builds a `Polynomial`
    object whose degree it automatically calculates.

3. Write a `show` method to display the polynomial nicely.

4. Write a function to evaluate the polynomial at a point `x`, as follows:

    ```julia
    function (p::Polynomial)(x)
        # fill in
    end
    ```

    Then if you have an object `p` of type polynomial, writing e.g. `p(3)`
    will evaluate that polynomial at the value 3 !

5. Write a function `derivative` that takes a polynomial and returns a new polynomial
    that is its derivative. 

6. Write `+` and `*` functions, re-using your code from Exercise 4.

7. Julia contains a module `Test` (in the standard library -- no installation
    required) for testing that code is correct.

    Write a few tests of the functionality you have defined using
    tests of the form

    ```julia
    @test a == b
    ```

    E.g. to test the sum of two `Polynomial`s you can write

    ```julia
    @test Polynomial([1, 2]) + Polynomial([3, 4]) == Polynomial([4, 6])
    ```

    When you run these tests, you should see the message `Test passed`.

    To create the tests, do the calculations by hand.

"""

# ╔═╡ 66fe2d56-791f-11eb-3d36-07011f20c93b


# ╔═╡ Cell order:
# ╟─56758636-7209-11eb-3f8f-f99a6aec934b
# ╟─8ad1bd54-791f-11eb-2127-6d180e178d93
# ╟─e24306d0-77bc-11eb-2ec1-996ff91a5397
# ╠═bace73c2-77bd-11eb-0f64-67fac915efd7
# ╟─1370c7b6-77be-11eb-1625-e1e5dc9b1905
# ╠═c96641ee-77bd-11eb-16d8-5d6ec861b5eb
# ╟─af0fb78c-77c0-11eb-1c9b-9b2bb5ea1512
# ╠═f843a896-791e-11eb-226c-27aae04a225c
# ╟─3388abfc-77be-11eb-04fb-ebcea16d3d07
# ╠═fb97d6b8-791e-11eb-0883-35a172cd98ab
# ╟─dc79f98a-77c0-11eb-2817-95eca797585d
# ╠═fd0c254c-791e-11eb-1012-210014c3c8da
# ╟─efb52a92-77c0-11eb-12b1-4fb0bcda54f1
# ╠═019b0b4e-791f-11eb-2bfd-3d71625a1d99
# ╟─0905d778-77c1-11eb-0a3b-910f9651c4c9
# ╠═0401325e-791f-11eb-37ce-a760c2b9154f
# ╟─6d455eae-7209-11eb-3eca-21c358fac67b
# ╟─905269e6-77c2-11eb-361a-c77b6a8ed277
# ╠═0def2210-791f-11eb-0cf1-6bc6fef582fe
# ╟─6664caf6-77b9-11eb-2998-eb13b501be1e
# ╠═137fda26-791f-11eb-3f67-9b12cc532a00
# ╟─6698c374-77b9-11eb-17c5-6953ec0f845b
# ╠═142ae1dc-791f-11eb-16ee-378cba8767b7
# ╟─66996414-77b9-11eb-047b-7bec89ab4c69
# ╠═15ff4908-791f-11eb-18ea-41241069171e
# ╟─66b9d30c-77b9-11eb-3c5c-c9463d1e29a8
# ╠═17ae196c-791f-11eb-1ac8-81bc285a0aae
# ╟─1183baaa-77ba-11eb-18c1-ed32e7ab4d25
# ╠═1a0fb9a6-791f-11eb-300e-ffceeff43e6f
# ╟─65fe461a-77ba-11eb-3752-d774ffddd6a6
# ╟─806f3478-77c2-11eb-05fa-951e01d84b24
# ╠═1ecff564-791f-11eb-2470-7508f198357c
# ╟─a2378570-77c1-11eb-1eb0-ed76e1107e2e
# ╠═20c5f26a-791f-11eb-0f48-d38d2003c1d9
# ╟─af6c5b02-77c2-11eb-3cdc-49f0568a672f
# ╠═21ddaca6-791f-11eb-3edc-278aa83797df
# ╟─d0e92956-77c2-11eb-08b0-33393f29e7be
# ╠═24bac300-791f-11eb-03fe-490e93152cfc
# ╟─04680c48-77c3-11eb-07ee-d17a5d0eb43d
# ╠═3488f86a-791f-11eb-3380-e93271d7d04b
# ╟─73a427ac-77c3-11eb-3aed-9d25021c4e27
# ╠═364d467e-791f-11eb-2667-e15f9d2551a9
# ╟─27bbf608-77c8-11eb-21ab-99bbb3f08249
# ╠═3f171f00-791f-11eb-0865-a7d64347642a
# ╟─a17828d6-77c3-11eb-318b-fd30eb199f52
# ╟─ab11288e-77c3-11eb-36e9-dbc10330486a
# ╠═4123a89a-791f-11eb-3271-f10816c11954
# ╟─636da092-77c4-11eb-1649-c738d6870f5c
# ╠═42bac77e-791f-11eb-23d8-3170089d2e97
# ╟─a573c3b8-77c4-11eb-034f-db8b81efe7db
# ╠═4a77705c-791f-11eb-03d6-0bae50764462
# ╟─27c61f5a-77c5-11eb-3fcb-fdfa24e57909
# ╠═60e7c800-791f-11eb-3f08-3bc776e718b6
# ╟─86c34f36-77ba-11eb-1486-71072d533d25
# ╟─c6bd5166-77c3-11eb-2707-8f9908807c47
# ╠═66fe2d56-791f-11eb-3d36-07011f20c93b
