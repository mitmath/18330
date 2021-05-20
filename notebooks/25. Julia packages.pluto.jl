### A Pluto.jl notebook ###
# v0.14.5

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

# ╔═╡ 3b7945c4-2f1c-4156-861e-130f6b9c458a
begin
	using PlutoUI
	using Plots
end

# ╔═╡ 5e49d04e-8de7-4ea1-9464-152c8a007a62
using DifferentialEquations

# ╔═╡ 2327f993-c10b-442a-9f5d-74c4ca24a7bb
begin
	using JuMP
	using Ipopt
end

# ╔═╡ 6798e617-3fdb-4df4-8f7b-1dbec0ee1cef
TableOfContents()

# ╔═╡ 4e59d1c6-b978-11eb-23c7-b96fcad901e1
md"""
# Some Julia packages for numerical methods
"""

# ╔═╡ 411656d9-804d-4047-bcc9-5512c3854d36
md"""
In this notebook we will survey a few of the many packages (libraries) for numerical methods available in the Julia ecosystem. In particular, we will see how libraries tend to be structured to allow us to choose between different algorithms.
"""

# ╔═╡ 4b51d547-24a7-4702-9c22-3f117f7c5958
md"""
# DifferentialEquations.jl
"""

# ╔═╡ 82014371-2cfb-4e4b-af4b-79b7360f03dc
md"""
This is a very extensive suite of solvers for many types of differential equations.
Let's look at some examples.
"""

# ╔═╡ 8f370f42-e3e6-47a0-92eb-f10d786f5706
md"""
## Basic usage
"""

# ╔═╡ da3534e1-7cb1-4a5c-a312-69ecd65785c0
md"""
Let's try to solve the ODE 

$$\dot{u} = -p \, u$$

with a parameter $p$. 

We use $u$ as the name of the dependent variable for consistency with the `DifferentialEquations.jl` documentation and internal structure.
"""

# ╔═╡ 53ed7c5e-2805-4b56-88e0-450f77b96e4e
f(u, p, t) = -p * u

# ╔═╡ b922ad8e-f95a-4ef9-8e5f-e24a5173cafd
md"""
Note that you always need the three input arguments `u`, `p` and `t`, in that order, even if you don't use them.
"""

# ╔═╡ 9f36759d-9458-4351-b5f7-d5cf9951bc64
md"""
Now we define our initial condition $u_0$ and the time span to integrate over, given as a tuple (initial\_time, final\_time):
"""

# ╔═╡ a44ed429-bdc1-4435-92ca-a8efb576dfba
begin
	u0 = 100.0
	
	time_span = (0.0, 10.0)
end

# ╔═╡ 983006ef-cde5-4224-a094-7b1cb975c8ba
md"""
To set up the **problem** instance we use a type `ODEProblem`, defined in the `DifferentialEquations.jl` package. We construct an `ODEProblem` with the information necessary to define the problem: the function defining the right-hand side of the ODE, the initial data, and the time span. The parameters must go in the following order:
"""

# ╔═╡ 60a7a8ca-5913-4611-8a08-09418cb390f5
p = 0.2

# ╔═╡ 2e0060d9-e305-4723-8ad8-ab8b48edffaa
md"""
(For more advanced use there are also some additional, optional, keyword arguments.)
Note that the displayed output does not currently include information about the function, nor the parameters.
"""

# ╔═╡ cf431860-ad7d-4dff-a7dd-a80f06cd5834
md"""
To solve the ODE we call the `solve` function:
"""

# ╔═╡ 6361e71f-6ca4-49b5-8410-3be7405bfdb4
md"""
What happened here? A suitable solver (i.e. an algorithm to calculate the solution) was chosen *automatically*, and it chose certain moments in time at which to output information about the (approximate, but very accurate) solution. 

In this particular case it chose to output data at only eight points in time between $t=0$ and $t=10$.

Let's try to plot the `solution` object:
"""

# ╔═╡ b726e392-4863-4535-bc8c-9b2944f279c2
md"""
### Plot recipes
"""

# ╔═╡ 3dbc276c-814d-4a3b-870b-630e93c79ab1
md"""
Two surprising things happen. Firstly, there is no reason to expect this to have worked: `solution` is some kind of Julia object, but somehow `Plots.jl` knows how to plot it. This is because `DifferentialEquations.jl` defines a **plot recipe**. This specifies a way to turn solution objects into plots! Any package can do this relatively easily.
"""

# ╔═╡ d02347e9-0ced-49de-b13c-8644a704783e
md"""
The second surprise is that the output looks like a smooth curve, rather than just 8 points. Let's see those points on top of the curve. We can extract the relevant data from the `solution` object:
"""

# ╔═╡ da8b04be-4a94-47e4-86fb-8242ded8ffd7
md"""
We see that the package in fact gives not only the value at those points, but it is in fact also capable of calculating an (approximate) solution at *any* intermediate point, using **interpolation**. In fact, we can access this by treating `solution` as if it were a function:
"""

# ╔═╡ 1b67eeef-ebbd-4f70-a136-142dacddf38e
md"""
For this particular ODE we know the analytical solution. Let's compare them as we vary the parameter $p$:
"""

# ╔═╡ 36f4cdae-68b2-4105-80d2-cf8fb9d40123
md"""
p = $(@bind pp Slider(0.0:0.1:2.0, show_value=true))
"""

# ╔═╡ 9c516a36-2667-41e3-b5cf-6d2ad2882d76
md"""
We see that the numerical and exact solutions are (to the eye) indistinguishable, and that the package is fast enough to calculate the solution basically in real time.
"""

# ╔═╡ 0a646d48-7fe1-4c02-810a-a9f5a0345b42
md"""
## Systems of ODEs
"""

# ╔═╡ 4341db7a-b7b2-4acb-8a9d-e94f2ad08964
md"""
Now let's try to solve the SIR equations that model the spread of an infection through a well-mixed population:

$$\begin{aligned}
\dot{s} &= -\beta s i \\
\dot{i} &= +\beta s i - \gamma i\\
\dot{r} &= + \gamma i
\end{aligned}$$
"""

# ╔═╡ 8038f9f2-9ace-4632-b406-c9c4e2c90419
md"""
We need to convert the system into a vector form,

$$\dot{\mathbf{x}} = \mathbf{f}_\mathbf{p}(t, \mathbf{x})$$

where:
- the vector $\mathbf{x}$ is a vector of all the variables, $\mathbf{x} := (x_1, x_2, x_3) := (s, i, r)$
- the function $\mathbf{f}$ is a vector-valued function $\mathbb{R}^3 \to \mathbb{R}^3$, where $f_k$ gives the right-hand side of the equation for $\dot{x_k}$; and 
- the vector $\mathbf{p} = (\beta, \gamma)$ is a vector of the parameters.


"""

# ╔═╡ 2ec6692e-9dbf-4c6f-8f90-be19dba09105
x0 = [0.99, 0.01, 0.0]   # initial conditions

# ╔═╡ bd896021-8c9d-4115-a8ae-74b0eeda5387
function SIR(x, p, t)
	
	s, i, r = x    # unpack the vectors into scalar values
	β, γ = p
	
	# build a new vector to return:
	
	return [-β * s * i, 
			+β * s * i - γ * i,
					   + γ * i]
		        
end

# ╔═╡ 27939304-8e86-4724-8ec9-324abf741ee1
md"""
Note that for efficiency, we should instead use `SVector`s from the `StaticArrays.jl` library, and we can also use an "in-place" version where we pass in a vector `du` that the function should modify.
"""

# ╔═╡ 52636e0d-1daa-476c-aa46-09f3db0cc45a
md"""
Now we see that the solverr has recognised that everything is a vector, and it returns a vector at each time stamp.

Again we can plot:
"""

# ╔═╡ 92c354da-7d10-41ff-9c73-b11af68a188d
gr()

# ╔═╡ 81ddfbe9-51bb-4e98-9235-2e226842bafc
md"""
β = $(@bind β Slider(-0.5:0.01:2.0, default=1.0, show_value=true))

γ = $(@bind γ Slider(-0.5:0.01:2.0, default=0.1, show_value=true))
"""

# ╔═╡ ff68aad2-0d9a-4ab5-a841-80e9ebad1987
params = [β, γ]   # β and γ are defined below by sliders 

# ╔═╡ f2e3f96d-21e3-4144-b4bd-6956b86f41fd
SIR_problem = ODEProblem(SIR, x0, (0.0, 50.0), params)

# ╔═╡ 132fb587-53f6-4b3b-b14e-0b223bada01d
sol = solve(SIR_problem)

# ╔═╡ 10bc93bd-7d49-414e-96a2-93ce13671d74
plot(sol)

# ╔═╡ ccebf7ec-425f-4bac-b687-dfd388e1fb1a
md"""
It knows to plot each variable separately.

We can instead plot combinations of variables in *phase space* or *state space*:
"""

# ╔═╡ dbfdff2f-68c8-4c35-9e69-ab0867b21a72
gr()

# ╔═╡ 7dee658d-8152-4041-8bf8-25b401cc2c6e
plot(sol, vars=(1, 2), xlabel="s", ylabel="i", arrow=true, xlims=(-0.1, 1.0), size=(500, 300))

# ╔═╡ 5ef48d12-b52c-4bda-9d28-907c2a2738b1
md"""
And even in 3D:
"""

# ╔═╡ 969c7c95-d9be-4053-a204-8cb73fff7075
plotly()

# ╔═╡ 2c739ffc-fdc9-4ad0-a022-ff8d6dec5d2e
plot(sol, vars=(1, 2, 3), xlabel="s", ylabel="i", zlabel="r")

# ╔═╡ 3f464ef6-3088-4c75-ac87-659c780c4f55
md"""
Note that the [ModelingToolkit.jl](https://mtk.sciml.ai/stable/tutorials/ode_modeling/) library  provides ways to make creating ODE models more intuitive, using symbolic equation objects.
"""

# ╔═╡ aa72e7a4-c1c7-455b-a715-a321aeeca863
md"""
## Digging into objects
"""

# ╔═╡ 188ffbcd-8c55-4365-bead-5e4696e90df1
md"""
A key feature of the `DifferentialEquations.jl` library, and of most other libraries in Julia, is the way they define and use new **types**. 

As we have seen previously, we can define new types using `struct` which store data, and then define functions which act on those types.
"""

# ╔═╡ da22e7a3-95ab-4148-8646-b0dfbe9199e5
md"""
Let's start by looking at the `ODEProblem` type:
"""

# ╔═╡ 427ad9c2-c673-431c-a2cf-b60f1bd99ee1
md"""
To see what fields, or attributes, the object contains we can use
"""

# ╔═╡ cf64779b-d492-462e-927d-ec56fedbaf78
md"""
In Pluto and other interactive environments we can get the same information using `problem.<TAB>`, i.e. by typing the TAB key after `problem.`
"""

# ╔═╡ 07c89d0e-71fc-4406-82c9-ca39c1d8c415
md"""
As usual we can extract the data contained in the object as usual using `.`:
"""

# ╔═╡ a57ca48d-5c97-4f85-b0b6-8d915b1bece5
md"""
To see everything contained in the object, we can use `Dump` in Pluto, or `dump` if we are not using Pluto:
"""

# ╔═╡ 24c8d85c-c015-4edc-82b0-e38de5f38003
md"""
This seems (much) more complicated than you might expect. The library is clearly doing more than just storing the data that we provide in a type! The main thing that has happened is that the function we passed in has been processed by wrapping it into yet another type, `ODEFunction`. This contains information such as how to calculate the derivative of the function that can be provided for more advanced usage of the package.
"""

# ╔═╡ 616785d3-f8e6-4238-9ff6-fcb4b9d1f30d
md"""
Similarly we can look inside the solution object:
"""

# ╔═╡ 9db0d439-1e3c-4382-b8eb-b7d34a07ba98
md"""
The solution is even more complicated, containing not only the data that was calculated, but also all information about which algorithms were used to solve the problem and tables of coefficients for interpolation.
"""

# ╔═╡ fd6d0ae8-1d29-489f-b051-ac13fd256579
md"""
## Parameterized types
"""

# ╔═╡ 81062841-5e95-41d0-b1b1-ba9499971312
md"""
Let's look now at the *type* of the DiffEq objects:
"""

# ╔═╡ 67e60dce-0fc0-4446-8ace-7b92eb0abe36
md"""
We see that indeed `problem` is an object of type `ODEProblem`, but that it also has several **type parameters**, which are listed inside the curly braces (`{` and `}`):
"""

# ╔═╡ 4d35145d-9d30-4743-9e44-6b96ba0d83d3
md"""
For example, we see that the second type parameter is of type `Tuple{Float64, Float64}`, which is the type of the variable `time_span`:
"""

# ╔═╡ d973bc4d-14cd-4490-8a90-ca516349090a
typeof(time_span)

# ╔═╡ 472c9b01-3325-468a-9e2b-3978e653f94a
md"""
One of the reasons for using parameterized types like this is for efficiency: Julia is fastest when it knows the exact types of every variable, since then it can generate efficient machine code.
"""

# ╔═╡ ed545118-a282-45b1-b4f8-3b443d46a078
md"""
# Optimization
"""

# ╔═╡ 9cfabda4-083c-47b8-a318-edfcb85e698d
md"""
Optimization is a key technique in many areas. There are several Julia packages providing optimization **solvers** in pure Julia, for example `Optim.jl`. A solver may implement several different optimization algorithms and choose between them based on the properties of your particular function.

Solvers in pure Julia have advantages such as being able to use `BigFloat`s and possibly other types, such as for automatic differentiation.

However, the most powerful optimization solvers, including several commercial ones, are not written in Julia, and require specialised, annoying and distinct input formats. It has thus become common to develop **modelling languages**, which enable you to specify the problem you wish to solve in a syntax very close to mathematics; these modelling languages then convert your input into the required form for each solver, and allow you to thus easily compare the performance of different solvers on your problem.

The JuMP language is a **domain-specific language** embedded in Julia.
"""

# ╔═╡ 1203d22e-c333-4284-b729-81b7827e4dcd
md"""
## Modelling using JuMP
"""

# ╔═╡ 48d2806c-cd8c-426d-8462-5165c5991259
md"""
JuMP is a **modeling language** embedded in Julia. It allows us to write down optimization problems in a natural way; these are then converted by JuMP into the correct input format to be sent to different **solvers**, i.e. software programs that choose which optimization algorithms to apply to solve the optimization problem.

We'll use the [`Ipopt`](https://github.com/coin-or/Ipopt) solver, which stands for **interior-point optimizer**, since it uses an [interior-point method](https://en.wikipedia.org/wiki/Interior-point_method) to carry out the optimization of nonlinear functions.
"""

# ╔═╡ bfd70f56-077e-46eb-b212-d9514b5dd14b
md"""
## Unconstrained optimization
"""

# ╔═╡ 07353bdc-c3da-4d20-ab6d-359dc9403d95
gr()

# ╔═╡ fab4f73f-6bd4-4f2d-b7ff-0be3ffc076ef
md"""
a = $(@bind a Slider(-3:0.01:3, show_value=true, default=0))
"""

# ╔═╡ 4861f5fe-0739-4af0-adf9-6b7b5edc6324
f(x) = x^2 - a*x + 2

# ╔═╡ 07e99b25-43e4-4206-b72d-dd26cda50543
problem = ODEProblem(f, u0, time_span, p)

# ╔═╡ 70053f84-699c-4083-bf56-d483cfd263d0
solution = solve(problem)

# ╔═╡ 2562d85d-0736-49d5-a8c9-ba6569913ec4
plot(solution, size=(500, 300), label="solution")

# ╔═╡ a1f36f60-042d-42be-a951-e32b53c2d838
scatter!(solution.t, solution.u, label="discrete output")

# ╔═╡ 95d2fa96-cd57-4e1c-9301-78e0ed1b20e3
begin
	tt = 3.5
	solution(tt)
end

# ╔═╡ 46083932-54db-4170-8eee-03c0c12d9cb1
scatter!([tt], [solution(tt)], label="t = $(tt)", ms=5, m=:square)

# ╔═╡ d45298fe-1dde-40f4-876f-4f0ac0c7c8ba
fieldnames(typeof(solution))

# ╔═╡ 9f1f42b0-872f-4750-bca7-2647f0b03edf
Dump(solution)

# ╔═╡ bdc58dbd-b91e-44f5-b341-b77eb494bb5a
problem

# ╔═╡ 29a53e54-feb6-409b-8fd4-1631ac51f0b9
fieldnames(typeof(problem))

# ╔═╡ 7b0ebb1a-3714-4449-b0da-50fe280f89d8
problem.u0

# ╔═╡ a2b02a77-1cc5-4ef6-bee3-f39e85fb450e
problem.tspan

# ╔═╡ 41a87ded-0845-423b-8eab-4950a4b2b7a2
Dump(problem)

# ╔═╡ b427a880-db85-44bc-bc96-2745cff06520
typeof(problem)

# ╔═╡ fb59a97c-c25f-4388-8aa5-253bf437df38
[typeof(problem).parameters...]

# ╔═╡ dc0de69f-cd3b-4e5d-a4c0-0d2cbf98feec
let
	
	problem = ODEProblem(f, u0, time_span, pp)	
	solution = solve(problem)
	
	plot(solution,
		linewidth=3, xlabel="t", yaxis="x(t)", label="numerical", size=(500, 300))
		
	plot!(t -> u0 * exp(-pp*t), lw=3, ls=:dash, label="exact")
	
	ylims!(0, 100)
	title!("p = $p")
end

# ╔═╡ c8fb2bdc-a3d7-4c7c-9e91-ec505f9be554
min_value, objective_value, model = let
	
	model = Model(Ipopt.Optimizer)				# set up a model object

	@variable(model, -10 ≤ x ≤ 10)    	# declare a variable called x with bounds

    @NLobjective(model, Min, f(x))   	# set the *objective function* to optimize


	optimize!(model)					# run the solver (optimizer)
	
	(getvalue(x), getobjectivevalue(model), model)   	  
end

# ╔═╡ 9037fc6b-e4ee-4f7c-84cb-ad463834304e
begin
	plot(-10:0.01:10, f, size=(400, 300), leg=false)
	plot!(-5:0.01:5, x -> x^2 + 2, ls=:dash, alpha=0.5)
	scatter!([min_value], [f(min_value)], xlims=(-11, 11))
end

# ╔═╡ faf60413-f21c-432a-a10f-5ae57eab15ff
md"""
## Constrained optimization
"""

# ╔═╡ 6b2593ff-29ca-46ca-8173-78fde029817b
md"""
Often we need to add one or more **constraints**, i.e. restrictions, to the problem.

Here we'll optimize a function of two variables under an **equality constraint** that restricts the two variables to live along a given curve (here a straight line).
"""

# ╔═╡ 7d22c825-e7ce-4571-8c24-ad46a0b552cd
g(x, y) = x^2 + y^2 - 1   # objective function

# ╔═╡ 9407e8fe-4a0a-401c-b24c-1209faa0a053
constraint(x, y) = y - x

# ╔═╡ 408d8343-1f4d-4802-b4da-3b956b2aaf55


# ╔═╡ 8c373523-dd35-4d72-8d6a-77503c8abd2d
b_slider = @bind b Slider(-5:0.1:5, show_value=true, default=0)

# ╔═╡ 8364466d-267e-4b75-9ae4-e60762b2a619
minx, miny = let
	
	model = Model(Ipopt.Optimizer)
	
	@variable(model, -10 ≤ x ≤ 10)
	@variable(model, -10 ≤ y ≤ 10)
	
    @NLobjective(model, Min, g(x, y))
	
	# add a constraint:
	@NLconstraint(model, constraint(x, y) == b)
	
	optimize!(model)
	
	(x = getvalue(x), y = getvalue(y))
end

# ╔═╡ b0776b6e-834b-4349-973d-818856cc3980
md"""
b = $(b_slider)
"""

# ╔═╡ c7e5ecb8-a5e4-41b4-af3c-a2be9bb00019
gr()

# ╔═╡ 83abff88-37d6-4034-b039-e1059000c4f2
begin
	r = -5:0.1:5
	
	contour(r, r, g, leg=false)
	contour!(r, r, constraint, levels=[b], ratio=1, lw=3, c=:blue)
	scatter!([minx], [miny])
end

# ╔═╡ 681f55f8-4994-4968-bb11-06eecebd71f0
plotly()

# ╔═╡ d3ac7797-cfef-450c-a6b9-96944ea5705e
surface(-5:0.1:5, -5:0.1:5, g, alpha=0.5)

# ╔═╡ 7fd26e7b-68f9-46f8-90fa-c12bada3c0a4
md"""
In this particular, simple case we can solve by hand to find the intersection of the surface that is the graph of the objective function with the plane that specifies the constraint:
"""

# ╔═╡ 43e3f850-2590-40ed-99ad-fecbb52a4e34
md"""
We have

$$y - x = b$$

so 

$$y = x + b$$

Hence

$z = x^2 + y^2 = x^2 + (x + b)^2$

"""

# ╔═╡ 862b1880-8e9b-4655-8450-72a0e0881368
md"""
In general this is not possible, since constraints can be arbitrary implicit functions!
"""

# ╔═╡ 426a6570-c735-4b1c-9619-723147f41f92
begin
	xs = -5:0.1:5
	ys = xs .+ b
end

# ╔═╡ de959ad2-13bb-4c51-90f7-156f712dff4b
plotly()

# ╔═╡ cc3beaee-90cd-4875-a999-db84463cd1f7
b_slider

# ╔═╡ f33b6a7c-052f-457d-8171-bfb109ac5748
md"""
Intersection of paraboloid with the plane $y - x = b$
"""

# ╔═╡ 102807d1-7cf1-41e6-a26c-647282a6db57
begin
	surface(-5:0.1:5, -5:0.1:5, g, alpha=0.5, label="objective")
	
	plot!(xs, ys, g.(xs, ys), lw=3, label="constraint")
	
	scatter!([minx], [miny], [g(minx, miny)], zlim=(-10, 50), xlim=(-5, 5), ylim=(-5, 5), label="")

end

# ╔═╡ 84d0d841-d433-4359-b81e-f81444c9af06
md"""
# Symbolic manipulation
"""

# ╔═╡ dcc682e4-44af-4d1b-afd5-1aff0b1f6f68
md"""
It is often convenient to be able to manipulate expressions symbolically. 

For polynomials in one variable there is `Polynomials.jl`. For polynomials in multiple variables there are several packages, including `TaylorSeries.jl` that I contributed to.
"""

# ╔═╡ bcc48844-8af5-48b8-b8cd-0ca7e88aa3e6
md"""
A recent and very important addition to the set of available libraries is `Symbolics.jl`, which enables you to define and manipulate *symbolic* quantities. 

See e.g. https://github.com/siravan/SymPertExamples.jl for examples using symbolic manipulation to develop perturbation expansions.
"""

# ╔═╡ Cell order:
# ╠═3b7945c4-2f1c-4156-861e-130f6b9c458a
# ╠═6798e617-3fdb-4df4-8f7b-1dbec0ee1cef
# ╟─4e59d1c6-b978-11eb-23c7-b96fcad901e1
# ╟─411656d9-804d-4047-bcc9-5512c3854d36
# ╟─4b51d547-24a7-4702-9c22-3f117f7c5958
# ╟─82014371-2cfb-4e4b-af4b-79b7360f03dc
# ╟─8f370f42-e3e6-47a0-92eb-f10d786f5706
# ╠═5e49d04e-8de7-4ea1-9464-152c8a007a62
# ╟─da3534e1-7cb1-4a5c-a312-69ecd65785c0
# ╠═53ed7c5e-2805-4b56-88e0-450f77b96e4e
# ╟─b922ad8e-f95a-4ef9-8e5f-e24a5173cafd
# ╟─9f36759d-9458-4351-b5f7-d5cf9951bc64
# ╠═a44ed429-bdc1-4435-92ca-a8efb576dfba
# ╟─983006ef-cde5-4224-a094-7b1cb975c8ba
# ╠═60a7a8ca-5913-4611-8a08-09418cb390f5
# ╠═07e99b25-43e4-4206-b72d-dd26cda50543
# ╟─2e0060d9-e305-4723-8ad8-ab8b48edffaa
# ╟─cf431860-ad7d-4dff-a7dd-a80f06cd5834
# ╠═70053f84-699c-4083-bf56-d483cfd263d0
# ╟─6361e71f-6ca4-49b5-8410-3be7405bfdb4
# ╠═2562d85d-0736-49d5-a8c9-ba6569913ec4
# ╟─b726e392-4863-4535-bc8c-9b2944f279c2
# ╠═3dbc276c-814d-4a3b-870b-630e93c79ab1
# ╠═d02347e9-0ced-49de-b13c-8644a704783e
# ╠═a1f36f60-042d-42be-a951-e32b53c2d838
# ╠═da8b04be-4a94-47e4-86fb-8242ded8ffd7
# ╠═95d2fa96-cd57-4e1c-9301-78e0ed1b20e3
# ╠═46083932-54db-4170-8eee-03c0c12d9cb1
# ╟─1b67eeef-ebbd-4f70-a136-142dacddf38e
# ╟─36f4cdae-68b2-4105-80d2-cf8fb9d40123
# ╠═dc0de69f-cd3b-4e5d-a4c0-0d2cbf98feec
# ╟─9c516a36-2667-41e3-b5cf-6d2ad2882d76
# ╟─0a646d48-7fe1-4c02-810a-a9f5a0345b42
# ╟─4341db7a-b7b2-4acb-8a9d-e94f2ad08964
# ╟─8038f9f2-9ace-4632-b406-c9c4e2c90419
# ╠═2ec6692e-9dbf-4c6f-8f90-be19dba09105
# ╠═bd896021-8c9d-4115-a8ae-74b0eeda5387
# ╟─27939304-8e86-4724-8ec9-324abf741ee1
# ╠═ff68aad2-0d9a-4ab5-a841-80e9ebad1987
# ╠═f2e3f96d-21e3-4144-b4bd-6956b86f41fd
# ╠═132fb587-53f6-4b3b-b14e-0b223bada01d
# ╟─52636e0d-1daa-476c-aa46-09f3db0cc45a
# ╠═92c354da-7d10-41ff-9c73-b11af68a188d
# ╠═10bc93bd-7d49-414e-96a2-93ce13671d74
# ╟─81ddfbe9-51bb-4e98-9235-2e226842bafc
# ╟─ccebf7ec-425f-4bac-b687-dfd388e1fb1a
# ╠═dbfdff2f-68c8-4c35-9e69-ab0867b21a72
# ╠═7dee658d-8152-4041-8bf8-25b401cc2c6e
# ╟─5ef48d12-b52c-4bda-9d28-907c2a2738b1
# ╠═969c7c95-d9be-4053-a204-8cb73fff7075
# ╠═2c739ffc-fdc9-4ad0-a022-ff8d6dec5d2e
# ╟─3f464ef6-3088-4c75-ac87-659c780c4f55
# ╟─aa72e7a4-c1c7-455b-a715-a321aeeca863
# ╟─188ffbcd-8c55-4365-bead-5e4696e90df1
# ╟─da22e7a3-95ab-4148-8646-b0dfbe9199e5
# ╠═bdc58dbd-b91e-44f5-b341-b77eb494bb5a
# ╟─427ad9c2-c673-431c-a2cf-b60f1bd99ee1
# ╠═29a53e54-feb6-409b-8fd4-1631ac51f0b9
# ╟─cf64779b-d492-462e-927d-ec56fedbaf78
# ╟─07c89d0e-71fc-4406-82c9-ca39c1d8c415
# ╠═7b0ebb1a-3714-4449-b0da-50fe280f89d8
# ╠═a2b02a77-1cc5-4ef6-bee3-f39e85fb450e
# ╟─a57ca48d-5c97-4f85-b0b6-8d915b1bece5
# ╠═41a87ded-0845-423b-8eab-4950a4b2b7a2
# ╠═24c8d85c-c015-4edc-82b0-e38de5f38003
# ╟─616785d3-f8e6-4238-9ff6-fcb4b9d1f30d
# ╠═d45298fe-1dde-40f4-876f-4f0ac0c7c8ba
# ╠═9f1f42b0-872f-4750-bca7-2647f0b03edf
# ╟─9db0d439-1e3c-4382-b8eb-b7d34a07ba98
# ╟─fd6d0ae8-1d29-489f-b051-ac13fd256579
# ╟─81062841-5e95-41d0-b1b1-ba9499971312
# ╠═b427a880-db85-44bc-bc96-2745cff06520
# ╟─67e60dce-0fc0-4446-8ace-7b92eb0abe36
# ╟─fb59a97c-c25f-4388-8aa5-253bf437df38
# ╟─4d35145d-9d30-4743-9e44-6b96ba0d83d3
# ╟─d973bc4d-14cd-4490-8a90-ca516349090a
# ╟─472c9b01-3325-468a-9e2b-3978e653f94a
# ╟─ed545118-a282-45b1-b4f8-3b443d46a078
# ╟─9cfabda4-083c-47b8-a318-edfcb85e698d
# ╟─1203d22e-c333-4284-b729-81b7827e4dcd
# ╟─48d2806c-cd8c-426d-8462-5165c5991259
# ╠═2327f993-c10b-442a-9f5d-74c4ca24a7bb
# ╟─bfd70f56-077e-46eb-b212-d9514b5dd14b
# ╠═4861f5fe-0739-4af0-adf9-6b7b5edc6324
# ╠═c8fb2bdc-a3d7-4c7c-9e91-ec505f9be554
# ╠═07353bdc-c3da-4d20-ab6d-359dc9403d95
# ╟─fab4f73f-6bd4-4f2d-b7ff-0be3ffc076ef
# ╠═9037fc6b-e4ee-4f7c-84cb-ad463834304e
# ╟─faf60413-f21c-432a-a10f-5ae57eab15ff
# ╟─6b2593ff-29ca-46ca-8173-78fde029817b
# ╠═7d22c825-e7ce-4571-8c24-ad46a0b552cd
# ╠═9407e8fe-4a0a-401c-b24c-1209faa0a053
# ╠═408d8343-1f4d-4802-b4da-3b956b2aaf55
# ╠═8364466d-267e-4b75-9ae4-e60762b2a619
# ╠═8c373523-dd35-4d72-8d6a-77503c8abd2d
# ╟─b0776b6e-834b-4349-973d-818856cc3980
# ╠═c7e5ecb8-a5e4-41b4-af3c-a2be9bb00019
# ╠═83abff88-37d6-4034-b039-e1059000c4f2
# ╠═681f55f8-4994-4968-bb11-06eecebd71f0
# ╠═d3ac7797-cfef-450c-a6b9-96944ea5705e
# ╟─7fd26e7b-68f9-46f8-90fa-c12bada3c0a4
# ╟─43e3f850-2590-40ed-99ad-fecbb52a4e34
# ╟─862b1880-8e9b-4655-8450-72a0e0881368
# ╠═426a6570-c735-4b1c-9619-723147f41f92
# ╠═de959ad2-13bb-4c51-90f7-156f712dff4b
# ╠═cc3beaee-90cd-4875-a999-db84463cd1f7
# ╟─f33b6a7c-052f-457d-8171-bfb109ac5748
# ╟─102807d1-7cf1-41e6-a26c-647282a6db57
# ╟─84d0d841-d433-4359-b81e-f81444c9af06
# ╟─dcc682e4-44af-4d1b-afd5-1aff0b1f6f68
# ╟─bcc48844-8af5-48b8-b8cd-0ca7e88aa3e6
