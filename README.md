
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Build
Status](https://travis-ci.org/ices-tools-dev/sfdSAR.svg?branch=master)](https://travis-ci.org/ices-tools-dev/sfdSAR)

[<img align="right" alt="ICES Logo" width="17%" height="17%" src="http://ices.dk/_layouts/15/1033/images/icesimg/iceslogo.png">](http://ices.dk)

# sfdSAR

The goal of sfdSAR is to make it easy to follow the procedure of
calculating swept area ratio of an area of seabed by a fishing gear.

## Installation

You can install the sfdSAR using

``` r
install.packages("sfdSAR", repos = "https://ices-tools-prod.r-universe.dev")
```

## Usage

For a summary of the package:

``` r
library(sfdSAR)
?sfdSAR
```

## References

ICES 2015. Report of the Working Group on Spatial Fisheries Data
(WGSFD), 8-12 June 2015, ICES Headquarters, Copenhagen, Denmark. ICES CM
2015/SSGEPI:18. 150pp

ICES 2016. Interim Report of the Working Group on Spatial Fisheries Data
(WGSFD), 17-20 May 2016, Brest, France. ICES CM 2016/SSGEPI:18. 244 pp

Eigaard OR, Bastardie F, Breen M, et al. (2016) Estimating seabed
pressure from demersal trawls, seines, and dredges based on gear design
and dimensions. ICES Journal of Marine Science, 73:27-43

Church N.J., Carter A.J., Tobin D., Edwards D., Eassom A., Cameron A.,
Johnson G.E., Robson, L.M. & Webb K.E. (2016) JNCC Recommended Pressure
Mapping Methodology 1. Abrasion: Methods paper for creating a geo-data
layer for the pressure ‘Physical Damage (Reversible Change) -
Penetration and/or disturbance of the substrate below the surface of the
seabed, including abrasion’. JNCC report No. 515, JNCC, Peterborough

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

Swept Area Ratio (SAR) is computed using the algorithm described below.
The main steps in the data processing are

1.  Determine the gear width of the VMS record according to:
    - Where average gear widths are supplied these are used.
    - For VMS records with missing gear widths but that have supplied
      average vessel characteristics (i.e. average overall vessel length
      or average KW engine power): use the model described in (Eigaard
      et al., 2016) to provide an estimate of gear width
    - For VMS records with missing gear widths and missing vessel
      characteristics use a fill-in value provided by ICES (2015) based
      on a review by the JNCC or on the BENTHIS survey (Eigaard et
      al. 2016).
2.  Estimate swept area based on gear type, fishing hours (hours),
    fishing speed (speed) and gear width (width) for each record (ICES,
    2016, p 69), note here speed is in knots and requires to be
    converted to km per hour:
    - Trawl : hours x width x speed x 1.82
    - Danish seine : hours / 2.591234 x (width<sup>2</sup>) / (4 π)
    - Scottish seine : hours / 1.9125 x (1.5 x width<sup>2</sup>) / (4
      π)
3.  Accumulate across gears for each year to produce annual totals of SA
    by c-square and gear category, and finally average over years within
    gear category and c-square.
4.  Calculate SAR values by scaling by the area of the c-squares

The code below shows how the sfdSAR functions can be used to calculate
swept area ratio (SAR)

In the following examples the `dplyr` package is used to simplify the
data processing and a made up vms toy vms dataset (`test_vms`) will be
used

    library(dplyr)
    library(sfdSAR)
    ## load sample vms data
    data(test_vms)

### 1. Determine gear widths

The calculation of gear with is done using the data in the benthis model
parameters table:

``` r
library(icesVMS)
gear_widths <- get_benthis_parameters()
#> GETing ... https://taf.ices.dk/vms/api/gearwidths
#> no token used
#> OK (HTTP 200).
kableExtra::kable(gear_widths)
```

<table>
<thead>
<tr>
<th style="text-align:right;">
id
</th>
<th style="text-align:left;">
benthisMet
</th>
<th style="text-align:left;">
avKw
</th>
<th style="text-align:left;">
avLoa
</th>
<th style="text-align:left;">
avFspeed
</th>
<th style="text-align:left;">
subsurfaceProp
</th>
<th style="text-align:right;">
gearWidth
</th>
<th style="text-align:right;">
firstFactor
</th>
<th style="text-align:right;">
secondFactor
</th>
<th style="text-align:left;">
gearModel
</th>
<th style="text-align:left;">
gearCoefficient
</th>
<th style="text-align:left;">
contactModel
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
OT_SPF
</td>
<td style="text-align:left;">
883.8421
</td>
<td style="text-align:left;">
34.38526
</td>
<td style="text-align:left;">
2.9
</td>
<td style="text-align:left;">
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
avg_oal
</td>
<td style="text-align:left;">
trawl_contact
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
SDN_DMF
</td>
<td style="text-align:left;">
167.6765
</td>
<td style="text-align:left;">
18.91915
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
0
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
avg_kw
</td>
<td style="text-align:left;">
danish_seine_contact
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
OT_DMF
</td>
<td style="text-align:left;">
441.6667
</td>
<td style="text-align:left;">
19.8
</td>
<td style="text-align:left;">
3.064286
</td>
<td style="text-align:left;">
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
avg_kw
</td>
<td style="text-align:left;">
trawl_contact
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
OT_MIX_DMF_BEN
</td>
<td style="text-align:left;">
691.0217
</td>
<td style="text-align:left;">
24.36896
</td>
<td style="text-align:left;">
2.911111
</td>
<td style="text-align:left;">
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
avg_oal
</td>
<td style="text-align:left;">
trawl_contact
</td>
</tr>
<tr>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
SSC_DMF
</td>
<td style="text-align:left;">
481.795
</td>
<td style="text-align:left;">
23.1175
</td>
<td style="text-align:left;">
0
</td>
<td style="text-align:left;">
5
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
avg_oal
</td>
<td style="text-align:left;">
scottish_seine_contact
</td>
</tr>
<tr>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
OT_MIX
</td>
<td style="text-align:left;">
400.6089
</td>
<td style="text-align:left;">
20.13774
</td>
<td style="text-align:left;">
2.788636
</td>
<td style="text-align:left;">
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
avg_kw
</td>
<td style="text-align:left;">
trawl_contact
</td>
</tr>
<tr>
<td style="text-align:right;">
7
</td>
<td style="text-align:left;">
OT_MIX_DMF_PEL
</td>
<td style="text-align:left;">
690.3574
</td>
<td style="text-align:left;">
23.745
</td>
<td style="text-align:left;">
3.410385
</td>
<td style="text-align:left;">
22
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
avg_oal
</td>
<td style="text-align:left;">
trawl_contact
</td>
</tr>
<tr>
<td style="text-align:right;">
8
</td>
<td style="text-align:left;">
OT_MIX_CRU_DMF
</td>
<td style="text-align:left;">
473.097
</td>
<td style="text-align:left;">
19.89515
</td>
<td style="text-align:left;">
2.629
</td>
<td style="text-align:left;">
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
avg_oal
</td>
<td style="text-align:left;">
trawl_contact
</td>
</tr>
<tr>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
OT_MIX_CRU
</td>
<td style="text-align:left;">
681
</td>
<td style="text-align:left;">
21.685
</td>
<td style="text-align:left;">
3.008889
</td>
<td style="text-align:left;">
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
avg_kw
</td>
<td style="text-align:left;">
trawl_contact
</td>
</tr>
<tr>
<td style="text-align:right;">
10
</td>
<td style="text-align:left;">
OT_CRU
</td>
<td style="text-align:left;">
345.5205
</td>
<td style="text-align:left;">
18.67739
</td>
<td style="text-align:left;">
2.47963
</td>
<td style="text-align:left;">
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
avg_kw
</td>
<td style="text-align:left;">
trawl_contact
</td>
</tr>
<tr>
<td style="text-align:right;">
11
</td>
<td style="text-align:left;">
TBB_CRU
</td>
<td style="text-align:left;">
210.625
</td>
<td style="text-align:left;">
20.765
</td>
<td style="text-align:left;">
2.975
</td>
<td style="text-align:left;">
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
avg_kw
</td>
<td style="text-align:left;">
trawl_contact
</td>
</tr>
<tr>
<td style="text-align:right;">
12
</td>
<td style="text-align:left;">
TBB_DMF
</td>
<td style="text-align:left;">
822.1667
</td>
<td style="text-align:left;">
33.8866
</td>
<td style="text-align:left;">
5.230851
</td>
<td style="text-align:left;">
100
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
avg_kw
</td>
<td style="text-align:left;">
trawl_contact
</td>
</tr>
<tr>
<td style="text-align:right;">
13
</td>
<td style="text-align:left;">
TBB_MOL
</td>
<td style="text-align:left;">
107.1773
</td>
<td style="text-align:left;">
10.14545
</td>
<td style="text-align:left;">
2.428571
</td>
<td style="text-align:left;">
100
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
avg_oal
</td>
<td style="text-align:left;">
trawl_contact
</td>
</tr>
<tr>
<td style="text-align:right;">
14
</td>
<td style="text-align:left;">
DRB_MOL
</td>
<td style="text-align:left;">
382.4375
</td>
<td style="text-align:left;">
24.59848
</td>
<td style="text-align:left;">
2.5
</td>
<td style="text-align:left;">
100
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
avg_oal
</td>
<td style="text-align:left;">
trawl_contact
</td>
</tr>
</tbody>
</table>

This table comes from Eigaard et al. (2016), with additions from ICES
(2015). And contains, for each benthis gear group, the proportion of the
gear contact that also affects the subsurface, the estimated average
gear width, and the coeffients and covariates of the surface contact
model which relates the gear width, properties of the vessel (kw or
overall length) to bottom contact.

In order to use this data a lookup table is required linking Metier
level 6 codes to the benthis gear groupings listed above. The lookup
table is given in the `get_metier_lookup()` function from the `icesVMS`
package and contains other gear groupings used in ICES outputs and was
initially developed by ICES (2015).

``` r
metier_lookup <- get_metier_lookup()
#> GETing ... https://taf.ices.dk/vms/api/MetierLookup
#> no token used
#> OK (HTTP 200).
kableExtra::kable(head(metier_lookup))
```

<table>
<thead>
<tr>
<th style="text-align:right;">
id
</th>
<th style="text-align:left;">
leMetLevel6
</th>
<th style="text-align:left;">
fishingHours
</th>
<th style="text-align:left;">
benthisMetiers
</th>
<th style="text-align:left;">
benthisMetiers2016Wrong
</th>
<th style="text-align:left;">
metierLevel5
</th>
<th style="text-align:left;">
metierLevel4
</th>
<th style="text-align:left;">
jnccGrouping
</th>
<th style="text-align:left;">
fishingCategory
</th>
<th style="text-align:left;">
description
</th>
<th style="text-align:left;">
fishingCategoryFo
</th>
<th style="text-align:left;">
ecomarClassification
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
FPO_FWS_110-156_0_0
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
FPO_FWS
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
Pot
</td>
<td style="text-align:left;">
Static
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
FPO_FWS_31-49_0_0
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
FPO_FWS
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
Pot
</td>
<td style="text-align:left;">
Static
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
FPO_FWS\_\>0_0_0
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
FPO_FWS
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
Pot
</td>
<td style="text-align:left;">
Static
</td>
<td style="text-align:left;">
Pots_and_traps
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
FPO_MCF_0-0_0_0
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
FPO_MCF
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
Pot
</td>
<td style="text-align:left;">
Static
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
FPO_MOL_0-0_0_0
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
FPO_MOL
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
Pot
</td>
<td style="text-align:left;">
Static
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
FPO_MOL_0_0_0
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
FPO_MOL
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
Pot
</td>
<td style="text-align:left;">
Static
</td>
<td style="text-align:left;">
Pots_and_traps
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
  right_join(metier_lookup, by = c("benthisMet" = "benthisMetiers"))

# add aux data to vms
vms <-
  aux_lookup %>%
  right_join(test_vms, by = c("leMetLevel6" = "LE_MET_level6"))
```

and the gear width model is applied using the helper function
`predict_gear_width`

``` r
# calculate the gear width model
vms$gearWidth_model <-
  predict_gear_width(vms$gearModel, vms$gearCoefficient, vms)
```

In general, if gearwdth is available, it is used. If average overall
vessel length (oal) or average vessel power (kW) is available then the
gear width model is used. Finally if none of these are avaiable an
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
sapply(unique(gear_widths$contactModel), function(x) body(get(x)))
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
  predict_surface_contact(vms$contactModel,
                          vms$fishingHours,
                          vms$gearWidth_filled,
                          vms$ICES_avg_fishing_speed)
# calculate subsurface contact
vms$subsurface <- vms$surface * as.numeric(vms$subsurfaceProp) * .01
```

### Summarising accross months etc.

Normally it is required to summarise the surface quantities, which can
be done like this

``` r
# compute summaries of swept area over groups
sa <-
  vms %>%
    mutate(
      mw_fishinghours = kw_fishinghours / 1000
    ) %>%
    group_by(year, c_square, fishingCategoryFo) %>%
    summarise(
      mw_fishinghours = sum(mw_fishinghours, na.rm = TRUE),
      subsurface = sum(subsurface, na.rm = TRUE),
      surface = sum(surface, na.rm = TRUE)
    ) %>%
  ungroup %>%
  mutate(
    lat = csquare_lat(c_square),
    lon = csquare_lon(c_square)
  )
#> `summarise()` has grouped output by 'year', 'c_square'. You can override using the `.groups` argument.
```

``` r
sa
#> # A tibble: 3 x 8
#>    year c_square       fishingCategoryFo mw_fishinghours subsurface surface   lat   lon
#>   <dbl> <chr>          <chr>                       <dbl>      <dbl>   <dbl> <dbl> <dbl>
#> 1  2020 7400:361:206:4 Otter                      15.7            0       0  46.1 -1.68
#> 2  2020 7400:361:206:4 Static                     10.8            0       0  46.1 -1.68
#> 3  2020 7400:361:206:4 <NA>                        0.903          0       0  46.1 -1.68
```

### Computing Swept Area Ratio (SAR)

In the code below, SAR is calculated for each year, then averaged over
years, resulting in a dataset of averarage SAR per c_square. Note that,
because grouping is taking place over `c_square` the summation in the
first `group_by` section is equivalent to `sum(surface) / area`. The
second grouping section computes averages for each `c_square` over all
years in the dataset.

``` r
# compute swept area ratio per year and c_square then average over years
sar <-
  sa %>%
    mutate(
      area = csquare_area(c_square)
    ) %>%
    group_by(c_square, year) %>%
      summarise(
        surface_sar = sum(surface / area, na.rm = TRUE),
        subsurface_sar = sum(subsurface / area, na.rm = TRUE)
      ) %>%
    ungroup() %>%
    group_by(c_square) %>%
    summarise(
      surface_sar = mean(surface_sar, na.rm = TRUE),
      subsurface_sar = mean(subsurface_sar, na.rm = TRUE)
    )
#> `summarise()` has grouped output by 'c_square'. You can override using the `.groups` argument.
sar
#> # A tibble: 1 x 3
#>   c_square       surface_sar subsurface_sar
#>   <chr>                <dbl>          <dbl>
#> 1 7400:361:206:4           0              0
```

### All in one

The steps described above are combined into one code block for
convienience. This code can be applied to a larger dataset to covering a
range of years, fishing gears and c_squares.

``` r
# join widths and lookup
aux_lookup <-
  gear_widths %>%
  right_join(metier_lookup, by = c("benthisMet" = "benthisMetiers"))

# add aux data to vms
vms <-
  aux_lookup %>%
  right_join(test_vms, by = c("leMetLevel6" = "LE_MET_level6"))
# calculate the gear width model
vms$gearWidth_model <-
  predict_gear_width(vms$gearModel, vms$gearCoefficient, vms)
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
  predict_surface_contact(vms$contactModel,
                          vms$fishingHours,
                          vms$gearWidth_filled,
                          vms$ICES_avg_fishing_speed)
# calculate subsurface contact
vms$subsurface <- vms$surface * as.numeric(vms$subsurfaceProp) * .01

# compute summaries of swept area over groups
sa <-
  vms %>%
    mutate(
      mw_fishinghours = kw_fishinghours / 1000
    ) %>%
    group_by(year, c_square, fishingCategoryFo) %>%
    summarise(
      mw_fishinghours = sum(mw_fishinghours, na.rm = TRUE),
      subsurface = sum(subsurface, na.rm = TRUE),
      surface = sum(surface, na.rm = TRUE)
    ) %>%
  ungroup %>%
  mutate(
    lat = csquare_lat(c_square),
    lon = csquare_lon(c_square)
  )
#> `summarise()` has grouped output by 'year', 'c_square'. You can override using the `.groups` argument.

# compute swept area ratio per year and c_square then average over years
sar <-
  sa %>%
    mutate(
      area = csquare_area(c_square)
    ) %>%
    group_by(c_square, year) %>%
      summarise(
        surface_sar = sum(surface / area, na.rm = TRUE),
        subsurface_sar = sum(subsurface / area, na.rm = TRUE)
      ) %>%
    ungroup() %>%
    group_by(c_square) %>%
    summarise(
      surface_sar = mean(surface_sar, na.rm = TRUE),
      subsurface_sar = mean(subsurface_sar, na.rm = TRUE)
    )
#> `summarise()` has grouped output by 'c_square'. You can override using the `.groups` argument.
sar
#> # A tibble: 1 x 3
#>   c_square       surface_sar subsurface_sar
#>   <chr>                <dbl>          <dbl>
#> 1 7400:361:206:4           0              0
```
