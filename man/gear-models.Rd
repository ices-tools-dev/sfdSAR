% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gear_width_models.R
\name{gear_models}
\alias{gear_models}
\alias{linear}
\alias{power}
\title{Gear width models}
\usage{
linear(a, b, x)

power(a, b, x)
}
\arguments{
\item{a}{the a parameter for the model}

\item{b}{the b parameter for the model}

\item{x}{the covariate used in the model: avg_oal (average overall length)
or avg_kw (average kilo-wats engine power)}
}
\value{
A vector of predicted gear widths.
}
\description{
Predict the gear with of a fishing gear from its benthis classification.
}
\examples{
linear(1, 1, 1)

}
