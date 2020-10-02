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

df <- read_dta(file.path(ddir, "Dataset_QJE_Replicate_with_Cities.dta"))

# =============================================================================
# Cleanup data following steps in replication code
# =============================================================================
reg_data <-
  df %>%
  mutate(exist1349 = if_else(judaica == 1 | com1349 == 1, TRUE, FALSE),
         logpop25c = log(c25pop),
         perc_JEW25 = 100*c25juden/c25pop,
         perc_PROT25 = 100*c25prot/c25pop)



# =============================================================================
# Table VI Panel A
# =============================================================================
# regress pog20 on controls if exist1349==1
# cluster at kreis_nr level
controls <- c("pog1349", "logpop25c", "perc_JEW25", "perc_PROT25")
