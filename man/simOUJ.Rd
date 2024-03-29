% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simOUJ.R
\name{simOUJ}
\alias{simOUJ}
\title{OUJ process simulation}
\usage{
simOUJ(
  nsims = 2,
  S0 = 5,
  mu = 5,
  theta = 10,
  sigma = 0.2,
  jump_prob = 0.05,
  jump_avesize = 2,
  jump_stdv = 0.05,
  T2M = 1,
  dt = 1/250
)
}
\arguments{
\item{nsims}{number of simulations. Defaults to 2. \code{numeric}}

\item{S0}{S at t=0. \code{numeric}}

\item{mu}{Mean reversion level. \code{numeric}}

\item{theta}{Mean reversion speed. \code{numeric}}

\item{sigma}{Standard deviation. \code{numeric}}

\item{jump_prob}{Probability of jumps. \code{numeric}}

\item{jump_avesize}{Average size of jumps. \code{numeric}}

\item{jump_stdv}{Standard deviation of jump average size. \code{numeric}}

\item{T2M}{Maturity in years. \code{numeric}}

\item{dt}{Time step size e.g. 1/250 = 1 business day. \code{numeric}}
}
\value{
Simulated values. \code{tibble}
}
\description{
Simulates a Ornstein–Uhlenbeck process with Jumps
}
\examples{
simOUJ(nsims = 2, S0 = 5, mu = 5, theta = .5, sigma = 0.2,
jump_prob = 0.05, jump_avesize = 3, jump_stdv = 0.05,
T2M = 1, dt = 1 / 12)
}
\author{
Philippe Cote
}
