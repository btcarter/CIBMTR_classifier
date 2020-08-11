# Preamble
# Author: Benjamin Carter
# Org: Collaborative Science & Innovation, Billings Clinic
# 
# 
# Instructions
# If you're looking here for instructions then "you're in the wrong place."


# Environment
require(readxl)
require(dplyr)

############
# Commands #
############

# user defined parameters
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
    "Plasma_cytomas",
    "lytic_lesions",
    "imaging_comments"
  )
)

# determine type of myeloma
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
}


##### DATA CLEANING & PREPARATION

df <- df.xl[!is.na(df.xl$Date), ]

df <- df %>% 
  mutate(
    days = (Date - first(Date)) / 86400,
    days_since_last_encounter = Date - lag(Date),
    per_plasma_bm = as.numeric(per_plasma_bm),
    Status = "Not assigned"
  )



# get basline scores

kappa <- as.numeric(df.xl[df.xl$Notes == "Diagnosis", ]$kappa_FLC)
lambda <- df.xl[df.xl$Notes == "Diagnosis", ]$lambda_FLC
kl_diff <- df.xl[df.xl$Notes == "Diagnosis", ]$k_l_diff
kl_ratio <- df.xl[df.xl$Notes == "Diagnosis", ]$k_l_ratio
spep <- as.numeric(df.xl$SPEP[1])
upep <- spep <- as.numeric(df.xl$UPEP[1])


##### FUNCTIONS

# determine status of secretory myeloma

secretory_cr <- function(df){
  df %>% 
    mutate(
      Status = if_else(
        SIFE == "ned" &
          UIFE == "ned" &
          is.na(Plasma_cytomas) &
          per_plasma_bm < 5,
        "CR",
        Status,
        Status
      )
    )
  return(df$Status)
}

secretory_vgpr <- function(df){
  df %>% 
    mutate(
      if_else(
        !is.na(SIFE) &
          !is.na(UIFE) &
          is.na(SPEP) &
          is.na(UPEP) &
          SPEP/spep <= 0.1,
        "VGPR",
        Status,
        Status
      ) 
    )
  return(df$Status)
}

secretory_pr <- function(df){
  df %>% 
    mutate(
      if_else(
        SPEP/spep <= 0.5 &
          UPEP/upep <= 0.1,
        "PR",
        Status,
        Status
      )
    )
  return(df$Status)
}

secretory_pd <- function(){}

secretory_relapse <- function(){}

# determine status of light chain only myeloma

# determine status of multiple myeloma