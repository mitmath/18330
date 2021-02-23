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
