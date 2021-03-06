# Created by Yixin Sun on October 1st, 2020
# This file calls the DFS1977solver.jl file and formats the output from 
# the functions in taht file

using DataFrames
using Plots
using DelimitedFiles
using LaTeXStrings
using Latexify
using Pipe


odir = "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/trade/assignment1"
ddir = "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/field_courses/International Macro and Trade/Assignments/assignment1"

# Define Variables
a = readdlm(join([ddir, "DFS1977_example_a.txt"], "/"))
b = convert(Array{Float64, 1}, vec(readdlm(join([ddir, "DFS1977_example_b.txt"], "/"))))

A_z = a[:,1] ./ a[:, 2]
L = [1.0, 1.0]
g = 0.9

# load DFS1977solver, DFS1977welfare, and DFS1977volume functions
include(joinpath(odir,"DFS1977solver.jl"))

# =============================================================================
# Plot A(z) and B(z; L*/L), the supply and demand curves that mimic DFS Fig. 1
# =============================================================================
B_z = cumsum(b) ./ (1 .- cumsum(b))
z = 1:length(A_z)

theme(:wong)
plot(z, B_z, ylim = (0, 20), xlim = (0, 140), xlabel = "z", ylabel = "ω", label = "B(z, L*/L)")  
plot!(z, A_z,  label = "A(z)")  
png(join([odir,"fig1.png"], "/"))

# =============================================================================
# Run and format output for DFS solver + welfare
# =============================================================================
output9 = DFS1977solver(a, b, L, 0.9)
output1 = DFS1977solver(a, b, L, 1.0)
eqm = DataFrame(Var = ["z^star", "z", "ω"], 
    g1 = round.(collect(output1), digits = 3),
    g9 = round.(collect(output9), digits= 3))

# output equilibrium values to latex
write(joinpath(odir,"equilibrium_values.tex"), latexify(eqm; env=:table))

output9_welfare = DFS1977welfare(a, b, L, 0.9)
output1_welfare = DFS1977welfare(a, b, L, 1.0)
welfare = DataFrame(Var = ["Home - Autarky", "Home - Trade", 
                           "Foreign - Autarky", "Foreign - Trade"], 
    g1 = round.(collect(output1_welfare), digits = 3), 
    g9 = round.(collect(output9_welfare), digits = 3))

write(joinpath(odir,"welfare.tex"), latexify(welfare; env=:table))

# uniform technical progress for Foreign
# a2 = hcat(a[:,1] ./ 2, a[:,2])
# DFS1977solver(a2, b, L, g)

# =============================================================================
# Volume and Gains from Trade - changing b around
# =============================================================================
# Fix L*/L = 1 and g = 0.9

# Economy 1 - Original Economy
volume = DFS1977volume(a, b, L, g)
gft_h = output9_welfare[2] - output9_welfare[1]
gft_f = output9_welfare[4] - output9_welfare[3]

# concatenate eqm, welfare, volume, and gains from trade together
econ1 = round.(vcat(collect(output9), volume, gft_h, gft_f), digits = 3) 

# Change b around --------------------------------------------------
b2 = vcat(b[1:120], b[121:end]*1.313)
b2 = b2 / sum(b2)
econ2_welfare = DFS1977welfare(a, b2, L, g)
gft_h2 = econ2_welfare[2] - econ2_welfare[1]
gft_f2 = econ2_welfare[4] - econ2_welfare[3]
econ2 = round.(vcat(collect(DFS1977solver(a, b2, L, g)), 
    collect(DFS1977volume(a, b2, L, g)),
    gft_h2, gft_f2), digits = 3)

# change b around again--------------------------------------------
b3 = vcat(b[1:50]*1.3, b[51:end])
b3 = b3 / sum(b3)
econ3_welfare = DFS1977welfare(a, b3, L, g)
gft_h3 = econ3_welfare[2] - econ3_welfare[1]
gft_f3 = econ3_welfare[4] - econ3_welfare[3]
econ3 = round.(vcat(collect(DFS1977solver(a, b3, L, g)), 
    collect(DFS1977volume(a, b3, L, g)),
    gft_h3, gft_f3), digits = 3)

# output table comparing the 3 economies with different b
economies = DataFrame(Var = ["z", "z^star", "ω", "Volume", "Gains - Home", "Gains - Foreign"], 
    Economy1 = econ1, Economy2 = econ2, Economy3 = econ3)

write(joinpath(odir,"b_economies.tex"), latexify(economies; env=:table))


# =============================================================================
# Volume and Gains from Trade - changing b around
# =============================================================================
# attempt to change a around, holding b fixed - big fail! 
coef = 0.5:0.01:2
coef = setdiff(coef, [1])
a1 = a[:,1]
V_diff = zeros(length(coef))
for i in 1:length(coef)
    a2 = hcat(a[:,1] .* coef[i], a[:,2])
    V_diff[i] = abs(volume - DFS1977volume(a2, b, L, g)) < .001
end
findall(x -> x == 1, V_diff)  # can't find any values!!!

# let's create some economies for different a's that generate different volumes
# to analyze relationship between volume and gains from trade
# uniform increase in Foreign tech
a2 = hcat(a[:,1] .* 1.5, a[:,2])
econ4_welfare = DFS1977welfare(a2, b, L, g)
gft_h4 = econ4_welfare[2] - econ4_welfare[1]
gft_f4 = econ4_welfare[4] - econ4_welfare[3]
econ4 = round.(vcat(collect(DFS1977solver(a2, b, L, g)), 
    collect(DFS1977volume(a2, b, L, g)),
    gft_h4, gft_f4), digits = 3)

# uniform increase in Home teceh
a3 = hcat(a[:,1] , a[:,2]*1.5)
econ5_welfare = DFS1977welfare(a3, b, L, g)
gft_h5 = econ5_welfare[2] - econ5_welfare[1]
gft_f5 = econ5_welfare[4] - econ5_welfare[3]
econ5 = round.(vcat(collect(DFS1977solver(a3, b, L, g)), 
    collect(DFS1977volume(a3, b, L, g)),
    gft_h5, gft_f5), digits = 3)

economies_a = DataFrame(Var = ["z", "z^star", "ω", "Volume", "Gains - Home", "Gains - Foreign"], 
    Economy1 = econ1, Economy4 = econ4, Economy5 = econ5)

write(joinpath(odir,"a_economies.tex"), latexify(economies_a; env=:table))


N = 150; G_amt = 10; gain_param = 1.1
a1 =hcat(ones(N,1), [ gain_param .+ 0.05*randn(G_amt); 0.5*[x/(N-G_amt) for x in 1:(N-G_amt)] .+ 0.55*ones(N-G_amt,1) ]);
a1[:,2] = sort(a1[:,2])

gain_param = 4
a2 =hcat(ones(N,1), [ gain_param .+ 0.05*randn(G_amt); 0.5*[x/(N-G_amt) for x in 1:(N-G_amt)] .+ 0.55*ones(N-G_amt,1) ]);
a2[:,2] = sort(a2[:,2])

DFS1977volume(a1, b, L, g)
DFS1977solver(a1, b, L, g)

DFS1977volume(a2, b, L, g)
DFS1977solver(a2, b, L, g)