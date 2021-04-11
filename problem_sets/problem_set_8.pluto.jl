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

# ╔═╡ 2af5ffb1-5103-4a66-8900-dc5d7c2ee040
begin
	using Images, TestImages
	
	img = testimage("mandrill")
	imgmat = Array(channelview(Float64.(Gray.(img))))
	heatmap(imgmat, c=:Greys, showaxis=false, clims=(0,1), yflip=true, ratio=1)
end

# ╔═╡ 56758636-7209-11eb-3f8f-f99a6aec934b
md"""
# Problem set 8

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

- Submit on Canvas by **Saturday, 17 April 2021** at **11:59pm EDT**. 
"""

# ╔═╡ 9cad8faa-1c7b-43c0-a0f7-d6ed0dd8d8a0
md"""
### Exercise 1: Calculating the SVD

Consider the matrix `M` given by
"""

# ╔═╡ 98e19502-8831-4e01-96f3-c627bf358097
M = [i + j for i in 1:5, j in 1:10]

# ╔═╡ 746059eb-f857-4add-a61e-076e84a32db2
md"""
1. Recall that the SVD of a matrix $\mathsf{M}$ is the factorisation

   $$\mathsf{M} = \mathsf{U} \Sigma \mathsf{V}^\mathrm{T},$$

   where $U$ and $V$ are orthogonal matrices.

   We saw in lectures that there is a relationship between the SVD and the eigenvalues and eigenvectors of certain symmetric matrices. Use that to calculate the SVD of $\mathsf{M}$ numerically. 

   Hint: For a matrix of size $(m \times n)$, how many singular values are there? Remember to order the singular values from largest to smallest. 

   Hint: Once you have found candidates for $\mathbf{v}_i$ and $\mathbf{u}_i$, you need to make sure that $\mathsf{M} \mathbf{v}_i = \sigma_i \mathbf{u}_i$. If this is not immediately the case, you should be able to see how to change $\mathbf{v}_i$ to maker it satisfied. 

   Tip: You may use the `eigvals` and/or `eig` function from the `LinearAlgebra` standard library in Julia, or your own code from previous problem sets. You can check that your result is correct using Julia's `svd` function.

"""

# ╔═╡ d757f9d6-9001-4304-aa97-388b79911883


# ╔═╡ ae38c8de-ad6c-4f15-b788-5df57af055c4
md"""
2. What is the rank of the matrix $\mathsf{M}$? What does that mean about the columns of $\mathsf{M}$?
"""

# ╔═╡ 940b846a-0cf5-4cc9-b00f-c12d3c3bfa5f


# ╔═╡ e0f45c2c-954f-4c81-bfbe-8536fcd221ae
md"""
3. What is the best rank-$1$ approximation to $\mathsf{M}$? How close is it to $\mathsf{M}$? 

   If $\mathsf{M}$ were a data matrix, how many dimensions would you think of the data as having?
"""

# ╔═╡ fcc4902a-ad63-43da-a90e-3c8e118b9d73


# ╔═╡ 465ab963-7dd0-4ef9-9d7d-ac1f2f9a04ce
md"""

### Exercise 2: Low-rank approximation

In this problem we will use the SVD to produce
**low-rank approximations** for matrices. 

A matrix is of **rank** $r$ if we can write it in the form

$$A = \sum_{i=1}^r \sigma_i \mathbf{u}_i \mathbf{v}_i^\top$$

where the $\mathbf{u}_i$ and $\mathbf{v}_i$ are
vectors of length $N$, so $\mathbf{u}_i \mathbf{v}_i^\top$ is a *matrix* of size
$(N \times N)$, of rank 1.

Recall that this same form occurs in the SVD. Truncating the summation after the largest $r$ singular values gives a rank-$r$ approximation of the matrix $A$; in fact, the Eckhart--Mirsky--Young theorem shows this is the *best* rank-$r$ approximation to $A$.

Define the rank-$r$ approximation of $A$ as
$$A_r := \sum_{i=1}^r \sigma_i \mathbf{u}_i \mathbf{v}_i^\top$$
where $\mathbf{u}_r$ and $\mathbf{v}_r$ are the singular vectors of $A$ and $\sigma_r$ are the singular values of the matrix.
"""

# ╔═╡ d91e18b3-be71-48d5-9848-9aa0dcbe5c8e
md"""

1. Write a function that takes in a matrix `A` and uses the SVD to construct its rank-$r$ approximation, `lowrank_approx(A, r)`. 

   Tip: You may use the `svd` function from the `LinearAlgebra` standard library package as `U, Σ, Vt = svd(A)`. Note that the algorithm produces `Vt`, the transpose of `V`.
"""

# ╔═╡ 712954a9-a109-4cae-8ab8-34f110d5a865
md"""
2. Consider the matrix `M2` given by:
"""

# ╔═╡ 662715a9-0cc6-47ff-bf47-d5e4dd66c363
begin
	n = 21
	half_n = n ÷ 2 + 1
	M2 = zeros(n, n)
	
	M2[half_n-1:half_n+1, half_n-5:half_n+5] .= 1
	M2[half_n-5:half_n+5, half_n-1:half_n+1] .= 1
end;

# ╔═╡ 1eb5e0e5-a11c-48dc-9708-608870e2ef30
md"""

3. Plot the matrix.

   Remembering that the rank is the column rank, i.e. the number of linearly-independent columns, what should the rank be? Use the SVD of `M` to confirm this. What does the rank-1 approximation of `M` look like?

   Tip: You can plot the matrix with `heatmap`.
"""

# ╔═╡ 5e5dfe1a-6a72-4ab2-b34d-c8965dc622c9


# ╔═╡ a36a5b46-b887-4883-b711-6f181280263d
md"""

4. Now add small random gaussian noise using the `randn` function, of intensity 0.1. Plot the new matrix . How should this affect the (column) rank of the matrix?
"""

# ╔═╡ 320474d9-145e-4c85-8155-ea4ae157ddd0


# ╔═╡ 9ba26390-f1c3-44ca-b433-22d6f43a3ae2
md"""

5. Plot the singular values $\sigma_n$ as a function of $n$. What do they tell us? What is a suitable rank-$n$ approximation to take? What does it look like?
"""

# ╔═╡ 52898ec7-7f66-4593-8b57-f7183f3505fd


# ╔═╡ 44955114-28c0-41f7-a2f2-fd4ffcc9269d
md"""

6. Now let's apply these ideas to a real image. Use the `Images.jl` package to load a test image using the following code. 

   Tip: You may need to install the following Julia packages to process images; you can do so by uncommenting and running the following cell. Depending on your operating system, you may be asked to install additional packages too.

"""

# ╔═╡ 47e12dd0-b025-43f1-a5ab-1ae3edea3ba0
# begin
# 	using Pkg
# 	Pkg.add("Images")
# 	Pkg.add("TestImages")
# end

# ╔═╡ 8697a24c-651b-42e1-9a5e-482fe737dfa7
md"""
This produces `imgmat` as a standard Julia matrix containing greyscale pixel values.

"""

# ╔═╡ 38548d62-8b77-47d1-b353-47427b8be561
md"""
7. Create an interactive visualization that shows the low-rank approximation for different values of $r$. After which $r$ are you happy with the quality of the resulting image?
"""

# ╔═╡ 20d13425-f1e3-444e-b7c9-eb1e9a3df7f7


# ╔═╡ 57b64c8b-9c71-4132-8f65-7cc582ab4d04
md"""
8. Calculate the singular values and plot them as a function of $n$. You should see an "elbow" shape. Where does the elbow occur? Does this correspond with your answer from [7]?
"""

# ╔═╡ 6dd6b97d-2157-4dce-a91a-d92a7144c15b


# ╔═╡ 59638b5a-965f-434b-9f23-3cb32caf4c3e
md"""
### Exercise 3: Conditioning of a problem and stability of an algorithm

Consider the problem of calculating

$$\phi(x) = \sqrt{1 + x} - 1$$

for a real number $x$.
"""

# ╔═╡ d7419152-8d4f-480c-8164-864a364a6330
md"""

1. Calculate the relative condition number $\kappa_\phi(x)$ as a function of $x$ for $x \neq 0$.
"""

# ╔═╡ 2f0bab5c-8df6-4060-ba70-5ae924e72524


# ╔═╡ 8d7837f7-409a-4e8b-8d6f-f135d4e7e1bb


# ╔═╡ 47f3a030-f33e-40d5-b4a4-668dcb6e87b6
md"""
2. Calculate the relative condition number $\kappa_\phi(x)$ for $x = 0$.

   Hint: Since $\phi(x=0) = 0$ you will have to do something extra to calculate $\kappa$ there.
"""

# ╔═╡ 856f1f5d-d3f2-448e-9d75-11812047e202


# ╔═╡ aff03327-afbb-4b86-9ef6-6038756955e1
md"""
3. Where is the problem well- and ill-conditioned? In particular, is it well-conditioned at $x=0$?
"""

# ╔═╡ d6c7898b-b35e-4687-af13-dfb880f4d7b6


# ╔═╡ 3150e48f-61b9-4693-8562-77a0309fce96
md"""
4. Consider the obvious algorithm for calculating $\phi$ near $x=0$. Treating it as a series of algorithmic steps, calculate the condition number of each step. 
  
"""

# ╔═╡ edba4db9-07dc-47bb-9d8c-0179bdb882b8


# ╔═╡ 065783b0-24f0-44c0-9258-c2f2428ff0d3
md"""
5. Is this algorithm **stable**, i.e. does the calculation behave as well as the relative condition number suggests?
"""

# ╔═╡ 3f5fb50e-3175-4966-8cb6-2ce2db181729


# ╔═╡ 96f2ebe7-a312-485a-9ba2-782b649d13dc
md"""
6. By using an algebraic manipulation, find an alternative expression for $\phi(x)$ for $x$ near $0$, and hence an improved algorithm.
"""

# ╔═╡ f3d02c0f-e99c-4e51-84b1-58c060c1d318


# ╔═╡ 39a66970-46a1-4087-880e-4083f2457e57
md"""
7. Implement both the obvious algorithm and your better algorithm. 

   Use `BigFloat`s to evaluate the true value of $\phi$ and calculate the relative error of both algorithms for different values of $x$ as $|x|$ decreases toward $0$.

   Plot the errors as a function of $x$ on the same axes. Is your new algorithm better?
"""

# ╔═╡ a40d455f-a574-4342-98b0-a2fc410d4bf8


# ╔═╡ 526db41d-4361-433c-9335-f677e2e331ea
md"""

### Exercise 4: Conditioning of polynomial roots

Consider the degree-$n$ polynomial
$p(x) = a_0 + a_1 x + \cdots + a_n x^n$.

1. Show that the condition number of the problem of finding a given root $r$ of this polymomial, when the leading coefficient $a_n$ is varied, is

   $$\kappa = \left| \frac{a_n r^{n-1}}{p'(r)} \right|,$$

   where $p'$ is the derivative of $p$.

   Hint: Use e.g. implicit differentiation on the equation satisfied by the root $r$.
"""

# ╔═╡ 164ff732-c5c7-4ef8-85bd-bb0c3a9663fc


# ╔═╡ c52dd38c-7342-4645-9ac2-641a652a8713
md"""
2. Consider the (in)famous Wilkinson polynomial

   $$p(x) = (x - 1) (x - 2) \cdots (x - 20).$$

   Calculate the coefficients of the polynomial using e.g. the [`Polynomials.jl`](https://github.com/JuliaMath/Polynomials.jl) package, or your code from previous problem sets.

   Tip: Note that you will need to use `Int128` or `BigInt` coefficients to avoid integer overflow.
"""

# ╔═╡ abe47f4c-5024-498b-ac0c-b3578ad57df8


# ╔═╡ 2afadb01-fb7a-4533-9c78-6e76643fa2f1
md"""

3. Calculate the condition number for each root of the polynomial. Which roots are well-conditioned and which are ill-conditioned?
"""

# ╔═╡ 2d90cf9a-46cb-4521-9965-56af28a4db0a


# ╔═╡ 00bd91f2-626d-4ce5-809b-5e4f44b7b95f
md"""
4. Calculate the roots of $p(x)$. Are they correct?

   Tip: You can use e.g. the `roots` function from the `Polynomials.jl` package.
"""

# ╔═╡ 2332c8cb-f7b0-4cf1-bc15-403fe97772e8


# ╔═╡ ea96b868-ba8c-4e6d-ba29-ee192592437e
md"""
5. Perturb the largest coefficient of $p(x)$ by `randn()*2.0^(-23)` and find and plot the (in general complex) roots in the complex plane.

   Repeat this 50 times to see a visual representation of the unstable nature of polynomial root finding.

   Does the result agree with what you calculated in [3]?

   Tip: Passing a vector of complex numbers to `scatter` will plot them directly in the complex plane.
"""

# ╔═╡ f2038db0-d470-480d-810d-5718f2007554


# ╔═╡ Cell order:
# ╟─56758636-7209-11eb-3f8f-f99a6aec934b
# ╟─8ad1bd54-791f-11eb-2127-6d180e178d93
# ╠═73c21295-6a80-47ab-9f2a-a30a0db098fb
# ╟─9cad8faa-1c7b-43c0-a0f7-d6ed0dd8d8a0
# ╠═98e19502-8831-4e01-96f3-c627bf358097
# ╟─746059eb-f857-4add-a61e-076e84a32db2
# ╠═d757f9d6-9001-4304-aa97-388b79911883
# ╟─ae38c8de-ad6c-4f15-b788-5df57af055c4
# ╠═940b846a-0cf5-4cc9-b00f-c12d3c3bfa5f
# ╟─e0f45c2c-954f-4c81-bfbe-8536fcd221ae
# ╠═fcc4902a-ad63-43da-a90e-3c8e118b9d73
# ╟─465ab963-7dd0-4ef9-9d7d-ac1f2f9a04ce
# ╟─d91e18b3-be71-48d5-9848-9aa0dcbe5c8e
# ╟─712954a9-a109-4cae-8ab8-34f110d5a865
# ╠═662715a9-0cc6-47ff-bf47-d5e4dd66c363
# ╟─1eb5e0e5-a11c-48dc-9708-608870e2ef30
# ╠═5e5dfe1a-6a72-4ab2-b34d-c8965dc622c9
# ╟─a36a5b46-b887-4883-b711-6f181280263d
# ╠═320474d9-145e-4c85-8155-ea4ae157ddd0
# ╟─9ba26390-f1c3-44ca-b433-22d6f43a3ae2
# ╠═52898ec7-7f66-4593-8b57-f7183f3505fd
# ╟─44955114-28c0-41f7-a2f2-fd4ffcc9269d
# ╠═47e12dd0-b025-43f1-a5ab-1ae3edea3ba0
# ╠═2af5ffb1-5103-4a66-8900-dc5d7c2ee040
# ╟─8697a24c-651b-42e1-9a5e-482fe737dfa7
# ╟─38548d62-8b77-47d1-b353-47427b8be561
# ╠═20d13425-f1e3-444e-b7c9-eb1e9a3df7f7
# ╟─57b64c8b-9c71-4132-8f65-7cc582ab4d04
# ╠═6dd6b97d-2157-4dce-a91a-d92a7144c15b
# ╟─59638b5a-965f-434b-9f23-3cb32caf4c3e
# ╟─d7419152-8d4f-480c-8164-864a364a6330
# ╟─2f0bab5c-8df6-4060-ba70-5ae924e72524
# ╠═8d7837f7-409a-4e8b-8d6f-f135d4e7e1bb
# ╟─47f3a030-f33e-40d5-b4a4-668dcb6e87b6
# ╠═856f1f5d-d3f2-448e-9d75-11812047e202
# ╟─aff03327-afbb-4b86-9ef6-6038756955e1
# ╠═d6c7898b-b35e-4687-af13-dfb880f4d7b6
# ╟─3150e48f-61b9-4693-8562-77a0309fce96
# ╠═edba4db9-07dc-47bb-9d8c-0179bdb882b8
# ╟─065783b0-24f0-44c0-9258-c2f2428ff0d3
# ╠═3f5fb50e-3175-4966-8cb6-2ce2db181729
# ╟─96f2ebe7-a312-485a-9ba2-782b649d13dc
# ╠═f3d02c0f-e99c-4e51-84b1-58c060c1d318
# ╟─39a66970-46a1-4087-880e-4083f2457e57
# ╠═a40d455f-a574-4342-98b0-a2fc410d4bf8
# ╟─526db41d-4361-433c-9335-f677e2e331ea
# ╠═164ff732-c5c7-4ef8-85bd-bb0c3a9663fc
# ╟─c52dd38c-7342-4645-9ac2-641a652a8713
# ╠═abe47f4c-5024-498b-ac0c-b3578ad57df8
# ╟─2afadb01-fb7a-4533-9c78-6e76643fa2f1
# ╠═2d90cf9a-46cb-4521-9965-56af28a4db0a
# ╟─00bd91f2-626d-4ce5-809b-5e4f44b7b95f
# ╠═2332c8cb-f7b0-4cf1-bc15-403fe97772e8
# ╟─ea96b868-ba8c-4e6d-ba29-ee192592437e
# ╠═f2038db0-d470-480d-810d-5718f2007554
