# Lecture 1

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
