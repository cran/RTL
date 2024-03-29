% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chart_PerfSummary.R
\name{chart_PerfSummary}
\alias{chart_PerfSummary}
\title{Cumulative performance and drawdown summary.}
\usage{
chart_PerfSummary(
  ret = ret,
  geometric = TRUE,
  main = "Cumulative Returns and Drawdowns",
  linesize = 1.25
)
}
\arguments{
\item{ret}{Wide dataframe univariate or multivariate of percentage returns. \code{tibble}}

\item{geometric}{Use geometric returns TRUE or FALSE. \code{logical}}

\item{main}{Chart title. \code{character}}

\item{linesize}{Size of lines in chart and legend. \code{numeric}}
}
\value{
Cumulative performance and drawdown charts. \code{ggplot}
}
\description{
Multi Asset Display of Cumulative Performance and Drawdowns
}
\examples{
ret <- data.frame(
  date = seq.Date(Sys.Date() - 60, Sys.Date(), 1),
  CL01 = rnorm(61, 0, .01), RB01 = rnorm(61, 0, 0.02)
)
chart_PerfSummary(ret = ret,
geometric = TRUE,
main = "Cumulative Returns and Drawdowns",
linesize = 1.25)
}
\author{
Philippe Cote
}
