% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chart_fwd_curves.R
\name{chart_fwd_curves}
\alias{chart_fwd_curves}
\title{Plots historical forward curves}
\usage{
chart_fwd_curves(df = dfwide, cmdty = "cmewti", weekly = TRUE, ...)
}
\arguments{
\item{df}{Wide dataframe with date column and multiple series columns (multivariate). \code{tibble}}

\item{cmdty}{Futures contract code in expiry_table object: unique(expiry_table$cmdty). \code{character}}

\item{weekly}{Defaults to TRUE for weekly forward curves. \code{logical}}

\item{...}{other graphical parameters}
}
\value{
plot of forward curves through time. \code{NULL}
}
\description{
Returns a plot of forward curves through time
}
\examples{
df <- dfwide \%>\%
  dplyr::select(date, dplyr::starts_with("CL")) \%>\%
  tidyr::drop_na()
chart_fwd_curves(
  df = df, cmdty = "cmewti", weekly = TRUE,
  main = "WTI Forward Curves", ylab = "$ per bbl", xlab = "", cex = 2
)
}
\author{
Philippe Cote
}
