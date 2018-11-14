
library(RODBC)
library(dplyr)

# get benthis auxiliary info
dbConnection <- 'Driver={SQL Server};Server=SQL06;Database=VMS;Trusted_Connection=yes'
conn <- odbcDriverConnect(connection = dbConnection)
metier_lookup <- sqlFetch(conn, "tblAux_Lookup_Metiers_incl_log")
odbcClose(conn)

# filter and select
metier_lookup <-
  metier_lookup %>%
  select(LE_MET_level6, Benthis_metiers, Metier_level5, Metier_level4,
         JNCC_grouping, Fishing_category, Fishing_category_FO, Description) %>%
  filter(Fishing_category != "Fishing_category")


# save data for use in package
usethis::use_data(metier_lookup, overwrite = TRUE)
