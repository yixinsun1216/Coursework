# Created by Yixin Sun on October 2, 2020

# =============================================================================
# Set up environment
# =============================================================================
library(tidyverse)
library(haven) # to read in .dta files
library(knitr)

root <- "C:/Users/Yixin Sun/Dropbox (Personal)/Coursework/Coursework/metrics/pset1"
ddir <- file.path("C:/Users/Yixin Sun/Dropbox (Personal)/Coursework",
                  "field_courses/Applied Microeconometrics/Problem Sets",
                  "Persecution_Perpetuated_QJE_Replicate")

# load helper functions
source(file.path(root, "pset1_utils.R"))

df <- read_dta(file.path(ddir, "Dataset_QJE_Replicate_with_Cities.dta"))

# =============================================================================
# Cleanup data following steps in replication code
# =============================================================================
df <-
  df %>%
  mutate(exist1349 = if_else(judaica == 1 | comm1349 == 1, TRUE, FALSE),
         logpop25c = log(c25pop),
         perc_JEW25 = 100*c25juden/c25pop,
         perc_PROT25 = 100*c25prot/c25pop)


dname <- "pog1349"
xnames <- c("logpop25c", "perc_JEW25", "perc_PROT25")
geonames <- c("Longitude", "Latitude")

# =============================================================================
# Replicate Table VI
# =============================================================================
# Panel A
reg_data <-
  filter(df, exist1349) %>%
  select(pog20s, dname, xnames, geonames, kreis_nr) %>%
  drop_na()

# regress pog20 on controls if exist1349==1
# cluster at kreis_nr level
f <-
  paste(c("pog20s", paste(c(dname, xnames), collapse = "+")), collapse = "~") %>%
  as.formula()

xvars <- reg_data[, xnames]
dvars <- reg_data[, dname]
yvars <- reg_data[, "pog20s"]
cluster_var <- reg_data[, "kreis_nr"]

panel_a <- ols(cbind(dvars, xvars), yvars, cluster = cluster_var)


# Panel B -------------------------------------------------------------
# Nearest-neighbor matching, ATT + mahalanobis
# documnetation for nnmatch https://www.stata.com/manuals13/teteffectsnnmatch.pdf
# more documentation https://scholar.harvard.edu/files/imbens/files/sjpdf-1.html_.pdf
panel_b <- nnmatch(xvars, yvars, dvars, outcome = "att")

# Panel C -------------------------------------------------------------
gvars <- reg_data[, c("Latitude", "Longitude")]
panel_c <- nnmatch(gvars, yvars, dvars, outcome = "att")

# Propensity Score -----------------------------------------------------
pscore_att <- propensity(xvars, yvars, dvars, outcome = "att")
pscore_ate <- propensity(xvars, yvars, dvars)


# =============================================================================
# Format and output results to tex file
# =============================================================================
extra_rows <- tibble(term = c("N", "Adj. R^2"), value = c(panel_a$n, panel_a$adj_r2))
coefs_a <-
  panel_a$coefs %>%
  filter(!str_detect(term, "Intercept"))
reg_output(coefs_a, extra_rows = extra_rows, decimals = 4) %>%
  write(file = file.path(root, "sunny_panel_a.tex"))

panel_matching <-
  mutate(panel_b, term = "pog1349 - Matching") %>%
  bind_rows(mutate(panel_c, term = "pog1349 - Geographic Matching"))
reg_output(panel_matching, decimals = 4) %>%
  write(file = file.path(root, "sunny_panel_matching.tex"))

panel_pscore <-
  mutate(pscore_att, term = "pog1349 - Prop. Score ATT") %>%
  bind_rows(mutate(pscore_ate, term = "pog1349 - Prop. Score ATE"))

reg_output(panel_pscore, decimals = 4) %>%
  write(file = file.path(root, "sunny_panel_pscore.tex"))



