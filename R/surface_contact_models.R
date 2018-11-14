#' Surface contact models
#'
#' Predict the surface contact of a fishing gear from its benthis classification.
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
#' @rdname surface-models
#' @name surface_contact_models
NULL

#' @rdname surface-models
#' @export
trawl_contact <- function(fishing_hours, gear_width, fishing_speed) {
  fishing_hours * gear_width * fishing_speed * 1.852
}


#' @rdname surface-models
#' @export
demersal_seine_contact <- function(fishing_hours, gear_width, fishing_speed) {
  (fishing_hours / 2.591234 * gear_width / (2 * pi))^2 * pi
}

#' @rdname surface-models
#' @export
demersal_seine_contact <- function(fishing_hours, gear_width, fishing_speed) {
  (fishing_hours / 1.912500 * gear_width / (2 * pi))^2 * 1.5 * pi
}
