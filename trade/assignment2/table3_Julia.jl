## Created by Yixin Sun on October 19th, 2020
using StatFiles, DataFrames, Query, FixedEffectModels RegressionTables CSV

# Set up file paths
if splitdir(homedir())[end] == "Yixin Sun" 
    ddir =  "C:/Users/Yixin Sun/Dropbox/Coursework/field_courses/International Macro and Trade/Assignments/assignment2"
    gdir = "C:/Users/Yixin Sun/Dropbox/Coursework/Coursework/trade/assignment2"
    cd(ddir) 
end

# Load in data and shape ---------------------------------
grav = DataFrame(load("col_regfile09.dta"))
grav = grav |> 
    @select(:flow, :distw, :iso_o, :iso_d, :year, :contig, :comlang_off) |>
    @filter(_.flow !=(0)) |>
    @mutate(log_flow = log(_.flow), 
        log_dist = log(_.distw)) |>
        #year = categorical(_.year), 
        #contig = categorical(_.contig), 
        #comlang_off = categorical(_.comlang_off)) |>
    DataFrame
grav[:year] = categorical(grav[:year]) # how do we use this with the query syntax?
grav[:contig] =  categorical(grav[:contig])
grav[:comlang_off] =  categorical(grav[:comlang_off])


grav_reg = @timed reg(grav, @formula(log_flow ~ log_dist + fe(year)*fe(iso_o) + 
    fe(year)*fe(iso_d) + fe(contig) + fe(comlang_off)), Vcov.robust())

# save regression result to tex file
outfile = joinpath(gdir, "sunny_table3_julia.tex")
regtable(grav_reg[1]; print_fe_section=false, number_regressions=false, 
    renderSettings = latexOutput(outfile))

# save time result to csv to be joined with stata and R results in R 
CSV.write(joinpath(gdir, "julia_time.csv"), DataFrame(time = grav_reg[2]))


