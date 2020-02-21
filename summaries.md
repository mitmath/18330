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
