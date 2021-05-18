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

# ╔═╡ c8776bbc-d0d4-4e15-90a2-7883ded587ba
begin
	using Plots
	using LaTeXStrings
	using IntervalArithmetic
end

# ╔═╡ 06495d24-56e1-11eb-3110-f9be8df18016
using IntervalArithmetic: @round_down, @round_up

# ╔═╡ 864ee9b0-56e8-11eb-041e-5d78d7213e17
using IntervalOptimisation

# ╔═╡ d67ef730-56e9-11eb-0380-e13897cce230
using IntervalRootFinding

# ╔═╡ 76e7db86-0a4b-11eb-0f49-9b44dfb50389
using ForwardDiff

# ╔═╡ 7275d088-0a5c-11eb-28be-95fbcac41561
using LinearAlgebra

# ╔═╡ f9b2f338-56e3-11eb-2878-d3226a44e68a
using PlutoUI

# ╔═╡ 680cc6ba-c0ae-47c1-8cf3-82ab8304259f
TableOfContents()

# ╔═╡ 958dc50e-56e3-11eb-1ad6-872914528ac9
html"<button onclick=present()>Present</button>"

# ╔═╡ aa5914ba-0a4c-11eb-09e1-6df31c935f11
md"""
## Kahan's example
"""

# ╔═╡ c4322273-ecdf-4f2b-a3d0-7897c2de10c1
md"""
Let's try to plot the following function 

(from [this article](https://people.eecs.berkeley.edu/~wkahan/Mindless.pdf), section 7,
by William Kahan, a famous numerical analyst)
"""

# ╔═╡ ae8151c2-0a4c-11eb-2463-ab0e6d25d042
f(x) = 1 + x^2 + (1/80) * log(abs(3 * (1 - x) + 1))

# ╔═╡ 87e1be4c-56de-11eb-2f57-074235547511
md"""
It seems nice enough, apart from a little dip between 1.3 and 1.4:
"""

# ╔═╡ b6c570d4-0a4c-11eb-0bc1-d51e28a13085
begin
	plot(1.2:0.001:1.5, f, leg=false, alpha=1, size=(400, 300))
	xlabel!("x")
	ylabel!("f(x)")
end

# ╔═╡ 0f0513ea-b0eb-4ae3-a5fe-85735b6f967b
md"""
But if you look closely at the *definition* of the function, you'll notice that something bad happens at $\frac{4}{3}$.
"""

# ╔═╡ 63668142-56de-11eb-2034-77957f6516e9
4 / 3

# ╔═╡ f86b58ae-0a52-11eb-3959-3dffbabdfb02
let 
	x = 4 // 3
	f(x)
end

# ╔═╡ 7483f810-574c-11eb-0656-9fb0f7957d5e
f(4/3)

# ╔═╡ b6acb09c-56de-11eb-1ba8-49d9aff92e96
md"""
#### What happens if we use intervals?
"""

# ╔═╡ a55effe8-0a53-11eb-0ae6-17fd68c3cbf5
let
	X = 1.33..1.34
	f(X)
end

# ╔═╡ 6661c95c-0a4b-11eb-0418-5199caf01453
md"""
## Defining an interval type
"""

# ╔═╡ 33b7d804-33d3-4939-aab5-e302bce48d35
md"""
Let's define an interval type to represent a closed interval $X = [a, b] := \{x \in \mathbb{R}: a \le x \le b \}$.

It is sometimes convenient to use the notation $\underline{X}$ and $\overline{X}$ for the lower and upper end-points, respectively, of the interval $X$.
"""

# ╔═╡ 8b8db1ac-56e0-11eb-3a06-f70187123d15
struct MyInterval
	left::Float64
	right::Float64
end

# ╔═╡ c503b8a4-7b4c-4428-a481-0090b35e54e7
md"""
This is a set, so we can define set operations like
"""

# ╔═╡ 3db16da9-19e0-415f-9092-040e3294964b
Base.in(x::Real, a::MyInterval) = a.left ≤ x ≤ a.right

# ╔═╡ edd3a4c7-919b-41ce-998f-8117ac73ee99
let 
	X = MyInterval(0.1, 0.3)
	
	0.2 ∈ X
end
	

# ╔═╡ 9bce488a-56e0-11eb-3caa-3dfe17a5250f
Base.:+(a::MyInterval, b::MyInterval) = 

	MyInterval(	
		a.left + b.left, 
		a.right + b.right 
	)

# ╔═╡ d5213479-16e9-4193-afb9-7f70d0016779
md"""
## Defining $f(X)$ on intervals
"""

# ╔═╡ 11ce60b7-efa9-47a1-bbad-0abfb0d9f3dc
md"""
What does $f(X)$ mean for an interval -- for example, $\exp(X)$?
"""

# ╔═╡ a5a0dcdd-fc0e-4dcf-8b21-c29ad26d5b31
md"""
Since $X$ is a set, it's perhaps natural to want this to mean the set that we obtain by applying the function to every element of the set, i.e. the **range** (or **image**) of $f$ over $X$:

$$\mathrm{range}(f; X) := \{f(x): x \in X \}$$

Note that mathematics, and standard computational techniques, provide **no methods** to calculate the range of a function! The main point of interval arithmetic is to provide a computationally cheap and useful way to calculate the range of a function.
"""

# ╔═╡ b4d1018b-1e44-4e50-92c7-e31602aa3794
md"""
### Defining $f(X)$ for monotonic functions 
"""

# ╔═╡ 4abf5dd4-2536-49ac-86ee-9bdd1d353f53
md"""
How could we do this for a monotonic function?

If $f$ is monotonic and continuous, then we know what the range of possible output values are: $\mathrm{range}(f; X) = [f(\underline{X})..f(\overline{X})]$

"""

# ╔═╡ f2058a6f-b215-4c20-8991-39026f82e853
let
	f(x) = exp(0.5x)
		
	X = 1..1.5

	plot(f, 0, 3, lw=3, leg=false, ratio=1)
	plot!(IntervalBox(X, f(X)), alpha=0.3)

	h = 0.05

	plot!(IntervalBox(X, -h..h))
	plot!(IntervalBox(-h..h, f(X)))

	plot!([X.lo, X.lo], [0, f(X).lo], ls=:dash, c=:black, alpha=0.5)
	plot!([X.hi, X.hi], [0, f(X).lo], ls=:dash, c=:black, alpha=0.5)

	plot!([0, X.lo], [f(X).lo, f(X).lo], ls=:dash, c=:black, alpha=0.5)
	plot!([0, X.lo], [f(X).hi, f(X).hi], ls=:dash, c=:black, alpha=0.5)


	annotate!(1.25, 0.2, L"X")
	annotate!(0.3, f(mid(X)), L"f(\!X)")

	title!(L"f(x) = \exp(0.5x)")

	xlims!(0, 2)
	ylims!(0, 3)
		
end

# ╔═╡ e0e6fbf4-2842-4dec-9abf-c6e11657d752
md"""
In these pictures, a box $X \times Y$ shows the result of applying interval arithmetic to the input interval $X$ with output $Y$. [This in fact computes an enclosure of the **graph** of the function, $\{(x, f(x)): x \in X \}$.
"""

# ╔═╡ b39868c4-56de-11eb-2f3e-7914b00c3a58


# ╔═╡ eaf76838-56e0-11eb-1832-65c66fc6b878
md"""
## Directed rounding
"""

# ╔═╡ 392508a6-62bc-4f40-b4ee-50e7589eec2d
md"""
However, this is not quite enough when implementing this numerically, since evaluating an elementary function like $\exp$ at an end point gives a floating-point approximation that may result in an interval that does *not* actually contain the complete range.

Rather, we need an additional step of **outwards** or **directed rounding**.
"""

# ╔═╡ effdb18c-56e0-11eb-2fe0-5dedeb8ce6be
exp(0.5)

# ╔═╡ f32ae258-56e0-11eb-3529-e52ca3a4f83c
exp(0.5, RoundDown)

# ╔═╡ f5366072-56e0-11eb-0cf8-f520bcd11710
exp(0.5, RoundUp)

# ╔═╡ f7bf9304-56e0-11eb-1029-33669f7a1d65
exp(big(0.5))

# ╔═╡ fcc446b0-56e0-11eb-147f-357d10dea355
exp(0.5, RoundDown) < exp(big(0.5)) < exp(0.5, RoundUp)

# ╔═╡ 2fbb7e08-56e1-11eb-0ce8-edbe42c96af7
@round_down exp(0.5)

# ╔═╡ ca9a005c-56e1-11eb-2a69-75816b51e874
@round_up exp(0.5)

# ╔═╡ f3903698-574d-11eb-3737-b7d0bec2f0a0
w = 3.14..3.15

# ╔═╡ ff255350-574d-11eb-0c78-91dee341748b
exp(cos(w + 1))

# ╔═╡ 261e9354-574e-11eb-15be-ab1a534ab0c2
(0..1) - (0..1)

# ╔═╡ 74bfd5d6-574e-11eb-17f6-b78744ce936d
(3..5) ∩ (4..6)

# ╔═╡ d307fbae-56e3-11eb-3f91-d9f39a3d5b89
md"""
## Function bounding
"""

# ╔═╡ d548877a-af80-4e43-befe-3fb67db9eac9
md"""
In general, interval arithmetic is (relatively) cheap to compute, but unfortunately gives an *over*-estimate of the true range.

An example of this is the simple function $x \mapsto x^2 - 2x$. It turns out that when a variable $x$ occurs more than once in an expression, this leads (in general) to such an over-estimation, as is visible in the following figure.

A partial cure to this is to **split** or **mince** the interval into pieces. As the width of the pieces decreases, the over-estimate also decreases in a predictable way.
"""

# ╔═╡ 8af11366-56e4-11eb-026e-0dc1866ac319
@bind n Slider(1:100, show_value=true)

# ╔═╡ af813bf2-56e4-11eb-01af-2180ad97e0f3
@bind n2 Slider(1:200, show_value=true)

# ╔═╡ db2440fc-56de-11eb-1f8e-15cf07413d76
md"""
## Searching for roots
"""

# ╔═╡ 46fb7422-0a55-11eb-12bd-8b41a2b0200e
X = 3..4

# ╔═╡ e627e922-56de-11eb-1b5a-d1b60f2d07d6
ff(x) = x^2 - 2

# ╔═╡ 89866847-f382-4339-ab04-f53a3a7fe8d0
ff(X)

# ╔═╡ e5f79113-0168-406c-a293-4b7dd15bad7f
0 ∈ ff(X)

# ╔═╡ 2cc9797a-56e6-11eb-27ae-e764f08b2054
md"""
## Branch and bound
"""

# ╔═╡ ce9c63e6-5745-11eb-3e78-4b2ac35ad2bb
NN = 100

# ╔═╡ d784fa92-5745-11eb-121f-557774e90c39
XXX = -10..8

# ╔═╡ 101987f0-5747-11eb-3ac5-fd5b668f4043
f4(x) = x * sin(x)

# ╔═╡ c98a4c76-5745-11eb-2500-31df973523d1
@bind i Slider(1:NN, show_value=true)

# ╔═╡ d02c5038-56e6-11eb-1c28-cd45b5def70d
interval_mid(X::T) where {T <: Region} = T(mid(X))

# ╔═╡ cb45692a-5750-11eb-12f6-c9d00b5672b6
mid(1..2)

# ╔═╡ cecaf158-5750-11eb-357a-1bea5b66efea
ZZ = (1..2) × (3..4)

# ╔═╡ d9e75bd0-5750-11eb-1bbe-57bb52d43851
IntervalBox(mid(ZZ))

# ╔═╡ 30efc484-56e6-11eb-1ec8-a19a57671970
function simple_minimise(f, X, ϵ=0.1)
	m = +∞
	
	working = [X]
	results = typeof(X)[]
	
	while !isempty(working)
		X = popfirst!(working)
		
		if f(X) > m 
			continue
		end
		
		if diam(X) < ϵ
			push!(results, X)
			continue
		end
		
		new_m = sup( f(interval_mid(X)) )
		if new_m < m
			m = new_m
		end
		
		push!(working, bisect(X)...)
		
	end
	
	return reduce(∪, f.(results)), results
end

# ╔═╡ 166e0dac-56e7-11eb-21e3-cb025bd58494
simple_minimise(x -> (x^2 - 2)^2, -10..10, 0.001)

# ╔═╡ 5837ff18-56e7-11eb-3591-65d5c1d463b7
simple_minimise(x -> x^2 - 2x, -10..10, 0.001)

# ╔═╡ ce92be5a-56e7-11eb-2be8-6983427a3a5f
rosenbrock(a, b) = ((x, y), ) -> (a - x)^2 + b * (y - x^2)^2

# ╔═╡ dc3f1346-56e7-11eb-3f61-a77ae00e9fcf
simple_minimise(rosenbrock(1, 100), (-10..10) × (-10..10), 0.001)

# ╔═╡ 32d76ad2-5751-11eb-3e46-d37893c76c23
v = [1, 2, 3]

# ╔═╡ 352c7994-5751-11eb-2638-e17d559dcd8f
double(x) = x * 2

# ╔═╡ 3b5aa642-5751-11eb-0b32-610cc3c5c140
double.(v)

# ╔═╡ a325dac6-5751-11eb-01fe-673c1a48d810
X1 = -1..1

# ╔═╡ a8860c84-5751-11eb-3c3d-5959e1da5ddc
X1^2 - 2X1

# ╔═╡ ab4212ea-5751-11eb-2ac3-c75cd919e9ba
(X1 - 1)^2 - 1

# ╔═╡ c2a859e6-5751-11eb-3e3c-8d24c0d75a01
X1^2 - 2X1 - X1 + X1

# ╔═╡ ca401932-5751-11eb-372f-9d4486326cb5
X1 - sin(X1)

# ╔═╡ 9156faca-56e8-11eb-247f-793a210a7efd
md"""
## IntervalOptimisation.jl
"""

# ╔═╡ 95bed3d2-56e9-11eb-0ef2-d5bc6e0cc468
G(X) = 1 + sum(abs2, X) / 4000 -
  prod( cos(X[i] / √(Interval(i))) for i in 1:length(X) )

# ╔═╡ a7b748da-56e9-11eb-33ea-f35ead225bc8
Z = IntervalBox(-100..100, 2)

# ╔═╡ ab5dcf0e-56e9-11eb-0e87-596116168b76
minimise(G, Z)

# ╔═╡ b72b6456-56e9-11eb-1f68-57d3d32c5970
minimise(G, IntervalBox(-100..100, 10))

# ╔═╡ d569f1a0-5753-11eb-252d-393be14cf1bd
(1..3) < 5

# ╔═╡ d9ee045a-5753-11eb-0dac-55bf04988ab9
(1..3) < 2

# ╔═╡ cd54e8ae-56e9-11eb-02f1-2d29d5c811cf
md"""
## IntervalRootFinding.jl
"""

# ╔═╡ e3a7ccca-56e9-11eb-3acb-0f8dbce1858a
rts = roots(∇(G), IntervalBox(-10..10, 2))

# ╔═╡ a2512cc6-56df-11eb-2a12-ff552cf7fb8f
md"""
## Interval Newton method
"""

# ╔═╡ de6b1efc-5742-11eb-1c69-7969e75b381f
@bind n3 Slider(1:10, show_value=true)

# ╔═╡ e6254244-5742-11eb-006f-a1cdd1a6df31
@bind α Slider(0.0:0.01:1, show_value=true, default=0.5)

# ╔═╡ 3a468386-5743-11eb-3180-8fd04efceb4c
@bind n4 Slider(1:10, show_value=true)

# ╔═╡ 4084a10a-5743-11eb-0a35-c74bb20a95eb
@bind α2 Slider(0.0:0.01:1, show_value=true, default=0.5)

# ╔═╡ 78278602-5743-11eb-3c73-e3ac9289bad7
@bind n5 Slider(1:10, show_value=true)

# ╔═╡ aa35194c-5744-11eb-1452-a986fa512cb1
@bind α3 Slider(0.0:0.01:1, show_value=true, default=0.5)

# ╔═╡ 74f1e43c-5743-11eb-0b9f-f92599d4e991
interval_newton_full(x->x^5 - x^4 +2x^2 - x, -1.5..1.5, n5, α3)

# ╔═╡ 03520242-5745-11eb-2483-3314d1053ac2
md"""
## Implementing interval Newton
"""

# ╔═╡ 4bcb90e8-56e0-11eb-0a20-9fde563c81b4
begin
	jacobian(f, v) = ForwardDiff.jacobian(f, v)
	jacobian(f, X::IntervalBox) = ForwardDiff.jacobian(f, X.v)
end

# ╔═╡ 47d0bb74-0a5c-11eb-2471-8b4fdd3d775f
fff( (x, y) ) = [x^2 + y^2 - 1, y - x]

# ╔═╡ f99e3a1e-56df-11eb-35e1-dde81cf8ffb5
xxx = 0.65..0.75

# ╔═╡ 03f513d4-56e0-11eb-2745-39b68d5191a4
Y = xxx × xxx

# ╔═╡ 5e9584c0-0a5c-11eb-3e93-73077e62ef8f
jacobian(fff, [0.7, 0.8])

# ╔═╡ 5f000bf8-56e0-11eb-18a3-f9660d7f5635
jacobian(fff, Y)

# ╔═╡ e0702c98-0a5c-11eb-2e2c-83725a5fd89f
function N(f, X)
	m = mid(X)
	J = jacobian(f, X)
	
	return IntervalBox( m - J \ f(m) )
end

# ╔═╡ f523f316-56df-11eb-28fa-618c97d7d4df
N(fff, Y)

# ╔═╡ 7cd583d0-56e0-11eb-0435-236dc5fe5f0c
N(fff, Y) ⊆ Y

# ╔═╡ 1329852a-5755-11eb-0956-21e4624c844e


# ╔═╡ ae834058-56e2-11eb-09fd-c395f97bb76f
md"""
## Packages
"""

# ╔═╡ 0591fa18-56ea-11eb-137b-0d5c5327bfdf
IntervalArithmetic.configure!(directed_rounding=:fast, powers=:fast)


# ╔═╡ cbd6ca27-42d5-4592-a5a0-7f03e6fb7f16
function bound_function(f, X, n, yrange=-5..10)
    Xs = mince(X, n)
        
    plot(f, X.lo, X.hi, lw=3, leg=false, size=(400, 300))
    plot!(IntervalBox.(Xs, f.(Xs)), c=Int.(0 .∈ f.(Xs)))
        
    ylims!(yrange.lo, yrange.hi)
end

# ╔═╡ f615d0ba-56e3-11eb-2d6d-4bab810f6a24
bound_function(x -> x^2 - 2x, -2..2, n)

# ╔═╡ 0fc92e58-56e4-11eb-3479-537013fbdba7
bound_function(x -> sin(1 / x), 0.01..1, n2, -1.1..1.1)

# ╔═╡ f9eef275-83c0-40f0-92c7-bdaac2c11e68
function interval_newton(f, X0, n, α, ymin=-10, ymax=10)

    X = X0

    # draw graph of function over interval X
    xx = X.lo:0.0001:X.hi
    p = plot(xx, map(f, xx), c="blue", lw=3, xlim=(X.lo, X.hi), ylim=(ymin, ymax), legend=:false)
    hline!([0], color="magenta", lw=3, linestyle=:dash)

    Xs = [X]
    new_Xs = []

    N1 = ∅
    N2 = ∅

    for i in 1:n-1

        for X in Xs

            x0 = (1-α)*X.lo + α*X.hi # mid(X)
            deriv = ForwardDiff.derivative(f, X)

            if 0 ∈ deriv 
                N1 = x0 - f(@interval(x0)) / @interval(deriv.lo, -0.0)
                N2 = x0 - f(@interval(x0)) / @interval(0.0, deriv.hi)

                N1 = N1 ∩ X
                N2 = N2 ∩ X

                if !(isempty(N1))
                    push!(new_Xs, N1)
                end

                if !(isempty(N2))
                    push!(new_Xs, N2)
                end


            else
                N1 = x0 - f(@interval(x0)) / deriv
                N1 = N1 ∩ X

                if !(isempty(N1))
                    push!(new_Xs, N1)
                end

            end

        end

        Xs = new_Xs
        new_Xs = []

    end

    for X in Xs
        #if n > 1

            plot!([X.lo, X.hi], [0,0], c="cyan", linewidth=4, alpha=0.3)

            m = (1-α)*X.lo + α*X.hi
            scatter!([m], [0], c="green")
            scatter!([m], [f(m)], c="red")
        plot!([m, m], [0, f(m)], c="green", ls=:dash)
        #end

        x0 = (1-α)*X.lo + α*X.hi # mid(X)
        deriv = ForwardDiff.derivative(f, X)

            # draw initial point
        y0 = f(x0)
        scatter!([x0], [y0], c="red")

        # draw cone
        for m in range(deriv.lo, deriv.hi, length=100)
            plot!([X.lo, X.hi], [ y0 + m*(x-x0) for x in [X.lo, X.hi]], color="gray", alpha=0.2)
        end

        if 0 ∈ deriv
            N1 = x0 - f(interval(x0)) / interval(deriv.lo, -0.0)
            N2 = x0 - f(interval(x0)) / interval(0.0, deriv.hi)

            N1 = N1 ∩ X
            N2 = N2 ∩ X
            
            plot!([N1.lo, N1.hi], [0,0], c="red", linewidth=4, alpha=0.8)
            plot!([N2.lo, N2.hi], [0,0], c="red", linewidth=4, alpha=0.8)

        else
            N1 = x0 - f(@interval(x0)) / deriv
            N1 = N1 ∩ X

            plot!([N1.lo, N1.hi], [0,0], c="red", linewidth=4, alpha=0.8)
        end
    end

    #text(0, 5, "$(length(Xs))")

    p

end

# ╔═╡ b93c1ea4-5742-11eb-0a3e-b9fe05c865ef
interval_newton(x -> x^2 - 2, 0..2, n3, α, -3, 3)

# ╔═╡ 267cdf32-5743-11eb-0915-c5971801f10a
interval_newton(x->x^2 - 2, -3..3, n4, α2, -10, 10)

# ╔═╡ e404f3a7-7fe7-41fe-963a-48cb510e0f6c
function calculate_branch_bound(f, X, N)

    interval_lists = [[X]]
    m = mid(X)
    
    upper_bound = f(interval(m)).hi
    upper_bounds = [upper_bound]
    
    working_list = [X]
    
    for i in 1:N
        X = popfirst!(working_list)
        
        upper_bound = min(upper_bound, f(interval(mid(X))).hi)
        
        if f(X).lo <= upper_bound
            X1, X2 = bisect(X)
            push!(working_list, X1, X2)
        end
        
        push!(interval_lists, copy(working_list))
        push!(upper_bounds, upper_bound)
    end
            
    
    return interval_lists, upper_bounds
end

# ╔═╡ 90c20ca8-5745-11eb-2681-d1d2aa08c484
interval_lists, upper_bounds = calculate_branch_bound(f4, XXX, NN)

# ╔═╡ 5ab7c1c5-d684-4937-89a6-c71aa15b2c55
function plot_branch_bound(f, X, interval_lists, upper_bounds, i)
    
    Xs = interval_lists[i]
    p = plot(IntervalBox.(Xs[2:end], f.(Xs[2:end])), ylim=(-7, 5), xlim=(X.lo, X.hi))
    plot!(IntervalBox(Xs[1], f(Xs[1])), c=:red)

    hline!([upper_bounds[i]], ls=:dash, lw=3)
    
    plot!(X.lo:0.001:X.hi, f, lw=3, leg=false)
    # annotate!(9, upper_bounds[i], text("m", :green))
    plot!([mid(Xs[1]), mid(Xs[1])], [upper_bounds[i], upper_bounds[i+1]], 
            lw=3, c=:green, arrow=true)

    scatter!([mid(Xs[1])], [f(mid(Xs[1]))], c=:red)
    scatter!([mid(Xs[1]), mid(Xs[1])], [upper_bounds[i], upper_bounds[i+1]], c=:green)

end

# ╔═╡ 977bbb2a-5745-11eb-2e16-c15791faea7f
plot_branch_bound(f4, XXX, interval_lists, upper_bounds, i)

# ╔═╡ Cell order:
# ╠═c8776bbc-d0d4-4e15-90a2-7883ded587ba
# ╠═680cc6ba-c0ae-47c1-8cf3-82ab8304259f
# ╠═958dc50e-56e3-11eb-1ad6-872914528ac9
# ╟─aa5914ba-0a4c-11eb-09e1-6df31c935f11
# ╟─c4322273-ecdf-4f2b-a3d0-7897c2de10c1
# ╠═ae8151c2-0a4c-11eb-2463-ab0e6d25d042
# ╟─87e1be4c-56de-11eb-2f57-074235547511
# ╠═b6c570d4-0a4c-11eb-0bc1-d51e28a13085
# ╟─0f0513ea-b0eb-4ae3-a5fe-85735b6f967b
# ╠═63668142-56de-11eb-2034-77957f6516e9
# ╠═f86b58ae-0a52-11eb-3959-3dffbabdfb02
# ╠═7483f810-574c-11eb-0656-9fb0f7957d5e
# ╟─b6acb09c-56de-11eb-1ba8-49d9aff92e96
# ╠═a55effe8-0a53-11eb-0ae6-17fd68c3cbf5
# ╟─6661c95c-0a4b-11eb-0418-5199caf01453
# ╟─33b7d804-33d3-4939-aab5-e302bce48d35
# ╠═8b8db1ac-56e0-11eb-3a06-f70187123d15
# ╟─c503b8a4-7b4c-4428-a481-0090b35e54e7
# ╠═3db16da9-19e0-415f-9092-040e3294964b
# ╠═edd3a4c7-919b-41ce-998f-8117ac73ee99
# ╠═9bce488a-56e0-11eb-3caa-3dfe17a5250f
# ╟─d5213479-16e9-4193-afb9-7f70d0016779
# ╟─11ce60b7-efa9-47a1-bbad-0abfb0d9f3dc
# ╟─a5a0dcdd-fc0e-4dcf-8b21-c29ad26d5b31
# ╟─b4d1018b-1e44-4e50-92c7-e31602aa3794
# ╟─4abf5dd4-2536-49ac-86ee-9bdd1d353f53
# ╟─f2058a6f-b215-4c20-8991-39026f82e853
# ╟─e0e6fbf4-2842-4dec-9abf-c6e11657d752
# ╟─b39868c4-56de-11eb-2f3e-7914b00c3a58
# ╟─eaf76838-56e0-11eb-1832-65c66fc6b878
# ╟─392508a6-62bc-4f40-b4ee-50e7589eec2d
# ╠═effdb18c-56e0-11eb-2fe0-5dedeb8ce6be
# ╠═f32ae258-56e0-11eb-3529-e52ca3a4f83c
# ╠═f5366072-56e0-11eb-0cf8-f520bcd11710
# ╠═f7bf9304-56e0-11eb-1029-33669f7a1d65
# ╠═fcc446b0-56e0-11eb-147f-357d10dea355
# ╠═06495d24-56e1-11eb-3110-f9be8df18016
# ╠═2fbb7e08-56e1-11eb-0ce8-edbe42c96af7
# ╠═ca9a005c-56e1-11eb-2a69-75816b51e874
# ╠═f3903698-574d-11eb-3737-b7d0bec2f0a0
# ╠═ff255350-574d-11eb-0c78-91dee341748b
# ╠═261e9354-574e-11eb-15be-ab1a534ab0c2
# ╠═74bfd5d6-574e-11eb-17f6-b78744ce936d
# ╟─d307fbae-56e3-11eb-3f91-d9f39a3d5b89
# ╟─d548877a-af80-4e43-befe-3fb67db9eac9
# ╠═8af11366-56e4-11eb-026e-0dc1866ac319
# ╠═f615d0ba-56e3-11eb-2d6d-4bab810f6a24
# ╠═af813bf2-56e4-11eb-01af-2180ad97e0f3
# ╠═0fc92e58-56e4-11eb-3479-537013fbdba7
# ╟─db2440fc-56de-11eb-1f8e-15cf07413d76
# ╠═46fb7422-0a55-11eb-12bd-8b41a2b0200e
# ╠═e627e922-56de-11eb-1b5a-d1b60f2d07d6
# ╠═89866847-f382-4339-ab04-f53a3a7fe8d0
# ╠═e5f79113-0168-406c-a293-4b7dd15bad7f
# ╟─2cc9797a-56e6-11eb-27ae-e764f08b2054
# ╠═ce9c63e6-5745-11eb-3e78-4b2ac35ad2bb
# ╠═d784fa92-5745-11eb-121f-557774e90c39
# ╠═101987f0-5747-11eb-3ac5-fd5b668f4043
# ╠═90c20ca8-5745-11eb-2681-d1d2aa08c484
# ╠═c98a4c76-5745-11eb-2500-31df973523d1
# ╠═977bbb2a-5745-11eb-2e16-c15791faea7f
# ╠═d02c5038-56e6-11eb-1c28-cd45b5def70d
# ╠═cb45692a-5750-11eb-12f6-c9d00b5672b6
# ╠═cecaf158-5750-11eb-357a-1bea5b66efea
# ╠═d9e75bd0-5750-11eb-1bbe-57bb52d43851
# ╠═30efc484-56e6-11eb-1ec8-a19a57671970
# ╠═166e0dac-56e7-11eb-21e3-cb025bd58494
# ╠═5837ff18-56e7-11eb-3591-65d5c1d463b7
# ╠═ce92be5a-56e7-11eb-2be8-6983427a3a5f
# ╠═dc3f1346-56e7-11eb-3f61-a77ae00e9fcf
# ╠═32d76ad2-5751-11eb-3e46-d37893c76c23
# ╠═352c7994-5751-11eb-2638-e17d559dcd8f
# ╠═3b5aa642-5751-11eb-0b32-610cc3c5c140
# ╠═a325dac6-5751-11eb-01fe-673c1a48d810
# ╠═a8860c84-5751-11eb-3c3d-5959e1da5ddc
# ╠═ab4212ea-5751-11eb-2ac3-c75cd919e9ba
# ╠═c2a859e6-5751-11eb-3e3c-8d24c0d75a01
# ╠═ca401932-5751-11eb-372f-9d4486326cb5
# ╟─9156faca-56e8-11eb-247f-793a210a7efd
# ╠═864ee9b0-56e8-11eb-041e-5d78d7213e17
# ╠═95bed3d2-56e9-11eb-0ef2-d5bc6e0cc468
# ╠═a7b748da-56e9-11eb-33ea-f35ead225bc8
# ╠═ab5dcf0e-56e9-11eb-0e87-596116168b76
# ╠═b72b6456-56e9-11eb-1f68-57d3d32c5970
# ╠═d569f1a0-5753-11eb-252d-393be14cf1bd
# ╠═d9ee045a-5753-11eb-0dac-55bf04988ab9
# ╟─cd54e8ae-56e9-11eb-02f1-2d29d5c811cf
# ╠═d67ef730-56e9-11eb-0380-e13897cce230
# ╠═e3a7ccca-56e9-11eb-3acb-0f8dbce1858a
# ╟─a2512cc6-56df-11eb-2a12-ff552cf7fb8f
# ╠═de6b1efc-5742-11eb-1c69-7969e75b381f
# ╠═e6254244-5742-11eb-006f-a1cdd1a6df31
# ╠═b93c1ea4-5742-11eb-0a3e-b9fe05c865ef
# ╠═3a468386-5743-11eb-3180-8fd04efceb4c
# ╠═4084a10a-5743-11eb-0a35-c74bb20a95eb
# ╠═267cdf32-5743-11eb-0915-c5971801f10a
# ╠═78278602-5743-11eb-3c73-e3ac9289bad7
# ╠═aa35194c-5744-11eb-1452-a986fa512cb1
# ╠═74f1e43c-5743-11eb-0b9f-f92599d4e991
# ╟─03520242-5745-11eb-2483-3314d1053ac2
# ╠═76e7db86-0a4b-11eb-0f49-9b44dfb50389
# ╠═4bcb90e8-56e0-11eb-0a20-9fde563c81b4
# ╠═47d0bb74-0a5c-11eb-2471-8b4fdd3d775f
# ╠═f99e3a1e-56df-11eb-35e1-dde81cf8ffb5
# ╠═03f513d4-56e0-11eb-2745-39b68d5191a4
# ╠═5e9584c0-0a5c-11eb-3e93-73077e62ef8f
# ╠═7275d088-0a5c-11eb-28be-95fbcac41561
# ╠═5f000bf8-56e0-11eb-18a3-f9660d7f5635
# ╠═e0702c98-0a5c-11eb-2e2c-83725a5fd89f
# ╠═f523f316-56df-11eb-28fa-618c97d7d4df
# ╠═7cd583d0-56e0-11eb-0435-236dc5fe5f0c
# ╠═1329852a-5755-11eb-0956-21e4624c844e
# ╟─ae834058-56e2-11eb-09fd-c395f97bb76f
# ╠═f9b2f338-56e3-11eb-2878-d3226a44e68a
# ╠═0591fa18-56ea-11eb-137b-0d5c5327bfdf
# ╠═cbd6ca27-42d5-4592-a5a0-7f03e6fb7f16
# ╠═f9eef275-83c0-40f0-92c7-bdaac2c11e68
# ╠═e404f3a7-7fe7-41fe-963a-48cb510e0f6c
# ╠═5ab7c1c5-d684-4937-89a6-c71aa15b2c55
