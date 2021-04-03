### A Pluto.jl notebook ###
# v0.14.0

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
# Problem set 7

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

- Submit on Canvas by **Saturday, 10 April 2021** at **11:59pm EDT**. 
"""

# ╔═╡ b50d86c2-bf33-434f-b8d0-e6d01e90e063
md"""
### Exercise 1: Power iteration
"""

# ╔═╡ acc20d11-a863-401e-9786-49c7e6594dd7
md"""
In this question we will implement power iteration, and we will apply it to the symmetric matrix `S` given by
"""

# ╔═╡ 23a0a2a6-f1c9-4c8f-8458-c761d099a35f
S = Matrix(Tridiagonal(-1 * ones(3), 2 * ones(4), -1 * ones(3)))

# ╔═╡ b7e2d5f0-7db7-44c7-86c0-070f8799fe12
md"""
1. Find the largest eigenvalue of `S` and its associated eigenvector, using power iteration.
"""

# ╔═╡ 3dea9533-3f8e-4aaf-a39f-5bdd86d2dda2


# ╔═╡ d40694d0-5e90-4c41-a2be-73506feb3f25
md"""
2. Draw a suitable graph of the convergence and find its rate.
"""

# ╔═╡ 8ad87af0-6f13-49ad-ace9-c91ad610580e


# ╔═╡ 5207ac91-1a3b-4a75-9e8f-bce4a0e4ff3b
md"""
3. [Theoretical question] To understand the convergence of power iteration, suppose that we start from an initial vector $\mathbf{x}_0$. 

   Expand $\mathbf{x}_0$ in the basis of eigenvectors $(\mathbf{v}_i)_{i=1}^m$ of the (general) symmetric matrix $\mathsf{S}$. 

   Find an expression for $\mathbf{x}_n := \mathsf{S}^n \mathbf{x}_0$ in terms of the $\mathbf{v}_i$.

   Hence show that the power iteration converges to the eigenvector whose eigenvalue is the largest in magnitude, and find the rate of convergence.
"""

# ╔═╡ 3b0265bf-cf8b-40a9-bf55-c8ab88a8d167


# ╔═╡ 9a4e1b10-d9ff-4670-ba24-3b094159f1ad
md"""
4. Implement the (standard) Gram--Schmidt algorithm in a function `gram_schmidt`.
"""

# ╔═╡ fee3f4a5-e2bf-4070-9135-647789a7f515


# ╔═╡ 2eb5724b-6a51-4a11-8f79-3ebeecd43775


# ╔═╡ 728054af-cb6f-4cd5-81e2-2fdae09e7ac0
md"""
5. Find all eigenvalues and eigenvectors of `S`.  
"""

# ╔═╡ fb90b22f-23f4-4c3e-b722-0e0370dbd2e9


# ╔═╡ e90c5e72-4623-4383-a11a-284bb16d3f46
md"""
6. How fast does the second eigenvector converge?
"""

# ╔═╡ 04766a6c-06ba-442b-885a-71a59b84ffcf


# ╔═╡ 7290b873-34f2-499c-a495-58e1d0fdca33
md"""
7. If you try to apply your algorithm to calculate all eigenvalues and eigenvectors of the following matrix `T`, you should find that the eigenvectors except for the first do not seem to converge. (Before running the code you should make sure to have a cut-off for the total number of iterations you allow it to run.)

   Nonetheless, you should be able to calculate the eigen*values*. What do they tell you about the rank of the matrix?
"""

# ╔═╡ 29e5eda6-2ecf-4e9e-88e1-e8c907cad3b3
T = Symmetric([i * j for i in 1:8, j in 1:8])

# ╔═╡ f9b7e7c6-5166-4a21-8e99-206a782d4632


# ╔═╡ 6290f9fe-275e-4396-a8e3-c32877212479
md"""
### Exercise 2: Least-squares fitting
"""

# ╔═╡ 5f33c9ea-effa-4dd1-af2e-6891a9f0b32c
md"""
1. Use your code from [Exercise 1] to make a `QR` function that calculates the QR factorisation of a matrix. [This is *not* an efficient method to calculate the QR factorisation!]
"""

# ╔═╡ f29007e1-584c-4da9-8de0-5500c6a8e4de


# ╔═╡ 6d817d86-481c-40b1-b376-1328acca821f
md"""
2. Use your code to find the best linear fit to some 2D data, in a function `linear_fit(xs, ys)` where you pass in the x and y coordinates.
"""

# ╔═╡ c8107c73-758f-467e-942b-ca6e8089bcf9


# ╔═╡ 840cde5c-ff58-46bc-9353-ee1e01bb66ed
md"""
3. Find the best linear fit to the following data:
"""

# ╔═╡ 32753b39-47c0-496f-8080-c5eb1a6be604
begin
	
	import Random
	Random.seed!(5)
	
	f(x) = -sqrt(2) * x^2 + 3x - 17
	
	xs = -3 .+ 6 .* rand(50)
	ys = f.(xs) .+ 5 .* rand.()

end

# ╔═╡ eec42592-d206-40ab-a9fa-73b9c8f45d37


# ╔═╡ b39c3bcc-ddd4-4cab-896c-ea5132b78e43
md"""
4. Generalise your function to a function `polyfit(xs, ys, n)` to fit a polynomial of degree $n$ to the data.
"""

# ╔═╡ ed6f9831-783c-4df6-8248-647f741fc2cb


# ╔═╡ 1398daa2-26b3-468c-9e2b-81a7b4d73b78
md"""
5. Use your code to find the best polynomial fits of degrees 2 to 10 to the data.
"""

# ╔═╡ cf7d4d27-5c4c-43cf-abc5-e14b76b80ec9


# ╔═╡ fd6969da-9820-4620-b7fb-dc91e2b78ec4
md"""
6. Plot the data and the curves. Which model best represents the data? Which do not represent it well? Why not?
"""

# ╔═╡ f3d4dc58-5475-4a5e-9005-80b59c37f3c2


# ╔═╡ d1477662-d145-4ae9-bc14-c96149be93db
md"""

## Exercise 3: Exploiting structure in matrices: Tridiagonal QR

In this exercise we will see how to exploit structure (zeros again) to make a more efficient QR algorithm.
(However, you do not need you to code the algorithm.)

We can think of the QR algorithm as making an orthogonal matrix via column operations, as we did in lectures, *or* as making an upper-triangular matrix via orthogonal operations (rotations), which is what we will do in this exercise for the special case of a tridiagonal matrix.

Consider a general tridiagonal matrix:

$$T = \left[ \begin{matrix} b_1 & c_1 \\ a_2 & b_2 & c_2 \\ & a_3 & b_3 & c_3 \\ && \ddots & \ddots & \ddots \\ &&& a_{N-1} & b_{N-1} & c_{N-1} \\ &&&& a_N & b_N \end{matrix} \right]$$

Since there is only a single subdiagonal it should be easier to make the matrix upper-triangular by operating on it.

[Since this question is not computational, you may either submit a photo of a hand-written version or type the results in the notebook.]
"""

# ╔═╡ c31cc246-448f-4c1d-84c2-3cea20ccdc31
md"""
1. Consider the rotation matrix

$$R(\theta) := \begin{bmatrix}
			\cos \theta & -\sin \theta \\
			\sin \theta & \cos \theta
			\end{bmatrix}$$

  How should you choose $\theta$ so that

$$R(\theta) \begin{bmatrix} p \\ q \end{bmatrix} = \begin{bmatrix} r \\ 0 \end{bmatrix},$$
	
   where $r^2 = p^2 + q^2$ ?
"""

# ╔═╡ 996101ab-ed66-4d59-8dab-227739bb4361


# ╔═╡ 415b2d46-4f82-4e01-bc9e-e029f4973cc4
md"""
2. Consider the matrix

$$P_0 = \begin{bmatrix} R(\theta) & 0 \\ 0 & I_{N-2} \end{bmatrix}$$

   where $I_N$ is the $N \times N$ identity matrix, and where $\theta$ is chosen as in [1] with $p = b_1$ and $q = a_2$. What does the resulting matrix $\tilde{A}_1 = P_0 A$ look like? Show that the first column is now upper-triangular.

   To be more concrete consider the matrix
   $$M = \begin{bmatrix} 1 & 4 & 0 & 0 \\
						2 & 1 & 3 & 0 \\
						0 & 5 & 6 & 7 \\
						0 & 0 & 1 & 2
						\end{bmatrix}.$$

   Show the resulting matrix when you multiply by $P_0$ -- is it what you expected?
"""

# ╔═╡ 693ed70a-3526-4303-b7f1-4d51f5ef489f


# ╔═╡ df5f8e7d-5ddc-4238-bd68-5f5621c0b353
md"""
3. What matrix should you multiply $\tilde{A}_1$ by to make the second column upper-triangular? (Hint: it will have a similar structure  to $P_0$.) Check that the first column is still upper-triangular. Call this matrix $P_1$. Multiply the result of $P_0 M$ by $P_1$ and show the result.
"""

# ╔═╡ 9e257598-ada4-44e8-845e-02e2f1f8999f


# ╔═╡ 0d1b5ef7-70a3-4636-a8b9-ce4fbee94350
md"""

4. Generalize to the rotation matrix that makes the $n$th column of a tridiagonal matrix upper-triangular. Call this matrix $P_{n-1}$. Show that $P_{n-1}$ is orthogonal, i.e. $P_n P_n^\mathrm{T} = I$.
"""

# ╔═╡ 414b8ba9-db91-41e5-b75c-48316c9a9c26


# ╔═╡ 1e0a6480-d6cf-45db-b4da-d05d12f994b5
md"""

5. We can now write a tridiagonal matrix $T$ in upper-triangular form by forming the product $P_{N-2} P_{N-3} \cdots P_1 P_0 T$. From the above we see that the result of this will be an upper-triangular matrix $R$.

   Show that the product of orthogonal matrices is orthogonal, and hence that this procedure gives a QR decomposition of $T$.
"""

# ╔═╡ 9567d8c6-e159-43df-b695-041d7cd8d4fa


# ╔═╡ f5ee7561-9ac7-4b3c-afbb-e60fb0decf84
md"""
6. What is the approximate operation count for a full QR factorization on a dense matrix $A$?
"""

# ╔═╡ 26001ff5-0b23-4579-a07f-cad2448a4c89


# ╔═╡ ca54dcaa-46e8-4bee-aed3-5e89f114279a
md"""
7. What is the approximate operation count for this reduced tridiagonal QR?
"""

# ╔═╡ 78913ee3-2f63-440e-89cc-a15d04aa4857


# ╔═╡ 28436841-148b-4fa0-964e-8131e1daff9d
md"""
8. [Extra credit] Implement this algorithm in an efficient way.
"""

# ╔═╡ e4e45da1-5cbf-4513-826d-e48c0d3e95e7


# ╔═╡ Cell order:
# ╟─56758636-7209-11eb-3f8f-f99a6aec934b
# ╟─8ad1bd54-791f-11eb-2127-6d180e178d93
# ╠═73c21295-6a80-47ab-9f2a-a30a0db098fb
# ╟─b50d86c2-bf33-434f-b8d0-e6d01e90e063
# ╟─acc20d11-a863-401e-9786-49c7e6594dd7
# ╠═23a0a2a6-f1c9-4c8f-8458-c761d099a35f
# ╟─b7e2d5f0-7db7-44c7-86c0-070f8799fe12
# ╠═3dea9533-3f8e-4aaf-a39f-5bdd86d2dda2
# ╟─d40694d0-5e90-4c41-a2be-73506feb3f25
# ╠═8ad87af0-6f13-49ad-ace9-c91ad610580e
# ╟─5207ac91-1a3b-4a75-9e8f-bce4a0e4ff3b
# ╠═3b0265bf-cf8b-40a9-bf55-c8ab88a8d167
# ╟─9a4e1b10-d9ff-4670-ba24-3b094159f1ad
# ╠═fee3f4a5-e2bf-4070-9135-647789a7f515
# ╠═2eb5724b-6a51-4a11-8f79-3ebeecd43775
# ╟─728054af-cb6f-4cd5-81e2-2fdae09e7ac0
# ╠═fb90b22f-23f4-4c3e-b722-0e0370dbd2e9
# ╟─e90c5e72-4623-4383-a11a-284bb16d3f46
# ╠═04766a6c-06ba-442b-885a-71a59b84ffcf
# ╟─7290b873-34f2-499c-a495-58e1d0fdca33
# ╠═29e5eda6-2ecf-4e9e-88e1-e8c907cad3b3
# ╠═f9b7e7c6-5166-4a21-8e99-206a782d4632
# ╟─6290f9fe-275e-4396-a8e3-c32877212479
# ╟─5f33c9ea-effa-4dd1-af2e-6891a9f0b32c
# ╠═f29007e1-584c-4da9-8de0-5500c6a8e4de
# ╟─6d817d86-481c-40b1-b376-1328acca821f
# ╠═c8107c73-758f-467e-942b-ca6e8089bcf9
# ╟─840cde5c-ff58-46bc-9353-ee1e01bb66ed
# ╠═32753b39-47c0-496f-8080-c5eb1a6be604
# ╠═eec42592-d206-40ab-a9fa-73b9c8f45d37
# ╟─b39c3bcc-ddd4-4cab-896c-ea5132b78e43
# ╠═ed6f9831-783c-4df6-8248-647f741fc2cb
# ╟─1398daa2-26b3-468c-9e2b-81a7b4d73b78
# ╠═cf7d4d27-5c4c-43cf-abc5-e14b76b80ec9
# ╟─fd6969da-9820-4620-b7fb-dc91e2b78ec4
# ╠═f3d4dc58-5475-4a5e-9005-80b59c37f3c2
# ╟─d1477662-d145-4ae9-bc14-c96149be93db
# ╟─c31cc246-448f-4c1d-84c2-3cea20ccdc31
# ╠═996101ab-ed66-4d59-8dab-227739bb4361
# ╟─415b2d46-4f82-4e01-bc9e-e029f4973cc4
# ╠═693ed70a-3526-4303-b7f1-4d51f5ef489f
# ╟─df5f8e7d-5ddc-4238-bd68-5f5621c0b353
# ╠═9e257598-ada4-44e8-845e-02e2f1f8999f
# ╟─0d1b5ef7-70a3-4636-a8b9-ce4fbee94350
# ╠═414b8ba9-db91-41e5-b75c-48316c9a9c26
# ╟─1e0a6480-d6cf-45db-b4da-d05d12f994b5
# ╠═9567d8c6-e159-43df-b695-041d7cd8d4fa
# ╟─f5ee7561-9ac7-4b3c-afbb-e60fb0decf84
# ╠═26001ff5-0b23-4579-a07f-cad2448a4c89
# ╟─ca54dcaa-46e8-4bee-aed3-5e89f114279a
# ╠═78913ee3-2f63-440e-89cc-a15d04aa4857
# ╟─28436841-148b-4fa0-964e-8131e1daff9d
# ╠═e4e45da1-5cbf-4513-826d-e48c0d3e95e7
