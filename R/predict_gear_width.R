#' Calculate gear fill in
#'
#' Predict gear width.
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
#'
#' @name predict_gear_width
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
    output[mwhich] <- with(data[mwhich,], fun(a, b, x[mwhich]))
  }

  output
}
