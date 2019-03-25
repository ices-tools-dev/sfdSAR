#' @docType data
#'
#' @name metier_lookup
#'
#' @title Lookup table to aggregate metier level 6 gear groupings to Benthis
#' gear groupings
#'
#' @description
#' A table.
#'
#' @usage
#' metier_lookup
#'
#' @format
#'
#' Data frame with containing 17 columns:
#' \tabular{ll}{
#'   \code{LE_MET_level6} \tab Metier level 6 gear code\cr
#'   \code{Benthis_metiers} \tab Benthis metier used to define bottom fishing pressure\cr
#'   \code{Metier_level5} \tab Metier level 5 gear codes\cr
#'   \code{Metier_level4} \tab Metier level 5 gear codes\cr
#'   \code{JNCC_grouping} \tab JNCC gear groupings\cr
#'   \code{Fishing_category} \tab Fishing category\cr
#'   \code{Fishing_category_FO} \tab Fishing category used in ICES fishery overview reports\cr
#'   \code{Description} \tab Text description of the gear code\cr
#' }
#'
#' @details
#' A lookup table linking Metier level 6 codes to the benthis gear groupings
#' developed at the ICES WGSFD. The lookup table contains other gear groupings
#' used in ICES outputs.
#'
#' @source
#' Reference to ices WGSFD, Benthis, ...
#'
#' @seealso
#' \code{\link{sfdSAR-package}} gives an overview of the package.
#'
#'
#' @examples
#' head(metier_lookup)

NA
