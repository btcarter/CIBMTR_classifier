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
    "Plasma-cytomas",
    "lytic_lesions",
    "imaging_comments"
  )
)

# determine type of myeloma
# need to know subtype of myeloma (measurable myeloma, non-measurable, light chain only, and non-secretory)

if (
  !is.na(df.type[8]) && !is.na(df.type[16])
){
  type <- "mm" # secretory multiple myeloma
} else if (
  !is.na(df.type[16]) && is.na(df.type[8])
){
  type <- "lco" # light chain only multiple myeloma
} else if (
  is.na(df.type[8]) && is.na(df.type[16])
){
  type <- "ns" # nonsecretory multiple myeloma
}

# determine patient status by CIBMTR criteria

df.xl %>% 
  mutate(
    Status = if_else(
      k_l_ratio >= 0.37 & 
        k_l_ratio <= 3.1 &
        is.na(bm_interpretation) &
        SIFE=="ned" &
        per_plasma_bm < 5,
      "Measurable and Non-Measurable Multiple Myeloma",
      
        
        
    )
  )
