# Summaries of lectures: 18.330 (spring 2021)

## Lecture 1: What is numerical analysis? (16 Feb)

We started off with course logistics and introducing ourselves.

Then we discussed what the phrase "numerical analysis" means. "Analysis" here refers to "mathematical analysis", i.e. calculus.
The subject deals with *continuous* objects, such as functions, derivatives, and solving differential equations defining models in science and engineering; this gives it a very different flavour from computer science, which usually deals with discrete objects.

We had breakout sessions in which we used as an example how to calculate the square root of a number. We saw that to do so we could drill down, by first finding an integer n such that n ≤ √x ≤ n+1, and then partitioning the interval [n, n+1] into 10 parts to get one decimal place, and then doing the same for the next decimal, etc.

This is an example of an **approximation algorithm**, where the goal is to calculate an approximation of the true solution within a given tolerance ϵ, for *any* value of ϵ. This is one of the main themes of the course.


## Lecture 2: Representing numbers (18 Feb)

We started off by looking at how to represent Booleans and integers in the computer, using a binary representation.
But we noticed that the way that negative integers is represented is surprising ("two's complement").

We saw that the usual integers in Julia have a fixed size (for performance reasons), and that they have a certain "overflow" behaviour when you exceed the range that can be represented. We can get round this using the `BigInt` big integers (which can be of any size), but they are slow and can take up a lot of memory.

Then we thought about how to represent rational and complex numbers. We would like to represent these using a pair (a, b) of integers.
But when we add or multiply these, the rules that we need to use will depend whether we have rationals or complexes.

This led us to the idea of defining a new *type*, which we do in Julia using `struct`. This enables us to group together
data (variables) that belong together into a new object, and then define how to operate on objects of that type.

We asked if we could get away with using rational numbers for scientific computations, but we saw that the number of digits in them
rapidly balloons as soon as we start doing many operations, so that is not a good idea. This leads on to seeing how to represent real numbers
in the next lecture.

## Lecture 3: Representing real numbers (25 Feb)

We started by thinking of real numbers as infinite decimal expansions.

Then we looked at **fixed-point numbers**, where we represent a real number as an integer with an implicit, fixed
decimal point (or, in general, "radix point" when using a different base, or radix, such as binary).

However, fixed-point numbers to not allow us to represent a wide *range* of numbers. So we allowed the decimal / binary point to
*move*, or **float**. This is done by multiplying by a power of the base.

This means that spacing between consecutive floating-point numbers is equal for a while, until we hit the next power of 2, when the spacing is multiplied by 2. This, in turn, means that we have less absolute precision, but the same relative precision (number of significant figures) when representing larger numbers.

We saw that decimal numbers like $0.1$ cannot be represented exactly in binary, so they are *round*ed to the nearest representable floating-point number.

## Lecture 4: Computing functions (27 Feb)

We started off by finishing a couple of remaining topics from the slides from last time on floating-point arithmetic: how to use `BigFloat`s to perform calculations with higher precision, special values `Inf` for numbers that are too big, and `NaN` ("not a number") for results of meaningless calculations like `0 / 0`.

Then we started to discuss how to compute *functions*, which form the foundation of the course (and of mathematics).

We discussed the difference between the mathematical idea of a function, as an association between values in a domain and a codomain, and the computer science version of a function, also called a subroutine. 

The computer science version makes us view a function as an **algorithm**, consisting of a sequence of steps making up a computation (sometimes called a "computational graph"). Julia allows us to see this in action using macros like `@code_typed`.

We then discussed how we could try to compute an elementary function like `exp(x)` on an input `x`. Since the exponential function is defined by an *infinite* power series we can never hope to compute the exact value, but by taking ever more terms we should be able to get arbitrarily close, giving an approximation algorithm for the function, which is hence **computable**.

The approximation obtained by taking only a finite number of terms is a **polynomial**. Polynomials are really the only functions that we can compute, using just `+` and `*` operations. We saw that polynomials can in principle approximate any (continuous) function arbitrarily closely; the problem then becomes *how to compute* such an approximation, a subject that will recur throughout the course, especially in the second half.

## Lecture 5: Taylor series and equation solving (Mar 2)

We began with a reminder about Taylor series approximations for smooth functions.
These give you an infinite series for $f(a + h)$ near a point $a$ in powers of $h$.

We recalled the Lagrange form of the remainder, which gives an expression for the remainder
of a series after truncating it at $N$ terms, but with the feature that it depends on evaluating
the $(N+1)$th derivative at an *unknown* point $\xi$. We then saw how to use that to give
an *upper bound* on the error of the polynomial approximation over a *finite* interval.

We moved on to discussing how to solve equations, which is equivalent to finding *roots* or *zeros*
of a function. We reminded that the Fundamental Theorem of Algebra tells us that a polynomial of
degree $n$ always has exactly $n$ roots in the complex plane (although some of them may be multiple roots).

We then saw how to use Pluto to interactively visualize the Fundamental Theorem by sweeping through circles
and calculating their image under a polynomial map.


## Lecture 6: Root finding using iterative methods (Mar 4)

We started off by formulating root-finding as a problem, where the input is a *function*.

Some algorithms to solve a problem have the property that given an input that approximately solves the problem, the output is a *better* approximation to the problem. In that case we can use the output as a new input to get an *even better* solution. By **iterating** this process we get a sequence of ever better solutions.

As an example we looked at the sequence generated by repeatedly applying the cosine function to an input value, and visually saw that this iteration *converges* to a *limiting value*. *If* an iteration $x_{n+1} = g(x_n)}$ converges to a limit $x^*$ and $g$ is a continuous function then $x^*$ is a solution of the equation $x = g(x)$. However, a general iteration is *not* guaranteed to converge.

We then looked at whether an iteration will converge if we start near a fixed point. We also looked at this computationally by plotting.


## Lecture 7: Root finding II &ndash; the Newton method (Mar 11)

We started off by reviewing the ideas about convergence from last lecture, in particular in terms of how using different configurations of logarithmic axes and looking for straight lines gives suggestions about how the data behaves.

An important question is how to *design* an iterative method to solve a given problem, e.g. to find a root of a function f, i.e. an x* such that 
f(x*) = 0.

We looked at cobweb diagrams as a way of visualising iterations and saw how the derivative condition for stability of a fixed point manifests in a geometrical way. This leads to the idea that we should look for an iteration g(x) = x + ϕ(x) f(x) for some function ϕ. If we also impose that  g'(x*) = 0 then we are led to the **Newton method**, x_{n+1} = x_n - f(x_n) / f'(x_n).

This method converges very fast when we are "sufficiently close" to a fixed point, but may behave badly when we are not.
