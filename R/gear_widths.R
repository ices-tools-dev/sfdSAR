#' @docType data
#'
#' @name gear_widths
#'
#' @title Lookup table used to calculate gear width and bottom contact
#'
#' @description
#' A table.
#'
#' @usage
#' gear_widths
#'
#' @format
#'
#' Data frame with containing 17 columns:
#' \tabular{ll}{
#'   \code{benthis_met} \tab Benthis gear category\cr
#'   \code{subsurface_prop} \tab Proportion of the gear that contacts the subsurface\cr
#'   \code{gearWidth} \tab Fillin value for gear width\cr
#'   \code{a} \tab Parameter used in the gear width model\cr
#'   \code{b} \tab Parameter used in the gear width model\cr
#'   \code{gear_model} \tab The gear width model\cr
#'   \code{gear_coefficient} \tab The covariate used in the gear width model\cr
#'   \code{contact_model} \tab The bottom contact model\cr
#' }
#'
#' @details
#' This table comes from (citation required), subsequently modified by (citation
#' required).  And contains, for each benthis gear group, the proportion of the gear
#' contact that also affects the subsurface, the estimated average gear width,
#' and the coeffients and covariates of the surface contact model which relates
#' the gear width, properties of the vessel (kw or overall length) to
#' bottom contact.
#'
#' In order to use this data a lookup table is required linking Metier level 6
#' codes to the benthis gear groupings listed above.  The lookup table is given in
#' the \code{\link{metier_lookup}} dataset and contains other gear groupings used in ICES
#' outputs.
#'
#' @source
#' Reference to Benthis project and papers.
#'
#' @seealso
#' \code{\link{sfdSAR-package}} gives an overview of the package.
#'
#'
#' @examples
#' gear_widths

NA
