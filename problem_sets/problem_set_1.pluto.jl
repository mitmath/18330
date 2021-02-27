### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 56758636-7209-11eb-3f8f-f99a6aec934b
md"""
# Problem set 1: 18.330 Spring 2021


## Your name: 

"""

# ╔═╡ ceeff4de-72e5-11eb-19b0-51e1fd03ca16
md"""
### Instructions
1. Add your name above and rename this Pluto notebook to add your name in the filename.

2. Fill in solutions after each sub-question. You may create additional cells where necessary.

3. If something is unclear, or you are having difficulties with Julia or Pluto, please ask on Piazza or in office hours.

4. Only attempt the extra credit questions (if you would like to -- not required) once you have completed the others.

5. Submit your renamed notebook **on Canvas** by the deadline: 

   **Friday 26th February 2021** at **11:59pm EST**.

(You may delete these instructions before you submit.
Please leave the cells with the questions in the notebook.)
"""

# ╔═╡ 456099f2-72e1-11eb-2206-99251dbbf1d1


# ╔═╡ 6d455eae-7209-11eb-3eca-21c358fac67b
md"""
### Exercise 1: Square roots

In this exercise we will extend the square root calculation we did in class.
We will write a function `my_sqrt(x, n)` to calculate the square root of $x$ to $n$ decimal digits.

To do so we will need to write three different **methods** (versions) of `my_sqrt` with different numbers of arguments. Each method will return a pair of numbers that define an interval `(a, b)` (an ordered pair of numbers), for which we know that $\sqrt{x}$ lies within the interval $[a, b]$.

[Note that this is *better* than the usual square root function: the usual one gives an approximation to the square root, but does not tell you on which side of the approximation the true square root lies.]
"""

# ╔═╡ 6a035de8-723d-11eb-0aab-e37109b3310e
md"""
1. Define a function `my_sqrt(x)` to calculate the square root of a positive input $x$ as we did in class. (You can just reuse the code we wrote.) 

   Given a positive number `x`, it returns the pair $(n, n)$ if $n^2 = x$ (i.e. if the square root is indeed the integer $n$), or the pair $(n, n+1)$ if $\sqrt{x}$ lies between $n$ and $n+1$.

"""

# ╔═╡ 6146d894-72e5-11eb-25ac-957ad2b00d07


# ╔═╡ 8ac4b442-720a-11eb-01d5-33193d7d45a1
md"""
2. Check that the result is correct for the input $x = 105$.
"""

# ╔═╡ 61ffa75c-72e5-11eb-2a72-db8e6c34e83d


# ╔═╡ d1695322-7209-11eb-3c96-9d4ac93f0d41
md"""
3. Define a new method `my_sqrt(x, a, b, h)`. This looks for a square root in the interval $(a, b)$ by dividing it into $n$ sub-intervals. It should return the sub-interval that contains the square root. (This assumes that you know that the square root does lie between $a$ and $b$.)
"""

# ╔═╡ 62c38974-72e5-11eb-3c24-bb8be1dcb7a9


# ╔═╡ 0d6ef642-720a-11eb-20b8-af6aa173cd88
md"""
4. Define a new method `my_sqrt(x, n)` to calculate the square root to $n$ decimal places. This must use the methods that you have already written. 

   It first finds the integer range, then repeatedly partitions into 10 sub-intervals to add an extra decimal place in the result.

   Hint: You can do `(p, q) = f()` if the function `f` returns a pair to "unpack" the tuple into the two separate variables `p` and `q`.
"""

# ╔═╡ 638658b4-72e5-11eb-249f-e32d4eb56a66


# ╔═╡ abc7c090-720c-11eb-0511-5d085116a9dd
md"""
5. Check that your code works to calculate $\sqrt{105}$ to 3 decimal places.
"""

# ╔═╡ 644c0c30-72e5-11eb-0b4b-b3542877f8ed


# ╔═╡ 5a724fdc-720c-11eb-3294-1d944017beb6
md"""
6. What happens if you find the exact square root? What could you do instead? (You do not need to implement this.)
"""

# ╔═╡ 650c0454-72e5-11eb-2bee-716f273b3df5


# ╔═╡ d0cddc28-720c-11eb-2813-739151f862e7
md"""
7. [Extra credit] The first step of the algorithm, where we search through all integers to find one near the square root, is inefficient. How can you make it more efficient by using properties of the square root function to provide an initial range to search inside? 

   Hint: How could you compute the number of digits that $x$ has? How can you use that   information?

   Implement this.
"""

# ╔═╡ 66443258-72e5-11eb-3ca3-f9de5fe15eb8


# ╔═╡ f564108c-7245-11eb-02b3-c39ac3ad430e
md"""
### Exercise 2: Towards real numbers
"""

# ╔═╡ 047c8ed4-7246-11eb-114a-3f8f914b5d6b
md"""
In this exercise we will see the main issue when we try to use real numbers: **rounding**. 

We'll do so by taking the simplest case: decimal numbers of the form $a \cdot b$ with an integer $a$ and a *single* decimal digit after the decimal point. That is, we'll represent the decimal $1.2$ as the pair $(1, 2)$.
"""

# ╔═╡ 3e2687a0-7246-11eb-3451-e5cbfe21d288
md"""
1. Define a type `MyDecimal` containing two integers $a$ and $b$ that represents the real number $ a \cdot b = a + \frac{b}{10}$.

   Define a `show` method to print it out as a decimal and check that it prints `MyDecimal(1, 2)` correctly as `1.2`.
"""

# ╔═╡ 682edb8e-72e5-11eb-2069-afa15cda552a


# ╔═╡ 8be9bd22-7246-11eb-3506-51cb2cb73b92
md"""
2. What is the mathematical rule to add two of these numbers together? You must make sure that the resulting value of $b$ is a *single* digit.

   Implement this as a method of `+`.

   Check that it gives the correct result for $1.5 + 2.6$.
"""

# ╔═╡ 68d75430-72e5-11eb-2edd-4dcd30b3af18


# ╔═╡ 13fe66de-7247-11eb-3937-4512599837c6
md"""
3. Now let's consider multiplication. 

   What is the mathematically correct rule to multiply `MyDecimal(a, b)` and `MyDecimal(c, d)`?

   Hint: Think in terms of the mathematical objects that these represent.
"""

# ╔═╡ 6a313314-72e5-11eb-3601-39b99b263116


# ╔═╡ ed13e8e2-7247-11eb-2b40-e92bc14ec7d0
md"""

4. What should $(1.1)^2$ give? The correct answer is $1.21$. But *we cannot represent this number exactly with only 1 decimal digit!*

   Instead we need to **round** the true result $1.21$ by choosing a **representable** value -- in this case it seems reasonable to choose $1.2$. A common choice is to round to the nearest value.

   But now consider $(1.5)^2 = 2.25$. Which way should we round? The true result is *exactly* half-way between two representable values. A common rule is to round down if the digit before the 5 is even, and up if it's odd.

   Implement multiplication following these rules.

   Hint: You can return values from the function to see if you are calculating them correctly, or use `@show` with `with_terminal` method to display things inside the function as we saw in class.

   Hint: Julia has an `iseven` function to test if a number is even, or you can use the `mod` or `%` function for the remainder after division.
"""

# ╔═╡ 6b61edb4-72e5-11eb-0693-71e9da174513


# ╔═╡ 9982f63a-72e6-11eb-06b9-e3990b061d4f
md"""
5.  Check that your code gives the correct result for $5.5 * 6.5$. 
"""

# ╔═╡ a81635fc-72e6-11eb-0dd1-c56cbb74b306


# ╔═╡ b1138e6e-7248-11eb-1f82-d308f1c9b096
md"""

### Exercise 3: Representing irrationals exactly

In this exercise we will see that it is possible to represent *some* irrational numbers in the computer *exactly*. Effectively we will do *symbolic* computation, in which we keep the symbol $\sqrt{2}$, rather than approximating it by a floating-point number.


Let's consider the subset of the real numbers given by $S := \{a + b\sqrt{2}: a, b \in \mathbb{Q} \}$,
    i.e. the set of numbers of the form $a + b\sqrt{2}$ where $a$ and $b$ are rational.

"""

# ╔═╡ e7d084c0-7248-11eb-3996-3f56a7fb5226
md"""
1. Write down formulae for the sum and product of $a_1 + b_1\sqrt{2}$
    and $a_2 + b_2 \sqrt{2}$, showing that the results are in $S$ (i.e. that they have the correct form).
"""

# ╔═╡ 6c84ee3a-72e5-11eb-0ef1-57d95bea4e9b


# ╔═╡ ff51812e-7248-11eb-1123-4f9fe4c52978
md"""
2. Show that $1 / (a + b\sqrt{2})$ is also in $S$ by supposing that it
   equals $c + d \sqrt{2}$ and finding explicit equations for $c$ and $d$.

   What type of equations are they? Solve them to find explicit values for $c$ and $d$ in terms of $a$ and $b$.

   [This shows that we can do division (by non-zero elements) and remain
    within the set, i.e. that $S$ is a **field**, namely an **extension field** of
    $\mathbb{Q}$. ]
"""

# ╔═╡ 6e41612a-72e5-11eb-171b-2f0e40c4c0bf


# ╔═╡ 22c2d27c-7249-11eb-2d01-c156a5a2cad7
md"""
3. Define a type `FieldExtension` to represent these number pairs, and
    the corresponding operations. Also define a `show` method to print them nicely
    using a `√` symbol.

"""

# ╔═╡ 6f468980-72e5-11eb-3020-5bcf50fc876b


# ╔═╡ b86aa638-7249-11eb-3c74-55a3fdafd39f
md"""
4. Use your code to calculate $(1 + 2\sqrt{2})^5$ in the form of an element of $S$. Check that the result agrees with a numerical calculation.
"""

# ╔═╡ 701ab640-72e5-11eb-0d79-35e9832b70fb


# ╔═╡ d7568cac-7248-11eb-3618-93f50d9bff63
md"""
5. [Extra credit]: What happens if you adjoin $\sqrt{2}$ *and* $\sqrt{3}$?
    Find a representation of $1 / (1 + \sqrt{2} + \sqrt{3})$ as an element of the
    corresponding set.

"""

# ╔═╡ 70a7e6ea-72e5-11eb-1072-8de94560445f


# ╔═╡ 8a9fa804-72e7-11eb-1d1f-3f339524597c
md"""
------
*David P. Sanders* $(html"<br>")
*Problem set 1, version 1 -- 18.330 Spring 2021*
"""

# ╔═╡ Cell order:
# ╟─56758636-7209-11eb-3f8f-f99a6aec934b
# ╟─ceeff4de-72e5-11eb-19b0-51e1fd03ca16
# ╠═456099f2-72e1-11eb-2206-99251dbbf1d1
# ╟─6d455eae-7209-11eb-3eca-21c358fac67b
# ╟─6a035de8-723d-11eb-0aab-e37109b3310e
# ╠═6146d894-72e5-11eb-25ac-957ad2b00d07
# ╟─8ac4b442-720a-11eb-01d5-33193d7d45a1
# ╠═61ffa75c-72e5-11eb-2a72-db8e6c34e83d
# ╟─d1695322-7209-11eb-3c96-9d4ac93f0d41
# ╠═62c38974-72e5-11eb-3c24-bb8be1dcb7a9
# ╟─0d6ef642-720a-11eb-20b8-af6aa173cd88
# ╠═638658b4-72e5-11eb-249f-e32d4eb56a66
# ╟─abc7c090-720c-11eb-0511-5d085116a9dd
# ╠═644c0c30-72e5-11eb-0b4b-b3542877f8ed
# ╟─5a724fdc-720c-11eb-3294-1d944017beb6
# ╠═650c0454-72e5-11eb-2bee-716f273b3df5
# ╟─d0cddc28-720c-11eb-2813-739151f862e7
# ╠═66443258-72e5-11eb-3ca3-f9de5fe15eb8
# ╟─f564108c-7245-11eb-02b3-c39ac3ad430e
# ╟─047c8ed4-7246-11eb-114a-3f8f914b5d6b
# ╟─3e2687a0-7246-11eb-3451-e5cbfe21d288
# ╠═682edb8e-72e5-11eb-2069-afa15cda552a
# ╟─8be9bd22-7246-11eb-3506-51cb2cb73b92
# ╠═68d75430-72e5-11eb-2edd-4dcd30b3af18
# ╟─13fe66de-7247-11eb-3937-4512599837c6
# ╠═6a313314-72e5-11eb-3601-39b99b263116
# ╟─ed13e8e2-7247-11eb-2b40-e92bc14ec7d0
# ╠═6b61edb4-72e5-11eb-0693-71e9da174513
# ╟─9982f63a-72e6-11eb-06b9-e3990b061d4f
# ╠═a81635fc-72e6-11eb-0dd1-c56cbb74b306
# ╟─b1138e6e-7248-11eb-1f82-d308f1c9b096
# ╟─e7d084c0-7248-11eb-3996-3f56a7fb5226
# ╠═6c84ee3a-72e5-11eb-0ef1-57d95bea4e9b
# ╟─ff51812e-7248-11eb-1123-4f9fe4c52978
# ╠═6e41612a-72e5-11eb-171b-2f0e40c4c0bf
# ╟─22c2d27c-7249-11eb-2d01-c156a5a2cad7
# ╠═6f468980-72e5-11eb-3020-5bcf50fc876b
# ╟─b86aa638-7249-11eb-3c74-55a3fdafd39f
# ╠═701ab640-72e5-11eb-0d79-35e9832b70fb
# ╟─d7568cac-7248-11eb-3618-93f50d9bff63
# ╠═70a7e6ea-72e5-11eb-1072-8de94560445f
# ╟─8a9fa804-72e7-11eb-1d1f-3f339524597c
