#' Calculate gear width from vessel characteristics
#'
#' Predict gear width using vessel length or engine size.
#'
#' @param model vector of characters defining a model
#'                   (see ?linear or ?power)
#' @param coefficient coefficient names, must be columns names in data
#' @param data a data.frame with the columns, a, b, model, .
#'
#' @return A vector of predicted gear widths.
#'
#'
#' @examples
#' # very simple example of how to apply this helper function
#' predict_gear_width("power", "avg_aol", data.frame(firstFactor = 1, secondFactor = 1, avg_aol = 1))
#'
#' # use the dummy vms dataset
#' data(test_vms)
#'
#' \donttest{
#' # get gear widths and metier lookup from ICES DB
#' library(icesVMS)
#' metier_lookup <- get_metier_lookup()
#' gear_widths <- get_benthis_parameters()
#'
#' # join widths and lookup
#' library(dplyr)
#' aux_lookup <-
#'   gear_widths %>%
#'   right_join(metier_lookup, by = c("benthisMet" = "benthisMetiers"))
#'
#' # add aux data to vms
#' vms <-
#'   aux_lookup %>%
#'   right_join(test_vms, by = c("leMetLevel6" = "LE_MET_level6"))
#'
#' # calculate the gear width model
#' vms$gearWidth_model <-
#'   predict_gear_width(vms$gearModel, vms$gearCoefficient, vms)
#'
#' }
#' @name predict_gear_width
#' @export
predict_gear_width <- function(model, coefficient, data) {

  # get coefficients
  coeffs <- unique(coefficient)
  coeffs <- coeffs[!is.na(coeffs)]
  x <- rep(NA, nrow(data))
  for (coeff in coeffs) {
    cwhich <- which(coefficient == coeff)
    x[cwhich] <- data[[coeff]][cwhich]
  }

  # apply the model
  mods <- unique(model)
  mods <- mods[!is.na(mods)]
  output <- rep(NA, nrow(data))
  for (mod in mods) {
    fun <- match.fun(mod)
    mwhich <- which(model == mod)
    output[mwhich] <- with(data[mwhich,], fun(firstFactor, secondFactor, x[mwhich]))
  }

  output
}
