
library(RODBC)
library(dplyr)

# get benthis auxiliary info
dbConnection <- 'Driver={SQL Server};Server=SQL06;Database=VMS;Trusted_Connection=yes'
conn <- odbcDriverConnect(connection = dbConnection)
gear_widths <- sqlFetch(conn, "tblAux_benthisGearWidthsForWGSFD17")
odbcClose(conn)

# reference for model and params:
#
# Eigaard,O.R.,Bastardie,F.,Breen,M.,Dinesen, G.E.,Hintzen,N.T.,Laffargue,P.,Mortensen,L.O.,Nielsen,J.R.,Nilsson, Hans C.,
# O’Neill, F. G., Polet, H., Reid, David G., Sala, A., Sko ¨ld, M., Smith, C., Sørensen, T. K., Tully, O., Zengin, M., and Rijnsdorp, A. D.
# Estimating seabed pressure from demersal trawls, seines, and dredges based on gear design and dimensions. – ICES Journal
# of Marine Science, 73: i27–i43.

# reference for subsurface proportion and gear width:?
#

# gear width fill in type
gearFillin <-
  rbind(
    data.frame(gear_model = "linear",
               gear_coefficient = "avg_oal",
               benthis_met = c('OT_MIX_DMF_BEN', 'OT_MIX_CRU_DMF', 'OT_SPF')),
    data.frame(gear_model = "power",
               gear_coefficient = "avg_kw",
               benthis_met = c('OT_CRU', 'OT_DMF', 'OT_MIX', 'OT_MIX_CRU',
                               'TBB_CRU', 'TBB_DMF', 'SDN_DMF')),
    data.frame(gear_model = "power",
               gear_coefficient = "avg_oal",
               benthis_met = c('OT_MIX_DMF_PEL', 'TBB_MOL', 'DRB_MOL','SSC_DMF'))
  )

surfaceFillin <-
  rbind(
    data.frame(contact_model = "trawl_contact",
               benthis_met = c('OT_CRU', 'OT_DMF', 'OT_MIX', 'OT_MIX_CRU',
                              'TBB_CRU', 'TBB_DMF', 'OT_MIX_DMF_PEL', 'TBB_MOL',
                              'DRB_MOL', 'OT_MIX_DMF_BEN', 'OT_MIX_CRU_DMF',
                              'OT_SPF')),
    data.frame(contact_model = "danish_seine_contact",
               benthis_met = 'SDN_DMF'),
    data.frame(contact_model = "scottish_seine_contact",
               benthis_met = 'SSC_DMF')
  )

# join widths and lookup
gear_widths <-
  gear_widths %>%
  filter(!is.na(FirstFactor)) %>%
  rename(a = FirstFactor, b = SecondFactor) %>%
  select(benthis_met, subsurface_prop, gearWidth, a, b) %>%
  right_join(gearFillin, by = c("benthis_met" = "benthis_met")) %>%
  right_join(surfaceFillin, by = c("benthis_met" = "benthis_met"))

# save data for use in package
usethis::use_data(gear_widths, overwrite = TRUE)
