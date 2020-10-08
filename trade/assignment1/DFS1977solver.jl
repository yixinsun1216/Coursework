# Created by Yixin Sun on October 1st, 2020
# Three functions here: 
# 1. solver for discrete approximation of DFS: outputs z_star_bar, z_bar, omega_bar
# 2. calculate welfare in autarky and trade for Home and foreign: outputs
    # home_autarky, home_trade, foreign_autarky, foreign_trade
# 3. calculate volume of trade: outputs single number for volume of trade

# =============================================================================
# Solver function
# =============================================================================
function DFS1977solver(a::Array{Float64,2}, b::Array{Float64,1}, L::Array{Float64,1}, g::Float64)
    A_z = a[:,1] ./ a[:, 2]
    N = size(A_z, 1)

    # basic error checking ---------------------------------------------
    #1. check dimensions of a and b
    if size(a) != (N, 2)
        error("a must be an N by 2 array")
    elseif size(a, 1) != size(b, 1)
        error("a and b must be the same length")
    elseif size(b) != (N,)
        error("b must be an N by 1 array")
    elseif abs(sum(b) - 1) > 0.00001
        error("sum(b) must equal 1")
    end

    #2. Check that A is monotone decreasing
    A_diff = A_z[2:end] - A_z[1:end .!=N] 
    if sum(A_diff .> 0) > 0
        error("A = a[:,1]./a[:,2] must be monotone decreasing")
    end

    #3. verify g is scalar in (0, 1]
    if g <= 0 || g > 1
        error("g must be in (0, 1]")
    end

    # Solving for z_bar, z_bar_star, and omega_bar ----------------------
    lambda = cumsum(b)
    omega_all = zeros(N)
    z_star = zeros(N)
    for i in 1:N
        omega = A_z[i] / g 
        z = i 
        z_star_i = argmin(abs.(g .* A_z .- omega))
        omega_all[i] = lambda[z_star_i] ./ (1 .- lambda[z]) * (L[1]/L[2])
        z_star[i] = z_star_i
    end

    z_bar = argmin(abs.(A_z ./ g .- omega_all))
    omega_bar = A_z[z_bar] / g
    z_star_bar = convert(Int32, z_star[z_bar])
   
    return z_star_bar, z_bar, omega_bar
end

# =============================================================================
# Calculate Welfare
# =============================================================================
function DFS1977welfare(a::Array{Float64,2}, b::Array{Float64,1}, L::Array{Float64,1}, g::Float64)
    out = DFS1977solver(a, b, L, g)
    z_star_bar, z_bar = out[1:2]
    w = 1
    w_star = 1 / out[3]

    home = - b[1:z_bar]' * log.(a[1:z_bar, 2]) - 
        b[(z_bar+1):end]' * log.(a[(z_bar+1):end, 1] .* w_star/g)

    foreign = log(w_star) - 
        b[z_star_bar:end]'*log.(a[z_star_bar:end, 1] .* w_star) - 
        b[1:(z_star_bar-1)]'*log.(a[1:z_star_bar-1,2]/g)

    # welfare in autarky
    home_a = log(w) - b'*log.(a[:,2])
    foreign_a = log(w_star) - b'*log.(w_star .* a[:,1])

    return home_a, home, foreign_a, foreign
end

# =============================================================================
# Trade Volume
# =============================================================================
function DFS1977volume(a::Array{Float64,2}, b::Array{Float64,1}, L::Array{Float64,1}, g::Float64)
    out = DFS1977solver(a, b, L, g)
    z_star_bar, z_bar = out[1:2]
    w_star = 1/out[3]

    exports = sum(b[1:z_star_bar]*w_star*L[1]) / g
    imports = sum(b[z_bar:end]*L[2]) / g
    volume = exports + imports

    return volume
end