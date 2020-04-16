# Summaries of lectures: 18.330 (spring 2020)

## Lecture 1: Invitation (3 Feb)

We started off discussing the logistics of the course and advertised
Steven Johnson's Julia tutorial on Friday Feb 7 from 5-7pm in 32-141.

Then we turned to discuss what the course is about with the example
of dropping a ball with air resistance and asking when it will hit the floor.
This will be modelled by some kind of ordinary differential equation $\dot{y} = f(y)$
that we would like to *solve*, i.e. find a solution $y(t)$ as a function of time,
and then find a *root*, i.e. the time $t^*$ when $y(t^*) = 0$.

In general it will be *impossible* to solve this problem exactly; the course is
about developing ways to find *approximate* solutions, and indeed to be able
to approximate the true solution as closely as we would like.

As a concrete example we discussed the collision of two discs modelling particles
in a fluid. If we take small time steps $\delta t$, after every step we will check an
overlap condition by evaluating a function $f(t)$ which calculates the current distance
between the two discs at time $t$. We have $f > 0$ if the discs do not overlap and
$f < 0$ if they do overlap. We are interested in finding the root $t^*$ for which
$f(t^*) = 0$, when they will just touch.

As an example of a root-finding algorithm, we implemented the bisection algorithm
including a tolerance $\epsilon$, and showed that it worked with `BigFloat`.

## Lecture 2: Representing numbers (5 Feb)

We began by looking at a visualization of a hard sphere fluid (using the Julia
package https://github.com/JuliaDynamics/HardSphereDynamics.jl that I wrote).

Then we took the bisection algorithm from last time and added the possibility to
store intermediate values in a Julia **vector** (with type `Array{Float64,1}` -- a *1*-dimensional array that stores numbers of type `Float64`). Then we plotted the data using the `Plots.jl` package, and saw that a straight line on a semi-log
graph with a logarithmic $y$ axis corresponds to an *exponential* relationship between the $y$ and $x$ data:

$$y \sim C \exp(-\alpha x),$$

where $-\alpha$ is the slope of the straight line on the semi-log
graph.

Then we moved on to representing numbers on the computer.
Since we only have a finite amount of space available, we can
only represent a finite subset of all numbers. All numbers (and indeed any other kind of object) are represented as a sequence of **bits** (binary digits) stored somewhere in memory. The **type** of a variable tells Julia which kind of number the data corresponds to, and hence how to interpret it, i.e. its **behaviour**.

We started with Booleans (true or false), represented by 1 bit. Then we saw that integers are represented as binary expansions, although something strange happens for negative integers ("two's complement").

Rational numbers correspond to pairs $(p, q)$ of integers, but
we want to define new operations on them, so we *defined our own rational type* using Julia's immutable `struct` composite types,
and did an example of how to define a new operation on such a type, and how to change how objects of that type are displayed (by overloading `Base.show`).

To represent real numbers we started off thinking about **fixed-point numbers**, which are basically integers with a decimal point (actually a "binary point") inserted at a fixed place in the binary expansion of an integer.

But these can't represent a wide enough range of numbers, so instead we turned to **floating-point numbers**. These are still just special rational numbers, with denominators that are powers of 2. They are spaced in an unusual way along the line: larger values have more space between them (although the *relative* spacing is the same).

We saw how to "peel apart" a float in Julia and reconstruct its value.

## Lecture 3: Representing functions (7 Feb)

I started with a few comments about the [bibliography](`bibliography.md`). The book `Fundamentals of Numerical Computation` by Driscoll and Braun is a nice, recent, modern point of view at the level of the course. It covers much of what we will see in the course.

Then we briefly discussed floating-point arithmetic. The fundamental operations `+`, `-`, `*`, `/` and `sqrt` are guaranteed by the IEEE 754 standard to be **correctly rounded**: the result is the *closest* floating-point number to the true result, as if it were calculated in infinite precision. In practice the CPU only needs to use a few extra "guard bits" to do this.

Next we moved on to thinking about how to evaluate a function $f$, for example  $f(x) = \exp(x)$ (exponential). Since that's a difficult problem, we replace it by a simpler problem: we **approximate** $f$ by a function that is simpler to evaluate.

The only functions that we can actually calculate are **polynomials**, which are a finite sum of terms of the form
$p(x) = a_0 + a_1 x + a_2 x^2 + \cdots + a_n x^n$. We can evaluate
these just with the basic arithmetic operations `+`, `-` and `*`.
[In fact we can also evaluate *ratios* of two polynomials, $p_1(x) / p_2(x)$; these are called **rational functions**, and play an increasingly important role in numerical analysis.]

Then we saw that it is actually possible to approximate *any* continuous function $f$ on a *finite* interval $[a, b]$, arbitrarily close by a polynomial; this is the content of the **Weierstrass approximation theorem**.

How can we actually *find*, or *construct*, an approximating polynomial, though? We will see several methods to do so during the course, but we started with one motivated in mathematics: **Taylor series**.

For example, we know that $\exp(x) = \sum_{n=0}^\infty \frac{x^n}{n!}$. We still can't evaluate this **power series**, since it has an infinite number of terms. Instead, we **truncate** it by stopping after $N$ terms, which gives a polynomial, called the **Taylor polynomial of degree $N$** for the function $f$.

In doing so we commit a **truncation error** by omitting the infinite tail of the series. The Lagrange form of this remainder is a way of writing this as a single term involving evaluating the $(N+1)$ the derivative of $f$; however, it is evaluated at an unknown point $\xi$ in the interval. Nonetheless, this allows us to calculate a *bound* of the truncation error.

We then saw how to use the `TaylorModels.jl` package to do this calculation rigorously, using **interval arithmetic** to calculate guaranteed (mathematically rigorous) lower and upper bounds of all errors in the calculation (rounding errors and truncation error). We also saw how the `Interact.jl` package can easily generate nice interactive visualizations.


## Lecture 4: Root finding (10 Feb)

We looked at some methods for finding **roots** (**zeros**) of a function $f(x)$, which will also solve equations of the form $g(x) = h(x)$ by solving $f(x) := g(x) - h(x) = 0$.

We started off reviewing roots of polynomials: the fundamental theorem of algebra guarantees that a degree-$n$ polynomial has exactly $n$ roots in the complex plane $\mathbb{C}$, although some of those may be **multiple roots**. Although there are exact formulae in terms of basic arithmetic and $r$th roots for polynomials of degree $\le 4$, in general it is known that no such formula is possible or degree $\ge 5$.

Thus any general numerical method for finding roots must be an **approximation algorithm**. A usual formulation would be as an **iterative algorithm** of the form $x_{n+1} = g(x_n)$, where $g$ is an algorithm that is applied to one iterate to calculate the next one. We hope that the sequence $x_0, x_1, \ldots$ converges to some $x^*$, in which case we must have $x^* = g(x^*)$ if $g$ is a continuous function. Thus *if* the sequence converges, it converges to a **fixed point** of $g$.

In order to solve the equation $f(x)$ we must thus arrange for a fixed point of $g$ to be a root of $f$; e.g. $g(x) = x + f(x)$, or rearrange $f(x)$ to isolate $x$ on one side.

We looked at conditions that guarantee the existence and uniqueness of a fixed point in a certain interval, and discussed when we can expect the iterative algorithm to converge to a root or not, depending on the value of the derivative at the fixed point. Note that it is often difficult to actually check these conditions in practice, however.

We defined the **order of convergence** of a sequence as being that value of $\alpha$ such that $\delta_{n+1} \sim \delta_n^\alpha$ when $n \to \infty$. Bisection is order 1 ("linearly convergent"), whereas the Babylonian algorithm is order 2 ("quadratically convergent"). But note that a "linearly convergent" sequence converges *exponentially* fast, whereas a quadratically convergence algorithm converges **super-exponentially**, i.e. "really very fast indeed".

We finished by looking at the Newton method, which is a workhorse of numerical root-finding methods, and turns out to be quadratically convergent. But that is true only if you are *close enough* to a root, and it is difficult to know when you are close enough. If you are not close enough then the Newton method can behave very badly.


## Lecture 5: Root finding II (Feb 12)

We started off looking at how to plot heatmaps and surfaces of 3D data (a value at each point in a 2D mesh) with Julia.

Then we continued with our study of fixed-point iterations for solving equations by using the mean-value theorem to prove that a fixed-point iteration $x_{n+1} = g(x_n)$ converges under the following conditions: $g$ is continuous; $g$ maps an interval $[a, b]$ into itself; and $g$ has a derivative whose absolute value is bounded above by $k < 1$. In this case we stated (proof in Burden and Faires) that there is a unique fixed point. We showed that the fixed-point iteration converges from any initial $x_0 \in [a, b]$ to the fixed point, and that the order of convergence is $1$ or larger.

Normally a fixed-point iteration will have order of convergence $\alpha = 1$, when the derivative $g'(x^*) \neq 0$. We next tried to design a method with faster convergence, by imposing that $g'(x^*)$ should be *equal* to 0. The simplest choice gives the Newton method.

So how fast does the Newton method converge? We showed using a Taylor expansion that is has order of convergence $2$. Interestingly, the Babylonian algorithm (which was apparently literally known in Babylonian times, over 3000 years ago) turns out to be a special case of the Newton method, namely for solving the equation $f(x) := x^2 - y = 0$ for $x$ (with fixed $y$ whose square root we wish to calculate).

The Newton method is not ideal, however, since it requires us to know how to calculate the *derivative* of the function $f$. Later in the course we will see (at least) two different types of methods to calculate derivatives, but for now we ask if there is a method somehow similar to Newton that has better convergence than a standard fixed-point iteration but does not require us to calculate a derivative, i.e. is **derivative-free**.

It turns out that we can design such a method as follows. We use a different linear / affine approximation of our function $f$ to replace the tangent line approximation that Newton uses.
To do so, instead of starting from *one* initial point $x_0$, we take *two* (distinct) initial starting points $x_0$ and $x_1$. Now we use the two data points $(x_0, f(x_0))$ and $(x_1, f(x_1))$ on the graph of the function $f$, and **interpolate** between them: we find the linear function $\ell(x)$ that joins those two points. Now we look where $\ell(x)$ intersects the $x$-axis to get the next approximation $x_2$. We repeat this process, using at each step the last two $x_i$ values that were produced.

We showed that this **secant method** (so-called since the line joining two points on a curve is called a **secant**) converges with order $\alpha \simeq 1.62$. At first sight this seems to be a slower rate of convergence than for the Newton method. However, the secant method requires only *one* new evaluation of the function $f$ at each step, whereas Newton requires us to evaluate $f$ and $f'$ at each step. Thus, *per function evaluation* the secant method is more efficient. Since we are often trying to find roots of complicated functions, evaluating $f$ determines the speed of the overall method, so the secant method may converge faster in practice. This will be problem-dependent.

## Lecture 6: Feedback from problem set I (Feb 14)

We covered some feedback from problem set I, namely some logistics and tips about how to approach the exercises; see the lecture 6 slides.

We discussed some points on the exercises from problem set 1.

We also covered some useful Julia features, especially for constructing arrays.

## Lecture 7: Systems of nonlinear equations (Feb 18)

We started by discussing the single nonlinear equation $f(x, y) = 0$ in two variables. The **solution set** is the set of $(x, y)$ pairs in $\mathbb{R}^2$ that satisfy the equation. A **level set** of $f(x, y)$ is a set where $f(x, y) = c$, with $c$ a constant. For a function $f: \mathbb{R}^2 \to \mathbb{R}$ this takes the form of a **contour line**.

For example, if $f(x, y) = x^2 + y^2$ then the level sets are circles centered at the origin for $c > 0$, a single point for $c = 0$, and the empty set for $c < 0$. They are intersections of the graph of the function (in 3D) with a horizontal plane at height $c$. We saw how to use the `contour` function to plot them.

In general we expect level sets of a function $f: \mathbb{R}^2 \to \mathbb{R}$ to look locally like **curves**, by the implicit function theorem. However, there can be [**singular points**](https://en.wikipedia.org/wiki/Singular_point_of_a_curve) where these curves join together.

In higher dimensions, a function $f: \mathbb{R}^n \to \mathbb{R}$ has level sets that locally are $(n-1)-dimensional$ surfaces, or **manifolds**, also called **codimension 1 manifolds**. Each constraint $f(\mathbb{x}) = c$ is expected to decrease by $1$ the dimension of the resulting object (increase by 1 the codimension).

A **system of nonlinear equations** is a set of nonlinear equations that must be satisfied *simultaneously*, i.e. we are interested in the **intersections** of the sets. If we have $n$ equations in $n$ unknowns, then we expect that the solutions are isolated points (although pathologies can also occur where this does not happen).

In order to find these points numerically, we looked at the multidimensional Newton method. Its derivation mirrors that of the 1-dimensional Newton method, but now using the Jacobian matrix in place of the derivative, and requiring us -- mathematically -- to invert this matrix. Numerically we instead solve a linear system, using the `\` operator in Julia; we will study this in detail later in the course.

We also reviewed the derivation of the gradient of a function $f: \mathbb{R}^n \to \mathbb{R}$ and the jacobian of a function $f: \mathbb{R}^n \to \mathbb{R}^n$.


## Lecture 8: Algorithmic differentiation (Feb 19)

We started off by realising that when we differentiate a complicated function, we are just following a set of well-defined rules. Computers are good at rule-following, so maybe we can encode those rules for the computer to use to calculate exact derivatives.

We recalled the definition of derivative and commented that the limit that occurs in the definition is difficult to work with, so we rewrote it by introducing "little-o notation": $o(h)$ is an unspecified function that converges to 0 *faster than $h$* as $h \to 0$, i.e. that satisfies $o(h) / h \to 0$.

In this way we get an equivalent definition of derivative that is easier to work with; in particular, if we can express $f(a + h)$ in the form $f(a + h) = A + Bh + o(h)$, then we know that $A$ must be $f(a)$ (this will usually be obvious) and, more importantly, that $B$ must be $f'(a)$. This gives a mechanism to *calculate* $f'(a)$.

We applied this to derive the sum and product rules from calculus. Then we introduced the idea of **dual numbers**. These form a new type of algebra where we introduce an "infinitesimal" symbolic quantity $\epsilon$ satisfying $\epsilon^2 = 0$. Then we think of $c + \epsilon d$ as representing a function with value $c$ and derivative $d$ at some point of interest $a$. We define arithmetic operations on these dual numbers to encapsulate the differentiation rules, always remembering that the coefficient of $\epsilon$ corresponds to the derivative of the function.

Then we saw how we can code this in Julia by defining a new composite thpe `Dual`. We made this a **parametric type** by allowing the fields inside the type to be of any type `T` that is a subtype of the abstract type `Real`. By overloading the arithmetic operations (which we must first `import` from `Base`), we arrange for `Dual(a, b)` to mimic the behaviour of $a + b\epsilon$.

In order to actually calculate the derivative of a Julia function `f`,  we use the fact that $f(a + \epsilon) = f(a) + \epsilon f'(a)$. So `f(Dual(a, 1.0))` gives a new `Dual`, whose second (dual) field contains the derivative. We can think of `Dual(a, 1.0)` as representing the identity function $x \mapsto x$ at the point $a$, whose derivative is indeed 1.

Finally, we saw that this may be extended to higher-dimensional functions such as $f(x, y)$. For example, $f(a_1 + v_1 \epsilon, a_2 + v_2 \epsilon) = f(a_1, a_2) + \epsilon \, \nabla f(a_1, a_2) \cdot \mathbf{v}$, so evaluating `f(Dual(a1, v1), Dual(a2, v2))` will calculate the **directional derivative** as its second (dual) field.

Setting the vector $\mathbf{v}$ to be coordinate directions gives partial derivatives. This can then further be used to build up a complete Jacobian matrix $\mathsf{J}$, although often all we actually need is $\mathsf{J} \cdot v$, a Jacobian--vector product, which can be calculated more efficiently by building it out of $f(a + \epsilon v)$ terms.


## Lecture 9: Conditioning (Feb 21)

In this lecture we introduced the concept of **condition number** to measure the sensitivity of a problem $\phi$: how much does the output $y = \phi(x)$ change when the input $x$ changes?

To define this, suppose we have an approximation $\hat{x}$ of $x$. We define $\hat{y} = \phi(\hat{x})$ to be the corresponding new output.

Now we define the **absolute errors** $\Delta x := \hat{x} - x$ and $\Delta y := \hat{y} - y$. However, the absolute output error will change just because we change the scale of the input, so it's more useful to define instead the corresponding **relative errors**,

$$\delta x := \Delta x / x; \quad \delta y := \Delta y / y$$

We saw that the number of **accurate** or **significant digits** in the approximation is $-\log_{10}(|\delta x|)$.

The **(relative) condition number**, $\kappa_\phi(x)$ of the problem $\phi$ at the point $x$ is then given by

$$\kappa_\phi(x) := \frac{|\delta y|}{|\delta x|}$$

When $\Delta x \to 0$ we can obtain a closed-form expression for $\kappa$ as

$$\kappa_\phi(x) = \left| \frac{x \phi'(x)}{\phi(x)} \right|$$

For example, $\phi(x) = x^2$ has a condition number of 2, which is low; hence the problem of squaring a value is **well-conditioned**. Note that a condition number is attached to a **problem**, and is independent of any algorithm that we might use to actually solve that problem in practice.

We derived the (relative) condition number for addition/subtraction; despite being one of the simplest operations, we saw that it is *ill-conditioned* if we subtract two numbers that are very close together. This is the effect known as **catastrophic cancellation** where we can lose many accurate digits by subtracting two close numbers.

This occurs, for example, when we try and solve a quadratic equation $ax^2 + bx + c$ by using the quadratic formula: if $ac$ is close to $0$ then we end up subtracting two very close numbers, and hence losing accuracy. A way round this is to realise that the calculation of the other root is well-conditioned, so we calculate that one and then use a relation between the two roots to calculate the difficult one. This is an example of a general idea: if part of your algorithm uses a step that is ill-conditioned, try to replace it by a different method!

Finally, we looked at the condition number of the problem "find the roots of a quadratic equation". We saw that this is ill-conditioned if the roots are close together, i.e. close to a double root: when we shift the quadratic slightly, the roots move a lot.


## Lecture 10: Polynomial interpolation (Feb 24)

We started off by looking at the problem of how to "fit" discrete data using a function. We can either try to find a "best" approximation (within some particular class of functions), which we will look at later in the course; or we can look for a function that *passes through* each data point, i.e. we can **interpolate** the data, i.e.
$f(t_i) = y_i$ for all $i$, where the $t_i$ are the **nodes** or **knots** where we have function values.

A natural class of functions to try and use are polynomials. A polynomial of degree 1 is a straight line, i.e. an affine function $x \mapsto ax + b$. Given two points $(t_1, y_1)$ and $(t_2, y_2)$, we can find a unique straight line joining the two. A useful way to do it is to first construct **cardinal (basis) functions**, which satisfy $\ell_1(t_1) = 1$ and $\ell_1(t_2) = 0$, and vice versa. In this way the Lagrange interpolating polynomial is $L(x) = y_1 \ell_1(x) + y_2 \ell_2(x)$.

We can then use this to do piecewise-linear interpolation, by constructing **hat functions**, which are piecewise linear and non-zero only at a single $t_k$.
Any piecewise-linear function can then be written as a sum of these hat functions, so the hat functions form a basis for the space of piecewise-linear functions.

We saw that by writing down the conditions for a degree-$n$ polynomial to interpolate in $n+1$ points, we get a linear system of equations to solve. This shows that there exists a solution and it's unique; but the numerical method obtained by trying to numerically solve the equations is ill-conditioned.

Instead we constructed Lagrange cardinal basis functions as products of the form $(x - t_i)$, which is zero at $t_i$. This gives a constructive way to find interpolating polynomials for any data. However we commented that this goes very wrong when we try to do interpolation in equally-spaced points.

We finished by seeing a visual demonstration of the fundamental theorem of algebra, by looking at the image of a circle of radius $\rho$ in the complex plane under a polynomial $f(z)$ of degre $n$ as we vary $\rho$ from a large value to $0$: The image curve crosses the origin $n$ times during the process.


## Lecture 11: Julia for mathematics (Feb 26)

We looked at a mixture of philosophical views and practical tips on the link between Julia and mathematics.

Code actually often requires us to be *more* precise than
mathematics about exactly which object we are talking about and what type it is. E.g. if $f_r(x) = r x (1 - x)$
is the logistic map, then we think of $f_r$ as a different univariate function for each $r$. In Julia we would write this as `f(r, x) = r * x * (1 - x)`, but then so far there is no way of talking about just `f(r)`.

What we would like to do is define `f(r)` as another method of the function `f` which takes only a single variable -- the parameter `r` -- and *returns a function*. We can do this using anonymous functions by defining

```julia
f(r) = x -> f(r, x)
```

We can then pass e.g. `f(2.5)` to another function that expects a function as an argument.

Then we talked about "vectors" in Julia. Here there is a tension between the mathematical meaning of "vector" -- basically, something that has components and can be added and multiplied by a number -- and the computer science meaning of "vector" as a 1-dimensional array, that is, just a *container for data*.

Julia conflates (combines) the two meanings into a single concept `Vector`, which you can use both as a mathematical object *and* as a storage container; indeed, `push!(v, 3)` appends a new element to the `Vector` `v`, an operation which is simply not possible with a mathematical vector.

However, the `StaticArrays.jl` package defines the `SVector{N,T}` type, which represents a vector of *fixed* length `N` holding objects of type `T`. These are implemented in a very efficient (performant) way, and are the vectors of choice for representing e.g. position and velocity vectors of particles in a simulation in a low number of dimensions.


## Lecture 12: Finite-difference approximations of derivatives (Feb 28)

Today we looked at a different way to find approximations to derivatives, using **finite differences**. The simplest example is where we ignore the limit in the definition of the derivative $f'(a)$ and approximate it by $(f(a + h) - f(a)) / h$ for a  small but non-zero value of $h$.

Supposing that $f$ is smooth enough, we can do a Taylor expansion of $f$ to show that the error in this approximation is $\mathcal{O}(h)$. However, we saw that when we try to just evaluate this approximation for tiny values of $h$, close to machine epsilon  ($\epsilon_\text{mach}$), the error initially converges to $0$ linearly, as expected, but then starts to get bigger for $h < 10^{-8}$! This unexpected behaviour basically originates in catastrophic cancellation coming from the subtraction in the definition, and corresponds to the problem being ill-conditioned as $h \to 0$.

We saw that by playing with Taylor expansions we can find higher-order approximations with errors going like $\mathcal{O}(h^n)$, and also approximations for higher derivatives. The goal is to find the coefficients for linear combinations of the function values to give these approximations. Doing so by manipulating Taylor series is not systematic, however.

A systematic approach is possible by thinking of these approximations as first interpolating a polynomial through the data, and then differentiating the interpolant. The Fornberg algorithm makes this usable.

One important application is to the discretization of differential equations: e.g. approximating a differential equation using finite differences reduces the Poisson equation to solving a linear system of equations.

Finally, we saw that finite differences can be thought of as derivative *matrices* that apply on vectors representing the coefficients of the problem. This will also be important later on.


## Lecture 13: Numerical integration (Mar 2)

We discussed the problem of how to numerically calculate definite integrals $I(f) := \int_a^b f(x) \, dx$, also called **quadrature**. We are looking for methods that approximate this by something of the form $\sum_k w_k f(t_k)$, where the function $f$ is evaluated at **nodes** $t_k$ and the $w_k$ are the **weights**, which should be independent of the function $f$.

The Riemann integral definition of $\int_a^b f$ suggests the simplest numerical method, the **rectangule rule**, where we split $[a, b]$ into subintervals, or **panels**, and approximate the function $f$ with a piecewise constant function, and the integral of $f$ by the sum of the areas of the corresponding rectangles.

We calculated the error of the resulting method as a function of the width $h$ of the intervals between equally-spaced points $t_i$, showing that the local error in the integral each subinterval is $\mathcal{O}(h^2)$, and so the global error is $\mathcal{O}(h)$.

Next we asked how we could improve on this. We can do so by approximating the function $f$ more accurately, for example by interpolating it in certain points. The simplest interpolation method is to use a degree-$1$ polynomial, i.e. a straight line, joining $(a, f(a))$ and $(b, f(b))$. If we represent this in Lagrange form as $p(x) = f(a) \ell_0(x) + f(b) \ell_1(x)$ then we see that the weights are just given by $w_k := \int \ell_k$!
These are independent of $f$, as desired. Doing this in equally-spaced points gives **Newton--Cotes** quadrature rules.

It is possible to find a general formula for the error in Lagrange interpolation that looks similar to the Lagrange form of the remainder in Taylor's theorem. From there we find that interpolating with a degree-$n$ polynomial gives a global error that is $O(h^{n+1})$.

## Lecture 14: Ordinary differential equations (Mar 4)

We started to discuss **ordinary differential equations** (ODEs), i.e. equations relating a function $x: t \mapsto x(t)$ with its derivatives $\dot{x}$ etc. A simple example is $\dot{x} = f(x)$. An ODE tells us in which direction and how fast to move, given where we are currently.

An example is $\dot{x} = -\lambda x$, to which we must add an initial condition $x(t=0) = x_0$. In this particular case we know that the function $x(t) = x_0 \exp(-\lambda t)$ is a **solution**, i.e. a function which satisfies both the differential equation and the initial condition. But for a general ODE we will not usually be able to find an explicit analytical solution like this.

Nonetheless, there are theorems which prove that solutions exist and are unique under certain technical conditions, for example if $f$ is continuously differentiable ($C^1$).

So we would like to construct approximations to the solutions. One way to do so is **time stepping**: we find approximations $x_n$ to the exact solution $x(t_n)$ at a sequence of times $t_1$, $t_2$, \ldots, $t_N$. For now we will take equally-spaced times, $t_n := t_0 + n h$. We are only interested in numerical methods that are **convergent**, i.e. such that the approximate solution at a given time converges to the true solution at that time as $h \to 0$.

The Euler method is the simplest such method, where we assume that the derivative $\dot{x}$ is constant over each step. This leads to the method

$$x_{n+1} = x_n + h_n \, f(t_n, x_n)$$

for an inhomogeneous ODE $\dot{x}(t) = f(t, x(t))$ that may depend explicitly on time.

We saw that we can rewrite the differential equation as an integral equation and construct methods by approximating the integral, for example the trapezium rule. This turns out to give an *implicit* equation for $x_{n+1}$ in terms of itself, so we need to use a root finding method, such as Newton, to solve this at each step. Nonetheless this class of implicit methods are important for solving **stiff** equations, as we will see later.

We finished by discussing systems of coupled ODEs. If we write them in a vector form then the Euler method has the *same* expression as above, except that each term (other than $t_n$) is now a vector. Thus the *same* code can be used to solve it.


## Lecture 15: Ordinary differential equations II: Runge--Kutta methods (Mar 6)

We started by seeing how higher-order differential equations, i.e. those with higher derivatives like $\ddot{x} + \omega^2 x = 0$, can be turned into systems of 1st-order equations. This is done by introducing a new variable for each derivative except the highest-order one. For example, defining $v := \dot{x}$ we have $\ddot{x} = \dot{v}$ and so $\dot{v} = -\omega^2 x$; in this way we replace the higher derivative with an additional first-order equation.

Then we asked how we could turn the implicit trapezium rule into an explicit method. We need an estimate of the term $x_{n+1}$ that appears on the right-hand side of the trapezium rule. But we can do this using an Euler step! Since there is already a factor of the step size $h$ multiplying this in the expression for the trapezium rule, the term with $h$ in the Euler step actually becomes a term multiplied by $h^2$.
Doing a Taylor expansion of the resulting method shows that it correctly captures Taylor expansion up to order $h^2$!

This is only one example of a class of **Runge--Kutta methods**, consisting of several **stages**, each of which is a single evaluation of the function $f$ defining the ODE. These methods can be represented by a **Butcher tableau** containing the coefficients that define the method.

We did not look at the theory of such methods (which is complicated), but there are methods known up to order 14 (!)

## Lecture 16: Ordinary differential equations III: Variable step size and error control (Mar 9)

We asked how we can know if a step of an ODE solver is a good one or not. We would like to compare the result with the true solution, but of course we don't have access to that.

Instead, we use *another* approximate solution to compare with. We can do one of two things: (1) use the same method with half the step size, repeated twice, or another method of the same order with the same step size. In this case the difference between the resulting estimates, $\Delta y$, gives us an estimate of the error $C h^{p+1}$ (for an order-$p$ method), multiplied by a constant that depends on the order.

(2) Use one method of order $p$ and one of order $p+1$. Then the difference $\Delta y$ between the two results gives us a direct (approximate) measurement of the error $C h^{p+1}$ in the lower-order method.

In either case, we first *propose* a step, without carrying it out.
Now we check the size of the error $\Delta y$. Suppose that we impose a desired error $\epsilon$, or an error per unit time, that we wish to attain. If $\Delta y < \epsilon$ then we **accept** the step and carry it out.

If $\Delta y > \epsilon$ then we **reject** the step and remain where we were. We now *choose* a new step size $h'$ such that it *would* give error $\epsilon$. We do this even if the step was accepted, since then the function is "easy to integrate" in the current region.

In this way we obtain an **adaptive** method, which adapts to the shape of the function: if the solution does not change shape fast, the method can take large steps. When the solution is changing in a complicated way, the method takes smaller steps to resolve those changes accurately.

## Lecture 17: Ordinary differential equations IV: Taylor methods (Mar 11)

We started off by noting that to solve the **non-autonomous** ODE $\dot{x}(t) = f(t, x(t))$, i.e. where $f$ has an explicit time dependence, you can replace it by an autonomous system by introducing a new variable $z$ such that $\dot{z} = 1$ and $z(0) = t_0$, so that basically $z$ is equal to time $t$. Then by adding the new equation $\dot{z} = 1$ we convert the original non-autonomous ODE into a system of autonomous ODEs.

Then we asked whether for an autonomous ODE $\dot{x} = f(x)$ we could directly calculate a series solution $x(t) = x_0 + x_1 t + \cdots$ by finding the Taylor coefficients $x_0$, $x_1$ etc. (Note that these are the derivatives of $x$ evaluated at $0$.)
Runge--Kutta and other methods try to calculate these indirectly with clever tricks, and provide methods that work for *any* $f$. If we are willing to do new calculations for each $f$ then we can actually get a specialized Taylor method that directly calculates the $x_i$.

To do so, we suppose that we have Taylor expansions

$$x(t) = x_0 + x_1 t + x_2 t^2 + \cdots$$

and

$$f(x(t)) = f_0 + f_1 t + f_2 t^2 + \cdots$$

Note that these are both expansions in *powers of $t$*.


Then
$$\dot{x}(t) = x_1 + 2 x_2 t + \cdots$$

so by equating coefficients of powers of $f$ we get $x_{n+1} = f_n / (n+1)$.

Now we noted that $f_n$ depends only on the coefficients $x_0$ through $x_n$, and can be calculated by evaluating $f(x_0 + \cdots + x_n t^n)$, i.e. $f$ applied to the polynomial up to order $n$, and taking the coefficient of $t_n$ in the resulting expression, i.e. truncating $f$ to order $n$.

In this way, starting from $x_0$ we can recursively calculate, in order, $f_0$, then $x_1$, then $f_1$, then ... then $x_n$, then $f_n$, etc, and hence calculate all the $x_n$ as high as we like. If we could use infinite precision real numbers, these would all be exact; in practice, we introduce round-off error when we use floating-point numbers instead.

Finally we saw that there is an equivalent point of view using the integral representation, where we set up a **Picard iteration**: starting from $x_0$, we repeatedly integrate the polynomial and re-add the initial condition. In this way we produce a sequence of polynomials that converge to infinite series solution.

Note that these power series usually have a finite **radius of convergence**, so the series solution is *not valid* beyond a certain $t^*$. We can use the error control techniques from the last lecture to determine how far to move in each step, before we re-calculate a new solution for the next step using the same Taylor method.


## Lecture 18: Midterm review (Mar 30)

We reviewed the conceptual ideas that we have seen so far in the course and some of the technical
details that we have covered.

In particular we recalled that we are interested in solving mathematical **problems**
and that we do so by replacing the true problem we wish to solve with an approximate
**designed** problem, for example "calculate $f(x)$ but using floating-point arithmetic".

Often these designed problems involve a parameter $N$ which we would like to converge to
$\infty$, for example the number of points in a discretization, or the degree of a polynomial
approximation, or a parameter $h$ that we would like to converge to $0$, such as a
step size used in a finite-difference approximation. Even though the original problem
does not contain such a parameter, it often (but not always) turns out that the solution
methods available to us provide only approximations of the true solution that become increasingly
good (at least, in principle with arbitrary precision) as the limit is approached.

In that case, we need to calculate the **error** -- i.e. how far away we are from
the limit if we take a finite $N$ instead $N \to \infty$. We are, in particular,
interested in *how fast* the error goes to $0$ as $N \to \infty$ or $h \to 0$,
i.e. the *rate of convergence*. If the convergence is faster then we need to do
less work to get the same accuracy, which is better for us.

We reviewed examples of these concepts from topics throughout the course.

## Lecture 19: Linear algebra review (Apr 1)

We started a new section of the course, on linear algebra, for which we
reviewed some fundamental concepts.

We started by discussing **vectors** and the fundamental idea of the **span** of
a set of vectors, i.e. the vector space formed by taking *all possible linear
combinations* of those vectors. We saw that if a set of vectors spans a space,
then any vector in the space is reachable, so we can solve the vector equation
that finds the coefficients of that linear combination.
We saw that this gives a set of linear equations by decomposing the vectors in
a basis and taking components.

We then introduced the other main concept in linear algebra, namely **linear maps**,
i.e. functions with the special property that they are linear. We saw that this
greatly restricts what a linear map can do, and in fact we can specify the action
of a linear map by the action on each member of a basis of the space. The result
of this action can then be encoded in a **matrix**, i.e. a table of coefficients
of the resulting linear combinations.

We defined the matrix--vector product as the result of applying the corresponding
linear map to the vector, and the matrix--matrix product as the
result of consecutively applying the corresponding linear maps.

## Lecture 20: Linear algebra II (Apr 3)

We discussed how to solve a linear system of equations, or equivalently a vector equation
or the matrix equation $A x = b$ for a square matrix $A$.

We looked at the ("Gaussian") **elimination** or row reduction algorithm, in which
we add multiples of one row to another in order to introduce 0s in the matrix.
By doing this in a certain order, and acting on the augmented matrix where we
adjoin the vector $b$ to the matrix, so that we operate on $b$ in the same way,
we can find an equivalent system in which the matrix is upper-triangular, and
hence can be solved easily using backsubstitution.

We saw that each row operation can be represented by left-multiplying $A$ by
some elementary matrix $L_i$, and hence that the result of applying all the row
operations is a product of the $L_i$, which is a lower-triangular matrix $L$,
whose entries are just the numbers that we computed during the reduction process.

In this way, we saw that we could write a square matrix $A$ as the product $LU$;
we called this the LU factorization of the matrix $A$.
This allows us to solve athe equation $Ax = b_i$ for many right-hand sides $b_i$ more
efficiently than redoing the elimination process each time, which would recalculate
the same matrix $L$.

## Lecture 21: Linear algebra III (Apr 6)

We introduced geometry into the linear algebra picture by thinking about
length and angle in Euclidean space. We introduced orthogonal projection operators
and showed that the projection of a vector $u$ onto a vector $v$ has length given
by the dot product $u \cdot v = \sum_i u_i v_i$.

We defined two vectors to be **orthogonal** if their dot product is $0$, which means
that the angle between them is $\pi/2$, so they are perpendicular.

We saw that having orthogonal vectors is very useful, since it enables us to
immediately find the coefficient of a given basis vector in a linear combination, by
just taking the dot product of that basis vector with the vector of interest.

In order to construct a suitable set of orthonormal vectors, we saw that a vector
$v$ can be written as a piece in the direction of $u$, together with the remainder,
and that that remainder is orthogonal to $u$. Using this idea repeatedly, we saw
that we could take linear combinations of the columns of $a$ in a triangular way
to make an orthonormal set of vectors that spans the same space.

Finally we saw that we could write $A = Q R$, where $Q$ has as columns the
orthonormal vectors, and $R$ is upper-triangular ("right triangular").
This QR decomposition turns out to be of fundamental importance in numerical linera algebra.

## Lecture 22: Linear least squares problems (Apr 8)

We discussed the need to be able to fit parametric functions, i.e. functions
containing some free parameters, to data, by choosing the parameters to minimize
some kind of **distance** between the data and the function.

As an example we discussed fitting a straight line to a set of data, and we
re-expressed this problem in a matrix language, namely trying to solve $Ax = b$.
However, the matrix $A$ is tall and narrow, i.e. is of shape $m \times n$ with $m > n$,
and hence the resulting linear system is overdetermined and will not in general
be solvable.

Instead, we ask how to find
the vector $x$ that minimizes $\| Ax - b \|^2$. This is a particular kind of optimization
problem, but one which turns out to be completely solvable analytically.

We showed that the solution to this minimization problem is the unique vector
$x$ satisfying

$$A^T A x = A^T b$$

i.e. a linear system with the square matrix $A^T A$, called the **normal equations**.

We could solve this using elimination, but constructing $A^T A$ requires extra work,
and it turns out to make the conditioning of the problem worse and so lead to a loss
in accuracy.

Instead, we defined a **thin** QR factorization of $A$ and used that to show that
the solution to the original least squares problem is given by solving

$$R x = Q^T b$$

by backsubstitution.

This is what Julia's backslash operator does when given a tall, narrow matrix $A$.

## Lecture 23: The Singular-Value Decomposition (SVD)  (Apr 10)

We looked at a new matrix factorization (decomposition) of fundamental importance: the Singular-Value Decomposition (SVD).

We approached this by taking a matrix $A$ and asking what the image under $A$ is of a unit sphere in $\mathbb{R}^n$. If we plot it, we see that it looks like an ellipse, i.e. a sphere that is stretched and rotated.  

Associated with that ellipse are the lengths of its semi-axes, which we will call the **singular values**, $\sigma_i$, as well as their directions, the **left singular vectors** $\mathbf{u}_i$, which are orthonormal. Since these are clearly quantities of fundamental importance to describe the action of any matrix, we would like to calculate them.

We saw that we vectors $y$ in the image of the sphere satisfy $y^\top S y = 1$ with a real and **symmetric** matrix $S$. We recalled that symmetric matrices have all their eigenvalues real, and a complete basis of eigenvectors that are orthogonal.

We showed that this means that this means that $y = Q z$ with an orthogonal matrix $Q$, where $z$ is an axis-aligned ellipse, and where $Q$ are the eigenvectors of $S$. Thus the image of the unit sphere under $A$ is indeed an ellipse and we can calculate everything from the eigenvectors and eigenvalues of $S$.

In order to actually calculate these eigen-features, we saw that the **power iteration method** can be used: we start with a non-zero vector $v$ and repeatedly multiply it by $A$ to get $A^n v$, then normalize. The resulting sequence of vectors converges to the leading eigenvector of $A$.

If we instead use several initial vectors and apply $A^n$ to each one, these will all separately converge to the *same* eigenvector. To prevent this, we periodically re-orthogonalize, e.g. using Gram--Schmidt. In this way the $k$ vectors will converge to the $k$ leading eigenvectors.


## Lecture 24: Conditioning of linear systems and iterative methods (Apr 13)

We looked at the sensitivity of the problem "solve the linear system $Ax = b$" with respect to perturbations in the input $b$.

To do so, we need to be able to measure the size of perturbations, so we introduced norms of vectors and induced norms of matrices.

We saw that for the linear system, the resulting perturbation in the output $x$ involves the inverse matrix $A^{-1}$, and that the condition number of the problem ends up as being the product of the norms of $A$ and $A^{-1}$, which we defined as the condition number of the matrix. This means that even if the residual $b - Ax$ is small for a given approximate solution $x$, the forward error, i.e. the distance of $x$ from the true solution, may not be, since the condition number appears.

The 2-norm of $A^{-1}$ is given by the *smallest* singular value of $A$, so if this is small then the problem is ill-conditioned.

Then we discussed iterative methods for linear systems. We can think about rearranging the equation $Ax = b$ into a suitable form for a standard iterative method by **splitting** $A$ into, for example, $A = D + (A - D)$, where $D$ is the diagonal part. Then $D x_{n+1} = b - (A - D)x_n$ is an iterative method that will converge to the solution of $Ax = b$, *provided* that it converges at all. Since $D$ can be easily inverted, and the calculation is $O(n^2)$ instead of $O(n^3)$ for elimination methods, this can be a practical method for solving linear systems.

Finally we mentioned Krylov methods, which only require knowing how to calculate $A x$ for vectors $x$; it is not even necessary to know or store the matrix $A$. Forming the set of vectors $b, Ab, A^2b, \ldots, A^{k-1} b$ gives a **Krylov subspace** where we can look for solutions of the linear system.

## Lecture 25: Approximating functions - Fourier analysis (Apr 15)

We started the last part of the course, on how to approximate and manipulate functions as a whole.

We recalled two approaches that we have looked at so far: Taylor series work only locally, near a point; Lagrange interpolation was difficult to work with.
We commented that so far we have not said anything about periodic functions.

In this section of the course we will take a different approach: approximating a function $f$ by a linear combination of basis functions, $f = \sum_n f_n \phi_n$, where $f_n$ are numeric coefficients and $\phi_n$ are the basis functions. To do this we need an *infinite* number of basis functions. The basis functions here are playing the role of "vectors" in our linear algebra discussiones (where we only dealt with finite linear combinations).

We recalled that when we have a linear combination it is most useful if we can talk about **orthogonality**, since then we obtain a formula for $f_n$. We thus need to generalise the concept of dot product from the Euclidean context.

The necessary generalisation is that of **inner product**: the inner product of two complex functions $f$ and $g$ is $(f, g) := \int \bar{f} g(x) \, dx$. This is linear (or conjugate linear) in each component, and satisfies $(f, f) \ge 0$; this is the reason for introducing the complex conjugate. It is necessary since we want $\| f \|^2 := (f, f)$, and $\| f \|$ is a positive number measuring some kind of "length" or "size" of $f$.

Once we have an inner product, we define orthogonality by $(f, g) = 0$. Then we obtain $f_n = (f, \phi_n)$, up to a multiplicative constant (which depends on the normalization of the $\phi_n$).

As an example, we discussed Fourier series: a continuous, periodic function $f$ on the interval $[0, 2\pi)$ can be written $f(t) = \sum_n \hat{f}_n e^{int}$, so $f = \sum_{n=-\infty}^\infty \hat{f}_n \phi_n$ with basis functions $\phi_n := e^{i n t}$. We can see by a simple calculation that indeed these are orthogonal, $(\phi_n, \phi_m) = 0$ for $n \neq m$. The fact that *any* suitable function $f$ can be written in this way is a deep result that is an extension of the spectral theorem on the existence of orthogonal eigenvectors for symmetric matrices to apply to "compact self-adjoint operators" on the Hilbert space of $L^2$ functions on $[0, 2\pi)$.

We saw that if a function $f$ is differentiable then the $n$th Fourier coefficient of the derivative is just $i n$ times the $n$th Fourier coefficient of the original function. In this way we showed that if $f$ is $k$ times differentiable, its Fourier coefficients must decay at least as fast as $n^{-k}$ as $n \to \infty$. If in fact $f$ is analytic in a suitable region, then its coefficients decay *exponentially* fast; this is called **spectral convergence**.

Thus on a computer we can obtain a numerical approximation to an arbitrary continuous, periodic function $f$ to close to machine epsilon with relatively few Fourier modes.
