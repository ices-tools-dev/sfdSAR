#' Calculate surface contact
#'
#' Predict surface contact.
#'
#' @param model vector of characters defining a model
#'              (see ?surface_contact_models)
#' @param fishing_hours the total number of hours fished.
#' @param gear_width the average gear width.
#' @param fishing_speed the average fishing speed.
#'
#' @return A vector of predicted gear widths.
#'
#'
#' @examples
#' # compute surface contact for a trawl gear, fishing for 1 hour, with
#' # a 85 metres trawl width, at 3 knots.
#' predict_surface_contact("trawl_contact", 1, 85, 3)
#'
#' @name predict_surface_contact
#' @export
predict_surface_contact <- function(model, fishing_hours, gear_width,
                                    fishing_speed) {
  # apply the approprate model
  mods <- unique(model)
  mods <- mods[!is.na(mods)]
  output <- rep(NA, length(model))
  for (mod in mods) {
    fun <- match.fun(mod)
    mwhich <- which(model == mod)
    output[mwhich] <- fun(fishing_hours[mwhich],
                          gear_width[mwhich],
                          fishing_speed[mwhich])
  }

  output
}
