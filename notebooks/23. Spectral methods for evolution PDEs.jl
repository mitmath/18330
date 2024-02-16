### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ d1905497-4db0-4c83-ba26-8072440bd9d3
begin
	using FFTW
	using Plots
	using PlutoUI
	using LinearAlgebra
end

# ╔═╡ ced9cc0e-886b-4ca4-a1ed-094d63b3225f
md"""
# Spectral methods in Julia

## David P. Sanders
"""

# ╔═╡ 7cc56dc0-46d8-4f4c-88d0-f3d817676465
md"""
In this notebook we use Fourier spectral methods to solve a nonlinear *partial* differential equation (PDE) evolving in time on a periodic 1-dimensional domain.

This notebook was adapted from [Benchmarking Julia on a PDE: the Kuramoto-Sivashinksy equation](https://github.com/johnfgibson/julia-pde-benchmark/blob/master/1-Kuramoto-Sivashinksy-benchmark.ipynb), by John F. Gibson, Department of Mathematics and Statistics, University of New Hampshire.
"""

# ╔═╡ 1b1d083e-bc85-465b-ac7e-c9eaa4273dd3
md"""
## The Kuramoto--Sivashinsky (KS) equation
"""

# ╔═╡ 8906f365-50da-45e0-980c-176a9990df00
md"""
The Kuramoto--Sivashinsky (KS) equation is a nonlinear partial differential equation (PDE) modelling the time evolution of a concentration $u(t, x)$ on a 1D spatial domain:

$$u_t = -u u_{x} - u_{xx} - u_{xxxx}.$$


Here, $x$ is space, $t$ is time, and subscripts indicate differentiation. We will take a spatial domain $x \in [0, L_x]$ with **periodic** boundary conditions.
"""

# ╔═╡ 31748b9f-db49-451d-9153-c12d4d5fc4f6
md"""
### Numerical method: CNAB2 algorithm

The CNAB2 algorithm is a **spectral** numerical integration scheme for the KS equation. It uses a finite Fourier expansion in space, a collocation calculation of the nonlinear term $u u_x$, and finite-differencing in time, specifically 2nd-order Crank--Nicolson Adams--Bashforth (CNAB2) timestepping. CNAB2 is low-order, but straightforward to describe and easy to implement for this simple benchmark.
"""

# ╔═╡ 29390611-0ef2-4eeb-a5c0-b865f304fd9c
md"""
$\newcommand{\LL}{\mathcal{L}}$
$\renewcommand{\NN}{\mathcal{N}}$
"""

# ╔═╡ 3cfe27e4-4617-4c4f-a6a2-9537d3ff255f
md"""
We write the KS equation as 

"""

# ╔═╡ 35b691e1-9dbc-4999-9f41-88d84876849f
md"""

$$u_t = \LL u + \NN(u),$$


where $\LL u := - u_{xx} - u_{xxxx}$ are the linear terms 
and $\NN(u) := -u u_{x}$ is the nonlinear term. In practice we  use the equivalent form $\NN(u) = - \frac{1}{2} \frac{d}{dx}  u^2$. 
"""

# ╔═╡ d079fc3e-c261-45a6-8670-aa7151e41221
md"""
#### Time discretization

Discretize time by letting $u^n(x) := u(x, n\Delta t)$ for some small $\Delta t$. The CNAB2 time-stepping formula approximates  $u_t = \LL u + \NN(u)$ at time $t = n+ \frac{1}{2} dt$ as 

$$\frac{u^{n+1} - u^n}{\Delta t} = \textstyle \frac{1}{2} \LL\left(u^{n+1} + u^n\right) + \frac{3}{2} \NN(u^n) - \frac{1}{2} \NN(u^{n-1}).$$
"""

# ╔═╡ 80ac7bd9-363f-49df-b204-133f54dd1b65
md"""
Put the unknown future $u^{n+1}$'s on the left-hand side of the equation and the present $u^{n}$ and past $u^{n+1}$ on the right:

$$\textstyle
\left(I  - \frac{\Delta t}{2} \LL \right) u^{n+1} = \left(I  + \frac{\Delta t}{2} \LL \right) u^{n} + \frac{3 \Delta t}{2} \NN(u^n) - \frac{\Delta t}{2} \NN(u^{n-1}).$$

Note that the linear operator $\LL$ applies to the unknown $u^{n+1}$ on the LHS, but that the nonlinear operator $\NN$ applies only to the knowns $u^n$ and $u^{n-1}$ on the RHS. This is an *implicit* treatment of the linear terms, which keeps the algorithm stable for large time steps, and an *explicit* treament of the nonlinear term, which makes the time-stepping equation linear in the unknown $u^{n+1}$.
"""

# ╔═╡ 0c15a8bb-67a0-4123-a871-f8fd5dd33d0b
md"""
#### Space discretization 

Now we discretize space with a finite Fourier expansion, so that $\hat{u}$ represents a vector of Fourier coefficients of $u$. Thus $\LL$ becomes a matrix -- in fact, a diagonal matrix, since Fourier modes are eigenfunctions of the linear operator. 


Define $A := (I - \frac{\Delta t}{2} \LL)$, and $B := I + \frac{\Delta t}{2} \LL$, and let the vector $N^n$ be the Fourier transform of a collocation calculation of $\NN(u^n)$. That is, $N^n$ is the Fourier transform of $- u u_x = - \frac{1}{2} \frac{d}{dx} u^2$ calculated at $N_x$ uniformly-spaced grid points on the domain $[0, L_x]$. 

With the spatial discretization, the CNAB2 time-stepping formula becomes 

$$
\textstyle A \, \hat{u}^{n+1} = B \, \hat{u}^n + \frac{3 \Delta t}{2} N^n -  \frac{\Delta t}{2}N^{n-1}.$$

This is a simple $Ax=b$ linear algebra problem whose iteration approximates the time-evolution of the Kuramoto--Sivashinksy PDE. 
"""

# ╔═╡ 28222c2f-3eac-4be0-937a-962072122717
md"""
## Julia implementation of the CNAB2 algorithm

"""

# ╔═╡ c3a8cdb6-a30a-495c-87ea-0a2f5de50516
md"""
### Original version: Translation from MATLAB by John F. Gibson
"""

# ╔═╡ 6eb15a6b-c4f9-4e43-a43d-ec951b8f87d5
function ksintegrateNaive(u, Lx, dt, Nt, nsave)
    
    Nx = length(u)                  # number of gridpoints
    x = collect(0:(Nx-1)/Nx)*Lx
    kx = vcat(0:Nx/2-1, 0, -Nx/2+1:-1)  # integer wavenumbers: exp(2*pi*kx*x/L)
    alpha = 2*pi*kx/Lx              # real wavenumbers:    exp(alpha*x)
    D = 1im*alpha;                  # D = d/dx operator in Fourier space
    L = alpha.^2 - alpha.^4         # linear operator -D^2 - D^4 in Fourier space
    G = -0.5*D                      # -1/2 D operator in Fourier space
    
    Nsave = div(Nt, nsave)+1        # number of saved time steps, including t=0
    t = (0:Nsave)*(dt*nsave)        # t timesteps
    U = zeros(Nsave, Nx)            # matrix of u(xⱼ, tᵢ) values
    U[1,:] = u                      # assign initial condition to U
    s = 2                           # counter for saved data
    
    # Express PDE as u_t = Lu + N(u), L is linear part, N nonlinear part.
    # Then Crank-Nicolson Adams-Bashforth discretization is 
    # 
    # (I - dt/2 L) u^{n+1} = (I + dt/2 L) u^n + 3dt/2 N^n - dt/2 N^{n-1}
    #
    # let A = (I - dt/2 L) 
    #     B = (I + dt/2 L), then the CNAB timestep formula is
    # 
    # u^{n+1} = A^{-1} (B u^n + 3dt/2 N^n - dt/2 N^{n-1}) 

    # convenience variables
    dt2  = dt/2
    dt32 = 3*dt/2;
    A_inv = (ones(Nx) - dt2*L).^(-1)
    B     =  ones(Nx) + dt2*L

    Nn  = G.*fft(u.*u) # -u u_x (spectral), notation Nn = N^n     = N(u(n dt))
    Nn1 = copy(Nn)     #                   notation Nn1 = N^{n-1} = N(u((n-1) dt))
    u  = fft(u)        # transform u to spectral

    # timestepping loop
    for n = 1:Nt
        Nn1 = copy(Nn)                 # shift nonlinear term in time: N^{n-1} <- N^n
        Nn  = G.*fft(real(ifft(u)).^2) # compute Nn = -u u_x

        u = A_inv .* (B .* u + dt32*Nn - dt2*Nn1)
        
        if mod(n, nsave) == 0
            U[s,:] = real(ifft(u))
            s += 1            
        end
    end

    t,U
end

# ╔═╡ 968c059a-7158-4324-b335-b56cb082db30
md"""
### Run the Julia code and plot results
"""

# ╔═╡ 4a49ba4e-1323-4900-8875-e29e2d17cf5e
begin
	Lx = 64*pi
	Nx = 1024
	dt = 1/16
	nsave = 8
	Nt = 3200
	
	x = Lx .* (0:Nx-1) ./ Nx
	u = cos.(x) + 0.1*sin.(x/8) + 0.01*cos.((2*pi/Lx)*x);
	t, U = ksintegrateNaive(u, Lx, dt, Nt, nsave)
end

# ╔═╡ baeafd17-131a-4bad-af1e-7e53c87d85e8
length(t)

# ╔═╡ 1379d762-a257-4cdf-a3c6-83ac50433f52
size(U)

# ╔═╡ 57a1b0c4-1e5e-4790-8d6e-9d3287a71e5c
begin
	heatmap(x, t[1:size(U, 1)], U, xlim=(x[1], x[end]), ylim=(t[1], t[end]), fillcolor=:bluesreds)
	plot!(xlabel="x", ylabel="t", title="Kuramoto-Sivashinsky dynamics")
end

# ╔═╡ f6babb2b-eac4-4932-aff0-1e7c781dbc44
md"""
$u_{xx}$ -- when we Fourier transform

$F(u_{xx})_k = -k^2 \hat{u}_k$
"""

# ╔═╡ 740e6af4-357f-4547-9efb-c7f32659e4de
md"""
## Version with more Julia features
"""

# ╔═╡ 02415a4a-0122-4593-b7fb-eb0f22f6205b
function KS_integrate(u, Lx, dt, Nt, nsave)
    
    Nx = length(u)                  # number of gridpoints
    x = [j * (Lx / Nx) for j in 0:Nx-1]
    kx = [0:(Nx/2 - 1); 0; (-Nx/2 + 1):-1]  # integer wavenumbers: exp(2*pi*kx*x/L)
    α = (2π / Lx) .* kx              # real wavenumbers:    exp(alpha*x)
    
    D = Diagonal(im .* α);                  # D = d/dx operator in Fourier space
    L = -D^2 - D^4              # linear operator -D^2 - D^4 in Fourier space
    G = -0.5 * D                      # -1/2 D operator in Fourier space
    
    Nsave = div(Nt, nsave)+1        # number of saved time steps, including t=0
    t = (0:Nsave)*(dt*nsave)        # t timesteps
    
    U = zeros(Nsave, Nx)            # matrix of u(xⱼ, tᵢ) values
    U[1, :] = u                      # assign initial condition to U
    s = 2                           # counter for saved data
    
    # Express PDE as u_t = Lu + N(u), L is linear part, N nonlinear part.
    # Then Crank-Nicolson Adams-Bashforth discretization is 
    # 
    # (I - dt/2 L) u^{n+1} = (I + dt/2 L) u^n + 3dt/2 N^n - dt/2 N^{n-1}
    #
    # let A = (I - dt/2 L) 
    #     B = (I + dt/2 L), then the CNAB timestep formula is
    # 
    # u^{n+1} = A^{-1} (B u^n + 3dt/2 N^n - dt/2 N^{n-1}) 

    # convenience variables
    
    A = I - (dt/2) * L
    B = I + (dt/2) * L

    Nn  = G * fft(u .* u) # -u u_x (spectral), notation Nn = N^n     = N(u(n dt))
    Nn1 = copy(Nn)     #                   notation Nn1 = N^{n-1} = N(u((n-1) dt))
    û  = fft(u)        # transform u to spectral

    # timestepping loop
    for n = 1:Nt
        Nn1 = copy(Nn)                 # shift nonlinear term in time: N^{n-1} <- N^n
        Nn  = G * fft(real(ifft(û)).^2) # compute Nn = -u u_x

        û = A \ (B * û + (dt/2)*(3*Nn - Nn1))
        
        if mod(n, nsave) == 0
            U[s, :] = real(ifft(û))
            s += 1            
        end
    end

    return t, U
end

# ╔═╡ a7f0b3d4-0c44-4c45-a037-2e4600380ae8
let
	Lx = 64*pi
	Nx = 1024
	dt = 1/16
	nsave = 8
	Nt = 3200
	
	x = Lx*(0:Nx-1)/Nx
	u = cos.(x) + 0.1*sin.(x/8) + 0.01*cos.((2*pi/Lx)*x);
	@time t, U = KS_integrate(u, Lx, dt, Nt, nsave)

	heatmap(x, t[1:size(U, 1)], U, xlim=(x[1], x[end]), ylim=(t[1], t[end]), fillcolor=:bluesreds)
	plot!(xlabel="x", ylabel="t", title="Kuramoto-Sivashinsky dynamics")
end


# ╔═╡ ab2b9de4-57bb-456d-a862-9b926683bc61
md"""
## Version allowing us to modify the equation to be solved
"""

# ╔═╡ f900ad22-cbc2-4769-825f-eeebd96aa486
md"""
Split the nonlinear part into two parts: a function $N_1$ applied pointwise to $u$,
and a spatial derivative operator $N_2$ applied to the result.

For example, to express $-0.5 u u_x = -0.5 (d/dx)(u^2)$, we put $N_1(x) = u^2$ and $N2(D) = -0.5 * D$, where $D$ is the differential operator.
"""

# ╔═╡ 4d4be706-74a3-454a-8b91-500e00fc7164
"""
Integrate a 1D time evolution PDE
``u_t = Lu + N(u)``
on a periodic domain.
where ``L(D)`` is the linear part as a function of the derivative
operator ``D``, expressed in terms of the derivative operator ``D``,
and ``N1`` and ``N2`` give the nonlinear part.
"""
function integrate_1D_evolution_PDE(u₀, L, N1, N2, Lx, dt, Nt, nsave)
    
    Nx = length(u₀)                  # number of grid points
    x = [j * (Lx / Nx) for j in 0:Nx-1]  # grid points
    kx = [0:(Nx/2 - 1); 0; (-Nx/2 + 1):-1]  # integer wavenumbers: exp(2π*kx*x/L)
    α = (2π / Lx) .* kx              # real wavenumbers:    exp(alpha*x)
    
    D = Diagonal(im .* α);      # D = d/dx operator in Fourier space multiplies by wavenumber
    LL = L(D)                   # linear operator in Fourier space
    
    Nsave = div(Nt, nsave)+1        # number of saved time steps, including t=0
    t = (0:Nsave)*(dt*nsave)        # t timesteps
    
    U = zeros(Nsave, Nx)            # matrix of u(xⱼ, tᵢ) values
    U[1, :] = u₀                      # assign initial condition to U
    s = 2                           # counter for saved data
    
    G = N2(D)  # differential operator for nonlinear part
    
    # convenience variables:
    A = I - (dt/2) * LL
    B = I + (dt/2) * LL

    Nn  = G * fft(N1.(u₀)) # N(u) (spectral), notation Nn = N^n     = N(u(n dt))
    Nn1 = copy(Nn)     #                   notation Nn1 = N^{n-1} = N(u((n-1) dt))
    û  = fft(u₀)        # transform u to spectral

    # time-stepping loop
    for n = 1:Nt
        Nn1 = copy(Nn)                 # shift nonlinear term in time: N^{n-1} <- N^n

        u = real(ifft(û))
        nonlin = N1.(u)
        Nn  = G * fft(nonlin)
        
        û = A \ (B * û + (dt/2)*(3*Nn - Nn1))  # CNAB2
        
        if mod(n, nsave) == 0
            U[s, :] = real(ifft(û))
            s += 1            
        end
    end

    return t, U
end

# ╔═╡ 0ff107df-e7c4-4616-a12b-12e7eb589214
md"""
KS equation again:
"""

# ╔═╡ 23cf7550-698b-44fc-96ab-ade3bea9630c
let
	
	N1(u) = u^2
	N2(D) = -0.5*D

	L(D) = -D^2 - D^4
	
	Lx = 64*pi
	Nx = 1024
	dt = 1/16
	nsave = 8
	Nt = 3200

	x = Lx*(0:Nx-1)/Nx
	u0 = cos.(x) + 0.1*sin.(x/8) + 0.01*cos.((2*pi/Lx)*x);

	@time t, U = integrate_1D_evolution_PDE(u0, L, N1, N2, Lx, dt, Nt, nsave)


	heatmap(x, t[1:size(U, 1)], U, xlim=(x[1], x[end]), ylim=(t[1], t[end]), fillcolor=:bluesreds)
	plot!(xlabel="x", ylabel="t", title="Kuramoto-Sivashinsky dynamics")
end

# ╔═╡ 689dc068-9ab3-4dcf-b903-f216887fd8d4
md"""
## Fisher--Kolmogorov PDE
"""

# ╔═╡ e65dfcd7-3d9a-4c07-9656-d5da93c60798
md"""
$u_t = u_{xx} + u(1 - u)$
"""

# ╔═╡ 88b86888-a512-427c-a1e6-7edfef312828
let
	N1(u) = 0 # u * (1-u)
	N2(D) = I  # no derivative in nonlinear term, so just use the identity

	L(D) = D^2

	Lx = 64π
	Nx = 1024
	dt = 0.01
	nsave = 100
	Nt = 10000

	x = Lx*(0:Nx-1)/Nx
	u0 = zeros(Nx)
	u0[1:10] .= 1

	@time t, U = integrate_1D_evolution_PDE(u0, L, N1, N2, Lx, dt, Nt, nsave)
	
	n = 1000
	
	# heatmap(x, t[1:n], U[1:n, :], xlim=(x[1], x[end]), ylim=(t[1], t[end]), fillcolor=:bluesreds)
	# plot!(xlabel="x", ylabel="t")
	
	heatmap(U)
	
end

# ╔═╡ e728f4ba-79aa-4c28-88c7-cbb5e55a2ea9


# ╔═╡ Cell order:
# ╠═d1905497-4db0-4c83-ba26-8072440bd9d3
# ╟─ced9cc0e-886b-4ca4-a1ed-094d63b3225f
# ╟─7cc56dc0-46d8-4f4c-88d0-f3d817676465
# ╟─1b1d083e-bc85-465b-ac7e-c9eaa4273dd3
# ╟─8906f365-50da-45e0-980c-176a9990df00
# ╟─31748b9f-db49-451d-9153-c12d4d5fc4f6
# ╟─29390611-0ef2-4eeb-a5c0-b865f304fd9c
# ╟─3cfe27e4-4617-4c4f-a6a2-9537d3ff255f
# ╟─35b691e1-9dbc-4999-9f41-88d84876849f
# ╟─d079fc3e-c261-45a6-8670-aa7151e41221
# ╟─80ac7bd9-363f-49df-b204-133f54dd1b65
# ╟─0c15a8bb-67a0-4123-a871-f8fd5dd33d0b
# ╟─28222c2f-3eac-4be0-937a-962072122717
# ╟─c3a8cdb6-a30a-495c-87ea-0a2f5de50516
# ╠═6eb15a6b-c4f9-4e43-a43d-ec951b8f87d5
# ╟─968c059a-7158-4324-b335-b56cb082db30
# ╠═4a49ba4e-1323-4900-8875-e29e2d17cf5e
# ╠═baeafd17-131a-4bad-af1e-7e53c87d85e8
# ╠═1379d762-a257-4cdf-a3c6-83ac50433f52
# ╠═57a1b0c4-1e5e-4790-8d6e-9d3287a71e5c
# ╟─f6babb2b-eac4-4932-aff0-1e7c781dbc44
# ╠═740e6af4-357f-4547-9efb-c7f32659e4de
# ╠═02415a4a-0122-4593-b7fb-eb0f22f6205b
# ╠═a7f0b3d4-0c44-4c45-a037-2e4600380ae8
# ╟─ab2b9de4-57bb-456d-a862-9b926683bc61
# ╟─f900ad22-cbc2-4769-825f-eeebd96aa486
# ╠═4d4be706-74a3-454a-8b91-500e00fc7164
# ╟─0ff107df-e7c4-4616-a12b-12e7eb589214
# ╠═23cf7550-698b-44fc-96ab-ade3bea9630c
# ╟─689dc068-9ab3-4dcf-b903-f216887fd8d4
# ╟─e65dfcd7-3d9a-4c07-9656-d5da93c60798
# ╠═88b86888-a512-427c-a1e6-7edfef312828
# ╠═e728f4ba-79aa-4c28-88c7-cbb5e55a2ea9
