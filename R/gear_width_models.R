#' Gear width models
#'
#' Predict the gear with of a fishing gear from its benthis classification.
#'
#' @param firstFactor the 'first' parameter for the model
#' @param secondFactor the 'second' parameter for the model
#' @param x the covariate used in the model: avg_oal (average overall length)
#'          or avg_kw (average kilo-wats engine power)
#'
#' @return A vector of predicted gear widths.
#'
#' @examples
#' linear(1, 1, 1)
#'
#' @rdname gear-models
#' @name gear_models
NULL

#' @rdname gear-models
#' @export
linear <- function(firstFactor, secondFactor, x) {
  firstFactor * x + secondFactor
}

#' @rdname gear-models
#' @export
power <- function(firstFactor, secondFactor, x) {
  firstFactor * x^secondFactor
  #exp(log(a) + b * log(x)) ...
}
