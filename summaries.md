# Summaries of lectures: 18.330 (spring 2021)

## Lecture 1: What is numerical analysis? (16 Feb)

We started off with course logistics and introducing ourselves.

Then we discussed what the phrase "numerical analysis" means. "Analysis" here refers to "mathematical analysis", i.e. calculus.
The subject deals with *continuous* objects, such as functions, derivatives, and solving differential equations defining models in science and engineering; this gives it a very different flavour from computer science, which usually deals with discrete objects.

We had breakout sessions in which we used as an example how to calculate the square root of a number. We saw that to do so we could drill down, by first finding an integer n such that n ≤ √x ≤ n+1, and then partitioning the interval [n, n+1] into 10 parts to get one decimal place, and then doing the same for the next decimal, etc.

This is an example of an **approximation algorithm**, where the goal is to calculate an approximation of the true solution within a given tolerance ϵ, for *any* value of ϵ. This is one of the main themes of the course.