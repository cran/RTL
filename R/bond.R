#' Bond pricing
#' @description Compute bond price, cash flow table or duration
#' @param ytm Yield to Maturity. `numeric`
#' @param C Coupon rate per annum. `numeric`
#' @param T2M Time to maturity in years. `numeric`
#' @param m Periods per year for coupon payments e.g semi-annual = 2. `numeric`
#' @param output "price", "df" or "duration". `character`
#' @returns  Returns price `numeric`, cash flows `tibble`, or duration `numeric`
#' @export bond
#' @author Philippe Cote
#' @examples
#' bond(ytm = 0.05, C = 0.05, T2M = 1, m = 2, output = "price")
#' bond(ytm = 0.05, C = 0.05, T2M = 1, m = 2, output = "df")
#' bond(ytm = 0.05, C = 0.05, T2M = 1, m = 2, output = "duration")
bond <- function(ytm = 0.05, C = 0.05, T2M = 1, m = 2, output = "price") {
  df <- dplyr::tibble(t.years = seq(from = 1 / m, to = T2M, by = 1 / m), cf = rep(x = C * 100 / m, times = T2M * m)) %>%
    dplyr::mutate(
      t.periods = m * t.years,
      cf = replace(cf, t.years == T2M, C * 100 / m + 100),
      disc.factor = 1 / ((1 + ytm / m)^t.periods), pv = cf * disc.factor
    )
  price <- sum(df$pv)
  df <- df %>% dplyr::mutate(duration = (pv * t.years) / price)
  if (output == "price") {
    return(sum(df$pv))
  }
  if (output == "df") {
    return(df)
  }
  if (output == "duration") {
    return(sum(df$duration))
  }
  if (!output %in% c("price", "df", "duration")) {
    return("error in output variable definition")
  }
}
