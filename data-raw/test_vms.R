
# packages
library(icesTAF)
library(data.table)

# read in some data
load("data-raw/vms.rda")
test_vms <- vms

test_vms$country <- "UNK"
test_vms$year <- 2020
test_vms$month <- 6
test_vms$c_square <- "7400:361:206:4"

# randomly permute rows within columns
test_vms[] <- lapply(test_vms, function(x) x[sample(length(x), replace = TRUE)])

# keep only a few
test_vms <- test_vms[1:10,]

# convert to df
test_vms <- as.data.frame(test_vms)

# save
usethis::use_data(test_vms, overwrite = TRUE)
