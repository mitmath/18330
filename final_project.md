# 18.330 Final project (spring 2020)

## Deadlines
The final project is due on May 12th 2020 @ 10pm EDT.
There will be no problem sets for the final 2 weeks of class; that time should be used to work on your final project, but you are encouraged to start working on it now.

Please submit a 1-page project proposal by Sunday April 12th @ 11:59pm EDT.

Alasdair and I will be available to help with technical questions you may have about the content of the project, coding in Julia etc.



## Project content

The project must be individual. You will explore a topic in numerical analysis that we have not covered in class, but that is at the same level of difficulty as the material we have seen in class.

The project write-up must include the following, at the level of the class:

1. A discussion of the mathematics behind the method.

2. A discussion of error analysis in the method.

3. Your own implementation in Julia.

4. A numerical investigation of the error.

5. A numerical investigation of how the time taken scales with the size of the system studied.

6. Visualizations of the solutions and the errors, including interactive visualizations where appropriate.

7. At least 3 relevant references.

You may include an application, e.g. to physics or economics, but that is *not* the goal of the project. The emphasis is on the numerical analysis (design and implementation of an algorithm and error analysis). Neither is the goal the mathematical object *per se*. The goal is to use the computer to numerically compute mathematical objects.

## References and citations

You may quote small pieces of text from references only if you include an explicit citation, e.g. "in the reference [3] we find the following statement:". Put a numbered list of all references at the end of the document.

If we covered something in class you may just say "as we saw in class..."

You should compare and contrast presentations of the material in at least 2 different references and comment on the differences or similarities.


## Project write-up

The write-up should be in the format of a Jupyter notebook, aimed at explaining the topic to the other students in the class. You should *briefly* recall any relevant topic from the class and relate it to your topic.

Optionally you may separate out the code into a separate `.jl` file that you `include` into the notebook.

You should also submit a PDF version, making sure that it is complete.

Any mathematics required that is beyond the level of the class should be stated but not discussed in detail. For example, you should state the relevant theorems and comment on how they relate to the method, with references.

## Some possible final project topics

These are some *examples* of possible topics.
You should browse through books such as *Numerical Recipes* to get more ideas and pick a topic that you find *interesting* or *surprising*.

Think about what you have enjoyed in the course so far and pick something similar to that. 

- Acceleration of sequence convergence (e.g. Richardson extrapolation, Anderson acceleration)

- Additional root-finding methods (e.g. Steffensen's method)

- Optimization (e.g. conjugate gradients, augmented lagrangians)

- Numerical integration (additional methods, contour integration in the complex plane, oscillatory functions, adaptive integration)

- Numerical linear algebra (topics not covered in course, especially related to sparse matrices or structured matrices)

- ODEs (multistep methods)

- Interpolation (spline methods, trigonometric interpolation)

- Boundary-value problems for ODEs
