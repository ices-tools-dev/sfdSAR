
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Build
Status](https://travis-ci.org/ices-tools-dev/sfdSAR.svg?branch=master)](https://travis-ci.org/ices-tools-dev/sfdSAR)

[<img align="right" alt="ICES Logo" width="17%" height="17%" src="http://ices.dk/_layouts/15/1033/images/icesimg/iceslogo.png">](http://ices.dk)

# sfdSAR

The goal of sfdSAR is to make it easy to follow the procedure of
calculating swept area ratio of an area of seabed by a fishing gear.

## Installation

You can install the sfdSAR from GitHub using

``` r
devtools::install_github("ices-tools-dev/sfdSAR")
```

## Usage

For a summary of the package:

``` r
library(sfdSAR)
?sfdSAR
```

## References

need to cite Benthis, WGSFD, Eigaard etc

## Development

sfdSAR is developed openly on
[GitHub](https://github.com/ices-tools-dev/sfdSAR).

Feel free to open an
[issue](https://github.com/ices-tools-dev/sfdSAR/issues) there if you
encounter problems or have suggestions for future versions.

## Example

The functions in this package are intended for one purpose: to compute
the swept area ratio (SAR) and the subsurface SAR of a fishing gear,
which can then be summarised over years and gear groupings.

The code below shows how the sfdSAR functions can be used to calculate
swept area ratio (SAR)

In the following examples the `dplyr` package is used to simplify the
data processing and a made up vms toy vms dataset (`test_vms`) will be
used

    library(dplyr)
    library(sfdSAR)
    ## load sample vms data
    data(test_vms)

### Predicting gear widths

The calculation of gear with is done using the data in the `gear_widths`
table:

``` r
data(gear_widths)
kableExtra::kable(gear_widths)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

benthis\_met

</th>

<th style="text-align:right;">

subsurface\_prop

</th>

<th style="text-align:right;">

gearWidth

</th>

<th style="text-align:right;">

a

</th>

<th style="text-align:right;">

b

</th>

<th style="text-align:left;">

gear\_model

</th>

<th style="text-align:left;">

gear\_coefficient

</th>

<th style="text-align:left;">

contact\_model

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

OT\_CRU

</td>

<td style="text-align:right;">

32.1

</td>

<td style="text-align:right;">

0.0789228

</td>

<td style="text-align:right;">

5.1039

</td>

<td style="text-align:right;">

0.4690

</td>

<td style="text-align:left;">

power

</td>

<td style="text-align:left;">

avg\_kw

</td>

<td style="text-align:left;">

trawl\_contact

</td>

</tr>

<tr>

<td style="text-align:left;">

OT\_DMF

</td>

<td style="text-align:right;">

7.8

</td>

<td style="text-align:right;">

0.1054698

</td>

<td style="text-align:right;">

9.6054

</td>

<td style="text-align:right;">

0.4337

</td>

<td style="text-align:left;">

power

</td>

<td style="text-align:left;">

avg\_kw

</td>

<td style="text-align:left;">

trawl\_contact

</td>

</tr>

<tr>

<td style="text-align:left;">

OT\_MIX

</td>

<td style="text-align:right;">

14.7

</td>

<td style="text-align:right;">

0.0613659

</td>

<td style="text-align:right;">

10.6608

</td>

<td style="text-align:right;">

0.2921

</td>

<td style="text-align:left;">

power

</td>

<td style="text-align:left;">

avg\_kw

</td>

<td style="text-align:left;">

trawl\_contact

</td>

</tr>

<tr>

<td style="text-align:left;">

OT\_MIX\_CRU

</td>

<td style="text-align:right;">

29.2

</td>

<td style="text-align:right;">

0.1051172

</td>

<td style="text-align:right;">

37.5272

</td>

<td style="text-align:right;">

0.1490

</td>

<td style="text-align:left;">

power

</td>

<td style="text-align:left;">

avg\_kw

</td>

<td style="text-align:left;">

trawl\_contact

</td>

</tr>

<tr>

<td style="text-align:left;">

TBB\_CRU

</td>

<td style="text-align:right;">

52.2

</td>

<td style="text-align:right;">

0.0171507

</td>

<td style="text-align:right;">

1.4812

</td>

<td style="text-align:right;">

0.4578

</td>

<td style="text-align:left;">

power

</td>

<td style="text-align:left;">

avg\_kw

</td>

<td style="text-align:left;">

trawl\_contact

</td>

</tr>

<tr>

<td style="text-align:left;">

TBB\_DMF

</td>

<td style="text-align:right;">

100.0

</td>

<td style="text-align:right;">

0.0202760

</td>

<td style="text-align:right;">

0.6601

</td>

<td style="text-align:right;">

0.5078

</td>

<td style="text-align:left;">

power

</td>

<td style="text-align:left;">

avg\_kw

</td>

<td style="text-align:left;">

trawl\_contact

</td>

</tr>

<tr>

<td style="text-align:left;">

OT\_MIX\_DMF\_PEL

</td>

<td style="text-align:right;">

22.0

</td>

<td style="text-align:right;">

0.0762053

</td>

<td style="text-align:right;">

6.6371

</td>

<td style="text-align:right;">

0.7706

</td>

<td style="text-align:left;">

power

</td>

<td style="text-align:left;">

avg\_oal

</td>

<td style="text-align:left;">

trawl\_contact

</td>

</tr>

<tr>

<td style="text-align:left;">

TBB\_MOL

</td>

<td style="text-align:right;">

100.0

</td>

<td style="text-align:right;">

0.0049306

</td>

<td style="text-align:right;">

0.9530

</td>

<td style="text-align:right;">

0.7094

</td>

<td style="text-align:left;">

power

</td>

<td style="text-align:left;">

avg\_oal

</td>

<td style="text-align:left;">

trawl\_contact

</td>

</tr>

<tr>

<td style="text-align:left;">

DRB\_MOL

</td>

<td style="text-align:right;">

100.0

</td>

<td style="text-align:right;">

0.0169653

</td>

<td style="text-align:right;">

0.3142

</td>

<td style="text-align:right;">

1.2454

</td>

<td style="text-align:left;">

power

</td>

<td style="text-align:left;">

avg\_oal

</td>

<td style="text-align:left;">

trawl\_contact

</td>

</tr>

<tr>

<td style="text-align:left;">

OT\_MIX\_DMF\_BEN

</td>

<td style="text-align:right;">

8.6

</td>

<td style="text-align:right;">

0.1563055

</td>

<td style="text-align:right;">

3.2141

</td>

<td style="text-align:right;">

77.9812

</td>

<td style="text-align:left;">

linear

</td>

<td style="text-align:left;">

avg\_oal

</td>

<td style="text-align:left;">

trawl\_contact

</td>

</tr>

<tr>

<td style="text-align:left;">

OT\_MIX\_CRU\_DMF

</td>

<td style="text-align:right;">

22.9

</td>

<td style="text-align:right;">

0.1139591

</td>

<td style="text-align:right;">

3.9273

</td>

<td style="text-align:right;">

35.8254

</td>

<td style="text-align:left;">

linear

</td>

<td style="text-align:left;">

avg\_oal

</td>

<td style="text-align:left;">

trawl\_contact

</td>

</tr>

<tr>

<td style="text-align:left;">

OT\_SPF

</td>

<td style="text-align:right;">

2.8

</td>

<td style="text-align:right;">

0.1015789

</td>

<td style="text-align:right;">

0.9652

</td>

<td style="text-align:right;">

68.3890

</td>

<td style="text-align:left;">

linear

</td>

<td style="text-align:left;">

avg\_oal

</td>

<td style="text-align:left;">

trawl\_contact

</td>

</tr>

<tr>

<td style="text-align:left;">

SDN\_DMF

</td>

<td style="text-align:right;">

0.0

</td>

<td style="text-align:right;">

6.5366439

</td>

<td style="text-align:right;">

1948.8347

</td>

<td style="text-align:right;">

0.2363

</td>

<td style="text-align:left;">

power

</td>

<td style="text-align:left;">

avg\_kw

</td>

<td style="text-align:left;">

danish\_seine\_contact

</td>

</tr>

<tr>

<td style="text-align:left;">

SSC\_DMF

</td>

<td style="text-align:right;">

5.0

</td>

<td style="text-align:right;">

6.4542120

</td>

<td style="text-align:right;">

4461.2700

</td>

<td style="text-align:right;">

0.1176

</td>

<td style="text-align:left;">

power

</td>

<td style="text-align:left;">

avg\_oal

</td>

<td style="text-align:left;">

scottish\_seine\_contact

</td>

</tr>

</tbody>

</table>

This table comes from (citation required), subsequently modified by
(citation required). And contains, for each benthis gear group, the
proportion of the gear contact that also affects the subsurface, the
estimated average gear width, and the coeffients and covariates of the
surface contact model which relates the gear width, properties of the
vessel (kw or overall length) to bottom contact.

In order to use this data a lookup table is required linking Metier
level 6 codes to the benthis gear groupings listed above. The lookup
table is given in the `metier_lookup` dataset and contains other gear
groupings used in ICES outputs.

``` r
data(metier_lookup)
kableExtra::kable(head(metier_lookup))
```

<table>

<thead>

<tr>

<th style="text-align:left;">

LE\_MET\_level6

</th>

<th style="text-align:left;">

Benthis\_metiers

</th>

<th style="text-align:left;">

Metier\_level5

</th>

<th style="text-align:left;">

Metier\_level4

</th>

<th style="text-align:left;">

JNCC\_grouping

</th>

<th style="text-align:left;">

Fishing\_category

</th>

<th style="text-align:left;">

Fishing\_category\_FO

</th>

<th style="text-align:left;">

Description

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

FPO\_FWS\_110-156\_0\_0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

FPO\_FWS

</td>

<td style="text-align:left;">

FPO

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

Static

</td>

<td style="text-align:left;">

Static

</td>

<td style="text-align:left;">

Pot

</td>

</tr>

<tr>

<td style="text-align:left;">

FPO\_FWS\_31-49\_0\_0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

FPO\_FWS

</td>

<td style="text-align:left;">

FPO

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

Static

</td>

<td style="text-align:left;">

Static

</td>

<td style="text-align:left;">

Pot

</td>

</tr>

<tr>

<td style="text-align:left;">

FPO\_FWS\_\>0\_0\_0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

FPO\_FWS

</td>

<td style="text-align:left;">

FPO

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

Static

</td>

<td style="text-align:left;">

Static

</td>

<td style="text-align:left;">

Pot

</td>

</tr>

<tr>

<td style="text-align:left;">

FPO\_MCF\_0-0\_0\_0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

FPO\_MCF

</td>

<td style="text-align:left;">

FPO

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

Static

</td>

<td style="text-align:left;">

Static

</td>

<td style="text-align:left;">

Pot

</td>

</tr>

<tr>

<td style="text-align:left;">

FPO\_MOL\_0-0\_0\_0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

FPO\_MOL

</td>

<td style="text-align:left;">

FPO

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

Static

</td>

<td style="text-align:left;">

Static

</td>

<td style="text-align:left;">

Pot

</td>

</tr>

<tr>

<td style="text-align:left;">

FPO\_MOL\_0\_0\_0

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

FPO\_MOL

</td>

<td style="text-align:left;">

FPO

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

Static

</td>

<td style="text-align:left;">

Static

</td>

<td style="text-align:left;">

Pot

</td>

</tr>

</tbody>

</table>

Linking the gearwidths and contact model information is done with the
following two lines

``` r
# join widths and lookup
aux_lookup <-
  gear_widths %>%
  right_join(metier_lookup, by = c("benthis_met" = "Benthis_metiers"))

# add aux data to vms
vms <-
  aux_lookup %>%
  right_join(test_vms, by = c("LE_MET_level6", "LE_MET_level6"))
```

and the gear width model is applied using the helper function
`predict_gear_width`

``` r
# calculate the gear width model
vms$gearWidth_model <-
  predict_gear_width(vms$gear_model, vms$gear_coefficient, vms)
```

In general, if gearwdth is available, it is used. If average overall
vessel length (oal) or average vessel power (kW) is available then the
gear width model is used. FInally if none of these are avaiable an
average gear width is applied. The following code implements this

``` r
# do the fillin for gear width:
# select provided average gear width, then modelled gear with, then benthis
# average if no kw or aol supplied
vms$gearWidth_filled <-
  with(vms,
    ifelse(!is.na(avg_gearWidth), avg_gearWidth / 1000,
      ifelse(!is.na(gearWidth_model), gearWidth_model / 1000,
        gearWidth)
    ))
```

### Predicting surface contact

finaly, surface contact is computed using the appropriate surface
contact model, given by the `contact_model` feild, defined as:

``` r
sapply(unique(gear_widths$contact_model), function(x) body(get(x)))
#> $trawl_contact
#> {
#>     fishing_hours * gear_width * fishing_speed * 1.852
#> }
#> 
#> $danish_seine_contact
#> {
#>     fishing_hours/2.591234 * gear_width^2/pi/4
#> }
#> 
#> $scottish_seine_contact
#> {
#>     fishing_hours/1.9125 * gear_width^2/pi/4 * 1.5
#> }
```

The helper function `predict_surface_contact` computes the surface
contact (usage shown below). The feild `subsurface_prop` which has come
from the `gear_width` dataset can be used to compute subsurface contact
from the surface contact.

``` r
# calculate surface contact
vms$surface <-
  predict_surface_contact(vms$contact_model,
                          vms$fishing_hours,
                          vms$gearWidth_filled,
                          vms$ICES_avg_fishing_speed)
# calculate subsurface contact
vms$subsurface <- vms$surface * vms$subsurface_prop * .01
```

### Summarising accross months etc.

Normally it is required to summarise the surface quantities, which can
be done like this

``` r
# compute summaries over groups
output <-
  vms %>%
    mutate(
      mw_fishinghours = kw_fishinghours / 1000
    ) %>%
    group_by(year, c_square, Fishing_category_FO) %>%
    summarise(
      mw_fishinghours = sum(mw_fishinghours, na.rm = TRUE),
      subsurface = sum(subsurface, na.rm = TRUE),
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

### All in one

The steps described above are combined into one code block for
convienience

``` r
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
# calculate subsurface contact
vms$subsurface <- vms$surface * vms$subsurface_prop * .01

# compute summaries over groups
output <-
  vms %>%
    mutate(
      mw_fishinghours = kw_fishinghours / 1000
    ) %>%
    group_by(year, c_square, Fishing_category_FO) %>%
    summarise(
      mw_fishinghours = sum(mw_fishinghours, na.rm = TRUE),
      subsurface = sum(subsurface, na.rm = TRUE),
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
