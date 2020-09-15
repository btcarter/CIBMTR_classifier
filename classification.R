# Preamble
# Author: Benjamin T. Carter, PhD
# Org: Collaborative Science & Innovation, Billings Clinic
# 
# 
# Instructions
# If you're looking here for instructions then "you're in the wrong place."
#


# Environment ####
require(readxl)
require(dplyr)
library(tidyr)

# normal lab values ####
nl_kl_ratio <- as.numeric()


# Commands ####

# select the spreadsheet ####
wb <- file.choose() # path to existing excel workbook (which will be overwritten?)

df.type <- read_xlsx(
  path = wb,
  sheet = "PCD Tracker",
  n_max = 1,
  col_names = FALSE
)

df.xl <- read_xlsx(
  path = wb,
  sheet = "PCD Tracker",
  skip = 5,
  col_names = c(
    "Date",
    "Notes",
    "per_plasma_bm",
    "bm_interpretation",
    "FISH",
    "flow_cyto",
    "SIFE",
    "SPEP",
    "kappa_FLC",
    "lambda_FLC",
    "k_l_diff",
    "k_l_ratio",
    "UIFE",
    "UPEP",
    "Plasmacytomas",
    "pc_count",
    "pc_size",
    "lytic_lesions",
    "lesion_count",
    "lesion_size",
    "imaging_comments",
    "blood_ca",
    "hgb",
    "sCr",
    "sVisc"
  )
)

# determine type of myeloma ####
# need to know subtype of myeloma (measurable myeloma, non-measurable, light chain only, and non-secretory)

if (
  !is.na(df.type[8]) && !is.na(df.type[16])
){
  type <- "sm" # secretory multiple myeloma
} else if (
  !is.na(df.type[16]) && is.na(df.type[8])
){
  type <- "lco" # light chain only multiple myeloma
} else if (
  is.na(df.type[8]) && is.na(df.type[16])
){
  type <- "ns" # nonsecretory multiple myeloma
} else {
  stop("Myeloma family is unidentifiable in this spreadsheet.") # wtf is this?
}

# DATA CLEANING & PREPARATION ####

df.filled <- df.xl[!is.na(df.xl$Date), ] %>% 
  fill(2:length(colnames(df.xl))) %>% 
  mutate(
    SPEP = as.numeric(SPEP),
    UPEP = as.numeric(UPEP),
    days_since_first_encounter = (Date - first(Date)) / 86400,
    days_since_last_encounter = Date - lag(Date),
    per_plasma_bm = as.numeric(per_plasma_bm),
    Status = ""
  )

# get baseline scores ####
baseline <- list()

baseline$kappa <- df.filled %>% 
  filter(
    !is.na(kappa_FLC)
  ) %>% 
  select(
    Date,
    value = kappa_FLC
  ) %>% 
  slice(1)

baseline$lambda <- df.filled %>% 
  filter(
    !is.na(lambda_FLC)
  ) %>% 
  select(
    Date,
    value = lambda_FLC
  ) %>% 
  slice(1)

baseline$k_l_diff <- df.filled %>% 
  filter(
    !is.na(k_l_diff)
  ) %>% 
  select(
    Date,
    value = k_l_diff
  ) %>% 
  slice(1)

baseline$k_l_ratio <- df.filled %>% 
  filter(
    !is.na(k_l_ratio)
  ) %>% 
  select(
    Date,
    value = k_l_ratio
  ) %>% 
  slice(1)

baseline$SPEP <- df.filled %>% 
  filter(
    !is.na(SPEP)
  ) %>% 
  select(
    Date,
    value = SPEP
  ) %>% 
  slice(1)

baseline$UPEP <- df.filled %>% 
  filter(
    !is.na(UPEP)
  ) %>% 
  select(
    Date,
    value = UPEP
  ) %>% 
  slice(1)


# FUNCTIONS ####

# determine status of secretory myeloma

scr_secretory <- function(k_l_ratio,
                          bm_results, # which value is this?
                          UIFE,
                          SIFE,
                          Plasmacytomas,
                          per_plasma_bm
                          ){
  if (
    k_l_ratio = nl_kl_ratio &
    bm_results = & # negative?
    UIFE == "ned" &
    SIFE == "ned" &
    Plasmacytomas == "no" & (
      per_plasma_bm < 5 | is.na(per_plasma_bm) # will it be 0 or some other value?
    )
  ){
    return("sCR")
  }
}

# determine status of light chain only myeloma

# determine status of multiple myeloma