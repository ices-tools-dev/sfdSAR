#' Gear width models
#'
#' Predict the gear with of a fishing gear from its benthis classification.
#'
#' @param a the a parameter for the model
#' @param b the b parameter for the model
#' @param x the covariate used in the model, avg_oal (average overall length),
#'          etc.
#'
#' @return A vector of predicted gear widths.
#'
#' @examples
#' oal_linear(1, 1, 1)
#'
#' @rdname gear-models
#' @name gear_models
NULL

#' @rdname gear-models
#' @export
linear <- function(a, b, x) {
  a * x + b
}

#' @rdname gear-models
#' @export
power <- function(a, b, x) {
  a * x ^ b
  #exp(log(a) + b * log(x)) ...
}
