### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ d9761286-7087-11eb-3d8d-ddf793df69df
using PlutoUI  # for `with_terminal`

# ╔═╡ 72f95a3a-708d-11eb-1e82-493e11537052
md"""
# Lecture 1: Calculating square roots
"""

# ╔═╡ 79845fee-708d-11eb-21ba-9f5560511ec9
md"""
As an example algorithm that illustrates many of the ideas in the course, let's try to calculate the square root of a number.
"""

# ╔═╡ b12144e6-7086-11eb-1fa2-c15126e61d8a
xx = 10

# ╔═╡ c046347c-7086-11eb-079c-6b20314ad52b
3xx

# ╔═╡ cc25bde4-7086-11eb-11bc-99cb4eb18b6f
md"""
# Basic sqrt algorithm

We're going to implement the sqrt algorithm that we came up with in the breakout sessions.

$$y = \sqrt{x}$$
"""

# ╔═╡ fd6d3954-7086-11eb-2285-79f160afead5
md"""
## Is the square root an integer? Implementation  

(Recall: To get Markdown I press ctrl-M or command-M)
"""

# ╔═╡ 0b323b16-7087-11eb-04f1-c1d13a217cfd
x = 16   # input

# ╔═╡ 30c95f44-7087-11eb-0e52-3b83a8136bef
md"""
Loop through all values of n from 0 to x and check if n^2 == x
"""

# ╔═╡ 7f0ba1f0-7087-11eb-3a5a-7f242447f957
function is_sqrt_integer(x)
	
	result = false
	
	for n in 0:x
		@show n   # same as println("n = ", n)

		if n * n == x
			result = true
		end
		
		if n * n > x
			break   # breaks immediately out of the for loop
		end

		@show result
	
	end
	
	return result
	
end

# ╔═╡ 860df064-7087-11eb-2d94-a302e569c063
answer = is_sqrt_integer(17)

# ╔═╡ 53bf96e8-7088-11eb-3aec-b7a0139d1e75
answer2 = is_sqrt_integer(16)

# ╔═╡ 5fb42130-7088-11eb-21d9-6bf492c6bc51
with_terminal() do
	is_sqrt_integer(16)
end

# ╔═╡ 423134c2-708d-11eb-2f22-cbed6444217e
md"""
(Use `with_terminal() do ... end` to display output from `@show`.)
"""

# ╔═╡ 8134157e-7088-11eb-3a7f-83771a7b45f0
md"""
Efficiency: Only need to check values until n * n is still less than x
"""

# ╔═╡ 641cd8de-708d-11eb-3ac9-83a18216cfd6
md"""
## *Calculating* the square root

With a small modification of the algorithm we can return more information, by giving a pair of integers that the square root lies between.
"""

# ╔═╡ 0fe93884-708a-11eb-0084-a9247626c330
function integer_sqrt(x)
	
	for n in 0:x
		
		if n * n == x
			return true, n, n   # true means that the result is exact
		end
		
		if n * n > x
			return (false, n-1, n)   # breaks immediately out of the for loop
		end
	
	end

	
end

# ╔═╡ 3ff798b4-708a-11eb-35e5-afa80e201c3f
integer_sqrt(16)

# ╔═╡ 42dca800-708a-11eb-328e-c591dd92c590
integer_sqrt(17)

# ╔═╡ 8f5df602-708a-11eb-2a99-ed83baad575f
md"""
## Drilling down: How can we get one decimal place?
"""

# ╔═╡ ca6df514-708d-11eb-2889-c3a450ef8c52
md"""
Idea: Now we have an integer range, split that up to drill down to get one decimal place.
"""

# ╔═╡ afeee37c-708a-11eb-201a-4960583547e9
range(4, 5, length=11)

# ╔═╡ c7285d98-708a-11eb-2c84-b97af426cb7f
collect( range(4, 5, length=11) )

# ╔═╡ d32cf7ca-708a-11eb-3298-5f885758ebf5
md"""
Exercise: Implement this.

"""

# ╔═╡ Cell order:
# ╟─72f95a3a-708d-11eb-1e82-493e11537052
# ╟─79845fee-708d-11eb-21ba-9f5560511ec9
# ╠═b12144e6-7086-11eb-1fa2-c15126e61d8a
# ╠═c046347c-7086-11eb-079c-6b20314ad52b
# ╟─cc25bde4-7086-11eb-11bc-99cb4eb18b6f
# ╟─fd6d3954-7086-11eb-2285-79f160afead5
# ╠═0b323b16-7087-11eb-04f1-c1d13a217cfd
# ╟─30c95f44-7087-11eb-0e52-3b83a8136bef
# ╠═7f0ba1f0-7087-11eb-3a5a-7f242447f957
# ╠═860df064-7087-11eb-2d94-a302e569c063
# ╠═53bf96e8-7088-11eb-3aec-b7a0139d1e75
# ╠═d9761286-7087-11eb-3d8d-ddf793df69df
# ╠═5fb42130-7088-11eb-21d9-6bf492c6bc51
# ╟─423134c2-708d-11eb-2f22-cbed6444217e
# ╟─8134157e-7088-11eb-3a7f-83771a7b45f0
# ╟─641cd8de-708d-11eb-3ac9-83a18216cfd6
# ╠═0fe93884-708a-11eb-0084-a9247626c330
# ╠═3ff798b4-708a-11eb-35e5-afa80e201c3f
# ╠═42dca800-708a-11eb-328e-c591dd92c590
# ╟─8f5df602-708a-11eb-2a99-ed83baad575f
# ╟─ca6df514-708d-11eb-2889-c3a450ef8c52
# ╠═afeee37c-708a-11eb-201a-4960583547e9
# ╠═c7285d98-708a-11eb-2c84-b97af426cb7f
# ╟─d32cf7ca-708a-11eb-3298-5f885758ebf5
