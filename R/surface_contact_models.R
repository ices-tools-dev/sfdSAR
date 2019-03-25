#' Surface contact models
#'
#' Predict the surface contact of a fishing gear
#'
#' @param fishing_hours the number of hours of fishing
#' @param gear_width (average) gear width in metres
#' @param fishing_speed (average) fishing speed in knots
#'
#' @return A vector of predicted gear widths.
#'
#' @examples
#' # compute surface contact for a trawl gear, fishing for 1 hour, with
#' # a 85 metres trawl width, at 3 knots.
#' trawl_contact(fishing_hours = 1,
#'               gear_width = 85,
#'               fishing_speed = 3)
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
danish_seine_contact <- function(fishing_hours, gear_width, fishing_speed) {
  fishing_hours / 2.591234 * gear_width^2 / pi / 4
}

#' @rdname surface-models
#' @export
scottish_seine_contact <- function(fishing_hours, gear_width, fishing_speed) {
  fishing_hours / 1.912500 * gear_width^2 / pi / 4 * 1.5
}
