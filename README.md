
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sfdSAR

The goal of sfdSAR is to make it easy to follow the procedure of
calculating swept area ratio of an area of seabed by a fishing gear.

## Installation

You can install the sfdSAR from GitHub using

``` r
devtools::install_github("ices-tools-dev/sfdSAR")
```

## Example

The functions in this package are intended for one purpose: to compute
the swept area ratio (SAR) and the subsurface SAR of a fishing gear,
which can then be summarised over years and gear groupings.

The code below shows how the sfdSAR functions can be used to calculate
swept area ratio (SAR)

In the following examples the `dplyr` package is used to simplify the
data processing

    library(dplyr)
    library(sfdSAR)

``` r
## load sample vms data
data(test_vms)

# load lookup tables
data(gear_widths)
data(metier_lookup)

# join widths and lookup
aux_lookup <-
  gear_widths %>%
  right_join(metier_lookup, by = c("benthis_met" = "Benthis_metiers"))

# add aux data to vms
vms <-
  aux_lookup %>%
  right_join(test_vms, by = c("LE_MET_level6", "LE_MET_level6"))

# calculate the gear width model
vms$gearWidth_model <-
  predict_gear_width(vms$gear_model, vms$gear_coefficient, vms)

# do the fillin for gear width:
# select provided average gear width, then modelled gear with, then benthis
# average if no kw or aol supplied
vms$gearWidth_filled <-
  with(vms,
    ifelse(!is.na(avg_gearWidth), avg_gearWidth / 1000,
      ifelse(!is.na(gearWidth_model), gearWidth_model / 1000,
        gearWidth)
    ))

# calculate surface contact
vms$surface <-
  predict_surface_contact(vms$contact_model,
                          vms$fishing_hours,
                          vms$gearWidth_filled,
                          vms$ICES_avg_fishing_speed)

# compute summaries over groups
output <-
  vms %>%
    mutate(
      mw_fishinghours = kw_fishinghours / 1000
    ) %>%
    group_by(year, c_square, Fishing_category_FO) %>%
    summarise(
      mw_fishinghours = sum(mw_fishinghours, na.rm = TRUE),
      subsurface = sum(surface * subsurface_prop * .01, na.rm = TRUE),
      surface = sum(surface, na.rm = TRUE)
    ) %>%
  ungroup %>%
  mutate(
    lat = sfdSAR::csquare_lat(c_square),
    lon = sfdSAR::csquare_lon(c_square)
  )

output
#> # A tibble: 3 x 8
#>    year c_square Fishing_categor~ mw_fishinghours subsurface surface   lat
#>   <dbl> <chr>    <chr>                      <dbl>      <dbl>   <dbl> <dbl>
#> 1  2020 7400:36~ <NA>                       0.903       0        0    46.1
#> 2  2020 7400:36~ Otter                     15.7         2.00    15.5  46.1
#> 3  2020 7400:36~ Static                    10.8         0        0    46.1
#> # ... with 1 more variable: lon <dbl>
```

In this made up example, we have calculated the total MW fishing hours
`mw_fishinghours`, subsurface swept area ratio (subsurface SAR)
`subsurface` and surface swept area ratio (surface SAR) `surface`, for
each Fishing category in a single c\_square.

The above code can be applied to a larger dataset to covering a range of
year, fishing gears and c\_squares.
