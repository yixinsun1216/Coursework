# Created by Yixin Sun on October 2, 2020

# =============================================================================
# Set up environment
# =============================================================================
library(tidyverse)
library(haven) # to read in .dta files

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


# =============================================================================
# Table VI Panel A
# =============================================================================
xnames <- c("pog1349", "logpop25c", "perc_JEW25", "perc_PROT25")
reg_data <-
  filter(df, exist1349) %>%
  select(pog20s, xnames, kreis_nr) %>%
  drop_na()

# regress pog20 on controls if exist1349==1
# cluster at kreis_nr level
f <-
  paste(c("pog20s", paste(xnames, collapse = "+")), collapse = "~") %>%
  as.formula()

panel_a <- ols(f, reg_data, cluster = "kreis_nr")


# =============================================================================
# Table VI Panel B
# =============================================================================




