#' Get information related to a C-Square
#'
#' Extract the surface area, latitude or longitude of a 0.05 resolution
#' C-Square.
#'
#' @param csquare the name of a 0.05 resolution C-Square.
#'
#' @return A vector of numeric values: latitudes, longitudes or areas.
#'
#'
#' @examples
#' csquare_area("1501:370:370:1")
#' csquare_lat("1501:370:370:1")
#' csquare_lon("1501:370:370:1")
#'
#' @rdname csquare-functions
#' @name csquare_utils
NULL

#' @rdname csquare-functions
#' @export
csquare_area <- function(csquare) {
  lat <- csquare_lat(csquare)
  cos(lat * pi / 180) * 111.1942^2 / 400
}

#' @rdname csquare-functions
#' @export
csquare_lat <- function(csquare) {
  C41 <- as.numeric(substring(csquare, 14, 14))
	C38 <- as.numeric(substring(csquare, 1, 1))
	D38 <- as.numeric(substring(csquare, 2, 2))
	D39 <- as.numeric(substring(csquare, 7, 7))
	D40 <- as.numeric(substring(csquare, 11, 11))

	G41 <- round(C41 * 2, -1) / 10
	B40 <- round(abs(C38 - 4) * 2, -1) / 5 - 1

	(D38 * 10 + D39 + D40 * 0.1 + G41 * 0.05 + 0.025)*B40
}

#' @rdname csquare-functions
#' @export
csquare_lon <- function(csquare) {
  C41 <- as.numeric(substring(csquare, 14, 14))
	C38 <- as.numeric(substring(csquare, 1, 1))
	E38 <- as.numeric(substring(csquare,3, 4))
	E39 <- as.numeric(substring(csquare,8, 8))
	E40 <- as.numeric(substring(csquare,12, 12))

	H41 <- (round((C41 - 1) / 2, 1) - floor((C41 - 1) / 2)) * 2

	B41 <- 1 - 2 * round(C38, -1) / 10

	(E38 * 10 + E39 + E40 * 0.1 + H41 * 0.05 + 0.025) * B41
}
