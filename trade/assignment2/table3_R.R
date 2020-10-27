# Created by Yixin Sun on October 21, 2020

# First check that all necessary packages are installed
packages <- c("dplyr", "foreign", "lfe", "tibble", "readr", "stringr")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))
}
library(dplyr)
library(foreign)
library(lfe)
library(tibble)
library(readr)
library(stringr)

# Set up file paths
if(Sys.getenv("USERNAME") == "Yixin Sun"){
  ddir =  "C/Users/Yixin Sun/Dropbox/Coursework/field_courses/International Macro and Trade/Assignments/assignment2"
  gdir = "C/Users/Yixin Sun/Dropbox/Coursework/Coursework/trade/assignment2"
  setwd(ddir)
}

grav <-
  read.dta("col_regfile09.dta") %>%
  as_tibble() %>%
  filter(flow != 0) %>%
  select(flow, distw, iso_o, iso_d, year, contig, comlang_off) %>%
  mutate(exp_year = as.factor(paste0(iso_o, year)),
         imp_year = as.factor(paste0(iso_d, year)))

time <- system.time(
  grav_reg <-
    as.formula(log(flow) ~ log(distw) | exp_year + imp_year + contig + comlang_off) %>%
    felm(data = grav)
)

# output to tex
stargazer(grav_reg, dep.var.caption = "", title = "Part 3 - R",
          out = file.path(gdir, "sunny_table3_R.tex"), digits = 4,
          omit.stat = c("adj.rsq", "ser"), omit.table.layout = "n", no.space = TRUE)

# format runtimes from stata and julia
julia_time <-
  read_csv(file.path(gdir, "julia_time.csv")) %>%
  as.numeric()

stata_time <-
  read_csv(file.path(gdir, "stata_time.csv")) %>%
  as.character() %>%
  str_replace("r1\t", "") %>%
  as.numeric()

# output comparison times to tex table
tibble("Stata" = stata_time, "Julia" = julia_time, "R" =  time[3]) %>%
  kable(digits = 2, format = "latex", booktabs = TRUE) %>%
  write(file.path(gdir, "sunny_speed_comparison.tex"))
